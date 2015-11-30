#ifndef _SYSTEM_H_
#define _SYSTEM_H_



/*
 * CR1 bits (CP#15 CR1)
 */
#define CR_M	(1 << 0)	/* MMU enable */
#define CR_A	(1 << 1)	/* Alignment abort enable */
#define CR_C	(1 << 2)	/* Dcache enable */
#define CR_W	(1 << 3)	/* Write buffer enable */
#define CR_P	(1 << 4)	/* 32-bit exception handler */
#define CR_D	(1 << 5)	/* 32-bit data address range */
#define CR_L	(1 << 6) 	/* Implementation defined */
#define CR_B 	(1 << 7)	/* Big endian */
#define CR_S 	(1 << 8)	/* System MMU protection */
#define CR_R	(1 << 9)	/* ROM MMU proctection */
#define CR_F	(1 << 10) 	/* Implementation defined */
#define CR_Z 	(1 << 11)	/* Implementation defined */
#define CR_I	(1 << 12)	/* Icache enable	*/
#define CR_V	(1 << 13)	/* Vectors relocated to 0xffff0000 */
#define CR_RR	(1 << 14)	/* Round Robin cache replacement */
#define CR_L4	(1 << 15)	/* LDR pc can set T bit */
#define CR_DT 	(1 << 16)
#define CR_IT	(1 << 18)
#define CR_ST	(1 << 19)
#define CR_FI	(1 << 21)	/* Fast interrupt (lower latency mode */
#define CR_U	(1 << 22)	/* Unaligned access operation */
#define CR_XP	(1 << 23)	/* Extended page tables */
#define CR_VE	(1 << 24)	/* Vectored interrupts */




#define CPUID_ID	0
#define CPUID_CACHETYPE	1



#endif
