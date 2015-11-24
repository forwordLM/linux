
#include <asm/pgtable-hwdef.h>

	.align
	.section ".proc.info.init", #alloc, #execinstr
	.type	__arm920_proc_info, #object
__arm920_proc_info:
	.long	0x41009200
	.long	0xff00fff0
	.long	PMD_TYPE_SECT | 
