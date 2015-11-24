#ifndef _ASMARM_PGTABLE_HWDEF_H_
#define _ASMARM_PGTABLE_HWDEF_H_

/*
 * hardware page table definitions.
 * + level 1 descriptor (PMD)
 *  -common
 */
#define PMD_TYPE_MASK	(3 << 0)
#define PMD_TYPE_FAULT	(0 << 0)
#define PMD_TYPE_TABLE	(1 << 0)


#endif
