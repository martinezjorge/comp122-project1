.equ OpenFile, 0x66


			
ldr r0,=InFileName		@ set Name for input file
mov r1,#0			@ mode is input
swi OpenFile			@ open file for input
bcs FileError			@ branch to error message output


ldr r1,=InFileHandle		@ store location of InFileHandle
str r0,[r1]			@ store file handle where IFH is pointing

ldr r0,[r1]			@ load the file handle into r0
mov r1,#0			@ set read mode for input

swi 0x6c			@ read an integer
bcs EmptyFile
mov r7,r0			@ store the first integer in r7
mov r9,#1			@ store a 1 in r9 to represent the first number that has been counted
mov r8,#0			@ the number of integers less than i, initialized to 0
mov r6,r0			@ the first integer value i

@@@@@@@@@@@@@@@@@@@@@@@ Read integers until EOF @@@@@@@@@@@@@@@@@@@@@@@
RLoop:

	ldr r1,=InFileHandle		@ store location of file handle
	ldr r0,[r1]			@ load the file handle into r0
	swi 0x6c			@ read an integer
	bcs EofReached			@ Check Carry-Bit (C): if=1 then EOF

	add r9,r9,#1			@ add one to counter
	
	cmp r0,r6			@ compare integer read with i
	addlt r8,r8,#1			@ if integer is less than i add 1

	cmp r0,r7			@ compare integer read with j
	movgt r7,r0			@ if integer > j make integer new r7

bal RLoop

EofReached:

ldr r1,=InFileHandle		@ store file handle in r1
swi 0x68			@ close the file

@@@@@@@@@@@@@@@@@@@@@@@ PRINTING VALUES @@@@@@@@@@@@@@@@@@@@@@@@@@@@

mov r0,#1			@ set r0 for file output
ldr r1,=Output1			@ load output message
swi 0x69			@ print output message
mov r0,#1			@ set r0 for file output
mov r1,r6			@ move r6 in to r1
swi 0x6b			@ print r6

mov r0,#1			@ set r0 for file output
ldr r1,=Output2			@ load output message
swi 0x69			@ print output message
mov r0,#1			@ set r0 for file output
mov r1,r7			@ move r7 to r1
swi 0x6b			@ print r7

mov r0,#1			@ set r0 for file output
ldr r1,=Output3			@ load output message
swi 0x69			@ print output message
mov r0,#1			@ set r0 for file output
mov r1,r8			@ move r8 to r1
swi 0x6b			@ print r8

mov r0,#1			@ set r0 for file output
ldr r1,=Output4			@ load output message
swi 0x69			@ print output message
mov r0,#1			@ set r0 for file output
mov r1,r9			@ move r9 to r1
swi 0x6b			@ print r9

swi 0x11            @ exit program


FileError:

mov r0,#1			@ set r0 for file output
ldr r1,=InFileError		@ load output message
swi 0x69			@ print output message
swi 0x11			@ exit program

EmptyFile:

mov r0,#1			@ set r0 for file output
ldr r1,=FileIsEmpty		@ load output message
swi 0x69			@ print output message
swi 0x11			@ exit program

InFileName: .asciz	"integers.dat"
FileIsEmpty: .asciz "File empty!"
InFileError: .asciz	"Unable to open input file; check file location.\n" 
	.align
Output1: .asciz "First Integer Read: "
Output2: .asciz "\nGreatest Integer Read: "
Output3: .asciz "\nTotal Integers Read Less Than First: "
Output4: .asciz "\nTotal Integers Read: "
@ allocate 4 bytes to save the integer address of the file handle
InFileHandle: .skip 4

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@NOTES@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@ keep track of
@ the first integer value i		 store this in r6
@ the integer with the greatest value j  store this in r7
@ the number of integers less than i     store this in r8
@ the total number of integers           store this in r9

@ output the four pieces of information to the console in a nice format
