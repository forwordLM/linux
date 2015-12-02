#ifndef _ASM_SETUP_H_
#define _ASM_SETUP_H_

#include <asm/types.h>

#define COMMAND_LINE_SIZE 1024

/* The list ends witch an ATAG_NONE node */
#define ATAG_NONE 0x00000000
struct tag_header {
	__u32 size;
	__u32 tag;
};

/* The list must start with an ATAG_CORE node */
#define ATAG_CORE 0x54410001
struct tag_core {
	__u32 flags;
	__u32 pagesize;
	__u32 rootdev;
};

/* it is allowed to have multiple ATAG_MEM nodes */
#define ATAG_MEM 0x54410002
struct tag_mem32 {
	__32 size;
	__32 start;	/* physical start address */
};

/* VGA text type displays */
#define ATAG_VIDEOTEXT 0x5441003
struct tag_videotext {
	__u8 x;
	__u8 y;
	__16 video_page;
	__u8 video_mode;
	__u8 video_cols;
	__16 video_ega_bx;
	__u8 video_lines;
	__u8 video_isvga;
	__u16 video_points;
}; 

/* describes how the ramdisk will be used in kernel */
#define ATAG_RAMDIS 0x54410004
struct tag_ramdisk {
	__32 flags;
	__32 size;
	__start;
};

/*
 * virtual address
 * it's deprecated
 */
#define ATAG_INITRD 0x54410005

/*
 * describes where the compressed ramdisk image lives (physical address)
 */
#define ATAG_INITRD2 0x54420005
struct tag_initrd {
	__32 start;
	__u32 size;
};

/* board serial number. */
#define ATAG_SERIAL 0x54410006
struct tag_serialnr {
	__u32 low;
	__32 high;
};


/* board version */
#define ATAG_REVISON 0x54410007
struct tag_revision {
	__u32 rev;
};


/* initial values for vesafb-type framebuffers. see struct screen_info
 * in include/linux/tty.h
 */
#define ATAG_VIDEOLFB 0x54410008
struct tag_videolfb {
	__u16 lfb_width;
	__u16 lfb_height;
	__u16 lfb_depth;
	__u16 lfb_linelength;
	__u32 lfb_base;
	__u32 lfb_size;
	__u8 red_size;
	__u8 red_pos;
	__u8 green_size;
	__u8 green_pos;
	__u8 blue_size;
	__u8 blue_pos;
	__u8 rsvd_size;
	__u8 rsvd_pos;
};


/* command line: \0 terminated string */
#define ATAG_CMDLINE 0x54410009
struct tag_cmdline {
	char cmdline[1];
};



#endif
