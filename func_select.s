#Tomer Shlasky 204300602
    .data
    .section    .rodata
oper:           .string "%hhd"
pstr:           .string "%s"
size:           .string "%hhd"
scanf_51:	.string	" %c %c"
scanf_52_54:	.string	" %d %d"

formatInt:
	.string	"%d" #int format for printf and scanf
formatString:
	.string	"%s" #string format for printf and scanf
str_invalid:
	.string	"invalid option!\n"
str_replace:
	.string    "old char: %c, new char: %c, first string: %s, second string: %s\n"
str_pstring:
	.string    "length: %d, string: %s\n"
str_cmp:
	.string	"compare result: %d\n"
str_inval_input:
	.string	"invalid input!\n"
str_len:
	.string	"first pstring length: %d, second pstring length: %d\n"
str_scanf:
	.string	"%d"
  .align 8  # Align address to multiple of 8
.cases:
  .quad     .L50                    # Case 50
  .quad     .L51                    # Case 51
  .quad     .L52                    # Case 52
  .quad     .L53                    # Case 53
  .quad     .L54                    # Case 54
  .quad     .default                # default
  

    .text
  
/**
    	run_func is dealing with 5 cases, 50-54. Every case do different thing on pstrings.
    	The case depends on choice value.    
	Arguments: %rdi = choice by int
              	   %rsi = address of pstring1
                   %rdx = address of pstring2
**/

# choise in %rdi, pstring1 %rsi, pstring2 in %rdx
.global	run_func
	.type	run_func, @function
run_func:
    pushq   %rbp		          # save the old frame pointer
    movq	  %rsp,   %rbp	          # create the new frame pointer
    
    # Set up the jump table access
    leaq    -50(%rdi),%r11          # Compute choise = x-50
    cmpq    $4,      %r11           # Compare choise:6
    jg      .default                # if choise>4, goto default-case
    cmpq    $0,      %r11           # Compare choise:6
    jl      .default                # if choise<0, goto default-case
    jmp     *.cases(  ,%r11,8)      # goto cases[xi]
 
.L50:                               # Case 50 
    call    printLength             # print the length of 2 pstrings
    jmp     .done                   # goto done
    
.L51:                               # Case 51 
    # choise in %rdi, pstring1 %rsi, pstring2 in %rdx
    
# increase stack-
    subq     $2, %rsp	            # place two byte - for the old and new chars
    pushq    %rdx                    # place pointer to pstring 2
    pushq    %rsi                    # place pointer to pstring 1
    
# get 2 chars from the user
    movq	   $scanf_51,   %rdi	     # get ready to scanf- rdi =" %c %c"
    leaq	   16(%rsp), %rsi	     # get ready to scanf- rsi = address of old char
    leaq	   17(%rsp), %rdx	     # get ready to scanf- rsx = address of new char
    movq	   $0,       %rax             # get ready to scanf- rax = 0
    call	   scanf
    
# replace chars in p1 - pointer to string in %rdi, old char in %rsi, new char in %rdx    
    popq    %rdi		             # get ready to repalceChar- rdi = pstring1 pointer
    movq    %rdi,   %r12              # save pstring1 pointer for printf
    movq	   8(%rsp), %rsi		     # get ready to repalceChar - rsi =the old char
    movzbq  %sil,   %rsi
    movq	   9(%rsp), %rdx		     # get ready to repalceChar - rdx =the new char
    movzbq  %dl,    %rdx
    call	repalceChar
    
# replace chars in p2 - pointer to string in %rdi, old char in %rsi, new char in %rdx
    popq    %rdi		             # get ready to repalceChar- rdi = pstring1 pointer
    movq    %rdi,   %r14              # save pstring2 pointer for printf
    movq	   (%rsp), %rsi		     # get ready to repalceChar - rsi =the old char(stack)
    movzbq  %sil,   %rsi
    movq	   1(%rsp), %rdx		     # get ready to repalceChar - rdx =the new char(stack)
    movzbq  %dl,    %rdx
    call	repalceChar
    
# get ready to print and print
    movq	   (%rsp),  %rsi               # get ready to printf- old char in rsi
    movzbq  %sil,   %rsi
    leaq	   1(%rsp), %rdx               # get ready to printf- new char in rdx
    movq	   (%rdx),  %rdx               
    movzbq  %dl,    %rdx
    movq	   $str_replace, %rdi       # get ready to printf- string of print in rdi
    addq	   $1,     %r12		   # increase pstring1 by 1 (because of the length) 
    movq   %r12,   %rcx             # get ready to printf- new string1 inr rcx 
    addq	   $1,     %r14		   # increase pstring2 by 1 (because of the length)
    movq	   %r14,   %r8              # get ready to printf- new string1 inr r8
    movq   $0,      %rax            # get ready to printf- 0 in rax
    # print "old char: %c, new char: %c, first string: %s, second string: %s"
    call	   printf                      
    movq	   $0,     %rax             # after printf- 0 in rax
    addq   $2,     %rsp		   # decrease stack by two byte - for the chars
    
    jmp     .done                   # goto done
    
    
.L52:                               # Case 52 

# increase stack-
    subq     $8, %rsp	            # place 8 byte - for the 2 index- i & j
    pushq    %rdx                    # place pointer to pstring 2
    pushq    %rsi                    # place pointer to pstring 1
    
# get 2 ints from the user
    movq	   $scanf_52_54,   %rdi	     # get ready to scanf- rdi =" %c %c"
    leaq	   16(%rsp), %rsi	     # get ready to scanf- rsi = address of i
    leaq	   20(%rsp), %rdx	     # get ready to scanf- rsx = address of j
    movq	   $0,       %rax             # get ready to scanf- rax = 0
    call	   scanf
    
