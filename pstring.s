# Tomer Shlasky 204300602
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
        .string	 "invalid input!\n"
str_len:
	.string	"first pstring length: %d, second pstring length: %d\n"
str_scanf:
	.string	"%d"

############################----pstrlen----###########################################
# return the length of a given pstrlen
# pstring in rdi
.global	pstrlen
	.type	pstrlen, @function
pstrlen:                            # return the pstring length- saved in the first byte
    movsbq  (%rdi), %rax            # move the value inside the first arg to rax 
    ret
    
############################----printLength----###########################################
# print the length of 2 given pstrings
# 50 in %rdi, pstring1 in %rsi, pstring2 in %rdx
.global	printLength
	.type	printLength, @function
printLength:
    pushq   %rbp		      # save the old frame pointer
    movq	  %rsp,   %rbp	      # create the new frame pointer

    pushq   %rdx                    # save rdx in the stack (caller saver)
    movq    %rsi,   %rdi            # move pstring1 to the first argument
    call    pstrlen                 # find the length of pstring1
    movq    %rax,   %r11            # move the length of pstring1 to r11
    
    popq    %rdi                    # move pstring2 to the first argument      
    call    pstrlen                 # find the length of pstring2
    
    movq    $str_len,%rdi           # prepare to printf- move string to rdi (1st arg) 
    movq    %r11,   %rsi            # prepare to printf- move p1 len to rsi (2nd arg) 
    movq    %rax,   %rdx            # prepare to printf- move p2 len to rdx (3rd arg) 
    movq    $0,     %rax            # clear %rax before printf
    call    printf                  # printf
    movq    $0,     %rax            # clear %rax before printf
    
    movq	  %rbp,   %rsp	      # restore the old stack pointer - release all used memory.
    popq    %rbp		      # restore old frame pointer (the caller function frame)
    ret			      # return to caller function (OS)

############################----repalceChar----###########################################
# replace a given old chars in a given new chars on a given pstring
# pointer to string in %rdi, old char to replace in %rsi, new char in %rdx
.global	repalceChar
	.type	repalceChar, @function
repalceChar:
    pushq   %rbp		      # save the old frame pointer
    movq    %rsp,    %rbp	      # create the new frame pointer
    
    movq    %rdi,    %rax           # save the pointer to the pstring1 in the return value
    leaq    1(%rdi), %rdi           # "i++"
    cmpb    $0,    (%rdi)          # check if string[i] == /0
    je      .endLoop1               # finish the loop - empty string
    
.loop1:
    cmpb    (%rdi), %sil            # check if string[i] == old char
    jne     .contiNoAssign1         # if it isn't- continue the loop without assign
    movb    %dl,   (%rdi)          # else- string[i] = new char
    
.contiNoAssign1:
    leaq    1(%rdi),%rdi            # "i++"
    cmpb    $0,    (%rdi)          # check if string[i] == /0
    jne     .loop1                  # continue the loop
    
.endLoop1:
    
    movq	  %rbp,    %rsp	      # restore the old stack pointer - release all used memory.
    popq    %rbp		      # restore old frame pointer (the caller function frame)
    ret	
    

############################----‫‪pstrijcpy‬‬----###########################################
# copy sub string from i to j from src (pstring) to dst (pstring)
# pointer to dst in %rdi, pointer to src in %rsi, index i in %rdx, index j in %rcx
.global	‫‪pstrijcpy‬‬
	.type	‫‪pstrijcpy‬‬, @function    
‫‪pstrijcpy‬‬:
    pushq   %rbp		            # save the old frame pointer
    movq    %rsp,	 %rbp	   # create the new frame pointer
    
    pushq   %rdi                    # save rdi (dst)
    cmpl    %edx,    %ecx           # if i > j, goto error
    jl      .error2
    cmpl    $0,      %edx           # if i < 0, goto error
    jl      .error2
    cmpb    (%rdi),   %cl          # if j >= dst.length, goto error
    jge     .error2
    cmpb    (%rsi),   %cl          # if j >= src.length, goto error
    jge     .error2
    jmp     .valid2                 # else - goto valid
    
.error2:                            # error:
    movq    $str_inval_input, %rdi  # put ‪"invalid input" in rdi
    movq    $0,     %rax            # put 0 in rax before printf
    call    printf                  # print error
    movq    $0,     %rax            # put 0 in rax
    popq    %rax                    # place dst (rdi) in rax
    jmp     .done2                  # goto done
    
.valid2:                            # valid:
    popq    %rdi                    # pop rdi from the stack
    movq    %rdi,   %rax            # save the pointer to dst in the return value
    leaq    1(%rdx, %rdi), %rdi     # dst += i (sizeof char=1) (1 for ignore len)
    leaq    1(%rdx, %rsi), %rsi     # src += i (sizeof char=1) (1 for ignore len)
    
.loop2:                             # loop:
    movb    (%rsi), %r11b           # temp = src[i]
    movb    %r11b,   (%rdi)         # dst[i] = temp
    incq    %rdi                    # dst[i]++
    incq    %rsi                    # src[i]++
    incl    %edx                    # i++
    cmpl    %ecx,   %edx            # while i <= j, goto loop
    jle     .loop2                  
    
