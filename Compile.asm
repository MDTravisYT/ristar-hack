align    macro
    cnop 0,\1
    endm

		incbin     "ristar.j - Copy.bin"	;	Include hex edited Ristar ROM
											;		to jump to custom code
		align		$200000                 ;	Aligns to proper location
											
CustomGameMode:                             ;	
		jsr	SHC                             ;	Play SHC screen
		move.w	#0,	$FFEA00                 ;	Move 0 to game mode RAM (i moved the level mode here)
		jmp	$789E                           ;	Jump to level code
											
SHC:	incbin	"SHC_Advanced.bin"          ;	SHC screen include

		align		$210000        

ChunkPointers	=	$163716
stardecompress	=	$4C3E
nemdec			=	$49A8

sub_87EA:                               ; CODE XREF: sub_7B32+492↑p
				move.b  $FFE500,d0		;	level display?
				jsr     $13A68
				move.b  $FFE500,d0		;	level art
				jsr     $13B06
				move.b  $FFE500,d0		;	level palette
				jsr     $13D0E
				lea     (ChunkPointers).l,a1
				moveq   #0,d0
				move.b  $FFE500,d0
				add.w   d0,d0
				add.w   d0,d0
				movea.l (a1,d0.w),a0
				lea     $FF0000.l,a4
				jsr     (nemdec).l
				lea     ($188492).l,a1
				moveq   #0,d0
				move.b  $FFE500,d0
				add.w   d0,d0
				add.w   d0,d0
				movea.l (a1,d0.w),a1
				lea     $FFA400,a2
				jsr     $13DB6
				jsr     $13A0E
				jmp     $13A2E
; End of function sub_87EA


; =============== S U B R O U T I N E =======================================


sub_8852:                               ; CODE XREF: sub_7B32+104↑p
                move.b  $FFE500,d0
                jsr     $13A98
                move.b  $FFE500,d0
                jsr     $13CC4
                move.b  $FFE500,d0

                lea     ($1853B0).l,a1
loc_886A:                               ; CODE XREF: sub_EEA6+CC↓p
                moveq   #0,d0
                move.b  $FFE500,d0
                add.w   d0,d0
                add.w   d0,d0
                movea.l (a1,d0.w),a0
                lea     ($FF4000).l,a1
                jsr     (stardecompress).l
                lea     ($FF4000).l,a0
                lea     ($FFAA00).l,a1
                move.w  #$FF,d7

loc_889A:                               ; CODE XREF: sub_8852+4A↓j
                move.l  (a0)+,(a1)+
                dbf     d7,loc_889A
                lea     ($188552).l,a1
                moveq   #0,d0
                move.b  $FFE500,d0
                add.w   d0,d0
                add.w   d0,d0
                movea.l (a1,d0.w),a1
                lea     $FFA600,a2
                jsr     $13DB6
                rts
				
		align		$220000  
		
		incbin	"SonLVL/chunks.nem"