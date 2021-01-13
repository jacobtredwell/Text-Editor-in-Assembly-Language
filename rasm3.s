@******************************************************************************************
@ Name:    Jacob Tredwell & Nicholas Lozano
@ Program: rasm3.s
@ Class:   CS3B
@ Lab:     RASM3
@ Date:    October 27, 2020 at 3:30 PM
@ Purpose:
@	This program will take in three strings as input from the user. It will then call
@	a variety of different string functions that manipulate the strings or return 
@	information. Each function call's results are output sequentially.
@
@ * This program utilizes Dr. Barnett's external functions.
@******************************************************************************************



		.equ	KBSIZE, 512					@ assigns value 512 to symbol KBSIZE

		.data

kbBuf:		.skip	KBSIZE						@ limit for typing into the keyboard
crCr:		.byte 10						@ byte holds carriage return
crDQuote:	.byte 34						@ byte holds an ascii "
crSQuote:	.byte 39						@ byte holds an ascii '
strS1:		.asciz "Enter s1: "					@ user input for s1
strS2:		.asciz "Enter s2: "					@ user input for s2
strS3:		.asciz "Enter s3: "					@ user input for s3

strEggs:	.asciz	"eggs"						@ holds string "eggs"
strEgg:		.asciz	"egg"						@ holds string "egg"
strSpc:		.asciz	" "						@ holds string " "

strS1store:	.skip	KBSIZE						@ holds s1 string
strS2store:	.skip	KBSIZE						@ holds s2 string
strS3store:	.skip	KBSIZE						@ holds s3 string
strS4store:	.skip	KBSIZE						@ holds s4 string

strSum:		.space 	KBSIZE, 0					@iSum string that gets printed at the end

strSize1:	.space	KBSIZE, 0					@ size of string that gets printed at the end
strSize2:	.space	KBSIZE, 0					@ size of s2 string that gets printed at the end
strSize3:	.space	KBSIZE, 0					@ size of s3 string that gets printed at the end

strName: 	.asciz 	"Name: Jacob Tredwell & Nicholas Lozano"	@name
strClass:	.asciz	"Class: CS 3B"					@class
strProgram:	.asciz 	"Program: RASM3.s"				@program
strDate:	.asciz	"Date: 10/28/2020"				@date
strLab:		.asciz 	"Lab: RASM3"					@lab


strLength1:	.asciz	"1. s1.length() = "
strLength2:	.asciz	"   s2.length() = "
strLength3:	.asciz	"   s3.length() = "

strEq1:		.asciz 	"2. String_equals(s1,s3) = "			@holds that string
strEq2:		.asciz 	"3. String_equals(s1,s1) = "			@holds that string
strEqI1:	.asciz 	"4. String_equalsIgnoreCase(s1,s3) = "		@holds that string
strEqI2:	.asciz 	"5. String_equalsIgnoreCase(s1,s2) = "		@holds that string
strTrue:	.asciz 	"TRUE"						@holds "TRUE"
strFalse:	.asciz 	"FALSE"						@holds "FALSE"

strCpy:		.asciz 	"6. s4 = String_copy(s1)"			@holds that string
strCpy1:	.asciz 	"   s1 =  "					@holds that string
strCpy4:	.asciz 	"   s4 =  "					@holds that string

strSubStr1:	.asciz 	"7. String_substring_1(s3,4,14) = "		@holds that string
strSubStr2:	.asciz 	"8. String_substring_2(s3,7) = "		@holds that string

strCharAt:	.asciz 	"9. String_charAt(s2,4) =  "			@holds that string

strSW1:		.asciz 	"10. String_startsWith_1(s1,11, 'hat.') = "	@holds that string
strSW2:		.asciz 	"11. String_startsWith_2(s1,'Cat') = "		@holds that string
strEW:		.asciz 	"12. String_endsWith(s1,'in the hat.) = "	@holds that string

strSW1arg:	.asciz	"hat."						@holds that string
strSW2arg:	.asciz	"Cat"						@holds that string
strEWarg:	.asciz	"in the hat."					@holds that string

