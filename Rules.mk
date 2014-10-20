TOOL_PREFIX = arm-none-eabi-
CC = $(TOOL_PREFIX)gcc
OBJCOPY = $(TOOL_PREFIX)objcopy

CFLAGS  = -g -Os -Wall -nostdlib -I.
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m3 -mfloat-abi=soft

CFLAGS += -MMD -MF .$(@F).d
DEPS = .*.d

AFLAGS += $(CFLAGS) -D__ASSEMBLY__
LDFLAGS += $(CFLAGS) -Wl,--gc-sections

.DEFAULT_GOAL := all

.PHONY: clean

.SECONDARY:

%.o: %.c Makefile
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S Makefile
	$(CC) $(AFLAGS) -c $< -o $@

%.ld: %.ld.S Makefile
	$(CC) -P -E $(AFLAGS) $< -o $@

clean:
	rm -f *~ *.o *.elf *.hex *.bin *.ld $(DEPS)

-include $(DEPS)