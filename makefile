.PHONY: all run test clean

all: test.prg

test.prg: test.s
	cl65 -t sim6502 -o $@ $<

# The program's answer is its exit status. Nonzero does not mean a failure here.
run: test.prg
	@sim65 test.prg; value=$$?; printf 'The 6502 returned: %s\n' "$$value"

# The finished program, with a=10, b=7, c=4, should return 30.
test: test.prg
	@sim65 test.prg; value=$$?; printf 'Expected 30, got %s\n' "$$value"; test "$$value" -eq 30

clean:
	rm -f test.prg test.o