# pointer to dst in %rdi, pointer to src in %rsi, index i in %rdx, index j in %rcx
    popq    %rdi		             # get ready to ‫‪pstrijcpy‬‬- rdi = pstring1 pointer
    movq    %rdi,   %r12              # save pstring1 pointer for printf
    popq    %rsi                      # get ready to ‫‪pstrijcpy‬‬- rsi = pstring2 pointer
    movq    %rsi,   %r14              # save pstring2 pointer for printf
    movl	   (%rsp), %edx		     # get ready to ‫‪pstrijcpy‬‬ - rdx = i
    movl	   4(%rsp), %ecx		     # get ready to ‫‪pstrijcpy‬‬ - rcx = j
    call    ‫‪pstrijcpy‬‬
        
# get ready to print dst
    movq	   $str_pstring, %rdi       # get ready to printf- string of print in rdi
    movq	   (%rax),  %rsi               # get ready to printf- dst length in rsi
    movzbq  %sil,   %rsi
    addq	   $1,     %rax		   # increase pstring1 by 1 (because of the length) 
    movq   %rax,   %rdx             # get ready to printf- new string1 inr rcx 
    movq   $0,      %rax            # get ready to printf- 0 in rax
    call	   printf                      
# get ready to print src
    movq	   $str_pstring, %rdi       # get ready to printf- string of print in rdi
    movq	   (%r14),  %rsi               # get ready to printf- dst length in rsi
    movzbq  %sil,   %rsi
    addq	   $1,     %r14		   # increase pstring1 by 1 (because of the length) 
    movq   %r14,   %rdx             # get ready to printf- new string1 inr rcx 
    movq   $0,      %rax            # get ready to printf- 0 in rax
    call	   printf      

# finish
    movq	   $0,     %rax             # after printf- 0 in rax
    addq   $8,     %rsp		   # decrease stack by two byte - for the chars
    jmp     .done                   # goto done
    
.L53:                               # Case 53 
    pushq   %rdx                    # save pstring 2 in the stack
# replace in pstring 1   
    movq    %rsi,   %rdi            # move pointer to pstring to %rdi
    call    swapCase                # call swapCase- new sting in %rax
    
# get ready to print new pstring 1
    movq	   $str_pstring, %rdi       # get ready to printf- string of print in rdi
    movq	   (%rax),  %rsi            # get ready to printf- dst length in rsi
    movzbq  %sil,   %rsi
    addq	   $1,     %rax		   # increase pstring1 by 1 (because of the length) 
    movq   %rax,   %rdx             # get ready to printf- new string1 inr rcx 
    movq   $0,      %rax            # get ready to printf- 0 in rax
    call	   printf    
      
# replace in pstring 2   
    popq    %rdi                    # pstring 2 in rdi
    call    swapCase                # call swapCase- new sting in %rax

# get ready to print new pstring 1
    movq	   $str_pstring, %rdi       # get ready to printf- string of print in rdi
    movq	   (%rax),  %rsi            # get ready to printf- dst length in rsi
    movzbq  %sil,   %rsi
    addq	   $1,     %rax		   # increase pstring1 by 1 (because of the length) 
    movq   %rax,   %rdx             # get ready to printf- new string1 inr rcx 
    movq   $0,      %rax            # get ready to printf- 0 in rax
    call	   printf
    
    jmp    .done                    # goto done
     
     
.L54:                               # Case 54 
    
# increase stack-
    subq     $8, %rsp	            # place 8 byte - for the 2 index- i & j
    pushq    %rdx                    # place pointer to pstring 2
    pushq    %rsi                    # place pointer to pstring 1
    
# get 2 ints from the user
    movq	   $scanf_52_54,   %rdi	     # get ready to scanf- rdi =" %c %c"
    leaq	   16(%rsp), %rsi	     # get ready to scanf- rsi = address of i
    leaq	   20(%rsp), %rdx	     # get ready to scanf- rsx = address of j
    movq	   $0,       %rax             # get ready to scanf- rax = 0
    call	   scanf
    
# pointer to dst in %rdi, pointer to src in %rsi, index i in %rdx, index j in %rcx
    popq    %rdi		             # get ready to ‫‪pstrijcpy‬‬- rdi = pstring1 pointer
    movq    %rdi,   %r12              # save pstring1 pointer for printf
    popq    %rsi                      # get ready to ‫‪pstrijcpy‬‬- rsi = pstring2 pointer
    movq    %rsi,   %r14              # save pstring2 pointer for printf
    movl	   (%rsp), %edx		     # get ready to ‫‪pstrijcpy‬‬ - rdx = i
    movl	   4(%rsp), %ecx		     # get ready to ‫‪pstrijcpy‬‬ - rcx = j
    call    pstrijcmp
        
# get ready to print compare result
    movq	   $str_cmp, %rdi       # get ready to printf- string of print in rdi
    xorq    %rsi,   %rsi            #rsi=0
    movq	   %rax,  %rsi               # get ready to printf- compare result in rsi
    movq   $0,      %rax            # get ready to printf- 0 in rax
    call	   printf                      
    movq   $0,      %rax            # get ready to printf- 0 in rax

# finish
    movq	   $0,     %rax             # after printf- 0 in rax
    addq   $8,     %rsp		   # decrease stack by two byte - for the chars
    
    
    jmp     .done                   # goto done

.default:
    movq    $0,     %rax            # put 0 in rax before printf
    movq    $str_invalid,   %rdi    # put ‪"invalid ‫option" in rdi
    call    printf                  # print error and continue to done
    movq    $0,     %rax            # clear %rax before printf
    
.done:
    movq	  %rbp,   %rsp	      # restore the old stack pointer - release all used memory.
    popq    %rbp		      # restore old frame pointer (the caller function frame)
    ret			      # return to caller function (OS)
    