@*****************************************************************************
@Name:      Jacob Tredwell
@Program:   String1.s
@Class:     CS 3B
@Date:      October 28, 2020 
@Purpose: Contains multiple string methods

@1) +String_length
	@ Returns length of string   
	@ R0: Contains pointer that points to the null-terminated string
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains pointer to string	
 
@2) +String_equals (string, string)  Boolean (byte)
	@ Returns if a string is equal to another string  
	@ R1: Contains pointer that points to the null-terminated string #1
	@ R2: Contains pointer that points to the null-terminated string #2
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains True (1) or False (0)
		

@3) +String_equalsIgnoreCase(string1:String,string2:String):boolean   (byte)
	@ Returns if a string is equal to another string  
	@ R1: Contains pointer that points to the null-terminated string #1
	@ R2: Contains pointer that points to the null-terminated string #2
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains True (1) or False (0)


@4)+String_copy(string1:String):String   => +String_copy(lpStringToCopy:dword):dword

	@makes a copy of string at a new location
	@ R0: Contains pointer that points to the null-terminated string
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains pointer to new s4 string


@5) +String_substring_1(string1:String,beginIndex:int,endIndex:int):String

	@makes a copy of string at a new location
	@ R0: Contains pointer that points to the null-terminated string
	@ R4: begin index
	@ R3: ending index
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains pointer to new s4 string


@6) +String_substring_2(string1:String,beginIndex:int):String

	@makes a copy of string at a new location
	@ R0: Contains pointer that points to the null-terminated string
	@ R4: begin index
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains pointer to new s4 string

@7) +String_charAt(string1:String,position:int):char (byte) 

	@makes a copy of string at a new location
	@ R0: Contains pointer that points to the null-terminated string
	@ R4: desired index
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains pointer to new string with desired string

@8) +String_startsWith_1(string1:String,strPrefix:String, pos:int):boolean
	@checks if string is equal at a starting address
	@ R0: Contains pointer that points to the null-terminated string
	@ R4: start index
	@ R3: prefix
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains True (1) or False (0)

@9) +String_startsWith_2(string1:String, strPrefix:String):boolean 

	@checks if string is equal at a starting address
	@ R0: Contains pointer that points to the null-terminated string
	@ R3: prefix
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains True (1) or False (0)


@10) +String_endsWith(string1:String, suffix:String):boolean

	@checks if string is equal at a starting address
	@ R0: Contains pointer that points to the null-terminated string
	@ R3: suffix
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains True (1) or False (0)

/*****************************Begin***********************************************************************/



@ AAPCS v2020Q2 Required registers are preserved

	.data
	.global String1

	.extern	mallloc			@ allows for dynamic memory allocation
	.extern	free			@ allows for dynamic memory freeing

	.text

	.global String_length			@provide program starting address to String_length
	.global String_equals			@provide program starting address to String_equals  
	.global	String_equalsIgnoreCase		@provide program starting address to String_equalsIgnoreCase 
	.global	String_copy			@provide program starting address to String_copy 
	.global String_substring_1		@provide program starting address to String_substring_1
	.global String_substring_2		@provide program starting address to String_substring_2
	.global String_charAt			@provide program starting address to String_charAt
	.global String_startsWith_1		@provide program starting address to String_startsWith_1
	.global String_startsWith_2		@provide program starting address to String_startsWith_2
	.global	String_endsWith			@provide program starting address to String_endsWith

String1:

/*****************************String_length***********************************************************************/

@1) +String_length
	@ Returns length of string   
	@ R0: Contains pointer that points to the null-terminated string
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains pointer to string	

String_length:
	
	@Preserve AAPCS Required Registers
	push	{r4-r8, r10, r11}
	push 	{sp}
	push	{lr}

	@----------------------------------------------------
	
	

	mov 	r6, #0				@this will hold the count of characters in the string

string_length_loop:

	
	ldrb 	r5, [r0]			@loads a single byte into r1 from string stored in memory
	add	r0, r0, #1			@increase r0 address by 1 byte
	

	cmp 	r5, #0				@compare r1 and 0x00
	beq	endStrLen			@branch to end if r1 = 0

	

	add	r6, r6, #1			@increment counter
	
	b 	string_length_loop		@branches back to string_length_loop



