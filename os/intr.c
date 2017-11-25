#include "defines.h"
#include "interrupt.h"
#include "intr.h"
#include "cm0scs.h"

/* 割り込みコントローラの初期化 */
void intc_init(void)
{
  *(volatile uint32 *)NVIC_ICER = ~0;     /* 全ての割り込みを禁止 */
  *(volatile uint32 *)NVIC_ICPR = ~0;     /* 全ての割り込み要因をクリア */
  // 割り込み優先順位は初期値のままとする
}

/* 割り込み要因の許可 */
void intc_enable(softvec_type_t type)
{
  type -= SOFTVEC_TYPE_IRQ(0);
  *(volatile uint32 *)NVIC_ISER = 1 << (type & 0x1f);
}

/* 割り込み要因の禁止 */
void intc_disable(softvec_type_t type)
{
  type -= SOFTVEC_TYPE_IRQ(0);
  *(volatile uint32 *)NVIC_ICER = 1 << (type & 0x1f);
}

/* 割り込み要因のクリア */
void intc_clear(softvec_type_t type)
{
  type -= SOFTVEC_TYPE_IRQ(0);
  *(volatile uint32 *)NVIC_ICPR = 1 << (type & 0x1f);
}
