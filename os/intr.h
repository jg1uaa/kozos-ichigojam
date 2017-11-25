#ifndef _INTR_H_INCLUDED_
#define _INTR_H_INCLUDED_

#include "interrupt.h"

/* ソフトウエア・割込みベクタの定義 */
#define SOFTVEC_TYPE_NUM     64
#define SOFTVEC_TYPE_IRQ(x)  ((x) + 16)

#define SOFTVEC_TYPE_SYSCALL 0				// SVC #0
#define SOFTVEC_TYPE_SOFTERR 3				// HardFault
#define SOFTVEC_TYPE_SERINTR SOFTVEC_TYPE_IRQ(21)

/* 割り込みコントローラ操作部分 */
void intc_init(void);
void intc_enable(softvec_type_t type);
void intc_disable(softvec_type_t type);
void intc_clear(softvec_type_t type);

#endif
