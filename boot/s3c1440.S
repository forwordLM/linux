
#define WTCON	0x53000000
#define INTMSK	0x4a000008

	.text
.global	low_level_init
low_level_init:
	ldr r0,=WTCON		@disable watch dog
	mov r1, 0x0
	str r1, [r0]

	ldr r0,=INTMSK
	ldr r1,0xffffffff
	