endStrLen:

	mov	r0, r6				@moves integer that holds count into r0



	@Restoring our AAPCS mandated Registers
	pop	{lr}
	pop 	{sp}
	pop	{r4-r8, r10, r11}


	bx 	lr





/*****************************String_equals***********************************************************************/

@2) +String_equals (string, string)  Boolean (byte)
	@ Returns if a string is equal to another string  
	@ R1: Contains pointer that points to the null-terminated string #1
	@ R2: Contains pointer that points to the null-terminated string #2
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains True (1) or False (0)
		

String_equals:	

@Preserve AAPCS Required Registers
	push	{r4-r8, r10, r11}
	push 	{sp}
	push 	{lr}

	@----------------------------------------------------
	
	



String_equals_loop:

	

	ldrb 	r5, [r1]			@loads a single byte into r5 from string #1 stored in memory
	add	r1, r1, #1			@increase r0 address by 1 byte


	ldrb 	r6, [r2]			@loads a single byte into r5 from string #1 stored in memory
	add	r2, r2, #1			@increase r0 address by 1 byte

	cmp	r5, r6				@compare character stored in r5 from string #1 and r6 from string 2

	bne	not_equal			@branch to not_equal if 

	cmp 	r5, #0				@compare r5 and 0x00
	beq	equal				@branch to end if r1 = 0

	b	String_equals_loop		@branch back to String_equals_loop	

not_equal:

	mov	r0, #0				@holds 0 for FALSE
	b	end_str_eq			@branch to end

equal:

	mov 	r0, #1				@holds 1 for TRUE
	b	end_str_eq			@branch to end

end_str_eq:

	

@Restoring our AAPCS mandated Registers
	pop 	{lr}
	pop 	{sp}
	pop	{r4-r8, r10, r11}


	bx 	lr	
		






/*****************************String_equalsignoreCase***********************************************************************/

@ +String_equalsIgnoreCase(string1:String,string2:String):boolean   (byte)
	@ Returns if a string is equal to another string  
	@ R1: Contains pointer that points to the null-terminated string #1
	@ R2: Contains pointer that points to the null-terminated string #2
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains True (1) or False (0)
		

String_equalsIgnoreCase:	

@Preserve AAPCS Required Registers
	push	{r4-r8, r10, r11}
	push 	{sp}
	push 	{lr}
	@----------------------------------------------------
	
	
String_equals_I_loop:

	

	ldrb 	r5, [r1]			@loads a single byte into r5 from string #1 stored in memory
	add	r1, r1, #1			@increase r0 address by 1 byte

	cmp	r5, #0x5E			@compares r5 to value that is after lowercase ascii

	addlt	r5, r5, #0x20			@add 0x20 to the value so that it converts all uppercase to lowercase


	ldrb 	r6, [r2]			@loads a single byte into r5 from string #1 stored in memory
	add	r2, r2, #1			@increase r0 address by 1 byte

	cmp	r6, #0x5E			@compares r5 to value that is after lowercase ascii
	addlt	r6, r6, #0x20			@add 0x20 to the value so that it converts all uppercase to lowercase

	cmp	r5, r6				@compare character stored in r5 from string #1 and r6 from string 2

	bne	not_equalI			@branch to not_equal if 

	cmp 	r5, #0x20			@compare r5 and 0x20 as if the null string exist it will be converted to 0x20
	beq	equalI				@branch to end if r1 = 0

	b	String_equals_I_loop		@branch back to String_equals_loop	

not_equalI:

	mov	r0, #0				@holds 0 for FALSE
	b	end_str_eqI			@branch to end

equalI:

	mov 	r0, #1				@holds 1 for TRUE
	b	end_str_eqI			@branch to end

end_str_eqI:

	

@Restoring our AAPCS mandated Registers
	pop 	{lr}
	pop 	{sp}
	pop	{r4-r8, r10, r11}


	bx 	lr	
		



/*****************************String_copy***********************************************************************/


@v +String_copy(string1:String):String   => +String_copy(lpStringToCopy:dword):dword

	@makes a copy of string at a new location
	@ R0: Contains pointer that points to the null-terminated string
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains pointer to new s4 string



String_copy:

