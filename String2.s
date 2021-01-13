@*****************************************************************************
@Name:      Nicholas Lozano
@Program:   String2.s
@Class:     CS 3B
@Date:      October 28, 2020 
@Purpose: Contains multiple string methods listed below.

@ File contains function definitions for the following:
@ 	String_indexOf_1 (string1:String, ch:char):int
@ 	String_indexOf_2 (string1:String, ch:char, fromIndex:int):int
@ 	String_indexOf_3 (string1:String, str:String):int
@ 	String_lastIndexOf_1(string:String, ch:char):int
@ 	String_lastIndexOf_2(string1:String, ch:char, fromIndex:int):int
@ 	String_lastIndexOf_3(string1:String, str:String):int
@ 	String_concat(string1:String, str:String):String
@ 	String_replace(string1:String, oldChar:char, newChar:char):String
@ 	String_toLowerCase(string1:String):String
@ 	String_toUpperCase(string1:String):String

@ AACPS v2020Q2 Required registers are preserved throughout all function calls.

@*****************************************************************************
	.text

	.global String_indexOf_1	@ provide function linking address
	.global String_indexOf_2	@ provide function linking address
	.global String_indexOf_3	@ provide function linking address
	.global String_lastIndexOf_1	@ provide function linking address
	.global String_lastIndexOf_2	@ provide function linking address
	.global String_lastIndexOf_3	@ provide function linking address
	.global String_concat		@ provide function linking address
	.global String_replace		@ provide function linking address
	.global String_toLowerCase	@ provide function linking address
	.global String_toUpperCase	@ provide function linking address
	
	.extern	mallloc			@ allows for dynamic memory allocation
	.extern	free			@ allows for dynamic memory freeing

/*********************************************************************************************/	

/*********************************************************************************************/	

	/************************/
	/*** String_indexOf_1 ***/
	/************************/
 
@ String_indexOf_1 (string1:String, ch:char):int

/* ----------------------------------------------------------------------------------------- */

@ Returns the index of the first occurrence of the specified character ch in the string.

@ R0: Points to the address of a string to search
@ R1: Holds a byte representing a character to be searched for

@ Returned register contents:
	@ R0: Index of the first of occurrence of ch if it is found. Otherwise, -1.
@ All registers EXCEPT R0 are preserved.

/* ----------------------------------------------------------------------------------------- */

String_indexOf_1:

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

	mov	r4, #0			@ count/index

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

String_indexOf_1_loop:

	ldrb	r5, [r0, r4]		@ step through string by one character

	/*** if (string1[r4] == 0) then break  ***/

	cmp	r5, #0			@ check for null character
	moveq	r4, #-1			@ if ch is not found, return a -1
	beq	String_indexOf_1_break	@ break from function if null is encountered

	/*** if (string1[r4] == ch) then break  ***/
	
	cmp	r5, r1			@ compare string[r4] to our desired char
	beq	String_indexOf_1_break	@ break from function if we find the desired char

	/*** if ch is not found and string continues, increment index ***/

	add	r4, #1			@ increment index counter
	b	String_indexOf_1_loop	@ loop again

/* ----------------------------------------------------------------------------------------- */

String_indexOf_1_break:

	mov	r0, r4			@ copy index counter into r0 to be returned
	b	returning		@ exit from function and return to caller

/*********************************************************************************************/	



/*********************************************************************************************/	

	/************************/
	/*** String_indexOf_2 ***/
	/************************/
 
@ String_indexOf_2 (string1:String, ch:char, fromIndex:int):int

/* ----------------------------------------------------------------------------------------- */

@ Returns the index of the first occurrence of the specified character ch in the string,
@	with the search starting after the specified index

@ R0: Points to the address of a string to search
@ R1: Holds a byte representing a character to be searched for
@ R2: Holds an int representing the desired index to start the search from

@ Returned register contents:
	@ R0: Index of the first occurrence of ch if it is found after fromIndex. Otherwise, -1.
@ All registers EXCEPT R0 are preserved.

