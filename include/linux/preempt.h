#ifndef _LINUX_PREEMPT_H_
#define _LINUX_PREEMPT_H_



#define inc_preempt_count() add_preempt_count(1)
#define preempt_disable() \
do {
	inc_preempt_count(); \
	barrier(); \
} while (0)

#endif
