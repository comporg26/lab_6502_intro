# A Gentle Introduction to the 6502

## Introduction

You all have already written some x86-64 assembly. Today we're going to meet
another processor: the **MOS 6502**.

The 6502 was used in computers such as the Apple II and Commodore 64. It is
quite different from the processor in our server. It has an **8-bit
accumulator** (register A), which can hold one byte, and two other 8-bit
registers, X and Y. We won't need X and Y today.

We don't need a physical Apple II today. On `the.hell.am` we already have
`cl65`, which can assemble and link 6502 programs, and `sim65`, a simulator
which executes them. The server will still be running its own processor; the
simulator will pretend to be a 6502 for us.

Let's start learning some instructions.

## 1. Our first instructions

Open `test.s` and look at these two lines:

```asm
    lda #10
    sta i
```

`LDA` means *load accumulator*. The accumulator is a register named **A**.
The first instruction puts the number 10 into A.

`STA` means *store accumulator*. It copies the value from A into a location
in memory. We have called that location `i`.

Where is `i` defined? At the beginning of the file:

```asm
.segment "BSS"
i:      .res 1
j:      .res 1
k:      .res 1
result: .res 1
```

`.res 1` tells the assembler to reserve **one byte** for each of these
variables. The labels `i`, `j`, `k`, and `result` stand for memory addresses.
They are not registers.

Now look at another instruction:

```asm
    lda i
```

This looks almost like `lda #10`, doesn't it? But it means something quite
different:

* `lda #10` loads the **number 10** into A.
* `lda i` loads the **number stored in memory at `i`** into A.
* `sta i` stores the number currently in A **into memory at `i`**.

That little `#` matters. We'll use it quite often.

In the starter program we put 10 into `i`, then set A to zero, and then
load `i` back into A. The number hasn't disappeared! We saved it in memory.

## 2. Let's run it

Connect to our server, open the directory with your lab files, and type:

```sh
make
sim65 test.prg
echo $?
```

The last command should print `10`.

Our program didn't print anything to the screen. Instead, `sim65` takes
the value in A when our program finishes and uses it as the program's
**exit status**. The shell remembers the exit status of the last command
in `$?`.

So be sure to type `echo $?` **immediately** after `sim65 test.prg`.

You can also type:

```sh
make run
```

That will build and run the program and show its result.

Now change `lda #10` to `lda #25`, rebuild and run again. What happened?

Please open `answers.md` and write down your observation. Then change 25
back to 10.

## 3. Three variables

You know how to put 10 into `i`:

```asm
    lda #10
    sta i
```

Now do the same for two more variables:

```text
j := 7
k := 4
```

Add the necessary instructions to `test.s`.

## 4. Let's calculate something

Here is the task for today:

```text
result := (i + j) * 2 - k
```

With our numbers the result should be:

```text
(10 + 7) * 2 - 4 = 30
```

We already know how to load the value of `i` into A:

```asm
    lda i
```

How do we add `j`? The 6502 has an instruction called `ADC`:

```asm
    clc
    adc j
```

For now, you can think of `ADC` as adding `j` to the accumulator.
The `CLC` instruction prepares the processor for addition. **Leave it in
place.** We'll see why it is necessary when we learn about flags in a
later lab.

Subtraction looks similar:

```asm
    sec
    sbc k
```

`SBC` subtracts `k` from A. For today, leave `SEC` before it. We are not
going to investigate what is it an why it exists (spoiler alert: carry flag).

But wait. What about multiplication by two? There is no multiplication
instruction in the original 6502 instruction set!

Fortunately, we can use a left shift:

```asm
    asl
```

`ASL` shifts the bits in A one position to the left. For positive values
small enough to fit after doubling, this is the same as multiplying by 2.
For example:

```text
00000101    5
00001010   10    after ASL
```

See? We can multiply by two without a multiplication instruction.

**Now it is your turn.** After initializing `i`, `j`, and `k`, replace the
little demonstration at the end of `test.s` with the following unfinished
calculation:

```asm
    lda i          ; Start with i in the accumulator
    clc            ; Keep this instruction

    ; TODO: Add j to A
    ; TODO: Multiply A by 2

    sec            ; Keep this instruction

    ; TODO: Subtract k from A
    ; TODO: Store A in result

    lda result     ; Load result back from memory
    rts            ; Return the value in A to sim65
```

Please fill in the missing instructions. Don't just use `lda #30` at the end!
The idea is to calculate the result from the variables.

Build and run your program:

```sh
make
make run
```

Do you see **30**? Good! You have written a program that uses the
accumulator and memory to evaluate an expression.

You can also check it with:

```sh
make test
```

This checks whether the result is 30. Before your program is complete,
`make test` is expected to fail.

## 5. Are we really calculating?

Let's change the numbers. Make your program initialize them to:

```text
i := 20
j := 3
k := 5
```

Calculate the answer yourself first. Now run the program. Did you get the
same value?

Open `answers.md` and write your answer. Then restore the original values
(10, 7, 4), so that `make test` passes before you submit.

## 6. A little closer to hardware

One last thought. When we write:

```asm
    sta i
```

we are telling the CPU to store a byte at a memory address. On some real
6502 computers, certain addresses were connected not to RAM, but to things
like a display, a sound chip, or an input device. A program could control
them using the very same `STA` instruction.

Our `sim65` is not an Apple II or Commodore 64 emulator, but it has a small
simulated device of its own. **If your version of sim65 supports it**, this
code turns on instruction tracing:

```asm
    lda #$16
    sta $FFCB
```

And this turns it off:

```asm
    lda #0
    sta $FFCB
```

Here `$FFCB` is a specific hexadecimal memory address understood by the
simulator, not a variable that we declared. Writing to that address affects
the simulator's behavior. This is called **memory-mapped I/O**.

Now if you run sim65 test.prg, you'll see the simulated CPU executing
instructions. For now, just notice that it has an accumulator, and its
value changes as the program runs.

## What to submit

Open `answers.md` and answer its questions. Then commit and push:

* `test.s` with your finished calculation.
* `answers.md` with your observations.

You don't need to commit `test.prg`. It is generated by `make`.

If you want to explore further, here are two references:

* [6502 instruction set](https://www.masswerk.at/6502/6502_instruction_set.html)
* [sim65 users guide](https://cc65.github.io/doc/sim65.html)

Have fun!