.done2:                             # done
    movq    %rbp,   %rsp	      # restore the old stack pointer - release all used memory.
    popq	    %rbp		      # restore old frame pointer (the caller function frame)
    ret

############################----swapCase----###########################################
# swap every small letter to capital letter and every capital to small in a given pstring
# pointer to string in %rdi
.global	swapCase
	.type	swapCase, @function   
swapCase:
    pushq   %rbp		      # save the old frame pointer
    movq    %rsp,   %rbp	      # create the new frame pointer
    
    movq    %rdi,   %rax            # save the pointer to the pstring
    
    movb    $1,     %r11b            # i=1 (save i in r11)
    cmpl    %r11d,   (%rax)          # if i>pstr[0] (empety string), goto done
    jl      .done3
    incq    %rdi                    # pstr++ to go over the len(in the [0])
.loop3:                             # loop
    cmpb    $65,    (%rdi)          # if 65 <= pstr[i]
    jge     .con2                   # to check 65 <= pstr[i] <= 90 (capital)
    jmp     .mid                    # to check 97 <= pstr[i] <= 122 (small)
.con2:
    cmpb    $90,    (%rdi)          # if pstr[i] <= 90
    jle     .makeSmallLet           # goto makeSmallLet (make it small)
                                    # else... continue
    cmpb    $97,    (%rdi)          # if 97 <= pstr[i]
    jge      .con4                   # to check 97 <= pstr[i] <= 122 (small)
    jmp     .mid 
.con4:
    cmpb    $122,   (%rdi)          # if pstr[i] <= 122
    jle     .makeCapitalLet         # goto makeCapitalLet (make it capitl)
    jmp     .mid                    # continue to mid
.makeSmallLet:
    addb    $32,    (%rdi)          # pstr[i] += 32  
    jmp     .mid
.makeCapitalLet:
    subb    $32,    (%rdi)          # pstr[i] -= 32, continue to mid
.mid:                               # after coditions -> continue loop
    incl    %r11d                    # i++
    incq    %rdi                    # pstr++
    cmpl    $0,   (%rdi)          # while i<=pstr[0] (pstr.len), goto loop
    jne .loop3
.done3:
    movq	%rbp, %rsp	      # restore the old stack pointer - release all used memory.
    popq	%rbp		      # restore old frame pointer (the caller function frame)
    ret

############################----pstrijcmp----###########################################
# compare between 2 substrings from i to j (lexicografic) and return -1 (subp1 < subp2)
# 1 (subp1 > subp2) or 0 (subp1 = subp2)
# pointer to dst in %rdi, pointer to src in %rsi, index i in %rdx, index j in %rcx
.global	pstrijcmp
	.type	pstrijcmp, @function   
pstrijcmp:
    pushq   %rbp		          # save the old frame pointer
    movq    %rsp,	 %rbp	  # create the new frame pointer
    
    cmpl    %edx,    %ecx           # if i > j, goto error
    jl      .error4
    cmpl    $0,      %edx           # if i < 0, goto error
    jl      .error4
    cmpb    (%rdi),   %cl          # if j >= dst.length, goto error
    jge     .error4
    cmpb    (%rsi),   %cl          # if j >= src.length, goto error
    jge     .error4
    jmp     .valid4                 # else - goto valid
    
.error4:                            # error:
    movq    $0,     %rax            # put 0 in rax before printf
    movq    $str_inval_input, %rdi  # put ‪"invalid input" in rdi
    call    printf                  # print error
    movq    $0,     %rax            # put 0 in rax before printf
    xorq    %r8,    %r8             # r8 =0
    movq    $-2,    %r8            # put "-2" in the temp value
    movq    %r8,    %rax            # put "-2" in the return value
    jmp     .done4                  # goto done
    
.valid4:                            # valid:
    movq    $0,   %rax              # put 0 in the return value ("equals")
    leaq    1(%rdx, %rdi), %rdi     # dst += i (sizeof char=1) (1 for ignore len)
    leaq    1(%rdx, %rsi), %rsi     # src += i (sizeof char=1) (1 for ignore len)
    
.loop4:                             # loop:
    movq    (%rdi), %r11            # r11 = dst[i]
    cmpb    %r11b,   (%rsi)          # compare dst[i]:src[i]
    jl      .grater                 # if dst[i]>src[i], goto grater
    cmpb    %r11b,   (%rsi)          # compare dst[i]:src[i]
    jg      .smaller                # if dst[i]<src[i], goto smaller
    jmp     .equal                  # dst[i]=src[i], continue to the next char
.grater:
    movq    $1,     %rax            # put 1 in the return value
    jmp     .done4      
.smaller:
    movq    $-1,    %rax            # put -1 in the return value
    jmp     .done4  
.equal:
    incq    %rdi                    # dst[i]++
    incq    %rsi                    # src[i]++
    incq    %rdx                    # i++
    cmpl    %edx,   %ecx            # while i <= j, goto loop
    jge     .loop4                  

.done4:
    movq    %rbp,   %rsp	      # restore the old stack pointer - release all used memory.
    popq    %rbp		      # restore old frame pointer (the caller function frame)
    ret
    