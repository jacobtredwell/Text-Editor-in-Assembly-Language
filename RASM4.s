@******************************************************************************************
@ Name:    Jacob Tredwell & Nicholas Lozano
@ Program: rasm4.s
@ Class:   CS3B
@ Lab:     RASM4
@ Date:    November 18, 2020 at 3:30 PM
@ Purpose:
@	For this assignment, you will be creating a Menu driver program that serves as a 
@	text editor and save the resulting text to a file. You must be able to enter new strings manually 
@	and/or via a file (input.txt). All additions are additive (i.e. i can call 2b 5 x times and 5 copies 
@ 	of the text file would be stored in the data structure (linked list of strings). Use the enclosed file 
@	for possible input. Do not load automatically, only via the menu.
@******************************************************************************************



		.equ	KBSIZE, 512					@ assigns value 512 to symbol KBSIZE

		.data

kbBuf:		.skip	KBSIZE						@ limit for typing into the keyboard

crCr:		.byte 	10						@ byte holds carriage return

strMenuHdr:	.asciz 	"RASM4:  TEXT EDITOR"				@holds that string

strMenuHdr2:	.asciz "Data Structure Heap Memory Consumption: "	@ holds that string

strMenuHdr3:	.asciz "Number of Nodes: "				@ holds that string

strBytes:	.asciz " bytes"						@ holds that string

strMenu1:	.asciz 	"<1> View all strings"

strMenu2: 	.asciz 	"<2> Add string <a> from Keyboard <b> from File. Static file named input.txt"

strMenu3:	.asciz	"<3> Delete string. Given an index #, delete the entire string and de-allocate memory (including the node)"

strMenu4:	.asciz 	"<4> Edit string. Given an index #, replace old string w/ new string. Allocate/De-allocate as needed."

strMenu5:	.asciz	"<5> String search. Regardless of case, return all strings that match the substring given"

strMenu6: 	.asciz	"<6> Save File (output.txt)"

strMenu7:	.asciz	"<7> Quit"

strMenuChoice:	.asciz	"Enter menu choice: "				@holds menuChoice string

strM1:		.asciz 	"View Strings Module"				@holds that string
strM2:		.asciz	"ADD STRINGS MODULE"				@holds that string
strM3:		.asciz	"Delete String Module"				@holds that string
strM4:		.asciz	"Edit String Module"				@holds that string

str2bSucc:	.asciz 	"Input File Successfully Read."			@holds that string
str3Fail:	.asciz	"Specified index is out of bounds. No change made.\n"
str5Fail:	.asciz	"\nThe specified substring was not found anywhere.\n\n"

strSave:	.asciz 	"New Output File Successfully Created 'output.txt'"		@holds that string

strMain:	.asciz	"Press 1 for Main Menu: "			@holds that string

intStore:	.word	0						@holds menu choice integer from INPUT
int2Store:	.word	0						@holds menu choice integer from INPUT

strStore:	.skip	KBSIZE						@ holds s1 string

strTemp:	.skip	KBSIZE						@ to be used for temporarily storing strings

strS2:		.asciz	"Enter '1' for <a> from Keyboard OR Enter '2' for <b> from File: "
strS3:		.asciz "Enter an index # to delete: "			@holds that string
str2a:		.asciz	"Enter string:  "

str2b:		.asciz 	"Add String from file named input.txt"

strS4:		.asciz	"Enter an index # to replace: "			@holds that string
strS42:		.asciz	"Enter the string to replace your selection with: "


str5:		.asciz "Enter substring to search for: "		@holds this string

intNodes:	.word 0							@ number of total nodes
intBytes:	.word 0							@ number of total bytes allocated on the heap

strNewStr:	.skip 40

strNull:	.asciz ""						@ null character

szPrompt:	.asciz 	"Please enter a string: "
szPromptDel:	.asciz 	"Please enter an index # to delete a node: "
szMsg1:		.asciz 	"The length of the string is "
szRes:		.skip 13		@ holds temp strings
listHead:	.word 0			@ head = nullptr
listTail:	.word 0			@ tail = nullptr
listCurrent:	.word 0			@ current = nullptr
szCRNL:		.asciz "\r\n"		@ new line character with a null terminator
crBracketL:	.byte 91		@ holds left bracket [
crBracketR:	.byte 93		@ holds right bracket ]
crSpace:	.byte 32		@ holds space character " "

filename: 	.asciz "input.txt"
outfilename:	.asciz "output.txt"
Handle:		.skip 	4		@holds the file handle
outHandle:	.skip	4		@holds the output file handle
readBuffer:	.skip 	1		@holds the read buffer
szReadHold:	.skip	1		@holds the read holder

	.text

	.global _start						@ provide program starting address to linker

	.extern	malloc			@ allows for dynamic memory allocation
	.extern	free			@ allows for dynamic memory freeing

_start:


print_menu:


@-----------print header---------------------------------------------------------------------


	ldr     r0, =strMenuHdr			@loads address StrMenuHdr string
	bl    	putstring			@prints name string
	
	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	/*** outputting heap memory allocation and node count ***/

	ldr	r0, =strMenuHdr2		@loads address strMenuHdr2 string
	bl	putstring			@prints header string

	ldr	r0, =intBytes			@loads address intBytes word
	ldr	r0, [r0]			@dereference pointer to r0
	ldr	r1, =strStore			@loads address strStore kb buffer
	bl	intasc32			@call intasc32, store in strStore
	ldr	r0, =strStore			@loads address strStore kb buffer
	bl	putstring			@output intBytes

	ldr	r0, =strBytes			@loads address strBytes word
	bl	putstring			@output strBytes

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strMenuHdr3		@loads address strMenuHdr3 string
	bl	putstring			@output header

	ldr	r0, =intNodes			@loads address intNodes
	ldr	r0, [r0]			@dereference pointer to r0
	ldr	r1, =strStore			@loads address strStore kb buffer
	bl	intasc32			@call intasc32, store in strStore
	ldr	r0, =strStore			@loads address strStore kb buffer
	bl	putstring			@output intNodes


	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

@-----------print menu line 1----------------------------------------------------------------

	ldr     r0, =strMenu1			@loads address StrMenuChoice string
	bl    	putstring			@prints name string
	
	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

@-----------print menu line 2------------------------------------------------------------------

	ldr     r0, =strMenu2			@loads address StrMenuChoice string
	bl    	putstring			@prints name string
	
	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

@-----------print menu line 3----------------------------------------------------------------

	ldr     r0, =strMenu3			@loads address StrMenuChoice string
	bl    	putstring			@prints name string
	
	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

@-----------print menu line 4----------------------------------------------------------------

	ldr     r0, =strMenu4			@loads address StrMenuChoice string
	bl    	putstring			@prints name string
	
	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

@-----------print menu line 5----------------------------------------------------------------

	ldr     r0, =strMenu5			@loads address StrMenuChoice string
	bl    	putstring			@prints name string
	
	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

@-----------print menu line 6 ----------------------------------------------------------------

	ldr     r0, =strMenu6			@loads address StrMenuChoice string
	bl    	putstring			@prints name string
	
	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

@-----------print menu line 7----------------------------------------------------------------

	ldr     r0, =strMenu7			@loads address StrMenuChoice string
	bl    	putstring			@prints name string
	
	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'



/***********************GET MENU CHOICE******************************************************************/
menu_choice:

	ldr     r0, =strMenuChoice		@loads address StrMenuChoice string
	bl    	putstring			@prints name string

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strS1store

	bl 	ascint32			@call ascint32 external fn, store use input into strStore

	mov	r1, r0				@move copy of INT menu INPUT into r1

	cmp	r1, #1				@compare r1 and #1
	beq	clearToStart1			@branch to ClearToStart1

	cmp 	r1, #2				@compare r1 and #2
	beq	clearToStart2			@branch to clearToStart2

	cmp	r1, #3				@compare r1 and #3
	beq	clearToStart3			@branch to clearToStart3

	cmp 	r1, #4				@compare r1 and #4
	beq	clearToStart4			@branch to clearToStart4

	cmp 	r1, #5				@compare r1 and #5
	beq	clearToStart5			@branch to clearToStart5


	cmp 	r1, #6				@compare r1 and #6
	beq	clearToStart6			@branch to clearToStart6


	cmp	r1, #7				@compare r1 and #7	
	beq	quit				@branch to quit

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   START 1 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

start1:


	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strM1			@r0 points to strM1
	bl	putstring			@prints "View Strings Module" to user

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'


	ldr	r0, =intNodes			@ load into r0 the address of intNodes
	ldr	r0, [r0]			@ dereference pointer to intNodes
	cmp	r0, #0				@ compare node count to 0
	blgt	outputList			@ output all strings in the linked list if node > 0

@-------------exiting 1-------------------------------------------------------------------------------

	ldr     r0, =strMain			@loads address of strMain  "Press 1 for Main Menu: "
	bl    	putstring			@prints string

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strS1store

	bl 	ascint32			@call ascint32 external fn, store use input into strStore

	mov	r3, r0				@r3 now holds int that was entered
					
	cmp	r3, #1				@compare r3 and #1

	beq	clearToMain			@branch to print menu at beginning


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   END 1 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   START 2 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

start2:

	@----------gets user input string --------------------------------------------------------------------


	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strM2			@r0 points to strM2
	bl	putstring			@prints "ADD STRING MODULE"

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strS2			@r0 points to strS2
	bl	putstring			@prints "enter 1 for <a> and <2> for <b> to user
	
	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strS1store


	bl 	ascint32			@call ascint32 external fn, to convert to an int

	mov	r1, r0				@moves int into r1

	cmp	r1, #1				@compare r1 and #1
	beq	start2a				@branch to start 2a if equal


	cmp 	r1, #2				@compare r1 and #2
	beq	start2b				@branch to start


@-----------------------------------------------------------------------------------


start2a:

	ldr	r0, =str2a			@r0 points to str2a
	bl	putstring			@prints "Enter string "
	
	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strStore

	/*** create a new node on the linked list ***/

	ldr	r0, =strStore			@ load the input string back into r0

	/*** each node's string must end with a \n, so concatenate one to the string ***/ 

	ldr	r1, =szCRNL			@ load into r1 the address of szCRNL
	bl	String_concat			@ concatenate the new line feed to the string

	@ String_concat gives a dynamically allocated string, so no need to copy this time

	bl	appendNode			@ create a new node with the string

	/*** prompts user to return to menu ***/

	ldr     r0, =strMain			@loads address of strMain  "Press 1 for Main Menu: "
	bl    	putstring			@prints string

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strS1store

	bl 	ascint32			@call ascint32 external fn, store use input into strStore

	mov	r3, r0				@r3 now holds int that was entered
					
	cmp	r3, #1				@compare r3 and #1

	beq	clearToMain			@branch to print menu at beginning



@-----------------------------------------------------------------------------------

start2b:

mov	r8, #0				@r8 holds BYTE COUNTER


	ldr	r0, =str2b			@r0 points to str2b
	bl	putstring			@prints "Add from file input.txt"

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'


	
	
	@open syscall to OPEN and READ-------------------------------------------
	
	ldr 	r0, =filename
	mov 	r1, #0 				@ flags to read
	ldr 	r2, =0666 			@ permissions
	mov 	r7, #5 				@ 5 is system call number for open
	svc 	#0				@system call
	cmp 	r0, #0
	blt 	quit				@branch to quit if no file

	@ Save the file handle in memory

	ldr 	r1, =Handle			@ load input file handle
	str 	r0, [r1]			@save the file handle
 
/************ABOUT TO READ TO BUFFER******************************/	

	
begin_read_loop:
	
	ldr 	r0, =Handle			@load input file handle
	ldr 	r0, [r0]			@dereference r0
	ldr	r1, =readBuffer			@load address of readBuffer
	mov	r2, #1				@read ONLY 1 byte
	mov 	r7, #3				@#3 is code for reading
	svc	#0				@service call

	cmp	r0, #0				@if zero bytes are read, you are at END OF FILE (EOF)
	beq	end_read_loop			@branch to end_read_loop when at the end of the file
	

	ldr 	r0, =readBuffer			@load the address of readBuffer

	bl	String_copy			@copy string, r0 now Contains pointer to new string

	mov	r4, r0				@make a copy of the new string's address in r4
	add	r8, r8, #1			@increments BYTE COUNTER

read_loop:

	ldr 	r0, =Handle			@load input file handle
	ldr 	r0, [r0]			@dereference r0
	ldr	r1, =readBuffer			@load address of readBuffer
	mov	r2, #1				@read ONLY 1 byte
	mov 	r7, #3				@#3 is code for reading
	svc	#0				@service call

	cmp	r0, #0				@if zero bytes are read, you are at END OF FILE (EOF)
	beq	end_read_loop			@branch to end_read_loop when at the end of the file
	

	ldr 	r0, =readBuffer			@load the address of readBuffer
	bl	String_copy			@copy string, r0 now Contains pointer to new string
	mov	r1, r0				@move new string into r1 (this prepares for String_concat)
	

	mov 	r0, r4				@load the new string in memory to r0 (for String_concat)
	push	{r0}				@ preserve r0 (current new string)

	bl	String_concat			@concatenates the next character to the end of the new string

	mov	r4, r0				@make a copy of the newest string's address in r4

	pop	{r0}				@ restore address of previous new string

	push	{r1-r4}				@ preserve r1-r4
	bl	free				@ delete previous new string, no longer needed
	pop	{r1-r4}				@ restore r1-r4

	mov	r0, r4				@ move newest string address back into r0

	add	r8, r8, #1			@increment BYTE COUNTER

	ldr	r1, =readBuffer			@load address of readBuffer
	ldrb	r2, [r1]			@loads the hex ASCII value into r2 for comparison

	cmp	r2, #0x0a			@compare readBuffer contents to "\n" character "0x0a"
	beq	append_read_loop		@branch to append_read_loop if you are at the end of the line

	@cmp	r2, #0x3			@compare the current CHaracter and the End of Text ascii character
	@beq	end_read_loop			@branch to end_read_loop when at the end of the file

	b	read_loop			@branch back to read_loop

	
append_read_loop:

	@ldr	r1, =strNull			@load address of null string into r1
	@mov	r0, r4				@moves string address to r0
	@bl	String_concat			@adds a null to the end of each string

	bl	appendNode			@Branch to appendNode, r4 holds new string address -> new node

	b	begin_read_loop			@after line read and new node created, startover to read nextline

	
end_read_loop:	
@------------------ exiting 2B ------------------------------------

	ldr	r0, =str2bSucc			@r0 points to str2bSucc
	bl	putstring			@prints "Input file succesfully read."
	

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'


	ldr     r0, =strMain			@loads address of strMain  "Press 1 for Main Menu: "
	bl    	putstring			@prints string

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strS1store

	bl 	ascint32			@call ascint32 external fn, store use input into strStore

	mov	r3, r0				@r3 now holds int that was entered
					
	cmp	r3, #1				@compare r3 and #1

	beq	clearToMain			@branch to print menu at beginning

@-----------------------------------------------------------------------------------


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   END 2 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   START 3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

@************************************START 3 - DELETE STRING***********************************

start3:

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strM3			@r0 points to strM3
	bl	putstring			@prints "View Strings Module" to user

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strS3			@ load into r0 the address of strS3
	bl	putstring			@ call putstring, output strS3

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strStore

	bl	ascint32			@ convert user input to an integer

	/*** first check to make sure the index number is valid ***/

	mov	r3, r0				@ copy r0 into r3

	ldr	r0, =str3Fail			@ load into r2 an error message
	ldr	r1, =intNodes			@ load into r1 the address of intNodes
	ldr	r1, [r1]			@ dereference pointer to intNodes

	/*** valid indexes range from 0 -> intNodes-1 ***/

	/*** if index is negative, output error ***/

	cmp	r3, #0				@ compare r0 to 0
	bllt	putstring			@ output error message
	blt	exiting_3			@ exit if index is negative

	/*** index is out of bounds, break ***/
	
	cmp	r3, r1				@ compare index to node count
	blge	putstring			@ output error message
	bge	exiting_3			@ exit if index is out of bounds

	mov	r0, r3				@ move original index request back to r0
	bl	deleteNode			@ delete the node if there are any


exiting_3:

@-------------exiting 3-------------------------------------------------------------------------------

	ldr     r0, =strMain			@loads address of strMain  "Press 1 for Main Menu: "
	bl    	putstring			@prints string

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strS1store

	bl 	ascint32			@call ascint32 external fn, store use input into strStore

	mov	r3, r0				@r3 now holds int that was entered
					
	cmp	r3, #1				@compare r3 and #1

	beq	clearToMain			@branch to print menu at beginning

@-----------------------------------------------------------------------------------

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   END 3 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   START 4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

start4:

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strM4			@r0 points to strM4
	bl	putstring			@prints "Edit String Module" to user

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strS4			@ load into r0 the address of strS4
	bl	putstring			@ call putstring, output szPrompt

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strStore

	bl	ascint32			@ convert user input to an integer

	/*** first check to make sure the index number is valid ***/

	mov	r3, r0				@ copy r0 into r3

	ldr	r0, =str3Fail			@ load into r2 an error message
	ldr	r1, =intNodes			@ load into r1 the address of intNodes
	ldr	r1, [r1]			@ dereference pointer to intNodes

	/*** valid indexes range from 0 -> intNodes-1 ***/

	/*** if index is negative, output error ***/

	cmp	r3, #0				@ compare r0 to 0
	bllt	putstring			@ output error message
	blt	exiting_4			@ exit if index is negative

	/*** index is out of bounds, break ***/
	
	cmp	r3, r1				@ compare index to node count
	blge	putstring			@ output error message
	bge	exiting_4			@ exit if index is out of bounds

	/*** remove the string ***/

	mov	r0, r3				@ move original index request back to r0

	bl	deleteNode			@ delete the node specified in the index

	/*** get replacement string ***/
	
	ldr	r0, =strS42			@ load into r0 the address of strS42
	bl	putstring			@ output strS42

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strStore

	ldr	r0, =strStore			@ load into r0 the address of strS42

	/*** concatenate a CRNL to the end of the new string ***/

	ldr	r1, =szCRNL			@ load into r1 the address of szCRNL
	bl	String_concat			@ concatenate the new line feed to the string

	/*** determine how to add in replacement node ***/

	ldr	r2, =intNodes			@ load into r2 the address of intNodes
	ldr	r2, [r2]			@ dereference pointer to intNodes

	cmp	r2, #0				@ compare r2 to 0
	beq	s4_replacing_tail		@ can append node as normal if we edit only node

	cmp	r3, r2				@ compare r3 (index) to r2
	beq	s4_replacing_tail		@ can append node as normal if we edit tail

	cmp	r3, #0				@ compare r3 (index) to 0
	beq	s4_replacing_head		@ must add node as new head if deleted first node

	/*** otherwise continue into adding node to neither head nor tail position ***/

@-----------------------------------------------------------------------------------

	/*** replacing a node that is neither the head nor tail ***/


/* ------------------------------------------------------------------------------------- */

	mov	r8, #1			@ move a 1 into r8

	ldr	r4, =listHead		@ load into r4 the address of listHead
	ldr	r4, [r4]		@ dereference pointer to listHead

	ldr	r5, =listCurrent	@ load into r5 the address of listCurrent

	str	r4, [r5]		@ point listCurrent to listHead's node

/* ------------------------------------------------------------------------------------- */

s4_search_loop:

	/*** check if we are at node before desired node ***/

	cmp	r3, r8			@ compare r3 to our counter
	beq	s4_end_search_loop	@ break loop if we reach desired index

	add	r8, r8, #1		@ r8 = r8 + 1

	/*** load in the next node ***/

	ldr	r4, =listCurrent	@ load into r4 the address of listCurrent
	ldr	r4, [r4]		@ dereference pointer to listCurrent
	ldr	r4, [r4]		@ dereference pointer to listCurrent's node

	ldr	r5, =listCurrent	@ load into r5 the address of listCurrent

	str	r4, [r5]		@ store next ptr's target into listCurrent

	b	s4_search_loop		@ loop again

	/*** replacing a node that is the tail OR that is the only node in list ***/

s4_end_search_loop:

	mov	r8, r0			@ copy new string address into r8

	/*** add to our total heap memory counter ***/

	ldr	r7, =intBytes		@ load into r8 the address of intBytes
	ldr	r6, [r7]		@ dereference pointer to intBytes and store in r6

	bl	String_length		@ get length of the string we just created in heap memory
	
	add	r6, r6, r0		@ r8 = r8 + r0
	add	r6, r6, #8		@ r8 = r8 + 8

	str	r6, [r7]		@ store r6 into address pointed to by r8

	/*** create the node ***/

	mov	r0, #8			@ copy an int 8 into r0
	
	push	{r1-r4}			@ push r1, r2, r3 to stack for safe keeping
	bl	malloc			@ dynamically allocate 8 bytes of memory
	pop	{r1-r4}			@ pop r1-r3 off stack

	/*** load in address of listCurrent->next ***/

	ldr	r7, =listCurrent	@ load into r7 the address of listCurrent
	ldr	r7, [r7]		@ dereference pointer to listCurrent
	ldr	r7, [r7]		@ dereference pointer to listCurrent->next

	str	r7, [r0]		@ store listCurrent->next into new node's next ptr

	ldr	r2, =listCurrent	@ load into r3 the address of listCurrent

	ldr	r2, [r2]		@ dereference pointer to current node
	str	r0, [r2]		@ listCurrent->next set to replacement node
	
	ldr	r2, =listCurrent	@ store into r2 the address of listCurrent
	str	r0, [r2]		@ store base address of this new node into listCurrent

	/*** move new string address into our current node's string ptr ***/

	ldr	r2, =listCurrent	@ load into r2 the address of listCurrent
	ldr	r2, [r2]		@ dereference pointer to r2

	add	r2, r2, #4		@ r2 = r2 + 4
	str	r8, [r2]		@ store new string's address into current node str ptr

	b	exiting_4_prep		@ branch over other node creations

s4_replacing_tail:

	bl	appendNode		@ append a node as usual if we're editing tail

	b	exiting_4		@ branch over other node creations

	/*** replacing a node that is the head ***/

s4_replacing_head:

	mov	r4, r0			@ copy new string address into r4

	/*** add to our total heap memory counter ***/

	ldr	r8, =intBytes		@ load into r8 the address of intBytes
	ldr	r6, [r8]		@ dereference pointer to intBytes and store in r6

	bl	String_length		@ get length of the string we just created in heap memory
	
	add	r6, r6, r0		@ r8 = r8 + r0
	add	r6, r6, #8		@ r8 = r8 + 8

	str	r6, [r8]		@ store r6 into address pointed to by r8

	/*** create the node ***/

	mov	r0, #8			@ copy an int 8 into r0
	
	push	{r1-r4}			@ push r1, r2, r3 to stack for safe keeping
	bl	malloc			@ dynamically allocate 8 bytes of memory
	pop	{r1-r4}			@ pop r1-r3 off stack

	ldr	r2, =listHead		@ load into r2 the address of listHead
	ldr	r3, =listHead		@ load into r3 the address of listHead

	ldr	r3, [r3]		@ dereference pointer to head node
	str	r3, [r0]		@ new node's next ptr is set to previous head node address

	str	r0, [r2]		@ store base address of this first node into listHead
	
	ldr	r2, =listCurrent	@ store into r2 the address of listCurrent
	str	r0, [r2]		@ store base address of this new node into listCurrent

	/*** move new string address into our current node's string ptr ***/

	ldr	r2, =listCurrent	@ load into r2 the address of listCurrent
	ldr	r2, [r2]		@ dereference pointer to r2

	add	r2, r2, #4		@ r2 = r2 + 4
	str	r4, [r2]		@ store new string's address into current node str ptr

	/*** adding to node counter when not replacing tail ***/

exiting_4_prep:

	/*** add to our total node counter ***/

	ldr	r8, =intNodes		@ load into r8 the address of intNodes
	ldr	r6, [r8]		@ dereference pointer to intNodes and store in r6
	
	add	r6, r6, #1		@ r8++

	str	r6, [r8]		@ store r6 into address pointed to by r8

	/*** exiting ***/

exiting_4:

@-------------exiting 4-------------------------------------------------------------------------------

	ldr     r0, =strMain			@loads address of strMain  "Press 1 for Main Menu: "
	bl    	putstring			@prints string

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strS1store

	bl 	ascint32			@call ascint32 external fn, store use input into strStore

	mov	r3, r0				@r3 now holds int that was entered
					
	cmp	r3, #1				@compare r3 and #1

	beq	clearToMain			@branch to print menu at beginning

@-----------------------------------------------------------------------------------


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   END 4 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   START 5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



@************************************START 5 - STRING SEARCH***********************************

start_5:

	/*** get user input ***/

	ldr	r0, =str5			@r0 points to str5
	bl	putstring			@prints "Enter substring to search for: "
	
	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strStore

	/*** ensure there are nodes in the list to search for ***/

	mov	r8, #0				@ counts how many strings were found

	ldr	r2, =intNodes			@ load into r2 the address of intNodes
	ldr	r2, [r2]			@ dereference pointer to intNodes
	cmp	r2, #0				@ compare r2 to 0
	beq	end_string_search		@ leave function if list is empty

	/*** convert to lowercase ***/

	ldr	r0, =strStore			@this holds substring to search for
	bl	convert_to_lowercase		@ convert input string to lowercase equivalent
	ldr	r1, =strStore			@ keep input string pointer in r1

	/*** begin from head of list ***/

	ldr	r2, =listHead			@r2 holds address of listHead
	ldr	r3, [r2]			@r3 holds contents of listHead

	ldr	r2, =listCurrent		@r2 holds address of listCurrent
	str	r3, [r2]			@listCurrent now has listHead contents

	mov	r7, #0				@ counts the line numbers

	/*** loop through each line in the list ***/

string_search_loop:

	/*** get to listCurrnet->string ***/

	ldr	r2, =listCurrent		@r0 holds pointer to list current
	ldr	r2, [r2]			@dereference pointer to listCurrent

	add	r2, r2, #4			@r2 points to second 4 bytes of node

	ldr	r0, [r2]			@this holds the string pointer in r0, now we can call String_lastIndexOf_3 

	/*** copy current node string into a buffer ***/

	push	{r1}				@ preserve r1

	ldr	r1, =strTemp			@ load in temp buffer to store lowercase copy
	bl	copy_to_buffer			@ copy node string into buffer

	pop	{r1}				@ restore r1

	ldr	r0, =strTemp			@ load strTemp into r0
	bl	convert_to_lowercase		@ convert node string copy to lowercase
	ldr	r0, =strTemp			@ load into r0 the address of strTemp

	/*** find if the substring is present anywhere in this line ***/

	bl	String_lastIndexOf_3 		@branch to external Fn, r1 points to substring, r0 holds pointer to string in current node

	cmp	r0, #-1				@compare r0 to -1

	blne	print_string_search		@ print the current string if it's found somewhere

	ldr 	r5, =listCurrent		@load into r5 the address of listCurrent
	ldr	r5, [r5]			@dereference r5

	ldr	r6, =listTail			@load into r6 the address of listTail
	ldr	r6, [r6]			@derefernce r6

	cmp	r5, r6				@compare listcurrent and listTail
	beq	end_string_search		@branch to end string search if equal
	
	/*** load in the next node for searching ***/

	ldr	r4, =listCurrent		@ load into r4 the address of listCurrent
	ldr	r4, [r4]			@ dereference pointer to listCurrent
	ldr	r4, [r4]			@ dereference pointer to listCurrent's node

	ldr	r5, =listCurrent		@ load into r5 the address of listCurrent

	str	r4, [r5]			@ store next ptr's target into listCurrent

	add	r7, r7, #1			@ increment r7

	b	string_search_loop		@ loop again

	/*** if substring is present in a line, print that line ***/

print_string_search:

	push	{lr}				@ preserve link register

	add	r8, r8, #1			@ increment string counter

	/*** output line number ***/

	push	{r0, r1}			@ preserve r0 and r1

	ldr	r0, =crBracketL			@ load into r0 the address of crBracketL
	bl	putch				@ output [

	mov	r0, r7				@ move line number into r0
	ldr	r1, =kbBuf			@ load into r1 the address of kbBuf

	bl	intasc32			@ convert line number to ascii

	ldr	r0, =kbBuf			@ load into r0 the address of strStore

	bl	putstring			@ output line number
	
	ldr	r0, =crBracketR			@ load into r0 the address of crBracketR
	bl	putch				@ output ]

	ldr	r0, =crSpace			@ load into r0 the address of crSpace
	bl	putch				@ output a space

	pop	{r0, r1}			@ restore r0 and r1

	/*** output string ***/

	ldr	r0, [r2]			@ load in node string ptr

	bl	putstring			@prints the string that holds that substring	

	pop	{lr}				@ restore link register

	bx	lr				@ return to caller

end_string_search:

	@-------------exiting 5-------------------------------------------------------------------------------

	cmp	r8, #0				@ compare r8 to 0
	bleq	fail_string_search		@ output a message saying no strings are found

	ldr     r0, =strMain			@loads address of strMain  "Press 1 for Main Menu: "
	bl    	putstring			@prints string

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strS1store

	bl 	ascint32			@call ascint32 external fn, store use input into strStore

	mov	r3, r0				@r3 now holds int that was entered
					
	cmp	r3, #1				@compare r3 and #1

	beq	clearToMain			@branch to print menu at beginning

	/*** if the specified substring is not found, output a message ***/

fail_string_search:

	push	{lr}				@ preserve lr

	ldr	r0, =str5Fail			@ load in str5Fail to r0
	bl	putstring			@ output str5Fail
	pop	{lr}				@ restore lr

	bx	lr				@ return to caller

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   END 5 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


@---------------------------------------------------------------------------------------------------------------------------


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@   START 6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


start_save:


@open syscall  
	ldr 	r0, =outfilename	@points to "output.txt"
	mov 	r1, #1101 		@ O_WRONLY | O_CREAT
	ldr 	r2, =0666 		@ permissions
	mov 	r7, #5 			@ 5 is system call number for open
	svc 	# 0
	cmp 	r0, #0
	blt 	exit


	@ Save the file handle in memory

	ldr 	r1, =outHandle			@ load input file outhandle
	str 	r0, [r1]			@save the file handle for output.txt


	ldr	r6, =listTail			@load into r6 the address of listTail
	ldr	r6, [r6]			@dereference pointer to listTail

	ldr	r7, =listHead			@r7 holds address of listHead
	ldr	r7, [r7]			@r7 now has listHead contents

write_out_loop:

	mov	r0, r7				@load into r1 the next node
	mov	r8, r0				@make copy of r0 in r8

	add 	r0, r0, #4			@r0 = r0 + 4
	ldr	r0, [r0]			@r0 holds pointer to string
	mov	r5, r0				@r5 holds value 

	bl	String_length			@puts length into r0
	

	mov	r2, r0				@moves # of bytes into r2
	ldr	r4, =outHandle			@load handle
	ldr	r0, [r4]			@load int for file handle in r0
	
	mov 	r1, r5				@we will write from r1 which is the pointer to the string

	mov 	r7, #4 				@ 4 is write
	svc 	#0				@service call


	cmp	r6, r8				@compare r6 and r8
	beq	end_write_out_loop		@break loop

	
	ldr 	r7, [r8]			@load into r7 the address pointed to by current node

	b	write_out_loop			@branch to the out_loop 



end_write_out_loop:

		@-------------exiting 6-------------------------------------------------------------------------------


	ldr     r0, =strSave			@loads address of strMain  "Output File Successfully Created: output.txt"
	bl    	putstring			@prints string

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr 	r0,=crCr			@load into r0 address of crCr	
	bl	putch				@call putch (external fn) to print the character 'carriage return'

	ldr     r0, =strMain			@loads address of strMain  "Press 1 for Main Menu: "
	bl    	putstring			@prints string

	ldr	r0, =strStore			@r0 points to kbBuf
	mov 	r1, #KBSIZE			@store KBSIZE
	bl 	getstring			@call getstring, store use input into strS1store

	bl 	ascint32			@call ascint32 external fn, store use input into strStore

	mov	r3, r0				@r3 now holds int that was entered
					
	cmp	r3, #1				@compare r3 and #1

	beq	clearToMain			@branch to print menu at beginning


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@   END 6 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


	/********************************/
	/*** clearToStart subroutines ***/
	/********************************/


clearToStart1:

	bl	clearScreen			@ clear the screen

	b	start1				@branch to start1


clearToStart2:

	bl	clearScreen			@ clear the screen

	b	start2				@branch to start2

clearToStart3:

	bl	clearScreen			@ clear the screen

	b	start3				@ branch to start3

clearToStart4:

	bl	clearScreen			@ clear the screen

	b	start4				@ branch to start4

clearToStart5:

	bl	clearScreen			@ clear the screen

	b	start_5				@ branch to start5

clearToStart6:

	bl	clearScreen			@clear the screen
	b	start_save			@ branch to start6

clearToMain:

	bl	clearScreen			@ clear the screen

	b	print_menu			@branch to print_menu

/*****************************************************************************************/

	/*******************/
	/*** SUBROUTINES ***/
	/*******************/

/*****************************************************************************************/



/*****************************************************************************************/

	/*********************************************/
	/*** output all strings in the linked list ***/
	/*********************************************/

@ R0 is not preserved.
@ R1 is not preserved.

outputList:

	push	{r4-r8, r10, r11}
	push	{sp}

	push	{lr}			@ preserve link register


/* ------------------------------------------------------------------------------------- */

	ldr	r6, =listTail		@ load into r6 the address of listTail
	ldr	r6, [r6]		@ dereference pointer to listTail
	ldr	r7, =listHead		@ load into r7 the address of the first node
	ldr	r7, [r7]		@ dereference pointer to listHead
	mov	r5, #0			@ used to output line numbers

/* ------------------------------------------------------------------------------------- */

out_loop:

	/*** output the string held in the current node ***/

	push	{r0, r1}		@ preserve r0 and r1

	ldr	r0, =crBracketL		@ load into r0 the address of crBracketL
	bl	putch			@ output [

	mov	r0, r5			@ move line number into r0
	ldr	r1, =strStore		@ load into r1 the address of kbBuf

	bl	intasc32		@ convert line number to ascii

	ldr	r0, =strStore		@ load into r0 the address of strStore

	bl	putstring		@ output line number
	
	ldr	r0, =crBracketR		@ load into r0 the address of crBracketR
	bl	putch			@ output ]

	ldr	r0, =crSpace		@ load into r0 the address of crSpace
	bl	putch			@ output a space

	pop	{r0, r1}		@ restore r0 and r1

	add	r5, r5, #1		@ increment line number

	mov	r0, r7			@ load into r0 the next node

	add	r0, r0, #4		@ r0 = r0 + 4
	ldr	r0, [r0]		@ dereference pointer to (r0 + 4)

	bl	putstring		@ call putstring, output node's string

	/*** check if we are at end of linked list ***/

	cmp	r7, r6			@ if this current node is the listTail, break
	beq	end_out_loop		@ break loop

	/*** load in next node, pointed to by the current node's next ptr ***/

	ldr	r7, [r7]		@ load into r7 address pointed to by current node ptr

	/*** loop ***/

	b	out_loop		@ branch back to loop start

/* ------------------------------------------------------------------------------------- */

end_out_loop:

/* ------------------------------------------------------------------------------------- */

	pop	{lr}			@ pop link register off stack

	pop	{sp}
	pop	{r4-r8, r10, r11}

	bx	lr			@ return to caller

/*****************************************************************************************/



/*****************************************************************************************/

	/******************/
	/*** appendNode ***/
	/******************/

	@ create a new node and return its base address in r0

appendNode:

	push	{r4-r8, r10, r11}
	push	{sp}

	push	{lr}			@ preserve link register


/* ------------------------------------------------------------------------------------- */

	mov	r4, r0			@ copy new string address into r4
	mov	r7, #0			@ 0 in r7 to initialize next pointers to 0 with malloc

	ldr	r8, =intBytes		@ load into r8 the address of intBytes
	ldr	r6, [r8]		@ dereference pointer to intBytes and store in r6

	/*** add to our total heap memory counter ***/

	bl	String_length		@ get length of the string we just created in heap memory
	
	add	r6, r6, r0		@ r8 = r8 + r0
	add	r6, r6, #8		@ r8 = r8 + 8

	str	r6, [r8]		@ store r6 into address pointed to by r8

/* ------------------------------------------------------------------------------------- */

	@ check to see if the linked list is currently empty

	ldr	r8, =intNodes		@ load into r8 the address of intNodes
	ldr	r8, [r8]		@ dereference pointer to intNodes

	cmp	r8, #0			@ compare r8 to 0
	beq	createAsHead		@ create the new node as the head

/* ------------------------------------------------------------------------------------- */

	/*** create the node ***/

	mov	r0, #8			@ move an 8 into r0

	push	{r1-r4}			@ push r1, r2, r3 to stack for safe keeping
	bl	malloc			@ dynamically allocate 8 bytes of memory
	pop	{r1-r4}			@ pop r1-r3 off stack

	/*** assign new node's address to listCurrent and point listTail to listCurrent ***/

	ldr	r6, =listTail		@ load into r3 the address of listTail

	ldr	r8, =listCurrent	@ load into r2 the address of listCurrent
	ldr	r8, [r8]		@ dereference pointer to r2
	str	r0, [r8]		@ store base address of this new node into listCurrent

	ldr	r8, =listCurrent	@ load into r2 the address of listCurrent
	str	r0, [r8]		@ store new node address into listCurrent
	str	r0, [r6]		@ store listCurrent's node address into listTail

	ldr	r8, =listCurrent	@ load into r2 the address of listCurrent
	ldr	r8, [r8]		@ dereference pointer to listCurrent
	str	r7, [r8]		@ initialize next ptr to null (0)
	add	r8, r8, #4		@ r2 = r2 + 4
	str	r4, [r8]		@ store new string address into new node's str ptr

	b	endCreation		@ finish node creation, skip over createHead

/* ------------------------------------------------------------------------------------- */

createAsHead:

/* ------------------------------------------------------------------------------------- */

	/*** alternative node creation if the linked list is empty ***/
	
	/*** create our first node ***/

	mov	r0, #8			@ copy an int 8 into r0
	
	push	{r1-r4}			@ push r1, r2, r3 to stack for safe keeping
	bl	malloc			@ dynamically allocate 8 bytes of memory
	pop	{r1-r4}			@ pop r1-r3 off stack

	ldr	r8, =listHead		@ load into r2 the address of listHead
	str	r0, [r8]		@ store base address of this first node into listHead
	
	ldr	r8, =listCurrent	@ store into r2 the address of listCurrent
	str	r0, [r8]		@ store base address of this new node into listCurrent

	ldr	r8, =listTail		@ load into r2 the address of listTail
	str	r0, [r8]		@ store base address of this new node into listTail

	/*** move new string address into our current node's string ptr ***/

	ldr	r8, =listCurrent	@ load into r2 the address of listCurrent
	ldr	r8, [r8]		@ dereference pointer to r2
	str	r7, [r8]		@ initialize next ptr to null (0)
	add	r8, r8, #4		@ r2 = r2 + 4

	str	r4, [r8]		@ store new string's address into current node str ptr

/* ------------------------------------------------------------------------------------- */

endCreation:

	/*** add to our total node counter ***/

	ldr	r8, =intNodes		@ load into r8 the address of intNodes
	ldr	r6, [r8]		@ dereference pointer to intNodes and store in r6
	
	add	r6, r6, #1		@ r8++

	str	r6, [r8]		@ store r6 into address pointed to by r8

/* ------------------------------------------------------------------------------------- */

	pop	{lr}			@ pop link register off stack

	pop	{sp}			@ pop stack pointer off stack
	pop	{r4-r8, r10, r11}	@ pop AAPCS mandated registers off stack

	bx	lr			@ return to caller

/*****************************************************************************************/



/*****************************************************************************************/

	/******************/
	/*** deleteNode ***/
	/******************/

	@ r0 gets passed with the index # to be deleted
	@ total bytes freed subtracted from total allocated bytes and total 
	@ (8 bytes for node + number of bytes held by the string)

deleteNode:

	push	{r4-r8, r10, r11}	@ preserve AAPCS mandated registers
	push	{sp}			@ push the stack pointer onto the stack

	push	{lr}			@ preserve link register


/* ------------------------------------------------------------------------------------- */

	/*** special case if the head is the node being deleted ***/

	cmp	r0, #0			@ compare index to 0
	beq	deleting_head		@ step through linked list if we are not deleting head

/* ------------------------------------------------------------------------------------- */

	ldr	r4, =intNodes		@ load into r4 the address of intNodes
	ldr	r4, [r4]		@ dereference pointer to intNodes

	mov	r8, #1			@ r8 is our counter

	mov	r7, r4			@ copy intNodes into r7

	sub	r7, r7, #1		@ r7 = r7 - 1

/* ------------------------------------------------------------------------------------- */

	ldr	r4, =listHead		@ load into r4 the address of listHead
	ldr	r4, [r4]		@ dereference pointer to listHead

	ldr	r5, =listCurrent	@ load into r5 the address of listCurrent

	str	r4, [r5]		@ point listCurrent to listHead's node

/* ------------------------------------------------------------------------------------- */

search_loop:

	/*** special case if the tail is the node being deleted ***/
	
	cmp	r8, r7			@ compare r0 to r7
	beq	deleting_tail		@ must be deleting tail, so perform special case
	
	/*** check if we are at node before desired node ***/

	cmp	r0, r8			@ compare r0 to our counter
	beq	end_search_loop		@ break loop if we reach desired index

	add	r8, r8, #1		@ r8 = r8 + 1

	/*** load in the next node ***/

	ldr	r4, =listCurrent	@ load into r4 the address of listCurrent
	ldr	r4, [r4]		@ dereference pointer to listCurrent
	ldr	r4, [r4]		@ dereference pointer to listCurrent's node

	ldr	r5, =listCurrent	@ load into r5 the address of listCurrent

	str	r4, [r5]		@ store next ptr's target into listCurrent

	b	search_loop		@ loop again

/* ------------------------------------------------------------------------------------- */
end_search_loop:

	/*** load into r0 the address of the current node's string ***/

	ldr	r8, =listCurrent	@ load into r2 the address of listCurrent
	ldr	r8, [r8]		@ dereference pointer to listCurrent
	ldr	r8, [r8]		@ get node's next ptr into r0

	/*** r8 now holds base address of listCurrent->next ***/

	mov	r0, r8			@ copy listCurrent->next into r0

	add	r0, r0, #4		@ r2 = r2 + 4
	ldr	r0, [r0]		@ dereference pointer to listCurrent->next's str ptr	


	/*** subtract the bytes of the string from our byte counter ***/

	push	{r0}			@ preserve r0 temporarily

	bl	String_length		@ get length of string we are deleting

	ldr	r4, =intBytes		@ load into r4 the address of intBytes
	ldr	r5, =intBytes		@ load into r5 the address of intBytes
	ldr	r4, [r4]		@ dereference pointer to r4

	sub	r4, r4, r0		@ r4 = r4 - r0

	str	r4, [r5]		@ store number of bytes back into intBytes

	pop	{r0}			@ restore r0

	/*** delete the string ***/	

	push	{r1-r4}			@ push r1, r2, r3 to stack for safe keeping
	bl	free			@ delete the dynamically allocated memory held in r0
	pop	{r1-r4}			@ pop r1-r3 off stack

	mov	r4, r8			@ load into r4 the address of listCurrent->next
	ldr	r5, =listCurrent	@ load into r5 the address of listCurrent
	mov	r0, r8			@ load into r0 the address of listCurrent->next

	/*** point listCurrent to the node after it ***/

	ldr	r4, [r4]		@ load in listCurrent->next->next
	ldr	r5, [r5]		@ dereference pointer to listCurrent
	str	r4, [r5]		@ store listCurrent->next->next into listCurrent->next

	/*** r0 points to current node base address, free the node ***/

	push	{r1-r4}			@ push r1-r4 for safe keeping
	bl	free			@ delete the node at this specified index
	pop	{r1-r4}			@ pop r1-r4 original values back off stack

	b	end_deleteNode		@ return from this function

/* ------------------------------------------------------------------------------------- */

deleting_head:

	/*** load into r0 the address of the head string ***/

	ldr	r0, =listHead		@ load into r2 the address of listHead
	ldr	r0, [r0]		@ dereference pointer to listHead
	add	r0, r0, #4		@ r2 = r2 + 4
	ldr	r0, [r0]		@ dereference pointer to listHead's str ptr	

	/*** subtract the bytes of the string from our byte counter ***/

	push	{r0}			@ preserve r0 temporarily

	bl	String_length		@ get length of string we are deleting

	ldr	r4, =intBytes		@ load into r4 the address of intBytes
	ldr	r5, =intBytes		@ load into r5 the address of intBytes
	ldr	r4, [r4]		@ dereference pointer to r4

	sub	r4, r4, r0		@ r4 = r4 - r0

	str	r4, [r5]		@ store number of bytes back into intBytes

	pop	{r0}			@ restore r0

	/*** delete the string ***/	

	push	{r1-r4}			@ push r1, r2, r3 to stack for safe keeping
	bl	free			@ delete the dynamically allocated memory held in r0
	pop	{r1-r4}			@ pop r1-r3 off stack

	ldr	r4, =listHead		@ load into r4 the address of listHead
	ldr	r5, =listHead		@ load into r5 the address of listHead
	ldr	r6, =listCurrent	@ load into r6 the address of listCurrent
	ldr	r0, =listHead		@ load into r0 the address of listHead

	ldr	r0, [r0]		@ r0 now points to current node base address

	/*** point listHead to the node after it ***/

	ldr	r4, [r4]		@ dereference pointer to listHead
	ldr	r4, [r4]		@ dereference pointer to listHead's node
	str	r4, [r5]		@ store next ptr's target into listHead
	str	r4, [r6]		@ store next ptr's target into listCurrent

	/*** r0 points to current node base address, free the node ***/

	push	{r1-r4}			@ push r1-r4 for safe keeping
	bl	free			@ delete the node at this specified index
	pop	{r1-r4}			@ pop r1-r4 original values back off stack

	b	end_deleteNode		@ return from this function

/* ------------------------------------------------------------------------------------- */

deleting_tail:


	/*** load into r0 the address of the tail string ***/

	ldr	r0, =listTail		@ load into r2 the address of listTail
	ldr	r0, [r0]		@ dereference pointer to listTail
	add	r0, r0, #4		@ r2 = r2 + 4
	ldr	r0, [r0]		@ dereference pointer to listTail's str ptr	

	/*** subtract the bytes of the string from our byte counter ***/

	push	{r0}			@ preserve r0 temporarily

	bl	String_length		@ get length of string we are going to delete

	ldr	r4, =intBytes		@ load into r4 the address of intBytes
	ldr	r5, =intBytes		@ load into r5 the address of intBytes
	ldr	r4, [r4]		@ dereference pointer to r4

	sub	r4, r4, r0		@ r4 = r4 - r0

	str	r4, [r5]		@ store number of bytes back into intBytes

	pop	{r0}			@ restore r0

	/*** delete the string ***/	

	push	{r1-r4}			@ push r1, r2, r3 to stack for safe keeping
	bl	free			@ delete the dynamically allocated memory held in r0
	pop	{r1-r4}			@ pop r1-r3 off stack

	ldr	r4, =listTail		@ load into r4 the address of listTail
	ldr	r5, =listCurrent	@ load into r5 the address of listCurrent
	ldr	r0, =listTail		@ load into r0 the address of listTail
	ldr	r0, [r0]		@ r0 now points to current node base address

	/*** point listTail to the node before it ***/

	ldr	r5, [r5]		@ dereference pointer to listCurrent
	str	r5, [r4]		@ point listTail to listCurrent's node

	mov	r6, #0			@ move a 0 into r5
	str	r6, [r5]		@ set listCurrent->next to null

	/*** r0 points to current node base address, free the node ***/

	push	{r1-r4}			@ push r1-r4 for safe keeping
	bl	free			@ delete the node at this specified index
	pop	{r1-r4}			@ pop r1-r4 original values back off stack

	b	end_deleteNode		@ return from this function

/* ------------------------------------------------------------------------------------- */

end_deleteNode:

	/*** update our byte and node counters ***/

	ldr	r4, =intBytes		@ load into r4 the address of intBytes
	ldr	r5, =intBytes		@ load into r5 the address of intBytes
	ldr	r4, [r4]		@ dereference pointer to intBytes

	sub	r4, r4, #8		@ r4 = r4 - 8

	str	r4, [r5]		@ store new intBytes back

	ldr	r4, =intNodes		@ load into r4 the address of intNodes
	ldr	r5, =intNodes		@ load into r5 the address of intNodes
	ldr	r4, [r4]		@ dereference pointer to intNodes

	sub	r4, r4, #1		@ r4 = r4 - 1

	str	r4, [r5]		@ store new intNodes back

/* ------------------------------------------------------------------------------------- */

	pop	{lr}			@ pop link register off stack

	pop	{sp}			@ restore stack pointer
	pop	{r4-r8, r10, r11}	@ restore AAPCS mandated

	bx	lr			@ return to caller

/*****************************************************************************************/



/*********************************************************************************************/
	
	/****************************/
	/*** convert to lowercase ***/
	/****************************/
 
/* ----------------------------------------------------------------------------------------- */

convert_to_lowercase:

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

	mov	r4, #0			@ count/index for our new string

/* ----------------------------------------------------------------------------------------- */

	mov	r4, #0			@ set r4 = 0 and use as index counter for iterating

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

	/*** loop through new string and replace all occurrences of uppercase characters  ***/
	/*** with their lowercase equivalent 						  ***/

convert_to_lowercase_l:

	ldrb	r5, [r0, r4]		@ step through new string by one character

	/*** if (new string[r4] == 0) then break from loop ***/

	cmp	r5, #0			@ check if char is a null character
	beq	convert_to_lowercase_b	@ break from loop if null is encountered

	/*** if (new string[r4] < 65) then loop and load next char ***/

	cmp	r5, #65			@ check if char is an uppercase letter; A = 65
	blt	convert_to_lowercase_i	@ loop again if char is a special char

	/*** if (new string[r4] > 90) then loop and load next char ***/

	cmp	r5, #90			@ check if char is outside uppercase range; Z = 90
	bgt	convert_to_lowercase_i	@ loop again if char is not an uppercase char

	/*** if new string[r4] is an uppercase char, replace with lowercase equivalent ***/

	add	r5, #32			@ r5 = r5 + 32; convers an uppercase char to lowercase
	strb	r5, [r0, r4]		@ store lowercase char into new string[r4]

	/*** if character is not  convertable to lowercase load next char & loop ***/

convert_to_lowercase_i:

	/*** increment index and loop ***/

	add	r4, #1			@ increment index counter for new string
	b	convert_to_lowercase_l	@ loop again

convert_to_lowercase_b:

	pop	{lr}			@ pop link register off stack

	pop	{sp}			@ restore stack pointer
	pop	{r4-r8, r10, r11}	@ restore AAPCS mandated

	bx	lr			@ return to caller

/*********************************************************************************************/	



/*********************************************************************************************/	

	/**********************/
	/*** copy_to_buffer ***/
	/**********************/

	@ subroutine copies a passed string into a buffer
	@ R0: points to address of string to copy
	@ R1: points to address of buffer to copy to

copy_to_buffer:

/* ----------------------------------------------------------------------------------------- */

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	
	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack
	
/* ----------------------------------------------------------------------------------------- */

	mov	r4, #0			@ offset counter

copy_to_buffer_l:

	ldrb	r5, [r0, r4]		@ step through string by one character

	/*** copy single char at index [r4] from string1 into new string  ***/

	strb	r5, [r1, r4]		@ store string1[r4] into new string[r4]

	/*** if (string1[r4] == 0) then break  ***/

	cmp	r5, #0			@ check for null character
	beq	copy_to_buffer_b	@ break from this loop if null is encountered

	/*** increment index and loop ***/

	add	r4, r4, #1		@ increment index counter
	b	copy_to_buffer_l	@ loop again

copy_to_buffer_b:

	pop	{lr}			@ pop link register off stack

	pop	{sp}			@ restore stack pointer
	pop	{r4-r8, r10, r11}	@ restore AAPCS mandated

	bx	lr			@ return to caller

/*********************************************************************************************/	



/*****************************************************************************************/

	/********************/
	/*** clear screen ***/
	/********************/

clearScreen:

/* ------------------------------------------------------------------------------------- */

	push	{r4-r8, r10, r11}	@ preserve AAPCS required registers
	push	{sp}			@ preserve stack pointer

	push	{lr}			@ preserve link register

/* ------------------------------------------------------------------------------------- */

	mov	r1, #0				@ loop counter
	ldr 	r0, =crCr			@load into r0 address of crCr	

/* ------------------------------------------------------------------------------------- */

clear_loop:

	cmp	r1, #55				@ compare loop counter to 55
	bge	end_clear_loop			@ only output 100 carriage returns

	bl	putch				@call putch (external fn) to print the character 'carriage return'

	add	r1, r1, #1			@ r1 = r1 + 1

	b	clear_loop			@ loop again

/* ------------------------------------------------------------------------------------- */

end_clear_loop:

/* ------------------------------------------------------------------------------------- */

	pop	{lr}				@ pop link register off stack

	pop	{sp}				@ pop stack pointer off stack
	pop	{r4-r8, r10, r11}		@ pop AAPCS mandated registers off stack

	bx	lr				@ return to caller

/*****************************************************************************************/

quit:

@------------------terminating program--------------------------------------------------------------------
	
	mov 	r0, #0			@set program Exit status code to 0
	mov	r7, #1			@service command code of 1 to terminate program
	
	svc 0				@Perform service call to linux
	.end