/* ----------------------------------------------------------------------------------------- */

String_indexOf_2:

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

	mov	r4, r2			@ count/index starting from index held in r2
	mov	r6, r0			@ copy the string address into r6

	/*** check if the desired index is outside of the bounds of the string ***/

	bl	String_length		@ call String_Length, return length of our string in R0

	/*** if (r0 < r2) then break and return -1 ***/

	cmp	r0, r2			@ compare string length to starting index
	movlt	r4, #-1			@ return a -1 if r0 < r2
	blt	String_indexOf_2_break	@ break from function if r0 < r2

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

String_indexOf_2_loop:

	ldrb	r5, [r6, r4]		@ step through string by one character

	/*** if (string1[r4] == 0) then break  ***/

	cmp	r5, #0			@ check for null character
	moveq	r4, #-1			@ if ch is not found, return a -1
	beq	String_indexOf_2_break	@ break from function if null is encountered

	/*** if (string1[r4] == ch) then break  ***/
	
	cmp	r5, r1			@ compare string[r4] to our desired char
	beq	String_indexOf_2_break	@ break from function if we find the desired char

	/*** if ch is not found and string continues, increment index ***/

	add	r4, #1			@ increment index counter
	b	String_indexOf_2_loop	@ loop again

/* ----------------------------------------------------------------------------------------- */

String_indexOf_2_break:

	mov	r0, r4			@ copy index counter into r0 to be returned
	b	returning		@ exit from function and return to caller

/*********************************************************************************************/	



/*********************************************************************************************/	

	/************************/
	/*** String_indexOf_3 ***/
	/************************/
 
@ String_indexOf_3 (string1:String, str:String):int

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

@ Returns the index of the first occurrence of the specified substring str in string string1.

@ R0: Points to the address of a string with at least one ascii character to search
@ R1: Points to the address of a string acting as the substring to search for

@ Returned register contents:
	@ R0: Index of the first byte of the first occurrence of str if it is present in 
	@     string1. Otherwise, -1.
@ All registers EXCEPT R0 are preserved.

/* ----------------------------------------------------------------------------------------- */

String_indexOf_3:

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

	mov	r4, #0			@ count/index for string
	mov	r7, #0			@ count/index for substring
	mov	r8, #-1			@ to hold our index of occurrence of substring

	ldrb	r6, [r1]		@ load our first byte of our substring

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

String_indexOf_3_loop:

	ldrb	r5, [r0, r4]		@ step through string by one character

	/*** if (string1[r4] == str[r7])  ***/

	cmp	r5, r6			@ compare string[r4] to str[r7]
	addeq	r7, #1			@ increment substring index if we find a matching char
	movne	r7, #0			@ set r7 to 0 if we encounter a non-matching character
	movne	r8, #-1			@ set r8 to -1 if we encounter non-matching character
	ldrb	r6, [r1, r7]		@ load next byte of substring in
	
	/*** keeping track of the index in which substring may be found ***/

	cmpeq	r8, #-1			@ if we have a match, check if r8 is still "empty"
	moveq	r8, r4			@ if r8 was empty, copy in the current index of string

	/*** if we encounter a null in str, we have found str in string1 ***/
	
	cmp	r6, #0			@ check for null character on substring
	moveq	r4, r7			@ return our last 'index of first match' if we hit null
	beq	String_indexOf_3_break	@ break from function if null is encountered in substr

	/*** if (string1[r4] == 0) then break  ***/

	cmp	r5, #0			@ check for null character
	moveq	r8, #-1			@ if ch is not found, return a -1
	beq	String_indexOf_3_break	@ break from function if null is encountered
	
	/*** if ch is not found and string continues, increment index ***/

	add	r4, #1			@ increment index counter
	b	String_indexOf_3_loop	@ loop again

/* ----------------------------------------------------------------------------------------- */

String_indexOf_3_break:

	mov	r0, r8			@ copy index of substring into r0 to be returned
	b	returning		@ exit from function and return to caller

/*********************************************************************************************/	



/*********************************************************************************************/	

	/****************************/
	/*** String_lastIndexOf_1 ***/
	/****************************/
 
@ String_lastIndexOf_1 (string1:String, ch:char):int


/* ----------------------------------------------------------------------------------------- */

@ Returns the index of the last occurrence of the specified character ch in the string.

@ R0: Points to the address of a string to search
@ R1: Holds a byte representing a character to be searched for

@ Returned register contents:
	@ R0: Index of the last occurrence of ch if it is found. Otherwise, -1.
@ All registers EXCEPT R0 are preserved.

/* ----------------------------------------------------------------------------------------- */

String_lastIndexOf_1:

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

	/*** get length of the string and store length-1 in r4 ***/

	mov	r6, r0			@ copy string address held in r0 into r6

	bl	String_length		@ call String_Length, return length of our string in r0

	mov	r4, r0			@ copy string length into r4
	sub	r4, #1			@ r4 = r4 - 1

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

String_lastIndexOf_1_l:

	/*** if (r4 < 0) then break ***/

	cmp	r4, #0			@ compare r4 to 0
	blt	String_lastIndexOf_1_b	@ break and return with -1 if we step out of bounds
	
	/*** load byte at string1[r4] ***/

	ldrb	r5, [r6, r4]		@ step through string starting from last index backwards

	/*** if (string1[r4] == ch) then break  ***/

	cmp	r5, r1			@ check if current byte holds desired character
	beq	String_lastIndexOf_1_b	@ break from function if desired char is encountered

	/*** if (string1[r4] != ch) then decrement and loop  ***/
	
	sub	r4, #1			@ r4 = r4 - 1

	b	String_lastIndexOf_1_l	@ loop again

/* ----------------------------------------------------------------------------------------- */

String_lastIndexOf_1_b:

	mov	r0, r4			@ copy index counter into r0 to be returned
	b	returning		@ exit from function and return to caller

/*********************************************************************************************/	



/*********************************************************************************************/	

	/****************************/
	/*** String_lastIndexOf_2 ***/
	/****************************/
 
@ String_lastIndexOf_2 (string1:String, ch:char, fromIndex:int):int

/* ----------------------------------------------------------------------------------------- */

@ Returns the index of the last occurrence of the specified character ch in the string, 
@ starting from the specified index fromIndex

@ R0: Points to the address of a string to search
@ R1: Holds a byte representing a character to be searched for
@ R2: Holds an int representing the index to begin the search from

@ Returned register contents:
	@ R0: Index of the last occurrence of ch if it is found in the bounds. Otherwise, -1.
@ All registers EXCEPT R0 are preserved.

/* ----------------------------------------------------------------------------------------- */

String_lastIndexOf_2:

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

	/*** get length of the string and store length-1 in r4 ***/

	mov	r6, r0			@ copy string address held in r0 into r6

	bl	String_length		@ call String_Length, return length of our string in r0

	/*** check if (length <= index) and return with -1 if it is ***/

	cmp	r0, r2			@ compare length with our beginning index
	movle	r4, #-1			@ if (length <= index) return with -1
	ble	String_lastIndexOf_2_b	@ return from function

	/*** initialize r4 (LCV) ***/

	mov	r4, r2			@ copy desired index into r4

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

String_lastIndexOf_2_l:

	/*** if (r4 < 0) then break ***/

	cmp	r4, #0			@ compare r4 to 0
	blt	String_lastIndexOf_2_b	@ break and return with -1 if we step out of bounds
	

	/*** load byte at string1[r4] ***/

	ldrb	r5, [r6, r4]		@ step through string starting from last index backwards

	/*** if (string1[r4] == ch) then break  ***/

	cmp	r5, r1			@ check if current byte holds desired character
	beq	String_lastIndexOf_2_b	@ break from function if desired char is encountered

	/*** if (string1[r4] != ch) then decrement and loop  ***/
	
	sub	r4, #1			@ r4 = r4 - 1

	b	String_lastIndexOf_2_l	@ loop again

/* ----------------------------------------------------------------------------------------- */