@Preserve AAPCS Required Registers
	push	{r4-r8, r10, r11}
	push 	{sp}
	push 	{lr}

	@----------------------------------------------------
	


	mov 	r6, r0 				@ copy the address of s1 string1 into r6


	
	mov	r0, #16				@move 16 bytes

	push 	{r1, r2, r3} 			@ preserve r1-r3 as malloc does not do so
	bl 	malloc 				@ call malloc, dynamically allocate memory with size r0
	pop 	{r1, r2, r3} 			@ pop r1-r3 back off the stack


	mov	r4, #0				@ count/index for our new string



	bl	copy_string_into_new		@ call subroutine to copy string1 into new string



	/****************************/
	/*** copy_string_into_new ***/
	/****************************/

	@ subroutine copies a passed string into a newly allocated string
	@ R0: points to address of newly allocated string
	@ R6: points to address of string to be copied
	@ R4: starting index for copy

copy_string_into_new:

	ldrb	r5, [r6, r4]			@ step through string by one character

	/*** copy single char at index [r4] from string1 into new string  ***/

	strb	r5, [r0, r4]			@ store string1[r4] into new string[r4]

	/*** if (string1[r4] == 0) then break  ***/

	cmp	r5, #0				@ check for null character
	beq	finish_copy			@ break from this loop if null is encountered

	/*** increment index and loop ***/

	add	r4, #1				@ increment index counter
	b	copy_string_into_new		@ loop again

finish_copy:
	

@Restoring our AAPCS mandated Registers
	pop 	{lr}
	pop 	{sp}
	pop	{r4-r8, r10, r11}


	bx 	lr	



/*****************************String_subscript_1***********************************************************************/
@ +String_substring_1(string1:String,beginIndex:int,endIndex:int):String

	@makes a copy of string at a new location
	@ R0: Contains pointer that points to the null-terminated string
	@ R4: starting index
	@ R3: ending index
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains pointer to new s4 string


String_substring_1:

@Preserve AAPCS Required Registers
	push	{r4-r8, r10, r11}
	push 	{sp}
	push 	{lr}


	mov 	r6, r0 				@ copy the address of s3 string1 into r6


	
	mov	r0, #16				@move 16 bytes

	push 	{r1, r2, r3} 			@ preserve r1-r3 as malloc does not do so
	bl 	malloc 				@ call malloc, dynamically allocate memory with size r0
	pop 	{r1, r2, r3} 			@ pop r1-r3 back off the stack


	mov	r4, #4				@starting index
	mov	r2, #0				@zero out r2

	bl	copy_string_into_new_1		@ call subroutine to copy string1 into new string



	/****************************/
	/*** copy_string_into_new ***/
	/****************************/

	@ subroutine copies a passed string into a newly allocated string
	@ R0: points to address of newly allocated string
	@ R6: points to address of string to be copied
	@ R4: starting index for copy

copy_string_into_new_1:

	ldrb	r5, [r6, r4]			@ step through string by one character

	/*** copy single char at index [r4] from string1 into new string  ***/

	strb	r5, [r0, r2]			@ store string1[r4] into new string[r4]


	cmp	r4, #13				@ check for last character for ending index
	beq	finish_copy_1			@ break from this loop if null is encountered

	/*** increment index and loop ***/
	
	add	r2, #1				@increment counter
	add	r4, #1				@ increment index counter
	b	copy_string_into_new_1		@ loop again

finish_copy_1:




@Restoring our AAPCS mandated Registers
	pop 	{lr}
	pop 	{sp}
	pop	{r4-r8, r10, r11}


	bx 	lr



/*****************************String_subscript_2***********************************************************************/

@ +String_substring_2(string1:String,beginIndex:int):String

	@makes a copy of string at a new location
	@ R0: Contains pointer that points to the null-terminated string
	@ R4: begin index
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains pointer to new s4 string


String_substring_2:

@Preserve AAPCS Required Registers
	push	{r4-r8, r10, r11}
	push 	{sp}
	push 	{lr}





	mov 	r6, r0 				@ copy the address of s3 string1 into r6


	
	mov	r0, #16				@move 16 bytes

	push 	{r1, r2, r3} 			@ preserve r1-r3 as malloc does not do so
	bl 	malloc 				@ call malloc, dynamically allocate memory with size r0
	pop 	{r1, r2, r3} 			@ pop r1-r3 back off the stack


	mov	r4, #7				@starting index
	mov	r2, #0				@zero out r2

	bl	copy_string_into_new_2		@ call subroutine to copy string1 into new string



	/****************************/
	/*** copy_string_into_new ***/
	/****************************/

	@ subroutine copies a passed string into a newly allocated string
	@ R0: points to address of newly allocated string
	@ R6: points to address of string to be copied
	@ R4: starting index for copy

