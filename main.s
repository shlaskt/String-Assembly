# Tomer Shlasky 204300602
	.section	.rodata
    .data
    .section    .rodata
oper:           .string "%hhd"
pstr:           .string "%s"
size:           .string "%hhd"

formatInt:
	.string	"%d" #int format for printf and scanf
formatString:
	.string	"%s" #string format for printf and scanf
str_invalid:
	.string	 "invalid‬‬ ‫option!\n‬‬"
str_replace:
	.string    "old char: %c, new char: %c, first string: %s, second string: %s\n"
str_pstring:
	.string    "length: %d, string: %s\n"
str_cmp:
	.string	"compare result: %d\n"
str_inval_input:
	.string	"invalid‬‬ input!\n‬‬"
str_len:
	.string	"first pstring length: %d, second pstring length: %d\n"
str_scanf:
	.string	"%d"
	.text
/**
        In main there are several scanf calls:
        1. scanf pstring1 len
        2. scanf pstring1
        3. scanf pstring2 len
        4. scanf pstring2
        5. scanf user choice
        Pstrings save in struct with the len and string itself.
        Passing those arguments to run_func.
**/
	.globl	main 
	.type	main, @function #defenition of main function
main:
    movq    %rsp,   %rbp                # for correct debugging
    pushq   %rbp                        # set %rbp to be pointer of the beggining of main scope
    movq    %rsp,   %rbp                # %rbp = point to %rsp
    subq	   $536,   %rsp                # allocate 536 bytes for:
                                        # 3 ints - 8 bytes for etch address
                                        # 2 strings of 255 bytes etch, and 2 more for the '/0'
    xorl	   %eax,   %eax                 # set %eax to be 0
    leaq	   -536(%rbp), %rax             # the scanf value will set at the -536(%rbp) on stack
    movq	   %rax,   %rsi                 # %rsi = save pointer of the scanf value
    movl	   $formatInt, %edi             # %edi = save int format for scanf
    xor	    %eax,   %eax                # set %eax to be 0
    call	   scanf                        # scanf the first string length
    
    leaq	   -528(%rbp), %rax             # the scanf value will set at the -528(%rbp) on stack
    addq	   $1,     %rax                 # save one byte for '/0'
    movq    %rax,   %rsi                # %rsi = save pointer for the scanf value
    movl	   $formatString, %edi          # %edi = save string format for scanf
    xor	    %eax,   %eax                # set %eax to be 0
    call	   scanf                        # scanf the first string
    
    movl	   -536(%rbp), %eax 
    movb	   %al,    -528(%rbp)           # put the first string len in -528(%rbp)
    leaq	   -536(%rbp), %rax              
    movq	   %rax,   %rsi                 # %rsi = save pointer for the scanf value
    movl	   $formatInt,  %edi            # %edi = save int format for scanf
    xor	    %eax,   %eax                # set %eax to be 0
    call    scanf                       # scanf the second string length
    
    leaq	   -272(%rbp), %rax             # the scanf value will set at the -272(%rbp)
    addq	   $1,     %rax                 # save one byte for '/0'
    movq	   %rax,   %rsi                 # %rsi = save pointer for the scanf value
    movl	   $formatString, %edi          # %edi = save string format for scanf
    xor	    %eax,   %eax                # set %eax to be 0
    call	   scanf                        # scanf the second string
    
    movl	   -536(%rbp), %eax
    movb	   %al,    -272(%rbp)           # put the second string len in -272(%rbp)
    leaq	   -532(%rbp), %rax             # set %rax to be the address of -532(%rbp)
    movq	   %rax,   %rsi		       # %rsi = save pointer for the scanf value
    movl	   $formatInt, %edi             # %edi = save int format for scanf
    xor	    %eax,   %eax                # set %eax to be 0
    call	   scanf
    
    movl	   -532(%rbp), %eax             # set choice in %eax
    leaq	   -272(%rbp), %rdx             # save pstring2 pointer in %rdx and send to run_func as third argument
    leaq	   -528(%rbp), %rsi             # save pstring1 pointer in %rsi and send to run_func as second argument
    movl    %eax,   %edi                # save the user chioce in %edi and send in to run_func as first argument
    call	   run_func
    
    xor	    %eax,    %eax              # set %eax to be 0
    movq    %rbp,    %rsp              # set %rsp to point on the start of main stack
    popq    %rbp                       # pop %rbp
    ret
    