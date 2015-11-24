
#ifndef __ASM_ARM_MEMORY_H__
#define __ASM_ARM_MEMORY_H__


#include <mach/memory.h>



/*
** Allow for constants defined here to be used from assembly code
** by prepending the UL suffix only with actual C code compilaton
*/

#define UL(x) _AC(x,UL)

#ifdef CONFIG_MMU

/*
** PAGE_OFFSET - the virtual address of the start of the kernel image
** TASK_SIZE - the maximum size of a user space task
** TASK_UNMAPPED_BASE - the lower boundary of mmap VM area
*/

#define PAGE_OFFSET UL(CONFIG_PAGE_OFFSET)
#define TASK_SIZE (UL(CONFIG_PAGE_OFFSET) - UL(0x01000000))


#endif