String_lastIndexOf_2_b:

	mov	r0, r4			@ copy index counter into r0 to be returned
	b	returning		@ exit from function and return to caller

/*********************************************************************************************/	


/*********************************************************************************************/	

	/****************************/
	/*** String_lastIndexOf_3 ***/
	/****************************/
 
@ String_lastIndexOf_3 (string1:String, str:String):int

/* ----------------------------------------------------------------------------------------- */

@ Returns the index of the last occurrence of the specified substring str in the string string1.

@ R0: Points to the address of a string to search
@ R1: Points to the address of a string acting as the substring to search for

@ Returned register contents:
	@ R0: Index of the last occurrence of str if it is found. Otherwise, -1.
@ All registers EXCEPT R0 are preserved.

/* ----------------------------------------------------------------------------------------- */

String_lastIndexOf_3:

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

	/*** get length of the string and store length-1 in r4 ***/

	mov	r6, r0			@ copy string address held in r0 into r6
	bl	String_length		@ call String_Length, return length of our string in r0
	sub	r0, #1			@ r0 = r0 - 1; length gets decremented as we iterate
	mov	r4, r0			@ r4 = string1.length - 1, used to step through string1

	/*** get length of the substring and store length - 1 in r8 ***/

	@ r8 will hold str.length - 1 throughout the entire function if a reset is needed
	@ r6 will be changed to step through the substring

	mov	r0, r1			@ copy substring address into r0
	bl	String_length		@ call String_Lenfth, return length of our string in r0
	sub	r0, #1			@ r0 = r0 - 1; length gets decremented as we iterate
	mov	r8, r0			@ r8 = str.length - 1

	mov	r0, r6			@ copy string1 address back into r0
	mov	r6, r8			@ r6 = str.length - 1

	ldrb	r7, [r1, r6]		@ load the last byte of our substring into r7

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

String_lastIndexOf_3_l:

	/*** if (r4 < 0) then break ***/

	cmp	r4, #0			@ compare r0 to 0 to check if we have stepped out
	blt	String_lastIndexOf_3_b	@ break and return with -1 if we step out of bounds
	
	/*** load byte at string1[r4] ***/

	ldrb	r5, [r0, r4]		@ step through string starting from last index backward

	/*** if (string1[r4] == str[r6])  ***/

	cmp	r5, r7			@ compare string1[r4] to str[r6]
	subeq	r6, #1			@ decrement substring index if we find a matching char
	movne	r6, r8			@ reset r8 to substr[length-1] if we have no match
	ldrb	r7, [r1, r6]		@ load next byte of substring in

	/*** if r6 < 0, we have found the entire substring within string1 ***/
	
	cmp	r6, #0			@ compare r6 (substring index) to 0
	blt	String_lastIndexOf_3_b	@ break and return with index currently held in r0

	/*** continue loop if r6 >= 0 && r0 != null terminator ***/

	sub	r4, #1			@ r4 = r4 - 1
	b	String_lastIndexOf_3_l	@ loop again

/* ----------------------------------------------------------------------------------------- */

String_lastIndexOf_3_b:

	mov	r0, r4			@ copy index counter into r0 to be returned
	b	returning		@ exit from function and return to caller

/*********************************************************************************************/	



/*********************************************************************************************/
	
	/*********************/
	/*** String_concat ***/
	/*********************/
 
@ String_concat (string1:String, str:string):String

/* ----------------------------------------------------------------------------------------- */

@ Returns the address of a new string, str concatenated to the end of string.

@ R0: Points to the address of the string to be concatenated to
@ R1: Points to the address of the string to be concatenated

@ Returned register contents:
	@ R0: Address of a new string consisting of string + str
@ All registers EXCEPT R0 are preserved.

/* ----------------------------------------------------------------------------------------- */

