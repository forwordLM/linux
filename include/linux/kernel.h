#ifndef _LINUX_KERNEL_H_
#define _LINUX_KERNEL_H_


static inline int printk(const char *s, ...)
	__attribute__((format(printf, 1, 2)));


#endif
