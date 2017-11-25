CSPREFIX  = /usr/local
CSBINDIR  = $(CSPREFIX)/bin
PREFIX    = /usr/local
BINDIR    = $(PREFIX)/bin

ARCH      = arm-none-eabi
ADDNAME   = $(ARCH)-

AR      = $(CSBINDIR)/$(ADDNAME)ar
AS      = $(CSBINDIR)/$(ADDNAME)as
CC      = $(CSBINDIR)/$(ADDNAME)gcc
LD      = $(CSBINDIR)/$(ADDNAME)ld
NM      = $(CSBINDIR)/$(ADDNAME)nm
OBJCOPY = $(CSBINDIR)/$(ADDNAME)objcopy
OBJDUMP = $(CSBINDIR)/$(ADDNAME)objdump
RANLIB  = $(CSBINDIR)/$(ADDNAME)ranlib
STRIP   = $(CSBINDIR)/$(ADDNAME)strip

LPC21ISP = $(BINDIR)/lpc21isp

# FreeBSD-4.x:/dev/cuaaX, FreeBSD-6.x:/dev/cuadX, FreeBSD(USB):/dev/cuaUx
# Linux:/dev/ttySx, Linux(USB):/dev/ttyUSBx, Windows:comX
LPC21ISP_SERDEV = /dev/cuad0

OBJS  = startup.o board_setup.o main.o interrupt.o intr.o
OBJS += lib.o serial.o

# sources of kozos
OBJS += kozos.o syscall.o memory.o consdrv.o command.o

TARGET = kozos

CFLAGS = -Wall -march=armv6s-m -mthumb -ffreestanding -nostartfiles
CFLAGS += -I.
#CFLAGS += -g
CFLAGS += -Os
CFLAGS += -DKOZOS
CFLAGS += -DDEBUG # デバッグ用
CFLAGS += -DCPU_CLOCK=48000000L

LFLAGS = -static -T ld.scr -L. -lgcc #requires libgcc

.SUFFIXES: .c .o
.SUFFIXES: .s .o
.SUFFIXES: .S .o

all :		$(TARGET) $(TARGET).hex

$(TARGET) :	$(OBJS)
		$(CC) $(OBJS) -o $(TARGET) $(CFLAGS) $(LFLAGS)
		cp $(TARGET) $(TARGET).elf
		$(STRIP) $(TARGET)

.c.o :		$<
		$(CC) -c $(CFLAGS) $<

.s.o :		$<
		$(CC) -c $(CFLAGS) $<

.S.o :		$<
		$(CC) -c $(CFLAGS) $<

$(TARGET).hex :	$(TARGET)
		$(OBJCOPY) -O ihex $(TARGET) $(TARGET).hex

write :		$(TARGET).hex
		$(LPC21ISP) $(TARGET).hex $(LPC21ISP_SERDEV) 115200 12000
clean :
		rm -f $(OBJS) $(TARGET) $(TARGET).elf $(TARGET).hex
