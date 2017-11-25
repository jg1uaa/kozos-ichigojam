/* Cortex-M0 System Control Spaceの定義 */

#define	SystemControlSpace	0xe000e000

/* System Control and ID registers */
#define	ACTLR			(SystemControlSpace + 0x0008)
#define	CPUID			(SystemControlSpace + 0x0d00)
#define	ICSR			(SystemControlSpace + 0x0d04)
#define	VTOR			(SystemControlSpace + 0x0d08)
#define	AIRCR			(SystemControlSpace + 0x0d0c)
#define	SCR			(SystemControlSpace + 0x0d10)
#define	CCR			(SystemControlSpace + 0x0d14)
#define	SHPR2			(SystemControlSpace + 0x0d1c)
#define	SHPR3			(SystemControlSpace + 0x0d20)
#define	SHCSR			(SystemControlSpace + 0x0d24)
#define	DFSR			(SystemControlSpace + 0x0d30)

/* SysTick (optional) */
#define	SYST_CSR		(SystemControlSpace + 0x0010)
#define	SYST_RVR		(SystemControlSpace + 0x0014)
#define	SYST_CVR		(SystemControlSpace + 0x0018)
#define	SYST_CALIB		(SystemControlSpace + 0x001c)

/* NVIC */
#define	NVIC_ISER		(SystemControlSpace + 0x0100)
#define	NVIC_ICER		(SystemControlSpace + 0x0180)
#define	NVIC_ISPR		(SystemControlSpace + 0x0200)
#define	NVIC_ICPR		(SystemControlSpace + 0x0280)
#define	NVIC_IPR(n)		(SystemControlSpace + 0x0400 + 4 * (n))

/* Debug (optional) */
#define	DHCSR			(SystemControlSpace + 0x0df0)
#define	DCRSR			(SystemControlSpace + 0x0df4)
#define	DCRDR			(SystemControlSpace + 0x0df8)
#define	DEMCR			(SystemControlSpace + 0x0dfc)

/* MPU (optional) */
#define	MPU_TYPE		(SystemControlSpace + 0x0d90)
#define	MPU_CTRL		(SystemControlSpace + 0x0d94)
#define	MPU_RNR			(SystemControlSpace + 0x0d98)
#define	MPU_RBAR		(SystemControlSpace + 0x0d9c)
#define	MPU_RASR		(SystemControlSpace + 0x0da0)