String_concat:

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

	mov	r6, r0			@ copy the address of string1 into r6

	/*** get the length of the new string to be dynamically made ***/

	bl	String_length		@ call String_Length, passing string1	
	mov	r7, r0			@ copy string1.length into r7

	mov	r0, r1			@ copy the address of str into r0
	bl	String_length		@ call String_Length, passing str
	add	r7, r0			@ r7 = r7 + r0 (add both lengths together)
	add	r7, #1			@ add 1 for the null terminator

	/*** create the new string with its address held in r0 ***/

	mov	r0, r7			@ copy the value of r7 into r0 (new string length)
	push	{r1, r2, r3}		@ preserve r1-r3 as malloc does not do so
	bl	malloc			@ call malloc, dynamically allocate memory with size r0
	pop	{r1, r2, r3}		@ pop r1-r3 back off the stack

	mov	r4, #0			@ count/index for our new string

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

	/*** first copy string1 into the new string ***/

String_concat_string1:

	ldrb	r5, [r6, r4]		@ step through string by one character

	/*** if (string1[r4] == 0) then break  ***/

	cmp	r5, #0			@ check for null character
	beq	String_concat_string1_b	@ break from this loop if null is encountered

	/*** copy single char at index [r4] from string1 into new string  ***/
	
	strb	r5, [r0, r4]		@ store string1[r4] into new string[r4]

	/*** increment index and loop ***/

	add	r4, #1			@ increment index counter
	b	String_concat_string1	@ loop again

/* ----------------------------------------------------------------------------------------- */

String_concat_string1_b:

	mov	r6, #0			@ r6 becomes a index counter for iterating through str

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

	/*** second, copy str immediately after string1 in the new string ***/

String_concat_str:

	ldrb	r5, [r1, r6]		@ step through str by one character

	/*** copy single char at str[r6] into new string[r4] ***/

	strb	r5, [r0, r4]		@ store str[r6] into new string[r4]

	/*** if (str[r6] == 0) then break ***/

	cmp	r5, #0			@ check for null character
	beq	String_concat_break	@ break from this loop if null is encountered

	/*** increment both indexes and loop ***/

	add	r4, #1			@ increment index counter for new string
	add	r6, #1			@ increment index counter for str
	b	String_concat_str	@ loop again

String_concat_break:

	b	returning		@ exit from function and return to caller

/*********************************************************************************************/	



/*********************************************************************************************/
	
	/**********************/
	/*** String_replace ***/
	/**********************/
 
@ String_replace (string1:String, oldChar:char, newChar:char):String

/* ----------------------------------------------------------------------------------------- */

@ Returns the address of a new string after changes all occurrences of oldChar with newChar.

@ R0: Points to the address of a null-terminated string to be updated
@ R1: Holds a byte representing a character to be replaced in string1.
@ R2: Holds a byte representing a character to replace oldChar with in string1.

@ Returned register contents:
	@ R0: Address of a new string with all oldChar replaced with newChar
@ All registers EXCEPT R0 are preserved.

/* ----------------------------------------------------------------------------------------- */

String_replace:

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

	mov	r6, r0			@ copy the address of string1 into r6

	/*** get the length of the new string to be dynamically made ***/

	bl	String_length		@ call String_Length, passing string1	

	/*** create a new string with size = string1.length, held in r0 ***/

	push	{r1, r2, r3}		@ preserve r1-r3 as malloc does not do so
	bl	malloc			@ call malloc, dynamically allocate memory with size r0
	pop	{r1, r2, r3}		@ pop r1-r3 back off the stack

	mov	r4, #0			@ count/index for our new string

/* ----------------------------------------------------------------------------------------- */

	/*** first copy string1 into the new string ***/

	bl	copy_string_into_new	@ call subroutine to copy string1 into new string

/* ----------------------------------------------------------------------------------------- */

	mov	r4, #0			@ set r4 = 0 and use as index counter for iterating

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

	/*** loop through new string and replace all occurrences of oldChar with newChar  ***/

