
#include <linux/init.h>

asmlinkage void __init start_kernel(void)
{
	char *command_line;
	extern struct struct kernel_param __start___param[], __stop___param[];
	
	setup_arch(&command_line);
	
}
