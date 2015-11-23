
#define WTCON	0x53000000
#define INTMSK	0x4a000008
#define INISUBMSK	0x4a00000c
	.text
.global	low_level_init
low_level_init:
	ldr r0,=WTCON		@disable watch dog
	mov r1, 0x0
	str r1, [r0]

	ldr r0,=INTMSK		@disable interrupt
	ldr r1,0xffffffff
	str r1,[r0]
	ldr r0,=INTSUBMSK
	ldr r1,=0x7fff
	