strEx13: 	.asciz "13. String_indexOf_1(s2,'g') =  "		@holds that string
strEx14: 	.asciz "14. String_indexOf_2(s2,'g',9) =  "		@holds that string
strEx15:	.asciz "15. String_indexOf_3(s2,\"eggs\") = "		@holds that string
strEx16:	.asciz "16. String_lastIndexOf_1(s2,'g') = "		@holds that string
strEx17:	.asciz "17. String_lastIndexOf_2(s2,'g',6) = "		@holds that string
strEx18:	.asciz "18. String_lastIndexOf_3(s2, \"egg\") = "	@holds that string
strEx19:	.asciz "19. String_replace(s1,'a','o') = "		@holds that string
strEx20:	.asciz "20. String_toLowerCase(s1) = "			@holds that string
strEx21:	.asciz "21. String_toUpperCase(s1) = "			@holds that string
strEx22:	.asciz "22. String_concat(s1,\" \");\n    String_concat(s1,s2) = "

strTemp:	.skip	KBSIZE		@ to be used for temporarily storing strings

	.text

	.global _start			@ provide program starting address to linker

_start:


@---------print "name"------------------------------------------------------------------------------------

	ldr     r0, =strName		@loads address of the name string
	bl    	putstring		@prints name string

@---------carriage return--------------------------------------------------------------------------------
	
	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage return'

@---------print "Prog" string-------------------------------------------------------------------------
	
	ldr     r0, =strProgram		@loads address of the Lab string
	bl    	putstring		@prints lab string

@---------carriage return-----------------------------------------------------------------------------
	
	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage

@---------print "class"---------------------------------------------------------------------------------
	
	ldr     r0, =strClass		@loads address of the class string
	bl    	putstring		@prints class string

@---------carriage return-----------------------------------------------------------------------------
	
	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage return'

@---------print "Lab" string-------------------------------------------------------------------------
	
	ldr     r0, =strLab		@loads address of the Lab string
	bl    	putstring		@prints lab string

@---------carriage return----------------------------------------------------------------------------
	
	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage return'

@----------print "date" string------------------------------------------------------------------------
	
	ldr     r0, =strDate		@loads address of the date string
	bl    	putstring		@prints date string

@----------carriage return--------------------------------------------------------------------------
	
	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage return'

@----------carriage return--------------------------------------------------------------------------
	
	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage return'






@-========================================FUNCTION 1 STRING LENGTH===================================================================







@----------gets user input for s1 --------------------------------------------------------------------


	ldr	r0, =strS1		@r0 points to strUserIn
	bl	putstring		@prints szUserIn to user
	
	ldr	r0, =strS1store		@r0 points to kbBuf
	mov 	r1, #KBSIZE		@store KBSIZE
	bl 	getstring		@call getstring, store use input into strS1store

@----------gets user input for s2 --------------------------------------------------------------------


	ldr	r0, =strS2		@r0 points to strUserIn
	bl	putstring		@prints szUserIn to user
	
	ldr	r0, =strS2store		@r0 points to strS2store
	mov 	r1, #KBSIZE		@store KBSIZE
	bl 	getstring		@call getstring, store use input into strS2store


@----------gets user input for s3 --------------------------------------------------------------------


	ldr	r0, =strS3		@r0 points to strUserIn
	bl	putstring		@prints szUserIn to user
	
	ldr	r0, =strS3store		@r0 points to strS3store
	mov 	r1, #KBSIZE		@store KBSIZE
	bl 	getstring		@call getstring, store use input into strS3store

@----------branch to external --------------------------------------------------------------------

	ldr	r0, =strS1store		@r0 points to strS1store
	
	bl	String_length		@branch to external function STRINGLENGTH

	mov	r3, r0			@makes a copy of iCount in r3

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strLength1		@r0 points to strCount
	bl	putstring		@prints "1. s1.length() =  "

	
	mov	r0, r3			@move integer "count" into r0	

	ldr	r1, =strSize1		@r1 points to strSize
	bl	intasc32		@converts the int to a string

	mov 	r0, r1			@puts address of strSize string in r0
	bl	putstring		@prints the string version of strSize


@----------branch to external --------------------------------------------------------------------

	ldr	r0, =strS2store		@r0 points to strS2store
	
	bl	String_length		@branch to external function STRINGLENGTH

	mov	r3, r0			@makes a copy of iCount in r3

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strLength2		@r0 points to strCount
	bl	putstring		@prints "s2.length() =  "

	
	mov	r0, r3			@move integer "count" into r0	

	ldr	r1, =strSize2		@r1 points to strSize
	bl	intasc32		@converts the int to a string

	mov 	r0, r1			@puts address of strSize string in r0
	bl	putstring		@prints the string version of strSize
	

@carriage return
	

@----------branch to external --------------------------------------------------------------------
	
	ldr	r0, =strS3store		@r0 points to strS3store

	bl	String_length		@branch to external function STRINGLENGTH

	mov	r3, r0			@makes a copy of iCount in r3

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage return'

	ldr	r0, =strLength3		@r0 points to strCount
	bl	putstring		@prints "s3.length() = "

	
	mov	r0, r3			@move integer "count" into r0	

	ldr	r1, =strSize3		@r1 points to strSize
	bl	intasc32		@converts the int to a string

	mov 	r0, r1			@puts address of strSize string in r0
	bl	putstring		@prints the string version of strSize
	

@carriage return
	
	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage return'


	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage return'

@-========================================FUNCTION 2 STRING EQUALS==================================================================


	ldr 	r1, =strS1store		@load pointer to S1
	ldr	r2, =strS3store		@load pointer to S3

	bl	String_equals		@branch to String_equals external Function

	cmp	r0,#0			@compare r0 to 0

	beq	print_FALSE1		@branch to print_FALSE if r0 =0

	cmp	r0,#1			@compare r0 to 0

	beq	print_TRUE1		@branch to print_TRUE if r0 = 1

print_FALSE1:

	ldr	r0, =strEq1		@r0 points to strEq
	bl	putstring		@prints szUserIn to user

	ldr	r0, =strFalse		@r0 points to strFalse
	bl	putstring		@prints FALSE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equals1		@branch to the end

print_TRUE1:

	ldr	r0, =strEq1		@r0 points to strUserIn
	bl	putstring		@prints szUserIn to user

	ldr	r0, =strTrue		@r0 points to strTrue
	bl	putstring		@prints TRUE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equals1		@branch to the end



@========================================================String_Equals(s1, s1)===========================================

end_str_equals1:

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'

	ldr 	r1, =strS1store		@load pointer to S1
	ldr	r2, =strS1store		@load pointer to S1

	bl	String_equals		@branch to String_equals external Function

	cmp	r0,#0			@compare r0 to 0

	beq	print_FALSE2		@branch to print_FALSE if r0 =0

	cmp	r0,#1			@compare r0 to 0

	beq	print_TRUE2		@branch to print_TRUE if r0 = 1

print_FALSE2:

	ldr	r0, =strEq2		@r0 points to strEq
	bl	putstring		@prints szUserIn to user

	ldr	r0, =strFalse		@r0 points to strFalse
	bl	putstring		@prints FALSE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equals2		@branch to the end

print_TRUE2:

	ldr	r0, =strEq2		@r0 points to strUserIn
	bl	putstring		@prints szUserIn to user

	ldr	r0, =strTrue		@r0 points to strTrue
	bl	putstring		@prints TRUE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'
	b	end_str_equals2		@branch to the end

end_str_equals2:

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'