copy_string_into_new_2:

	ldrb	r5, [r6, r4]			@ step through string by one character

	/*** copy single char at index [r4] from string1 into new string  ***/

	strb	r5, [r0, r2]			@ store string1[r4] into new string[r4]


	cmp	r5, #0				@ check for NULL last character
	beq	finish_copy_2			@ break from this loop if null is encountered

	/*** increment index and loop ***/
	
	add	r2, #1				@increment counter
	add	r4, #1				@ increment index counter
	b	copy_string_into_new_2		@ loop again

finish_copy_2:







@Restoring our AAPCS mandated Registers
	pop 	{lr}
	pop 	{sp}
	pop	{r4-r8, r10, r11}


	bx 	lr












/***************************************************************************************************************/
/*****************************String_charAt***********************************************************************/

@ +String_charAt(string1:String,position:int):char (byte) 

	@makes a copy of string at a new location
	@ R0: Contains pointer that points to the null-terminated string
	@ R4: desired index
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains pointer to new string with desired string

String_charAt:

@Preserve AAPCS Required Registers
	push	{r4-r8, r10, r11}
	push 	{sp}
	push 	{lr}



	mov 	r6, r0 				@ copy the address of s3 string1 into r6


	
	mov	r0, #16				@move 16 bytes

	push 	{r1, r2, r3} 			@ preserve r1-r3 as malloc does not do so
	bl 	malloc 				@ call malloc, dynamically allocate memory with size r0
	pop 	{r1, r2, r3} 			@ pop r1-r3 back off the stack


	mov	r4, #4				@desired index


	ldrb	r5, [r6, r4]			@ step through string by one character

	/*** copy single char at index [r4] from string1 into new string  ***/

	strb	r5, [r0]			@ store string1[r4] into new string[r4]



@Restoring our AAPCS mandated Registers
	pop 	{lr}
	pop 	{sp}
	pop	{r4-r8, r10, r11}


	bx 	lr


/***************************************************************************************************************/
/*****************************String_startsWith_1***********************************************************************/

@String_startsWith_1(string1:String,strPrefix:String, pos:int):boolean

	@makes a copy of string at a new location
	@ R0: Contains pointer that points to the null-terminated string
	@ R3: strprefix string
	@ R4: index of starting index
	@ LR: Contains the return address

	
	
	@Returned register contents:
	@R0: Contains True (1) or False (0)


String_startsWith_1:

	@Returned register contents:
	@R0: Contains 0 (FALSE) or 1 (TRUE)


	@Preserve AAPCS Required Registers
	push	{r4-r8, r10, r11}
	push 	{sp}
	push 	{lr}




	mov 	r6, r0 				@ copy the address of s3 string1 into r6


	
	mov	r0, #16				@move 16 bytes

	push 	{r1, r2, r3} 			@ preserve r1-r3 as malloc does not do so
	bl 	malloc 				@ call malloc, dynamically allocate memory with size r0
	pop 	{r1, r2, r3} 			@ pop r1-r3 back off the stack


	mov	r4, #10				@starting index
	mov	r2, #0				@zero out r2
	

	bl	startsWith			@ call subroutine to startsWith



startsWith:

	ldrb	r5, [r6, r4]			@ step through string by one character

	strb	r5, [r1, r2]			@ store string1[r4] into new string[r4]


	cmp	r5, #0				@ check for NULL
	beq	check_SW			@ break from this loop if true

	/*** increment index and loop ***/
	
	add	r4, #1				@ increment index counter
	add	r2, #1				@ increment index counter

	b	startsWith			@loop back

check_SW:

	cmp	r1, r3				@compares the entered string and prefix

	beq	true_SW				@branch to true_SW

false_SW:

	mov	r0, #1				@make r0 = 0 (False)

	b	end_of_SW			@branch to end
	
true_SW:

	mov	r0, #1				@make r0 = 1 (TRUE)

	b	end_of_SW			@branch to end


