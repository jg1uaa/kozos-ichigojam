#define	MEMMAP		0x40048000
#define	SYSPLLCTRL	0x40048008
#define	SYSPLLSTAT	0x4004800c
#define	SYSPLLCLKSEL	0x40048040
#define	SYSPLLCLKUEN	0x40048044
#define	MAINCLKSEL	0x40048070
#define	MAINCLKUEN	0x40048074
#define	AHBCLKCTRL	0x40048080
#define	PDRUNCFG	0x40048238

	.section .text
	.thumb
	.align 0
	.global	board_setup

board_setup:	

memmap_init:	// ベクタエリアをLPC111xx内蔵ブートローダからFlashROMに切替
	ldr	r4, =MEMMAP
	mov	r2, #2
	str	r2, [r4]

pll_init:
	//	デフォルトのクロック設定は以下の通り。
	//		MAINCLKSEL	0x000	main clock: 内蔵発振器(12MHz)
	//		SYSAHBCLKDIV	0x001	system clock: main clock/1
	//		SSP0CLKDIV	0x000	SPI0_PCLK: disable
	//		UARTCLKDIV	0x000	UART_PCLK: disable
	//		SSP1CLKDIV	0x000	SPI1_PCLK: disable
	//		WDT他は省略

	mov	r0, #0
	mov	r1, #1

	ldr	r4, =MAINCLKSEL		// main clock: 内蔵発振器(12MHz)
	str	r0, [r4]		// 安全のために設定しておく
	ldr	r4, =MAINCLKUEN
	str	r0, [r4]
	str	r1, [r4]

	ldr	r4, =PDRUNCFG		// System PLL power-up
	ldr	r2, [r4]
	mov	r3, #0x80
	bic	r2, r2, r3
	str	r2, [r4]

	ldr	r4, =SYSPLLCLKSEL	// PLL clock source: 内蔵発振器(12MHz)
	str	r0, [r4]
	ldr	r4, =SYSPLLCLKUEN
	str	r0, [r4]
	str	r1, [r4]

	ldr	r4, =SYSPLLCTRL		// Fcco = 2 x P x FCLKOUT
	mov	r2, #0x23		//  192MHz = 2 x 2 x 48MHz
	str	r2, [r4]		// M = FCLKOUT / FCLKIN
					//  4 = 48MHz / 12MHz

	ldr	r4, =SYSPLLSTAT		// PLLのロック待ち
pll_wait:
	ldr	r2, [r4]
	tst	r2, r1
	beq	pll_wait

	ldr	r4, =MAINCLKSEL		// main clock: system PLL
	mov	r2, #0x03
	str	r2, [r4]
	ldr	r4, =MAINCLKUEN
	str	r0, [r4]
	str	r1, [r4]

clock_init:
	ldr	r4, =AHBCLKCTRL
	ldr	r2, [r4]
	ldr	r3, =0x00010000		// IOCON
	orr	r2, r2, r3
	str	r2, [r4]

	bx	lr

	.pool
