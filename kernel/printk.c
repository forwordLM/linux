

asmlinkage int vprintk(const char *fmt, va_list args)
{
	unsigned long flags;
	int printed_len;
	char *p;
	static char printk_buf[1024];
	static int log_level_unknow = 1;

	preempt_disable();
	if (unlikely(oops_in_progress) && printk_cpu == smp_process_id())
	zap_locks();

}

asmlinkage int printk(const char *fmt, ...)
{
	char *rgs;
	int r;
	
	vprintk();
}
