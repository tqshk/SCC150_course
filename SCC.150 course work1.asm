.data 
           num:.word -10,6,0                               #memory holding a,b and result
           result_s: .asciiz "The result is : "              #output preamble
           error_s: .asciiz " Multiplication Error."          #error message

.text 
           j main            # jump over the following function
           
 multi: 
     addi $t1,$zero,0      # $t1 is result  ,= r
     lw $t2,0($a0)        # load 16 bit into $t2, = a
     lw $t3,4($a0)       # load 16 bit into $t3, = b
check:
       blt $t2,-0xffff,ck_er     #             less      
       blt $t3,-0xffff,ck_er
       bgt $t2,0xffff,ck_er      # if a($t2) larger than 16 bit
       bgt $t3,0xffff,ck_er      # if b($t3) larger than 16 bit
       # other load error
while:
     bne $t2,0,if    # while (a!=0) ------ $t2!=0;
     beq $t2,0,out   # out the loop while $t2 = 0;

if:                                # if a is odd   
      sll  $t4,$t2,31             
      bne $t4,0x80000000,loop     # if $t2 is not the odd jump to -loop- function           
odd:            
       addu  $t1,$t1,$t3          # r = r + b
loop:        
       srl $t2,$t2,1           # a = a / 2
       sll $t3,$t3,1          # b = b * 2
       j while
 
out: 
      addi $v0,$t1,0           # $v0 = result   
      add $a0,$zero,$v0       # print result
      addi $v0,$zero,1       # return 1 and print the integer__result
      syscall
      j end

ck_er:
     addi $v0,$zero,0     # return 0
     
     la $a0,error_s      # print the error_massages
     addi $v0,$zero,4    # print the string__massages    
     syscall
     j end
 main:         
           la $s0, num         # fetch address of num buffer
           la $a0, result_s
           addi $v0,$zero,4   # print the string__massages       
           syscall
next:
           add $a0,$zero,$s0   # fetch address of num buffer to $a0
           jal multi
           
end: nop
