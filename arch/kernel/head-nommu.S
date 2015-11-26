

#include <asm/assembler.h>

	.section ".text.head", "ax"
ENTRY(stext)
	setmod PSR_F_BIT | PSR_I_BIT | SVC_MODE, r9 @ ensure svc mode
												@ and irqs disabled
	mrc p15, 0, r9, c0, c0		@get processor id
	bl __lookpu_processor_type