end_of_SW:

	

	@Restoring our AAPCS mandated Registers
	pop 	{lr}
	pop 	{sp}
	pop	{r4-r8, r10, r11}


	bx 	lr


/***************************************************************************************************************/
/*****************************String_startsWith_2***********************************************************************/

@String_startsWith_2(string1:String,strPrefix:String:boolean

	@makes a copy of string at a new location
	@ R0: Contains pointer that points to the null-terminated string
	@ R3: strprefix string
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains True (1) or False (0)



String_startsWith_2:

	@Returned register contents:
	@R0: Contains 0 (FALSE) or 1 (TRUE)


	@Preserve AAPCS Required Registers
	push	{r4-r8, r10, r11}
	push 	{sp}
	push 	{lr}




	mov 	r6, r0 				@ copy the address of s3 string1 into r6


	
	mov	r0, #16				@move 16 bytes

	push 	{r1, r2, r3} 			@ preserve r1-r3 as malloc does not do so
	bl 	malloc 				@ call malloc, dynamically allocate memory with size r0
	pop 	{r1, r2, r3} 			@ pop r1-r3 back off the stack


	mov	r4, #0				@starting index
	mov	r2, #0				@zero out r2


	b	startsWith2			@ call subroutine to startsWith2



startsWith2:

	ldrb	r5, [r6, r4]			@ step through string by one character

	strb	r5, [r1]			@ store string1[r4] into new string[r1]


	cmp	r5, #0				@ check for NULL
	beq	check_SW2			@ break from this loop if true

	/*** increment index and loop ***/
	
	add	r4, #1				@ increment index counter

	b	startsWith2			@loop back

check_SW2:


	cmp	r1, r3				@compares the entered string and prefix

	beq	true_SW2			@branch to true_SW

false_SW2:

	mov	r0, #1				@make r0 = 0 (False)

	b	end_of_SW2			@branch to end
	
true_SW2:

	mov	r0, #1				@make r0 = 1 (TRUE)

	b	end_of_SW2			@branch to end


end_of_SW2:

	

	@Restoring our AAPCS mandated Registers
	pop 	{lr}
	pop 	{sp}
	pop	{r4-r8, r10, r11}


	bx 	lr


/***************************************************************************************************************/
/*****************************String_endsWith***********************************************************************/

@ +String_endsWith(string1:String, suffix:String):boolean

	@checks if string is equal at a starting address
	@ R0: Contains pointer that points to the null-terminated string
	@ R3: suffix
	@ LR: Contains the return address

	@Returned register contents:
	@R0: Contains True (1) or False (0)



	@Returned register contents:
	@R0: Contains 0 (FALSE) or 1 (TRUE)


	@Preserve AAPCS Required Registers
	push	{r4-r8, r10, r11}
	push 	{sp}
	push 	{lr}


String_endsWith:

	mov 	r6, r0 				@ copy the address of s3 string1 into r6


	
	mov	r0, #16				@move 16 bytes

	push 	{r1, r2, r3} 			@ preserve r1-r3 as malloc does not do so
	bl 	malloc 				@ call malloc, dynamically allocate memory with size r0
	pop 	{r1, r2, r3} 			@ pop r1-r3 back off the stack


	mov	r4, #4				@starting index
	mov	r2, #0				@starting counter
	mov	r7, #0				@zero out r7	

	b	endsWITH			@ call subroutine to startsWith2



endsWITH:

	ldrb	r5, [r6, r4]			@ step through string by one character

	strb	r5, [r7, r2]			@ store string1[r4] into new string[r1]


	cmp	r5, #0				@ check for NULL
	beq	check_EW			@ break from this loop if true

	/*** increment index and loop ***/
	
	add	r4, #1				@ increment index counter
	add	r2, #1				@ increment index counter

	b	endsWITH			@loop back

check_EW:

	cmp	r7, r3				@compares the entered string and prefix

	beq	true_EW				@branch to true_EW

false_EW:

	mov	r0, #0				@make r0 = 0 (False)

	b	end_of_EW			@branch to end
	
true_EW:

	mov	r0, #1				@make r0 = 1 (TRUE)

	b	end_of_EW			@branch to end


end_of_EW:

	

	@Restoring our AAPCS mandated Registers
	pop 	{lr}
	pop 	{sp}
	pop	{r4-r8, r10, r11}


	bx 	lr



/*****************************end***********************************************************************/


end:
	.end




