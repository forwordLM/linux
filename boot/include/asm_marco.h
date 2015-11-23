#ifndef _ASM_MARCO_H_
#define _ASM_MARCO_H_

.macro set_mode, mode
	msr cpsr_c, #\mode 

#endif
