# REQUIRES: loongarch
# RUN: rm -rf %t && split-file %s %t

# RUN: llvm-mc --filetype=obj --triple=loongarch32 %t/32.s -o %t/32.o
# RUN: llvm-mc --filetype=obj --triple=loongarch64 %t/64.s -o %t/64.o

## LA32 IE
# RUN: ld.lld -shared %t/32.o -o %t/32.so
# RUN: llvm-readobj -r -d %t/32.so | FileCheck --check-prefix=IE32-REL %s
# RUN: llvm-objdump -d --no-show-raw-insn %t/32.so | FileCheck --check-prefixes=IE32 %s

## LA32 IE -> LE
# RUN: ld.lld %t/32.o -o %t/32
# RUN: llvm-readelf -r %t/32 | FileCheck --check-prefix=NOREL %s
# RUN: llvm-readelf -x .got %t/32 | FileCheck --check-prefix=LE32-GOT %s
# RUN: llvm-objdump -d --no-show-raw-insn %t/32 | FileCheck --check-prefixes=LE32 %s

## LA64 IE
# RUN: ld.lld -shared %t/64.o -o %t/64.so
# RUN: llvm-readobj -r -d %t/64.so | FileCheck --check-prefix=IE64-REL %s
# RUN: llvm-objdump -d --no-show-raw-insn %t/64.so | FileCheck --check-prefixes=IE64 %s

## LA64 IE -> LE
# RUN: ld.lld %t/64.o -o %t/64
# RUN: llvm-readelf -r %t/64 | FileCheck --check-prefix=NOREL %s
# RUN: llvm-readelf -x .got %t/64 | FileCheck --check-prefix=LE64-GOT %s
# RUN: llvm-objdump -d --no-show-raw-insn %t/64 | FileCheck --check-prefixes=LE64 %s

# IE32-REL:      FLAGS STATIC_TLS
# IE32-REL:      .rela.dyn {
# IE32-REL-NEXT:   0x20230 R_LARCH_TLS_TPREL32 - 0xC
# IE32-REL-NEXT:   0x20234 R_LARCH_TLS_TPREL32 - 0x1000
# IE32-REL-NEXT:   0x2022C R_LARCH_TLS_TPREL32 a 0x0
# IE32-REL-NEXT: }

# IE64-REL:      FLAGS STATIC_TLS
# IE64-REL:      .rela.dyn {
# IE64-REL-NEXT:   0x20398 R_LARCH_TLS_TPREL64 - 0xC
# IE64-REL-NEXT:   0x203A0 R_LARCH_TLS_TPREL64 - 0x1000
# IE64-REL-NEXT:   0x20390 R_LARCH_TLS_TPREL64 a 0x0
# IE64-REL-NEXT: }

## LA32:
## &.got[0] - . = 0x2022c - 0x101b0: 0x10 pages, page offset 0x22c
## &.got[1] - . = 0x20230 - 0x101bc: 0x10 pages, page offset 0x230
## &.got[2] - . = 0x20234 - 0x101c8: 0x10 pages, page offset 0x234
# IE32:      101b0: pcalau12i $a4, 16
# IE32-NEXT:        ld.w $a4, $a4, 556
# IE32-NEXT:        add.w $a4, $a4, $tp
# IE32-NEXT: 101bc: pcalau12i $a5, 16
# IE32-NEXT:        ld.w $a5, $a5, 560
# IE32-NEXT:        add.w $a5, $a5, $tp
# IE32-NEXT: 101c8: pcalau12i $a6, 16
# IE32-NEXT:        ld.w $a6, $a6, 564
# IE32-NEXT:        add.w $a6, $a6, $tp

## LA64:
## &.got[0] - . = 0x20390 - 0x102b8: 0x10 pages, page offset 0x390
## &.got[1] - . = 0x20398 - 0x102c4: 0x10 pages, page offset 0x398
## &.got[2] - . = 0x203a0 - 0x102d0: 0x10 pages, page offset 0x3a0
# IE64:      102b8: pcalau12i $a4, 16
# IE64-NEXT:        ld.d $a4, $a4, 912
# IE64-NEXT:        add.d $a4, $a4, $tp
# IE64-NEXT: 102c4: pcalau12i $a5, 16
# IE64-NEXT:        ld.d $a5, $a5, 920
# IE64-NEXT:        add.d $a5, $a5, $tp
# IE64-NEXT: 102d0: pcalau12i $a6, 16
# IE64-NEXT:        ld.d $a6, $a6, 928
# IE64-NEXT:        add.d $a6, $a6, $tp

# NOREL: no relocations

# a@tprel = st_value(a) = 0x8
# b@tprel = st_value(b) = 0xc
# c@tprel = st_value(c) = 0x1000
# LE32-GOT: section '.got':
# LE32-GOT-NEXT: 0x00030138 08000000 0c000000 00100000
# LE64-GOT: section '.got':
# LE64-GOT-NEXT: 0x000301f0 08000000 00000000 0c000000 00000000
# LE64-GOT-NEXT: 0x00030200 00100000 00000000

## LA32:
## &.got[0] - . = 0x30138 - 0x20114: 0x10 pages, page offset 0x138
## &.got[1] - . = 0x3013c - 0x20120: 0x10 pages, page offset 0x13c
## &.got[2] - . = 0x30140 - 0x2012c: 0x10 pages, page offset 0x140
# LE32:      20114: pcalau12i $a4, 16
# LE32-NEXT:        ld.w $a4, $a4, 312
# LE32-NEXT:        add.w $a4, $a4, $tp
# LE32-NEXT: 20120: pcalau12i $a5, 16
# LE32-NEXT:        ld.w $a5, $a5, 316
# LE32-NEXT:        add.w $a5, $a5, $tp
# LE32-NEXT: 2012c: pcalau12i $a6, 16
# LE32-NEXT:        ld.w $a6, $a6, 320
# LE32-NEXT:        add.w $a6, $a6, $tp

## LA64:
## &.got[0] - . = 0x301f0 - 0x201c8: 0x10 pages, page offset 0x1f0
## &.got[1] - . = 0x301f8 - 0x201d4: 0x10 pages, page offset 0x1f8
## &.got[2] - . = 0x30200 - 0x201e0: 0x10 pages, page offset 0x200
# LE64:      201c8: pcalau12i $a4, 16
# LE64-NEXT:        ld.d $a4, $a4, 496
# LE64-NEXT:        add.d $a4, $a4, $tp
# LE64-NEXT: 201d4: pcalau12i $a5, 16
# LE64-NEXT:        ld.d $a5, $a5, 504
# LE64-NEXT:        add.d $a5, $a5, $tp
# LE64-NEXT: 201e0: pcalau12i $a6, 16
# LE64-NEXT:        ld.d $a6, $a6, 512
# LE64-NEXT:        add.d $a6, $a6, $tp

#--- 32.s
la.tls.ie $a4, a
add.w $a4, $a4, $tp
la.tls.ie $a5, b
add.w $a5, $a5, $tp
la.tls.ie $a6, c
add.w $a6, $a6, $tp

.section .tbss,"awT",@nobits
.globl a
.zero 8
a:
.zero 4
b:
.zero 0x1000-8-4
c:

#--- 64.s
la.tls.ie $a4, a
add.d $a4, $a4, $tp
la.tls.ie $a5, b
add.d $a5, $a5, $tp
la.tls.ie $a6, c
add.d $a6, $a6, $tp

.section .tbss,"awT",@nobits
.globl a
.zero 8
a:
.zero 4
b:
.zero 0x1000-8-4
c:
