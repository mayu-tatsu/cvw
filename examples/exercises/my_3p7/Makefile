fir.objdump: fir
	riscv64-unknown-elf-objdump -S -D fir > fir.objdump

# changed -O to -O2

fir: fir.c Makefile
	riscv64-unknown-elf-gcc -o fir -gdwarf-2 -O2\
	  -march=rv64gc -mabi=lp64d -mcmodel=medany \
	  -nostdlib -static -lm -fno-tree-loop-distribute-patterns \
	  -T../../C/common/test.ld \
	  -I../../C/common \
	  fir.c \
	  ../../C/common/crt.S \
	  ../../C/common/syscalls.c

clean:
	rm -f fir fir.objdump
