

#define ATAG_CORE 0x54410001
#define ATAG_CORE_SIZE ((2*4 + 3*4) >> 2)
	.align	2
	.type	__switch_data, %object
__switch_data:
	.long	__mmap_switched
	.long	__data_loc							@r4
	.long	_data								@r5
	.long	__bss_start							@r6
	.long	_end								@r7
	.long 	processor_id						@r4
	.long	__machine_arch_type					@r4
	.long	__atags_pointer						@r5
	.long	cr_alignment						@r7
	.long	init_thread_union + THREAD_START_SP	@sp
	


/*
 * Read processor ID register (CP#15, CR0), and look up in the linker-built
 * supported processor list.  Note that we can't use the absolute addresses
 * for the __proc_info lists since we aren't running with the MMU on
 * (and therefore, we are not in the correct address space).  We have to
 * calculate the offset.
 *
 *	r9 = cpuid
 * Returns:
 *	r3, r4, r6 corrupted
 *	r5 = proc_info pointer in physical address space
 *	r9 = cpuid (preserved)
 */
__lookup_processor_type:
	adr r3, 3f	 		//r3=below physical address
	ldmda r3, {r5 - r7} //[r3]->r7, [r3-4]->r6, [r3-8]->r5
						//r5=__proc_info_begin(virt)
						//r6=__proc_info_end(virt)
	sub r3, r3, r7		//(phys addr) - (virt addr)
	add r5, r5, r3		//r5=__proc_info_begin(virt)+(phys addr)-(virt addr)
						//  =__proc_info_begin(phys)
	add r6, r6, r3		//r6=__proc_info_end(phys)
1:	ldmia r5, {r3, r4}	//[r5]->r3, [r5+4]->r4;r3=__proc_info_list.cpu_val,
											//r4 =__proc_info_list.cpu_mask
	and r4, r4, r9		//r9=cpu_id, r4=r4&r9=cpu_mask&cpu_id
	teq r3, r4			//compare
	beq 2f				//if equal, jump 2f;
	add r5, r5 #PROC_INFO_SZ	//r5 point the next (struct proc_info_list)
	
	cmp r5, r6			//it's the end?
	blo	1b				//r5 < r6,jump 1b
	mov r5, #0			//none matched structer
2:	mov pc, lr			//back
ENDPROC(__proc_processor_type)


	.long	__proc_info_begin
	.long	__proc_info_end
3:	.long	.
	.long	__arch_info_begin
	.long	__arch_info_end

__lookup_machine_type:
	adr r3, 3b
	ldmia	r3, {r4 - r6}	//[r3]->r4,[r3+4]->r4,[r3+8]->r7
	sub	r3, r3, r4
	add r5, r5, r3
	add r6, r6, r3
1:	ldr r3, [r5, #MACHINFO_TYPE]	@get machine type
	teq r3, r1		@matches loader number?
	beq	2f			@found
	
	add r5, r5, #SIZE_MACHINE_DES	@next machine_desc
	cmp r5, r6
	blo	1b
	mov r5, #0		@unknow machine

2:	mov	pc, lr
ENDPROC(__proc_machine_type)

/* determine validity of the r2 atags pointer, requires that
 * the pointer be aligned, in the first 16k of physical ram and
 * that the ATAG_CORE marker is first and present. future revisions
 * of this function may be more lenient with the physical address and
 * may also be able to move the ATAGS block if necessory.
 * 
 * r8 = machinfo
 * returns:
 * r2 either valid atags pointer, or zero
 *
 */

__vet_atags:
	tst	r2, #0x3			@ aligned?
	bne	1f

	ldr	r5, [r2, #0]			@ is first tag ATAG_CORE?
	cmp	r5, #ATAG_CORE_SIZE
//	cmpne	r5, #ATAG_CORE_SIZE_EMPTY
	bne	1f
	ldr	r5, [r2, #4]
	ldr	r6, =ATAG_CORE
	cmp	r5, r6
	bne	1f
	
	mov	pc, lr				@ atag pointer is ok
	
1:	mov	r2, #0
	mov	pc, lr
ENDPROC(__vet_atags)


