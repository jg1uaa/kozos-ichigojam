#include "defines.h"
#include "intr.h"
#include "interrupt.h"
#include "kozos.h"
#include "lib.h"

/*
 * 共通割込みハンドラ．
 */
void interrupt(softvec_type_t type)
{
  thread_intr(type);
}

/*
 * HardFaultハンドラ (簡易デバッグ情報表示)
 *	戻り値:  0 動作継続
 *		!0 動作終了(halt)
 */
int hardfault(unsigned long sp)
{
  unsigned long *p = (unsigned long *)sp;
  static char *regList[] = {
    "R0 ", "R1 ", "R2 ", "R3 ", "R12", "LR ", "PC ", "PSR",
  };
  int i;

  puts("HardFault    SP :");
  putxval(sp, 8);
  putc('\n');

  for (i = 0; i < 8; i++) {
	  puts(regList[i]);
	  putc(':');
	  putxval(*p++, 8);
	  putc((i & 3) == 3 ? '\n' : ' ');
  }

  return 0;
}
