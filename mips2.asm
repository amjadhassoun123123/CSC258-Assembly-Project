# Demo for painting
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8					     
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
.data
	displayAddress:	.word	0x10008000
	PlatformCurrent:  .word   0x10008908, 0x10008728, 0x10008448  #Platform cords
	DoddleLocation: .word 	  0x10008554
.text
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0xff0000	# $t1 stores the red colour code
	li $t2, 0x00ff00	# $t2 stores the green colour code
	lw $t3 DoddleLocation
	li $t4 0x0000ff	# $t4 stores the blue colour code
	li $t6 0x10009000 	# screen size
	la $t7 PlatformCurrent	#loading initial array
	lw $t4 0($t7)
	add $t5 $t4 20
InitialStart:
	lw $t0, displayAddress
	
	jal DrawScreen
	add $sp $sp -4
	sw $t4 ($sp)	#Pushing location
	jal DrawPlatform

	lw $t4 4($t7)
	add $t5 $t4 20
	add $sp $sp -4
	sw $t4 ($sp)
	jal DrawPlatform
	
	lw $t4 8($t7)
	add $t5 $t4 20
	add $sp $sp -4
	sw $t4 ($sp)
	jal DrawPlatform
	
	add $sp $sp -4
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $t4 ($sp) #Pushing colour
	jal DrawDoodle
	
	li $t8 0
	jal BounceUp
	
	j InitialStart
	
BounceUp:
	beq $t8 5 BounceDown
	lw $t0, displayAddress
	li $a0 250
	li $v0 32
	syscall
	add $t3 $t3 -128
	
	add $sp $sp -4
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $t4 ($sp) #Pushing colour
	
	jal DrawScreen
	
	lw $t4 ($t7)
	add $sp $sp -4
	sw $t4 ($sp)	#Pushing location
	jal DrawPlatform

	lw $t4 4($t7)
	add $t5 $t4 20
	add $sp $sp -4
	sw $t4 ($sp)
	jal DrawPlatform
	
	lw $t4 8($t7)
	add $t5 $t4 20
	add $sp $sp -4
	sw $t4 ($sp)
	jal DrawPlatform
	
	add $sp $sp -4
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $t4 ($sp) #Pushing colour
	jal DrawDoodle
	add $t8 $t8 1
	j BounceUp
	

BounceDown:
	li $t8 0
	lw $t0, displayAddress
	li $a0 250
	li $v0 32
	syscall
	add $t3 $t3 128
	
	add $sp $sp -4
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $t4 ($sp) #Pushing colour
	
	jal DrawScreen
	
	lw $t4 ($t7)
	add $sp $sp -4
	sw $t4 ($sp)	#Pushing location
	jal DrawPlatform

	lw $t4 4($t7)
	add $t5 $t4 20
	add $sp $sp -4
	sw $t4 ($sp)
	jal DrawPlatform
	
	lw $t4 8($t7)
	add $t5 $t4 20
	add $sp $sp -4
	sw $t4 ($sp)
	jal DrawPlatform
	
	add $sp $sp -4
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $t4 ($sp) #Pushing colour
	jal DrawDoodle
	jal VerifyLocation
	j BounceDown

VerifyLocation:
	bgt $t3 $t6 Exit
	j VerifyPlatform
	
VerifyPlatform:
	lw $t4 0($t7) #Start of platform 1
	li $s3 20
	add $s3 $s3 $t4 #End of platform 1
	blt $t3 $t4 VerifyP2 #goto platform 2 if its smaller of if its equal
	ble $t3 $s3 BounceUp
	
VerifyP2:
	lw $t4 4($t7) #Start of platform 2
	li $s3 20
	add $s3 $s3 $t4 #End of platform 2
	blt $t3 $t4 VerifyP3
	ble $t3 $s3 BounceUp
VerifyP3:
	lw $t4 8($t7) #Start of platform 2
	li $s3 20
	add $s3 $s3 $t4 #End of platform 2
	blt $t3 $t4 BounceDown
	ble $t3 $s3 BounceUp
	j BounceDown

DrawScreen: #Draw entire screen red
	bge  $t0 $t6, Return
	sw $t1, 0($t0)	 # paint unit red. 
	addi $t0 $t0, 4
	j DrawScreen
	
DrawPlatform:
	lw $s1 ($sp)
	addi $sp $sp 4
	addi $s2 $s1 20
	
reDraw:	bge $s1, $s2, Return
	sw $t2, 0($s1)
	addi $s1 $s1, 4
	j reDraw

Return:
	jr $ra
	
	
DrawDoodle:
	lw $s1 ($sp) #Get color
	lw $s2 4($sp) #Get Doodle
	addi $sp $sp 8
	sw $s1, ($s2)
	addi $s2 $s2 -124
	sw $s1, ($s2)
	addi $s2 $s2 132
	sw $s1, ($s2)
	jr $ra
Exit:
