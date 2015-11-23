#include "include/asm_macro.h"


.global _start
_start:
	b reset


.global start
start:	.word _start

.global pv_offset
pv_offset:	.word 0

.global kernel_virtual_start
kernel_virtual_start	.word 0

.global kernel_phy_start
kernel_phy_start	.word 0

.global soc_dec
soc_dec:
	.space 4
	.space 4
	.space 4

	.align 5
reset:
	set_mode SVC_MODE | NO_INT  @SVC mode, mmu off, icache disable, cache disable
	mrc p15, 0, c0, c0, 0       @problem

	mov r4, #0
	mov r5, #0
	mov r6, #0
		
	adr r3, soc_desc
	str r4, [r3]
	str r5, [r3, #4]
	str r6, [r3, #8]
	
	bl low_level_init			@do some low level init sush as disable watch dog

