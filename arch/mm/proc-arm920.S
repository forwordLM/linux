
#include <asm/pgtable-hwdef.h>

	.align
	.section ".proc.info.init", #alloc, #execinstr
	.type	__arm920_proc_info, #object
__arm920_proc_info:
	.long	0x41009200
	.long	0xff00fff0
	.long	PMD_TYPE_SECT | \
		PMD_SECT_BUFFERABLE | \
		PMD_SECT_CACHEABLE | \
		PMD_BIT4 | \
		PMD_SECT_AP_WRITE | \
		PMD_SECT_AP_READ
	.long   PMD_TYPE_SECT | \
		PMD_BIT4 | \
		PMD_SECT_AP_WRITE | \
		PMD_SECT_AP_READ
	b	__arm920_setup
 