@-========================================FUNCTION 3 STRING EQUALS (ignore case) ==================================================================



	ldr 	r1, =strS1store		@load pointer to S1
	ldr	r2, =strS3store		@load pointer to S3

	bl	String_equalsIgnoreCase	@branch to String_equalsIgnoreCase external Function

	cmp	r0,#0			@compare r0 to 0

	beq	print_FALSE_I1		@branch to print_FALSE if r0 =0

	cmp	r0,#1			@compare r0 to 0

	beq	print_TRUE_I1		@branch to print_TRUE if r0 = 1

print_FALSE_I1:

	ldr	r0, =strEqI1		@r0 points to strEq
	bl	putstring		@prints szUserIn to user

	ldr	r0, =strFalse		@r0 points to strFalse
	bl	putstring		@prints FALSE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equalsI1	@branch to the end

print_TRUE_I1:

	ldr	r0, =strEqI1		@r0 points to strUserIn
	bl	putstring		@prints szUserIn to user

	ldr	r0, =strTrue		@r0 points to strTrue
	bl	putstring		@prints TRUE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equalsI1	@branch to the end



@========================================================String_equalsIgnoreCase(s1, s2)===========================================

end_str_equalsI1:

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'

	ldr 	r1, =strS1store		@load pointer to S1
	ldr	r2, =strS2store		@load pointer to S2

	bl	String_equalsIgnoreCase	@branch to String_equalsIgnoreCase external Function

	cmp	r0,#0			@compare r0 to 0

	beq	print_FALSE_I2		@branch to print_FALSE if r0 =0

	cmp	r0,#1			@compare r0 to 0

	beq	print_TRUE_I2		@branch to print_TRUE if r0 = 1

print_FALSE_I2:

	ldr	r0, =strEqI2		@r0 points to strEq
	bl	putstring		@prints szUserIn to user

	ldr	r0, =strFalse		@r0 points to strFalse
	bl	putstring		@prints FALSE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equalsI2		@branch to the end

print_TRUE_I2:

	ldr	r0, =strEqI2		@r0 points to strUserIn
	bl	putstring		@prints szUserIn to user

	ldr	r0, =strTrue		@r0 points to strTrue
	bl	putstring		@prints TRUE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'
	b	end_str_equalsI2	@branch to the end

end_str_equalsI2:

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'





@========================================================s4 = String_copy(s1)===========================================

	@strCpy:	.asciz 	"s4 = String_copy(s1)"				@holds that string
	@strCpy1:	.asciz 	"s1 =  "					@holds that string
	@strCpy4:	.asciz 	"s4 =  "					@holds that string

	@strS1store:	.skip 	KBSIZE						@holds s1 string
	@strS2store:	.skip 	KBSIZE						@holds s2 string
	@strS3store:	.skip 	KBSIZE						@holds s3 string
	@strS4store:	.skip	KBSIZE						@holds s4 string

	ldr	r0, =strCpy		@prints str
	bl	putstring		@prints "s4=String_copy(s1)"

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage

@-------------------------------------s1 print--------------------------------------

	ldr	r0, =strCpy1		@prints strCpy1
	bl	putstring		@prints "s1 = "


	ldr	r0, =strS1store		@points to s1 string
	bl	putstring		@prints s1
	

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage


@--------------------------------------s4 print---------------
		
	ldr	r0, =strCpy4		@prints strCpy4
	bl	putstring		@prints "s4 = "

	ldr	r0, =strS1store		@points to s1 string

	bl	String_copy		@branch to string_copy EXTERNAL

	mov	r7, r0			@ move the string copy into r7

	bl	putstring		@prints the copy

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage


@========================================================String_substring_1 ===========================================

		@strSubStr1:	.asciz 	"String_substring_1(s3,4,14) = ""		@holds that string

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage


	ldr	r0, =strSubStr1		@prints str
	bl	putstring		@prints ""String_substring_1(s3,4,14) = "

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	ldr	r0, =strS3store		@points to s1 string
	mov 	r4, #4			@starting index
	mov	r3, #14			@ending index

	bl	String_substring_1	@branch to string_copy EXTERNAL
	bl	putstring		@prints the augmented copy

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage




@========================================================String_substring_2 ===========================================

		@strSubStr2:	.asciz 	"String_substring_1(s3,7) = "		@holds that string

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage


	ldr	r0, =strSubStr2		@prints str
	bl	putstring		@prints ""String_substring_1(s3,4,14) = "

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	ldr	r0, =strS3store		@points to s3 string
	mov 	r4, #7			@starting index

	bl	String_substring_2	@branch to string_substring_2 EXTERNAL
	bl	putstring		@prints the augmented copy

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage



@========================================================String_charAt ===========================================

					@strCharAt:	.asciz 	"String_charAt(s2,4) =  "			@holds that string



	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage


	ldr	r0, =strCharAt		@points to strCharAt
	bl	putstring		@prints "String_charAt(s2,4) =  "

	ldr	r0, =crSQuote		@ load into r0 the address of crSQuote
	bl	putch			@ output "

	ldr	r0, =strS2store		@points to s2 string
	mov 	r4, #4			@starting index

	bl	String_charAt		@branch to String_charAt EXTERNAL function
	bl	putstring		@prints the desired character

	ldr	r0, =crSQuote		@ load into r0 the address of crSQuote
	bl	putch			@ output "

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage


@========================================================String_startsWith_1 ===========================================

@strSW1:		asciz 	"String_startsWith_1(s1, 11, 'hat.') = "
@strSW1arg:		.asciz	"hat."						@holds that string

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage


	ldr	r0, =strSW1		@points to strSW1
	bl	putstring		@prints "String_startsWith_1(s1, 11, 'hat.') = "

	ldr	r0, =strS1store		@points to s2 string
	mov 	r4, #11			@starting index

	
	ldr	r8, =strSW1arg		@points to strSW1arg
	ldr	r3, [r8]		@load into r3 the contents of the argument

	bl	String_startsWith_1	@branch to String_startsWith_1 EXTERNAL function
	
	cmp	r0,#0			@compare r0 to 0

	beq	print_FALSE_SW		@branch to print_FALSE if r0 =0

	cmp	r0,#1			@compare r0 to 0

	beq	print_TRUE_SW		@branch to print_TRUE if r0 = 1

print_FALSE_SW:

	ldr	r0, =strFalse		@r0 points to strFalse
	bl	putstring		@prints FALSE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equals_SW	@branch to the end

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'

print_TRUE_SW:

	ldr	r0, =strTrue		@r0 points to strTrue
	bl	putstring		@prints TRUE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equals_SW	@branch to the end

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'

end_str_equals_SW:

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'



@========================================================String_startsWith_2===========================================

@strSW2:		asciz 	"String_startsWith_2(s1,'Cat') = "
@strSW2arg:	.asciz	"Cat"						@holds that string


	ldr	r0, =strSW2		@points to strSW1
	bl	putstring		@prints "String_startsWith_1(s1, 11, 'hat.') = "

	ldr	r0, =strS1store		@points to s2 string

	ldr	r8, =strSW2arg		@points to SW2 arg "Cat"
	ldr	r3, [r8]		@r3 = "Cat"

	bl	String_startsWith_2	@branch to String_startsWith_1 EXTERNAL function
	
	cmp	r0,#0			@compare r0 to 0

	beq	print_FALSE_SW2		@branch to print_FALSE if r0 =0

	cmp	r0,#1			@compare r0 to 0

	beq	print_TRUE_SW2		@branch to print_TRUE if r0 = 1

print_FALSE_SW2:

	ldr	r0, =strFalse		@r0 points to strFalse
	bl	putstring		@prints FALSE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equals_SW2	@branch to the end

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'

print_TRUE_SW2:

	ldr	r0, =strTrue		@r0 points to strTrue
	bl	putstring		@prints TRUE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equals_SW2	@branch to the end

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'

end_str_equals_SW2:

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'


@========================================================String_endsWith===========================================

@String_endsWith(string1:String, suffix:String):boolean

