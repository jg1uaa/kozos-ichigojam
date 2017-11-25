#include "defines.h"
#include "kozos.h"
#include "consdrv.h"
#include "lib.h"

/* コンソール・ドライバの使用開始をコンソール・ドライバに依頼する */
static void send_use(int index)
{
  char *p;
  p = kz_kmalloc(3);
  p[0] = '0';
  p[1] = CONSDRV_CMD_USE;
  p[2] = '0' + index;
  kz_send(MSGBOX_ID_CONSOUTPUT, 3, p);
}

/* コンソールへの文字列出力をコンソール・ドライバに依頼する */
static void send_write(char *str)
{
  char *p;
  int len;
  len = strlen(str);
  p = kz_kmalloc(len + 2);
  p[0] = '0';
  p[1] = CONSDRV_CMD_WRITE;
  memcpy(&p[2], str, len);
  kz_send(MSGBOX_ID_CONSOUTPUT, len + 2, p);
}

#ifdef DEBUG
/* メモリの16進ダンプ出力 ※デバッグ用 */
static int dump(char *buf, int size)
{
  int i;

  if (size < 0) {
    puts("no data.\n");
    return -1;
  }
  for (i = 0; i < size; i++) {
    if ((i & 0xf) == 0) {
      putxval((unsigned int)&buf[i], 8);
      puts(": ");
    }
    putxval(buf[i], 2);
    if ((i & 0xf) == 15) {
      puts("\n");
    } else {
      if ((i & 0xf) == 7) puts(" ");
      puts(" ");
    }
  }
  puts("\n");

  return 0;
}
#endif

int command_main(int argc, char *argv[])
{
  char *p;
  int size;

  send_use(SERIAL_DEFAULT_DEVICE);

  while (1) {
    send_write("command> "); /* プロンプト表示 */

    /* コンソールからの受信文字列を受け取る */
    kz_recv(MSGBOX_ID_CONSINPUT, &size, &p);
    p[size] = '\0';

    if (!strncmp(p, "echo", 4)) { /* echoコマンド */
      send_write(p + 4); /* echoに続く文字列を出力する */
      send_write("\n");
#ifdef DEBUG
    } else if (!strncmp(p, "dump", 4)) { /* メモリの16進ダンプ出力 */
      extern char _data_start[];
      extern char _main_stack[];
      dump(_data_start, _main_stack - _data_start);
#endif
    } else {
      send_write("unknown.\n");
    }

    kz_kmfree(p);
  }

  return 0;
}
