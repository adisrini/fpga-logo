# LOGO IDE on FPGA

**Team Members**: Josh Xu, Aditya Srinivasan, Hunter Lee


## Project Description

### Overview
For our project, we plan to develop an IDE for the [LOGO programming language](https://en.wikipedia.org/wiki/Logo_(programming_language)). The language was designed as a tool to help young students learn concepts of programming and computer science in the 1960s and 1970s. It is a variant of Lisp and utilizes a turtle graphic to demonstrate to the user the effects of valid commands.

### Inputs and Outputs
_Input_: We plan on using a PS2 keyboard as the primary source of input, through which users can enter valid commands to control the turtle. Examples of commands include fwd 50 (which causes the turtle to move forward in the direction it’s facing by 50 unit distance). The full list of commands (subject to slight change) that we plan to implement is:
```
	FWD x			(move forward x units)
	BKD x			(move backward x units)
	LRT x			(rotate leftwards 90 degrees x times)
	RRT x			(rotate rightwards 90 degrees x times)
	UND			    (undo last command)
	RDO			    (redo latest command, if possible)
	CTC x			(change turtle color to color x)
	CBC x			(change background color to color x)
	CLC x			(change line color to color x)
	ADD x y		    (display x + y)
	SUB x y		    (display x - y)
	AND x y		    (display x & y)
	_OR x y		    (display x | y)
	MUL x y		    (display x * y)
	DIV x y		    (display x / y)
	RPT x			(repeat the instruction afterwards x times)
	EQL x y		    (execute the instruction after if x == y)
	_LT x y		    (execute the instruction after if x < y)	
	STO x y		    (store variable of value x with index y)
```

Furthermore, these inputs will be typed and displayed on the LCD display, which will serve as a terminal-like window.


_Output_: We plan on displaying the turtle’s movement and output of mathematical calculations using the VGA. We also plan on using the FPGA LED array to signal particular events to the user, such as invalid commands or overflow/exceptions.


### Modifications to the processor

**Module 1**

> __Goal__: Convert valid LOGO command to an instruction that can be understood by the processor

> __Input__: Command string

> __Output__: Function opcode with a valid bit indicating it is a valid command

**Module 2**

> __Goal__: Encode PS2 input into a 32-bit instruction to be decoded later

> __Input__: Keyboard input through PS2

> __Output__: 32-bit instruction to be stored in the memory

**Module 3**

> __Goal__: Encode PS2 input to be displayed on the LCD

> __Input__: Keyboard input through PS2

> __Output__: LCD input display data


### Code to be run on the processor

We will have assembly code that runs the entire program. This will consist of an input loop, similar to a game loop, that detects whether there exists a new instruction (input string) from PS2. This will trigger following steps to execute the command, which will depend on the current state of the turtle (which will exist in DMEM. 

### Conventions

Certain registers in the register file are special purpose registers:

**$30**: holds current command
**$29**: holds current state
**$28**: turtle state pointer (to DMEM)
**$27**: command history pointer (to DMEM)
**$26**: variables pointer (to DMEM)

### General Timeline

**Week 1 (Nov 21)**: We will make necessary modifications to the processor by implementing aforementioned modules. We will begin working on the parser and be able to create a basic visualization of the turtle on the screen, with basic commands to move turtle. We will establish the conventions of data memory (outlined below).

**Week 2 (Nov 28)**: Complete commands that make modifications to the turtle’s position and orientation. Implement ability to undo/redo, and display mathematical calculations.


## Appendix


<p align="center">
<img src="/assets/graphic.png" width=300px/> <br />
<b>Figure 1</b>: Proposed graphic design of our project
</p>

<br />

<p align="center">
<img src="/assets/data-memory-segmentation.png" width=300px /><br />
<b>Figure 2</b> Data memory segmentation, with designated pointers (registers)
</p>
