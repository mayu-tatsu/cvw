fir.objdump: fir
	riscv64-unknown-elf-objdump -S -D fir > fir.objdump

fir: fir.S Makefile
	riscv64-unknown-elf-gcc -o fir -gdwarf-2 -O3 \
	  -march=rv64gc -mabi=lp64d -mcmodel=medany \
	  -nostdlib -static -lm -fno-tree-loop-distribute-patterns \
	  -T../../C/common/test.ld \
	  -I../../C/common \
	  fir.S \
	  mul_add.c \
	  main.c \
	  ../../C/common/crt.S \
	  ../../C/common/syscalls.c

clean:
	rm -f fir fir.objdump
