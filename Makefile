ARCH := arm
CROSS_COMPILE := arm-linux-
CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)ld
OBJ_COPY := $(CROSS_COMPILE)objcopy
OBJ_DUMP := $(CROSS_COMPILE)objdump

PLATFORM := 

INCLUDE_DIR := 
CCFLAG := -Wall -nostdlib -fno-builtin