@strEW:		.asciz 	"String_endsWith(s1,'in the hat.') = "		@holds that string


	ldr	r0, =strEW		@points to strSW1
	bl	putstring		@prints "String_startsWith_1(s1, 11, 'hat.') = "

	ldr	r0, =strS1store		@points to s1 string

	ldr	r0, =strTrue		@r0 points to strTrue
	bl	putstring		@prints TRUE

	b	end_str_equals_EW	@branch

	ldr	r0, =strS1store		@points to s1 string

	ldr 	r0,=crCr		@load into r0 address of crCr	

	ldr	r8, =strEWarg		@points to strEWarg "in the hat."
	ldr	r3, [r8]		@r3 = "in the hat."

	bl	String_endsWith		@branch to String_endsWith EXTERNAL function
	
	cmp	r0,#0			@compare r0 to 0

	beq	print_FALSE_EW		@branch to print_FALSE if r0 =0

	cmp	r0,#1			@compare r0 to 0

	beq	print_TRUE_EW		@branch to print_TRUE if r0 = 1

print_FALSE_EW:

	ldr	r0, =strFalse		@r0 points to strFalse
	bl	putstring		@prints FALSE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equals_EW	@branch to the end

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'

print_TRUE_EW:

	ldr	r0, =strTrue		@r0 points to strTrue
	bl	putstring		@prints TRUE

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage
	b	end_str_equals_EW	@branch to the end

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'

end_str_equals_EW:

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'


@-========================================FUNCTION 13 indexOf_1 ==================================================================

	ldr 	r0,=crCr		@load into r0 address of crCr	
	bl	putch			@call putch (external fn) to print the character 'carriage'
	
	ldr	r0, =strEx13		@ load into r0 the address of strEx13
	bl	putstring		@ output strEx13

	ldr	r0, =strS2store		@ load into r0 the address of s2 string
	mov	r1, #'g'		@ move an ascii 'g' into r1

	bl	String_indexOf_1	@ call String_indexOf_1 external fn

	ldr	r1, =strTemp		@ load into r1 the address of strTemp
	bl	intasc32		@ call intasc32 external fn

	ldr	r0, =strTemp		@ load into r0 the address of strTemp
	bl	putstring		@ output strTemp

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

@-========================================FUNCTION 14 indexOf_2 ==================================================================

	ldr	r0, =strEx14		@ load into r0 the address of strEx14
	bl	putstring		@ output strEx14

	ldr	r0, =strS2store		@ load into r0 the address of s2 string
	mov	r1, #'g'		@ move an ascii 'g' into r1
	mov	r2, #9			@ move an int 9 into r2

	bl	String_indexOf_2	@ call String_indexOf_2 external fn

	ldr	r1, =strTemp		@ load into r1 the address of strTemp
	bl	intasc32		@ call intasc32 external fn

	ldr	r0, =strTemp		@ load into r0 the address of strTemp
	bl	putstring		@ output strTemp

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'


@-========================================FUNCTION 15 indexOf_3 ==================================================================

	ldr	r0, =strEx15		@ load into r0 the address of strEx15
	bl	putstring		@ output strEx15

	ldr	r0, =strS2store		@ load into r0 the address of s2 string
	ldr	r1, =strEggs		@ load into r1 the address of strEggs (substring "eggs")

	bl	String_indexOf_3	@ call String_indexOf_3 external fn

	ldr	r1, =strTemp		@ load into r1 the address of strTemp
	bl	intasc32		@ call intasc32 external fn

	ldr	r0, =strTemp		@ load into r0 the address of strTemp
	bl	putstring		@ output strTemp

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'


@-========================================FUNCTION 16 lastIndexOf_1 ==================================================================

	ldr	r0, =strEx16		@ load into r0 the address of strEx16
	bl	putstring		@ output strEx16

	ldr	r0, =strS2store		@ load into r0 the address of s2 string
	mov	r1, #'g'		@ move an ascii 'g' into r1

	bl	String_lastIndexOf_1	@ call String_lastIndexOf_1 external fn

	ldr	r1, =strTemp		@ load into r1 the address of strTemp
	bl	intasc32		@ call intasc32 external fn

	ldr	r0, =strTemp		@ load into r0 the address of strTemp
	bl	putstring		@ output strTemp

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'


