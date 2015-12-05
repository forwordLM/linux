#include <linux/init.h>
#include <asm/setup.h>

/*
 * This holds our defaults
 */

static struct init_tags {
	struct tag_header hdr1;
	struct tag_core core;
	struct tag_header hdr2;
	struct tag_mem32 mem;
	struct tag_header hdr3;
}init_tags __initdata = {
	{tag_size(tag_core), ATAG_CORE},
	{1, PAGE_SIZE, 0xff},
	{tag_size(tag_mem32), ATAG_MEM},
	{MEM_SIZE, PHYS_OFFSE},
	{0, ATAG_NONE}
};

static struct machine_desc * __init setup_machine(unsigned int nr)
{
	struct machine_desc *list;
	
	/*
	 * locate machine in the list of supported machines
	 */
	list = lookup_machine_type(nr);
	if (!list) {
		printk("Machine configration botched (nr %), unable to continue.\n", nr);
	while(1);
	}
	
	printk("Machine: %s", list->name);
	
	return list; 
}

static const char *machine_name;

void __init setup_arch(char **cmdline_p)
{
	struct tag *tags = (struct tag *)&init_tags;
	struct machine_desc *mdesc;
	char *from = default_command_line;

	/* multi cpu use */
	setup_processor();
	mdesc = setup_machine(machine_arch_type);
	machine_name = mdesc->name;

	if (mdesc->soft_reboot)
		reboot_setup("s");
	
	if (mdesc->boot_params)
		tags = phys_to_virt(mdesc->boot_params);

}
