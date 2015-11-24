
#include <asm/assembler.h>
#include <asm/memory.h>

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


												



