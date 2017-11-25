#include "cm0scs.h"

/* 割り込みベクタ */

	.section .vector,"ax"
	.thumb
	.align 0

	.long	_main_stack		// MSP default value
	.long	reset_entry + 1		//  1: Reset
	.long	intr_entry + 1		//  2: NMI
	.long	hardfault_entry + 1	//  3: HardFault
	.long	intr_entry + 1		//  4: reserved
	.long	intr_entry + 1		//  5: reserved
	.long	intr_entry + 1		//  6: reserved
	.long	intr_entry + 1		//  7: reserved
	.long	intr_entry + 1		//  8: reserved
	.long	intr_entry + 1		//  9: reserved
	.long	intr_entry + 1		// 10: reserved
	.long	svc_entry + 1		// 11: SVCall
	.long	intr_entry + 1		// 12: reserved
	.long	intr_entry + 1		// 13: reserved
	.long	pendsv_entry + 1	// 14: PendSV
	.long	intr_entry + 1		// 15: SysTick
	.long	intr_entry + 1		// 16: External Interrupt(0)
	.long	intr_entry + 1		// 17: External Interrupt(1)
	.long	intr_entry + 1		// 18: External Interrupt(2)
	.long	intr_entry + 1		// 19: External Interrupt(3)
	.long	intr_entry + 1		// 20: External Interrupt(4)
	.long	intr_entry + 1		// 21: External Interrupt(5)
	.long	intr_entry + 1		// 22: External Interrupt(6)
	.long	intr_entry + 1		// 23: External Interrupt(7)
	.long	intr_entry + 1		// 24: External Interrupt(8)
	.long	intr_entry + 1		// 25: External Interrupt(9)
	.long	intr_entry + 1		// 26: External Interrupt(10)
	.long	intr_entry + 1		// 27: External Interrupt(11)
	.long	intr_entry + 1		// 28: External Interrupt(12)
	.long	intr_entry + 1		// 29: External Interrupt(13)
	.long	intr_entry + 1		// 30: External Interrupt(14)
	.long	intr_entry + 1		// 31: External Interrupt(15)
	.long	intr_entry + 1		// 32: External Interrupt(16)
	.long	intr_entry + 1		// 33: External Interrupt(17)
	.long	intr_entry + 1		// 34: External Interrupt(18)
	.long	intr_entry + 1		// 35: External Interrupt(19)
	.long	intr_entry + 1		// 36: External Interrupt(20)
	.long	intr_entry + 1		// 37: External Interrupt(21)
	.long	intr_entry + 1		// 38: External Interrupt(22)
	.long	intr_entry + 1		// 39: External Interrupt(23)
	.long	intr_entry + 1		// 40: External Interrupt(24)
	.long	intr_entry + 1		// 41: External Interrupt(25)
	.long	intr_entry + 1		// 42: External Interrupt(26)
	.long	intr_entry + 1		// 43: External Interrupt(27)
	.long	intr_entry + 1		// 44: External Interrupt(28)
	.long	intr_entry + 1		// 45: External Interrupt(29)
	.long	intr_entry + 1		// 46: External Interrupt(30)
	.long	intr_entry + 1		// 47: External Interrupt(31)
	.long	intr_entry + 1		// 48: External Interrupt(32)
	.long	intr_entry + 1		// 49: External Interrupt(33)
	.long	intr_entry + 1		// 50: External Interrupt(34)
	.long	intr_entry + 1		// 51: External Interrupt(35)
	.long	intr_entry + 1		// 52: External Interrupt(36)
	.long	intr_entry + 1		// 53: External Interrupt(37)
	.long	intr_entry + 1		// 54: External Interrupt(38)
	.long	intr_entry + 1		// 55: External Interrupt(39)
	.long	intr_entry + 1		// 56: External Interrupt(40)
	.long	intr_entry + 1		// 57: External Interrupt(41)
	.long	intr_entry + 1		// 58: External Interrupt(42)
	.long	intr_entry + 1		// 59: External Interrupt(43)
	.long	intr_entry + 1		// 60: External Interrupt(44)
	.long	intr_entry + 1		// 61: External Interrupt(45)
	.long	intr_entry + 1		// 62: External Interrupt(46)
	.long	intr_entry + 1		// 63: External Interrupt(47)

/* スタートアップ */

	.section .text
	.thumb
	.align 0
	.global reset_entry

reset_entry:

#ifdef DEBUG // --------------------------------------------------------------
xxx_clear:
	ldr	r2, =_data_start
	ldr	r3, =_main_stack
	ldr	r0, =0xaddeadde

xxx_clear_loop:
	str	r0, [r2]
	add	r2, r2, #4

	cmp	r2, r3
	bne	xxx_clear_loop
#endif // --------------------------------------------------------------------

	/* 各種スタックを初期化 */
	ldr	r0, =_process_stack
	msr	psp, r0
	mov	r0, #2
	msr	control, r0		// use PSP in Thread mode

	/* ボード固有の設定 */
	bl	board_setup

	/* .dataの初期化 */
data_init:
	ldr	r1, =_data_org
	ldr	r2, =_data_start
	ldr	r3, =_data_end
	cmp	r2, r3
	beq	bss_init
data_loop:
	ldrb	r0, [r1]
	add	r1, r1, #1
	strb	r0, [r2]
	add	r2, r2, #1
	cmp	r2, r3
	bne	data_loop

	/* .bssの初期化 */
bss_init:
	mov	r0, #0
	ldr	r2, =_bss_start
	ldr	r3, =_bss_end
	cmp	r2, r3
	beq	start_main
bss_loop:
	strb	r0, [r2]
	add	r2, r2, #1
	cmp	r2, r3
	bne	bss_loop

	/* メイン */
