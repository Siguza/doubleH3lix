/*
 * arch.h - Code to deal with different architectures.
 *          Taken from kern-utils
 *
 * Copyright (c) 2014 Samuel Groß
 * Copyright (c) 2016-2017 Siguza
 */

#ifndef ARCH_H
#define ARCH_H

#include <mach-o/loader.h>      // mach_header, mach_header_64, segment_command, segment_command_64
#include <Foundation/Foundation.h> // NSLog

#include "common.h"

#define IMAGE_OFFSET 0x2000
#define MACH_TYPE CPU_TYPE_ARM64
#define SIZE "%lu"
#define MACH_LC_SEGMENT_NAME "LC_SEGMENT_64"
#define KERNEL_SPACE 0x8000000000000000
typedef struct section_64 mach_sec_t;

#define MAX_HEADER_SIZE 0x4000

typedef struct
{
    mach_vm_address_t addr;
    mach_vm_size_t len;
    char *buf;
} segment_t;

#endif