String_replace_loop:

	ldrb	r5, [r0, r4]		@ step through new string by one character


	/*** if (new string[r4] == 0) then break ***/

	cmp	r5, #0			@ check for null character
	beq	String_replace_break	@ break from this loop if null is encountered

	/*** if (new string[r4] == oldChar) then replace it ***/

	cmp	r5, r1			@ compare new string[r4] to oldChar
	streqb	r2, [r0, r4]		@ store str[r6] into new string[r4]

	/*** increment index and loop ***/

	add	r4, #1			@ increment index counter for new string
	b	String_replace_loop	@ loop again

String_replace_break:

	b	returning		@ exit from function and return to caller

/*********************************************************************************************/	



/*********************************************************************************************/
	
	/**************************/
	/*** String_toLowerCase ***/
	/**************************/
 
@ String_toLowerCase (string1:String):String

/* ----------------------------------------------------------------------------------------- */

@ Returns the address of a new string after changing the contents of the string to be all
@ lowercase characters.

@ R0: Points to the address of a null-terminated string to be updated

@ Returned register contents:
	@ R0: Address of a new string with all lowercase contents of original string
@ All registers EXCEPT R0 are preserved.

/* ----------------------------------------------------------------------------------------- */

String_toLowerCase:

	/*** Preserve AACPS required registers ***/

	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */

	mov	r6, r0			@ copy the address of string1 into r6

	/*** get the length of the new string to be dynamically made ***/

	bl	String_length		@ call String_Length, passing string1	

	/*** create a new string with size = string1.length, held in r0 ***/

	push	{r1, r2, r3}		@ preserve r1-r3 as malloc does not do so
	bl	malloc			@ call malloc, dynamically allocate memory with size r0
	pop	{r1, r2, r3}		@ pop r1-r3 back off the stack

	mov	r4, #0			@ count/index for our new string

/* ----------------------------------------------------------------------------------------- */

	/*** first copy string1 into the new string ***/

	bl	copy_string_into_new	@ call subroutine to copy string1 into new string

/* ----------------------------------------------------------------------------------------- */

	mov	r4, #0			@ set r4 = 0 and use as index counter for iterating

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

	/*** loop through new string and replace all occurrences of uppercase characters  ***/
	/*** with their lowercase equivalent 						  ***/

String_toLowerCase_l:

	ldrb	r5, [r0, r4]		@ step through new string by one character


	/*** if (new string[r4] == 0) then break from loop ***/

	cmp	r5, #0			@ check if char is a null character
	beq	String_toLowerCase_b	@ break from loop if null is encountered

	/*** if (new string[r4] < 65) then loop and load next char ***/

	cmp	r5, #65			@ check if char is an uppercase letter; A = 65
	blt	String_toLowerCase_Inv	@ loop again if char is a special char

	/*** if (new string[r4] > 90) then loop and load next char ***/

	cmp	r5, #90			@ check if char is outside uppercase range; Z = 90
	bgt	String_toLowerCase_Inv	@ loop again if char is not an uppercase char

	/*** if new string[r4] is an uppercase char, replace with lowercase equivalent ***/

	add	r5, #32			@ r5 = r5 + 32; convers an uppercase char to lowercase
	strb	r5, [r0, r4]		@ store lowercase char into new string[r4]

	/*** if character is not  convertable to lowercase load next char & loop ***/

String_toLowerCase_Inv:

	/*** increment index and loop ***/

	add	r4, #1			@ increment index counter for new string
	b	String_toLowerCase_l	@ loop again

String_toLowerCase_b:

	b	returning		@ exit from function and return to caller


/*********************************************************************************************/	



/*********************************************************************************************/
	
	/**************************/
	/*** String_toUpperCase ***/
	/**************************/
 
@ String_toUpperCase (string1:String):String



@ Returns the address of a new string after changing the contents of the string to be all
@ uppercase characters.

@ R0: Points to the address of a null-terminated string to be updated

@ Returned register contents:
	@ R0: Address of a new string with all uppercase contents of original string
@ All registers EXCEPT R0 are preserved.

/* ----------------------------------------------------------------------------------------- */

String_toUpperCase:

	/*** Preserve AACPS required registers ***/
	
	push	{r4-r8, r10, r11} 	@ push all necessary registers to stack to be preserved
	push	{sp}			@ stack pointer gets pushed last
	

	@ NOT AAPCS REQUIRED
	@ preserve link register to enable external fn calls

	push	{lr}			@ push link register to stack

