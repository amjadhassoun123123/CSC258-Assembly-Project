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
	PlatformCurrent:  .word   0x10008C04, 0x10008898, 0x100084C8, 0x10008198  #Platform cords
	DoddleLocation: .word 	  0x10008B84
	Music: .word 40, 55, 100, 10, 110, 20, 45, 37, 38, 11, 40
.text
	lw $t0, displayAddress	# $t0 stores the base address for display
	li $t1, 0x00FFFFFF	# $t1 stores the red colour code
	li $t2, 0x00ff00	# $t2 stores the green colour code
	lw $t3 DoddleLocation
	li $s4 0x0000ff	# $t4 stores the blue colour code
	li $t6 0x10009000 	# screen size
	la $t7 PlatformCurrent	#loading initial array
	lw $t4 0($t7)
	add $t5 $t4 36
	lw $t9 0xffff0000 	#get keystroke input
	beq $t9, 1, GetKeyPressed	#make sure a key was clicked'
	
InitialStart:
	lw $t0, displayAddress
	
	jal DrawScreen
	add $sp $sp -4
	sw $t4 ($sp)	#Pushing location
	li $t2, 0x00ff00
	jal DrawPlatform

	lw $t4 4($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00ff00
	jal DrawPlatform
	
	lw $t4 8($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00ff00
	jal DrawPlatform
	
	lw $t4 12($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00FFFF00
	jal DrawPlatform
	
	add $sp $sp -4
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $s4 ($sp) #Pushing colour
	jal DrawDoodle
	
	li $t8 0
	jal BounceDown
	
	j InitialStart


StartBounceUp:
	lw $t0, displayAddress #screen initial
	li $t1 0
	add $t1 $t3 -1408  #where doddle would be if he jump
	ble $t1 $t0 MovePlatforms 
	j BounceUp
	
MakeMusic:
	li $a1 100
	li $a0 60
	li $a3 100
	li $v0 31
	
	la $s1 Music
	beq $t8 0 Music1
	beq $t8 1 Music2
	beq $t8 2 Music3
	beq $t8 3 Music4
	beq $t8 4 Music5
	beq $t8 5 Music6
	beq $t8 6 Music7
	beq $t8 7 Music8
	beq $t8 8 Music9
	beq $t8 9 Music10
	jr $ra

Music1:
	li $a0 30
	la $a2 ($s1)
	syscall
	li $a0 50
	la $a2 ($s1)
	syscall
	li $a0 12
	la $a2 ($s1)
	syscall
	jr $ra
	
Music2:
	li $a0 40
	la $a2 4($s1)
	syscall
	jr $ra

Music3:
	li $a0 70
	la $a2 8($s1)
	syscall
	jr $ra
	
Music4:
	li $a0 55
	la $a2 12($s1)
	syscall
	jr $ra

Music5:
	li $a0 10
	la $a2 16($s1)
	syscall
	jr $ra
Music6:
	li $a0 72
	la $a2 20($s1)
	syscall
	jr $ra

Music7:
	li $a0 12
	la $a2 24($s1)
	syscall
	jr $ra
Music8:
	la $a2 28($s1)
	syscall
	jr $ra

Music9:
	la $a2 32($s1)
	syscall
	jr $ra
Music10:
	la $a2 36($s1)
	syscall
	jr $ra

	
	
MovePlatforms:
	jal DrawScreen
	
	add $sp $sp -4
	add $t3 $t3 1024
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $s4 ($sp) #Pushing colour
	jal DrawDoodle
	
	
	lw $t4 ($t7)
	add $t4 $t4 1024
	jal CheckBellow #Cheeck below, if yes update its location

	sw $t4 ($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00ff00
	jal DrawPlatform
	

	lw $t4 4($t7)
	add $t4 $t4 1024
	jal CheckBellow #Cheeck below, if yes update its location
	
	
	sw $t4 4($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00ff00
	jal DrawPlatform
	
	
	lw $t4 8($t7)
	add $t4 $t4 1024
	jal CheckBellow #Cheeck below, if yes update its location
	
	
	sw $t4 8($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00ff00
	jal DrawPlatform
	
	
	lw $t4 12($t7)
	add $t4 $t4 1024
	sub $t4 $t4 24
	
	jal CheckBellow #Cheeck below, if yes update its location
	
	
	sw $t4 12($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00FFFF00
	jal DrawPlatform
	
	j BounceUp


CheckBellow:
	li $t6 0x10009000 #screen size
	bgt $t4 $t6 ResetPlatform #if its greater, reset it otherwise continue
	jr $ra
	
ResetPlatform:
	sub $t4 $t4 3072
	sw $t4 0($sp)	#Pushing location
	jr $ra

BounceUp:
	jal MakeMusic
	li $t1 1
	li $s1 1
	jal VerifyPress
	beq $t8 10 BounceDown
	lw $t0, displayAddress

	li $a0 100
	li $v0 32 #Make Delay
	syscall
	
	add $t3 $t3 -128
	
	add $sp $sp -4
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $s4 ($sp) #Pushing colour
	
	jal DrawScreen
	
	lw $t4 ($t7)
	add $sp $sp -4
	sw $t4 ($sp)	#Pushing location
	li $t2, 0x00ff00
	jal DrawPlatform

	lw $t4 4($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00ff00
	jal DrawPlatform
	
	lw $t4 8($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00ff00
	jal DrawPlatform
	
	lw $t4 12($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00FFFF00
	jal DrawPlatform
	
	add $sp $sp -4
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $s4 ($sp) #Pushing colour

	jal DrawDoodle
	add $t8 $t8 1
	j BounceUp
	

BounceDown:
	jal MakeMusic
	li $t1 0
	li $s1 0
	jal VerifyPress
	li $t8 0
	lw $t0, displayAddress
	
	li $a0 100
	li $v0 32 #Make Delay
	syscall
	
	add $t3 $t3 128
	
	add $sp $sp -4
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $s4 ($sp) #Pushing colour
	jal DrawScreen
	
	lw $t4 ($t7)
	add $sp $sp -4
	sw $t4 ($sp)	#Pushing location
	li $t2, 0x00ff00
	jal DrawPlatform

	lw $t4 4($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00ff00
	jal DrawPlatform
	
	lw $t4 8($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	jal DrawPlatform
	
	lw $t4 12($t7)
	add $t5 $t4 36
	add $sp $sp -4
	sw $t4 ($sp)
	li $t2, 0x00FFFF00
	jal DrawPlatform
	
	add $sp $sp -4
	sw $t3 ($sp) #Pushing Doodle
	add $sp $sp -4
	sw $s4 ($sp) #Pushing colour
	
	jal DrawDoodle
	jal VerifyLocation
	j BounceDown

VerifyLocation:
	bgt $t3 $t6 DrawLoss
	j VerifyPlatform
	
VerifyPlatform:
	lw $t4 0($t7) #Start of platform 1
	li $s3 36
	add $s3 $s3 $t4 #End of platform 1
	li $t5 0
	add $t5 $t3 8 #right side of my doodle
	blt $t5 $t4 VerifyP2  #goto platform 2 if its smaller of if its equal
	ble $t3 $s3 StartBounceUp


VerifyP2:
	lw $t4 4($t7) #Start of platform 1
	li $s3 36
	add $s3 $s3 $t4 #End of platform 1
	li $t5 0
	add $t5 $t3 8 #right side of my doodle
	blt $t5 $t4 VerifyP3  #goto platform 2 if its smaller of if its equal
	ble $t3 $s3 StartBounceUp


VerifyP3:
	lw $t4 8($t7) #Start of platform 1
	li $s3 36
	add $s3 $s3 $t4 #End of platform 1
	li $t5 0
	add $t5 $t3 8 #right side of my doodle
	blt $t5 $t4 VerifyP4  #goto platform 2 if its smaller of if its equal
	ble $t3 $s3 StartBounceUp

VerifyP4:
	lw $t4 12($t7) #Start of platform 1
	li $s3 36
	add $s3 $s3 $t4 #End of platform 1
	li $t5 0
	add $t5 $t3 8 #right side of my doodle
	blt $t5 $t4 BounceDown  #goto platform 2 if its smaller of if its equal
	ble $t3 $s3 StartBounceUp
	j BounceDown
	
VerifyPress:
	lw $t9 0xffff0000 	#get keystroke input
	beq $t9, 1, GetKeyPressed	#make sure a key was clicked'
	jr $ra

GetKeyPressed:
	lw $a0 0xffff0004	#load that key value
	beq $a0 'j', MoveDoodleLeft
	beq $a0 'k', MoveDoodleRight
	j VerifyPress
	
MoveDoodleRight:
	add $sp $sp -4
	add $t3 $t3 24
	beq $s1 0 BounceDown
	b BounceUp

MoveDoodleLeft:
	
	add $sp $sp -4
	sub $t3 $t3 24

	beq $s1 0 BounceDown
	b BounceUp
	

DrawScreen: #Draw entire screen red
	li $t1, 0x00FFFFFF
	bge  $t0 $t6, Return
	sw $t1, 0($t0)	 # paint unit red. 
	addi $t0 $t0, 4
	
	j DrawScreen
	
DrawPlatform:
	lw $s1 ($sp)
	addi $sp $sp 4
	addi $s2 $s1 36
	
	
reDraw:	
	bge $s1, $s2, Return
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
	
	
DrawLoss:
	lw $t0, displayAddress
	jal DrawScreen
	li $s1 0x10008738
	li $s2 0x00ff00
	sw $s2, ($s1)
	add $s1 $s1 128
	sw $s2, ($s1)
	add $s1 $s1 128
	sw $s2, ($s1)
	add $s1 $s1 128
	sw $s2, ($s1)
	add $s1 $s1 128
	sw $s2, ($s1)
	add $s1 $s1 128
	sw $s2, ($s1)
	add $s1 $s1 128
	sw $s2, ($s1)
	add $s1 $s1 128
	sw $s2, ($s1)
	add $s1 $s1 4
	sw $s2, ($s1)
	add $s1 $s1 4
	sw $s2, ($s1)
	add $s1 $s1 4
	sw $s2, ($s1)
	add $s1 $s1 4
	sw $s2, ($s1)
	li $v0 10 #End Game
	syscall