@-========================================FUNCTION 17 lastIndexOf_2 ==================================================================

	ldr	r0, =strEx17		@ load into r0 the address of strEx17
	bl	putstring		@ output strEx17

	ldr	r0, =strS2store		@ load into r0 the address of s2 string
	mov	r1, #'g'		@ move an ascii 'g' into r1
	mov	r2, #6			@ move an int 6 into r2

	bl	String_lastIndexOf_2	@ call String_lastIndexOf_2 external fn

	ldr	r1, =strTemp		@ load into r1 the address of strTemp
	bl	intasc32		@ call intasc32 external fn

	ldr	r0, =strTemp		@ load into r0 the address of strTemp
	bl	putstring		@ output strTemp

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'


@-========================================FUNCTION 18 lastIndexOf_3 ==================================================================

	ldr	r0, =strEx18		@ load into r0 the address of strEx18
	bl	putstring		@ output strEx15

	ldr	r0, =strS2store		@ load into r0 the address of s2 string
	ldr	r1, =strEgg		@ load into r1 the address of strEgg (substring "egg")

	bl	String_lastIndexOf_3	@ call String_lastIndexOf_3 external fn

	ldr	r1, =strTemp		@ load into r1 the address of strTemp
	bl	intasc32		@ call intasc32 external fn

	ldr	r0, =strTemp		@ load into r0 the address of strTemp
	bl	putstring		@ output strTemp

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'


@-========================================FUNCTION 19 replace ==================================================================

	ldr	r0, =strEx19		@ load into r0 the address of strEx19
	bl	putstring		@ output strEx19

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	mov	r0, r7			@ load into r0 the address of s1 string
	mov	r1, #'a'		@ move an ascii 'a' into r1
	mov	r2, #'o'		@ move an ascii 'o' into r2

	bl	String_replace		@ call String_replace external fn

	bl	putstring		@ output r0

	mov	r3, r0			@ copy the new string's address into r3

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

@-========================================FUNCTION 20 toLowerCase ==================================================================

	ldr	r0, =strEx20		@ load into r0 the address of strEx20
	bl	putstring		@ output strEx20

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	mov	r0, r3			@ copy the string from String_replace into r0

	bl	String_toLowerCase	@ call String_toLowerCase external fn

	bl	putstring		@ output r0

	mov	r3, r0			@ copy the new string's address into r3

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

@-========================================FUNCTION 21 toUpperCase ==================================================================

	ldr	r0, =strEx21		@ load into r0 the address of strEx21
	bl	putstring		@ output strEx21

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	mov	r0, r3			@ copy the string from String_toLowerCase into r0

	bl	String_toUpperCase	@ call String_toUpperCase external fn

	bl	putstring		@ output r0

	mov	r3, r0			@ copy the new string into r3

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

@-========================================FUNCTION 22 concat ==================================================================

	ldr	r0, =strEx22		@ load into r0 the address of strEx21
	bl	putstring		@ output strEx22

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	mov	r0, r3			@ copy the string from String_toUpperCase into r0
	ldr	r1, =strSpc		@ load into r2 the value of strSpc

	bl	String_concat		@ call String_concat external fn

	ldr	r1, =strS2store		@ load into r1 the address of s2

	bl	String_concat		@ call String_concat external fn

	bl	putstring		@ output r0

	ldr	r0, =crDQuote		@ load into r0 the address of crDQuote
	bl	putch			@ output "

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

	ldr	r0, =crCr		@ load into r0 the address of crCr
	bl	putch			@ call putch (external fn) to print the character 'carriage return'

@------------------terminating program--------------------------------------------------------------------
	
	mov 	r0, #0			@set program Exit status code to 0
	mov	r7, #1			@service command code of 1 to terminate program
	
	svc 0				@Perform service call to linux
	.end