start_main:
	mov	r0, #0
	bl	serial_init	// デバッグ用シリアルポートを初期化
	bl	main
	b	die

	/* 暴走防止用の無限ループ */
die:
	b	die

	.pool

/*
 * 割り込みエントリ
 *
 * IPSRから割り込みベクタ番号を取得して、ハンドラへ渡す。
 */
intr_entry:
	mrs	r0, ipsr
	b	interrupt

/*
 * HardFaultエントリ
 *
 * 簡単なデバッグ情報を表示できるよう、例外発生時のSPを取得して
 * そのSPをHardFaultハンドラに渡す。
 *
 *	     +-------------+
 *	+  0 | R0          |	ハードウェアによる自動保存/退避
 *	+  4 | R1          |
 *	+  8 | R2          |
 *	+ 12 | R3          |
 *	+ 16 | R12         |
 *	+ 20 | R14(LR)     |
 *	+ 24 | R15(PC)     |
 *	+ 28 | xPSR        |
 *	     +-------------+
 */
hardfault_entry:
	/* LRに入っているEXC_RETURN[3:0]の値から、MSP/PSPを判定 */
	mrs	r0, msp
	mov	r1, lr
	lsl	r1, r1, #28
	lsr	r1, r1, #28	// r0 &= 0x0000000f
	cmp	r1, #0xd
	bne	1f
	mrs	r0, psp
1:
	/* HardFaultハンドラを呼び出し */
	bl	hardfault

	/* HardFaultハンドラの戻り値に応じ、動作継続/停止 */
	cmp	r0, #0
	beq	intr_entry
	b	die

/*
 * SVCエントリ
 *
 * SVC命令からベクタ番号を取得して、ハンドラへ渡す。
 * SVC命令は、スタックに保存された(PC-2)に存在する。
 */
svc_entry:
	/* LRに入っているEXC_RETURN[3:0]の値から、MSP/PSPを判定 */
	mrs	r0, msp
	mov	r1, lr
	lsl	r1, r1, #28
	lsr	r1, r1, #28	// r0 &= 0x0000000f
	cmp	r1, #0xd
	bne	1f
	mrs	r0, psp
1:
	/* スタック上からPCを取得し、SVC命令の存在するアドレスに補正 */
	ldr	r0, [r0, #24]
	sub	r0, r0, #2

	/* SVC命令に記述されたベクタ番号を取得 ※little-endianを前提 */
	ldrb	r0, [r0]
	b	interrupt

/*
 * コンテキストのレイアウト
 *
 * 以下の順番でコンテキスト（レジスタ）を保存する。
 *
 *	     +-------------+
 *	+  0 | R8          |
 *	+  4 | R9          |
 *	+  8 | R10         |
 *	+ 12 | R11         |
 *	+ 16 | R4          |
 *	+ 20 | R5          |
 *	+ 24 | R6          |
 *	+ 28 | R7          |
 *	+    +=============+
 *	+ 32 | R0          |	ハードウェアによる自動保存/退避
 *	+ 36 | R1          |
 *	+ 40 | R2          |
 *	+ 44 | R3          |
 *	+ 48 | R12         |
 *	+ 52 | R14(LR)     |
 *	+ 56 | R15(PC)     |
 *	+ 60 | xPSR        |
 *	     +-------------+
 */

/* ディスパッチャ（PendSVハンドラとして実装） */
pendsv_entry:
	// ハードウェアによる自動保存/退避対象外のレジスタは、
	// ARM ABIの定義によりプロシージャ内での破壊を禁止されている。
	// 故にここに到達した際は、例外発生時の内容がそのまま保持されている。

	cpsid	i

	/* PendSV要求をクリア */
	ldr	r1, =ICSR
	ldr	r2, =0x08000000	// PENDSVCLR
	ldr	r3, [r1]
	orr	r3, r3, r2
	str	r2, [r1]
	
	/* コンテキストスイッチの必要性をチェック */
	// running_context: 現在実行中の(古い)タスクのTCB
	// current: これから実行する、(新しい)タスクのTCB
	ldr	r2, =running_context
	ldr	r0, [r2]
	ldr	r1, =current
	ldr	r1, [r1]
	cmp	r0, r1
	beq	no_dispatch
	str	r1, [r2]		// running_contextの内容を更新
					// ※元の内容はr0に保存されている
	ldr	r3, =offsetof_kz_context
	ldr	r3, [r3]
	add	r0, r0, r3		// r0: &(running_context->sp)
	add	r1, r1, r3		// r1: &(current->sp)

	/* process stackにコンテキストを保存 */
	mrs	r3, psp
	sub	r3, r3, #0x10
	stmia	r3!, {r4-r7}
	mov	r4, r8
	mov	r5, r9
	mov	r6, r10
	mov	r7, r11
	sub	r3, r3, #0x20
	stmia	r3!, {r4-r7}
	sub	r3, r3, #0x10
	str	r3, [r0]

	/* process stackからコンテキストを復元 */
	ldr	r3, [r1]
	ldmia	r3!, {r4-r7}
	mov	r8, r4
	mov	r9, r5
	mov	r10, r6
	mov	r11, r7
	ldmia	r3!, {r4-r7}
	msr	psp, r3

no_dispatch:
	cpsie	i
	bx	lr

/* ディスパッチ要求を発行 */
	.global dispatch
dispatch:
	cpsid	i
	ldr	r1, =ICSR
	ldr	r2, =0x10000000	// PENDSVSET
	ldr	r3, [r1]
	orr	r3, r3, r2
	str	r2, [r1]
	cpsie	i
	bx	lr

	.pool

	.section .data
	.align 0

running_context:
	.long	0
