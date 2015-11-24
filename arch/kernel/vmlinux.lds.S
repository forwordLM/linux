
OUTPUT_ARCH(arm)
ENTRY(stext)

#ifndef __ARMEB__
jiffies = jiffies_64;
#else
jiffies = jiffies_64 + 4;
#endif

SECTIONS
{
#ifdef CONFIG_XIP_KERNEL
	. = XIP_VIRT_ADDR(CONFIG_XIP_PHYS_ADDR);
#else
	. = PAGE_OFFSET + TEXT_OFFSET;
#endif
	.text.head:{
		_stext=.;
		_sinittext=.;
		*(.text.head)
	}

	.init:{

	}
}
