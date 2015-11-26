
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
		_stext = .;
		_sinittext = .;
		*(.text.head)
	}

	.init:{		/* init code and data */
			// INIT_TEXT
			*(.init.text)
			*(.devinit.text)
			*(.cpuinit.text)
			*(.meminit.text)
		_einittext = .;
		__proc_info_begin = .;
			*(.proc.info.init)
		__proc_info_end = .;
		__arch_info_begin = .;
			*(.arch.info.init)
		__arch_info_end = .;
		__tagtable_begin = .;
			*(.taglist.init)
		__tagtable_end = .;
		. = ALIGN(0x10);
		__setup_start = .;
			*(.init.setup)
		__setup_end = .;
		__early_begin = .;
			*(.early_param.init)
		__early_end = .;
		__initcall_start = .;
			//INITCALLS
			*(.initcallearly.init)
		__early_initcall_end = .;
			*(.initcall0.init)	\
			*(.initcall0s.init)	\
			*(.initcall1.init)	\
			*(.initcall1s.init)	\
			*(.initcall2.init)	\
			*(.initcall2s.init)	\
			*(.initcall3.init)	\
			*(.initcall3s.init)	\
			*(.initcall4.init)	\
			*(.initcall4s.init)	\
			*(.initcall5.init)	\
			*(.initcall5s.init)	\
			*(.initcallrootfs.init)	\
			*(.initcall6.init)	\
			*(.initcall6s.init)	\
			*(.initcall7.init)	\
			*(.initcall7s.init)
		__initcall_end = .;
	}
}
