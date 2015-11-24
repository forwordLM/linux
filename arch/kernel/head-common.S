


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
	adr r3, 3f	//r3=line 190 physical address
	ldmda r3, {r5 - r7} //[r3]->r7, [r3-4]->r6, [r3-8]->r5
						//r5=__proc_info_begin(virt)
						//r6=__proc_info_end(virt)
						//r7=190 line addr(virt)
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




	.long	__proc_info_begin
	.long	__proc_info_end
3:	.long	.
	.long	__arch_info_begin
	.long	__arch_info_end
