
#include <asm/assembler.h>
#include <asm/memory.h>
#include <asm/system.h>
#include <asm/domain.h>


#if (PHYS_OFFSET & 0x001fffff)
#error"PHYS_OFFSET must be at an even 2M boundary!"
#endif

#define KERNEL_RAM_VADDR	(PAGE_OFFSET + TEXT_OFFSET)
#define KERNEL_RAM_PADDR	(PHYS_OFFSET + TEXT_OFFSET)

#if (KERNEL_RAM_VADDR & 0xffff) != 0x8000
#error KERNEL_RAM_VADDR must start at 0xXXXX8000
#endif

	.global	swapper_pg_dir
	.equ	swapper_pg_dir, KERNEL_RAM_VADDR - 0x4000

	.macro	pgtbl, rd
	ldr \rd, =(KERNEL_RAM_PADDR - 0x4000)
	.endm

#ifdef CONFIG_XIP_KERNEL
#define 
#define 
#else
#define KERNEL_START KERNEL_RAM_VADDR
#define KERNEL_END _end
#endif


/*
** Kernel startup entry point.
**-----------------------------
**
** this is normally called form the decompressor code, the requirements
** are: mmu = off, d-cache = off, i-cache = dont care, r0 = 0,
** r1 = machine id, r2 = atags pointer
**
**
** this code is mostly position independent, so if you link the kernel at
** 0xc0008000, you call this at __pa(0xc0008000).
*/

	.section ".text.head", "ax"
ENTRY(stext)
	setmode	PSR_F_BIT | PSR_I_BIT | SVC_MODE, r9 @ ensure svc mode
												@ and irqs disabled
	mrc	p15, 0, r9, c0, c0		@ get processor id
	bl __lookup_processor_type	@ r5=procinfo r9=cpuid
	movs	r10, r5				@invalid processor(r5=0)?
	beq __error_p
	bl __lookup_machine_type	@r5=machinfo
	movs	r8, r5				@invalid machine(r5=0)?
	beq __error_a
	bl __vet_atags
	bl __create_page_tables
	
	ldr sp, __switch_data		@address to jump to after, mmu has been enabled
	adr lr, _enable_mmu			@return (PIC) address
	add pc, r10, #PROCINFO_INITFUNC


/*
 * setup common bits before finally enabling the MMU.essentially
 * this is just loading the page table pointer and domain access
 * registers.
 *
 */
	.type	__enable_mmu, %function
__enable_mmu:
#ifdef	CONFIG_ALIGNMENT_TRAP
	orr r0, r0, #CR_A
#else
	bic r0, r0, #CR_A
#endif
#ifdef	CONFIG_CPU_DCACHE_DISABLE
	bic	r0, r0, #CR_C
#endif
#ifdef	CONFIG_CPU_BPREDICT_DISABLE
	bic	r0, r0, #CR_Z
#endif
#ifdef	CONFIG_CPU_ICACHE_DISABLE
	bic	r0, r0, #CR_I
#endif
	mov r5, #(domain_val(DOMAIN_USER, DOMAIN_MANAGER) | \
			domain_val(DOMAIN_KERNEL, DOMAIN_MANAGER) | \
			domain_val(DOMAIN_TABLE, DOMAIN_MANAGER) | \
			domain_val(DOMAIN_IO, DOMAIN_CLIENT))
	mcr p15, 0, r5, c3, c0, 0	@load domain access register
	mcr p15, 0, r4, c2, c0, 0	@load page table pointer
	b	__turn_mmu_on


	.align	5
	.type	__turn_mmu_on, %function
__turn_mmu_on:
	mov r0, r0
	mcr p15, 0, r0, c1, c0, 0	@write control reg
	mrc	p15, 0, r3, c0, c0, 0	@read id reg
	mov r3, r3
	mov r3, r3
	mov pc, sp
												
/*
 * setup the initial page tables. we only setup the barest
 * amount which are required to get the kernel running, which
 * generally means mapping in the kernel code.
 * 
 * r8=machinfo
 * r9=cpuid
 * r10=procinfo
 *
 * returns:
 * r4 = physical page table address
 *
 */

__create_page_tables:
	pgtbl r4				@page table address
							@r4 = (KERNEL_RAM_PADDR - 0x4000)

	mov r0, r4				@r0 = r4
	mov r3, #0				@r3 = 0
	add r6, r0, #0x4000		@r6 = KERNEL_RAM_PADDR
1:	str r3, [r0], #4		@[r0] = 0, r0 = r0+4
	str r3, [r0], #4
	str r3, [r0], #4
	str r3, [r0], #4
	teq r0, r6
	bne 1b

	ldr r7, [r10, #PROCINFO_MM_MMUFLAGS]	@mm_mmuflags
	

	mov r6, pc, lsl #20
	add r3, r7, r6, lsr #20
		
	ldr r5, =KERNEL_START
	ldr r6, =KERNEL_END - 1
	add r0, r4, r5, lsr #18
	str r3, [r0]
1:	add r0, r0, #4
	add r3, r3, 1 << 20
	str r3, [r0]
	cmp r0, r6
	bls 1b
		



