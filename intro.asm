;Should be run at around 15k cycles in dosbox
org 100h

push 0xa000
pop es

mov al,13h
int 10h

mov bp,1

mainloop:
frameloop:
mov ax,0xCCCD
mul di

;generate sun
mov al,dh
sub al,25
imul al
mov bx,ax

mov al,dl
sub al,40
imul al
add ax,bx
mov bx,sp
imul bx,bx
cmp ax,bx
jge bg_sky
mov al,14
jmp short short bg_sun

bg_sky:
mov al,0x20
bg_sun:
cmp dh, 50
jbe short fill
mov al,0x1

;generate wave animation
xor bx,bx
add bx,sp
add bx,16
mov [si],bx
fild word[si]
mov bl,dl
shr bx,3
mov [si],bx
fild word[si]
fsin
fmulp
fistp word[si]
mov bx,[si]
sub dh,bl
mov bx,sp
add dh,bl
cmp dh, 130
jbe short fill
mov al,43


fill:
stosb
loop frameloop

test sp,31
jnz short kbd
neg bp

kbd:
add sp,bp

;some music
mov ax, sp
add ax, 80
or al,0x4B
out 0x42,al
out 0x61,al

in al,60h
dec al
jnz short mainloop

ret
