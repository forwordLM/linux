
#ifndef _ASSEMBLER_H_
#define _ASSEMBLER_H_


	.marco setmode, mode, reg
	mcr cpsr_c, #\mode
	.endm

#endif