/* ----------------------------------------------------------------------------------------- */
/* ----------------------------------------------------------------------------------------- */

	mov	r6, r0			@ copy the address of string1 into r6

	/*** get the length of the new string to be dynamically made ***/

	bl	String_length		@ call String_Length, passing string1	

	/*** create a new string with size = string1.length, held in r0 ***/

	push	{r1, r2, r3}		@ preserve r1-r3 as malloc does not do so
	bl	malloc			@ call malloc, dynamically allocate memory with size r0
	pop	{r1, r2, r3}		@ pop r1-r3 back off the stack

	mov	r4, #0			@ count/index for our new string

/* ----------------------------------------------------------------------------------------- */

	/*** first copy string1 into the new string ***/

	bl	copy_string_into_new	@ call subroutine to copy string1 into new string

/* ----------------------------------------------------------------------------------------- */

	mov	r4, #0			@ set r4 = 0 and use as index counter for iterating

	/*** Loop ***/

/* ----------------------------------------------------------------------------------------- */

	/*** loop through new string and replace all occurrences of lowercase characters  ***/
	/*** with their uppercase equivalent 						  ***/

String_toUpperCase_l:

	ldrb	r5, [r0, r4]		@ step through new string by one character


	/*** if (new string[r4] == 0) then break from loop ***/

	cmp	r5, #0			@ check if char is a null character
	beq	String_toUpperCase_b	@ break from loop if null is encountered

	/*** if (new string[r4] < 97) then loop and load next char ***/

	cmp	r5, #97			@ check if char is a lowercase letter; a = 97
	blt	String_toUpperCase_Inv	@ loop again if char is not lowercase

	/*** if (new string[r4] > 122) then loop and load next char ***/

	cmp	r5, #122		@ check if char is outside lowercase range; z = 122
	bgt	String_toUpperCase_Inv	@ loop again if char is not an lowercase char

	/*** if new string[r4] is a lowercase char, replace with uppercase equivalent ***/

	sub	r5, #32			@ r5 = r5 - 32; convers a lowercase char to uppercase
	strb	r5, [r0, r4]		@ store uppercase char into new string[r4]

	/*** if character is found to not be convertable to uppercase load next char & loop ***/

String_toUpperCase_Inv:

	/*** increment index and loop ***/

	add	r4, #1			@ increment index counter for new string
	b	String_toUpperCase_l	@ loop again

String_toUpperCase_b:

	b	returning		@ exit from function and return to caller

/*********************************************************************************************/	



/*********************************************************************************************/	

	/****************************/
	/*** copy_string_into_new ***/
	/****************************/

	@ subroutine copies a passed string into a newly allocated string
	@ R0: points to address of newly allocated string
	@ R6: points to address of string to be copied
	@ R4: starting index for copy

copy_string_into_new:

	ldrb	r5, [r6, r4]		@ step through string by one character

	/*** copy single char at index [r4] from string1 into new string  ***/

	strb	r5, [r0, r4]		@ store string1[r4] into new string[r4]

	/*** if (string1[r4] == 0) then break  ***/

	cmp	r5, #0			@ check for null character
	beq	finish_copy	@ break from this loop if null is encountered

	/*** increment index and loop ***/

	add	r4, #1			@ increment index counter
	b	copy_string_into_new	@ loop again

finish_copy:

	bx	lr

/*********************************************************************************************/	



/*********************************************************************************************/	

	/*****************/
	/*** Returning ***/
	/*****************/

	@ pop registers off the stack and return from function

returning:

	pop	{lr}

	/******************************************/
	/*** Restoring AAPCS mandated registers ***/
	/******************************************/

	pop	{sp}			@ stack pointer gets popped before others
	pop	{r4-r8, r10, r11}	@ pop all preserved registers off of the stack

/*********************************************************************************************/	

	bx	lr			@ return to calling location

	.end
