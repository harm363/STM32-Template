TEMPLATEROOT = .

# compilation flags for gdb

CFLAGS  = -O1 -g
ASFLAGS = -g 

# object files

OBJS=  $(STARTUP) main.o stm32f10x_usart.o stm32f10x_rcc.o

# include common make file

#include $(TEMPLATEROOT)/Makefile.common


# name of executable

ELF=$(notdir $(CURDIR)).elf                    

# Tool path

TOOLROOT=/home/harm/software/gcc-arm-none-eabi-10.3-2021.10/bin

# Library path

LIBROOT=/home/harm/server/thuis/stm32/stm32_library/STM32F10x_StdPeriph_Lib_V3.5.0

# Tools

CC=$(TOOLROOT)/arm-none-eabi-gcc
LD=$(TOOLROOT)/arm-none-eabi-gcc
AR=$(TOOLROOT)/arm-none-eabi-ar
AS=$(TOOLROOT)/arm-none-eabi-as

# Code Paths

DEVICE=$(LIBROOT)/Libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x
CORE=$(LIBROOT)/Libraries/CMSIS/CM3/CoreSupport
PERIPH=$(LIBROOT)/Libraries/STM32F10x_StdPeriph_Driver

# Search path for standard files

vpath %.c $(TEMPLATEROOT)

# Search path for perpheral library

vpath %.c $(CORE)
vpath %.c $(PERIPH)/src
vpath %.c $(DEVICE)

# Search path for Library

#vpath %.c $(TEMPLATEROOT)/Library/ff9/src
#vpath %.c $(TEMPLATEROOT)/Library/ff9/src/option
#vpath %.c $(TEMPLATEROOT)/Library

#  Processor specific

PTYPE = STM32F10X_MD_VL 
LDSCRIPT = $(TEMPLATEROOT)/stm32f100.ld
STARTUP= startup_stm32f10x.o system_stm32f10x.o 

# Compilation Flags

FULLASSERT = -DUSE_FULL_ASSERT 

LDFLAGS+= -T$(LDSCRIPT) -mthumb -mcpu=cortex-m3 
CFLAGS+= -mcpu=cortex-m3 -mthumb 
CFLAGS+= -I$(TEMPLATEROOT) -I$(DEVICE) -I$(CORE) -I$(PERIPH)/inc -I.
CFLAGS+= -D$(PTYPE) -DUSE_STDPERIPH_DRIVER $(FULLASSERT)
CFLAGS+= -I$(TEMPLATEROOT)/Library/ff9/src -I$(TEMPLATEROOT)/Library

# Build executable 

$(ELF) : $(OBJS)
	cd debug;
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LDLIBS)

# compile and generate dependency info

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o debug/$@
	$(CC) -MM $(CFLAGS) $< > debug/$*.d

%.o: %.s
	$(CC) -c $(CFLAGS) $< -o $@

clean:
#	rm -f $(OBJS) $(OBJS:.o=.d) $(ELF) startup_stm32f* $(CLEANOTHER)
	rm -f debug/*

debug: $(ELF)
	arm-none-eabi-gdb $(ELF)


# pull in dependencies

-include $(OBJS:.o=.d)




