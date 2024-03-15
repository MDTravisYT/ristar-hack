;	TO ADD CODE:	4E F9 (ADDRESS LONGWORD)

align    macro
    cnop 0,\1
    endm

		incbin     "ristar.j - Copy.bin"	;	Include hex edited Ristar ROM
											;		to jump to custom code
											
;	============================================================================!
		align		$200000				 ;	SHC SPLASH							!
;	============================================================================!
											
CustomGameMode:				             ;	
		jsr	SHC				             ;	Play SHC screen
		move.w	#0,	$FFEA00				 ;	Move 0 to game mode RAM (i moved the level mode here)
		jmp	$789E				           ;	Jump to level code
											
SHC:	incbin	"SHC_Advanced.bin"          ;	SHC screen include

;	============================================================================!
		align		$210000				 ;	CHUNK LOADING						!
;	============================================================================!        

ChunkPointers	=	$163716
stardec	=	$4C3E
nemdec			=	$49A8
nemdec_vram		=	$4996

sub_87EA:				               ; CODE XREF: sub_7B32+492↑p

		;		move.b  $FFE500,d0		;	level art
		;		jsr     $13B06
				
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
				lea		ArtMZ,	a0
				move.l  #$64000000,($C00004).l
				jsr     (nemdec_vram).l
				move.b  $FFE500,d0		;	level display?
				jsr     sub_13A68
				jmp     $13A2E
; End of function sub_87EA


; =============== S U B R O U T I N E =======================================


sub_8852:				               ; CODE XREF: sub_7B32+104↑p
				move.b  $FFE500,d0
				jsr     $13A98
				move.b  $FFE500,d0
				jsr     $13CC4
				move.b  $FFE500,d0

				lea     ($1853B0).l,a1
loc_886A:				               ; CODE XREF: sub_EEA6+CC↓p
				moveq   #0,d0
				move.b  $FFE500,d0
				add.w   d0,d0
				add.w   d0,d0
				movea.l (a1,d0.w),a0
				lea     ($FF4000).l,a1
				jsr     (stardec).l
				lea     ($FF4000).l,a0
				lea     ($FFAA00).l,a1
				move.w  #$FF,d7

loc_889A:				               ; CODE XREF: sub_8852+4A↓j
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
				
;	============================================================================!
		align		$212000				 ;	BLOCK LOADING						!
;	============================================================================!
		
BlockPointers	=	$11C764

sub_13A68:				              ; CODE XREF: sub_87EA+4↑p
				moveq   #0,d0
				move.b  $FFE500,d0
				lea     (BlockPointers).l,a0
				add.w   d0,d0
				add.w   d0,d0
				add.w   d0,d0
				move.w  4(a0,d0.w),d7
				movea.l (a0,d0.w),a0
				lea     $FF8008,a4
				tst.b   $FFE501
				bne.s   loc_13A90
				lea     $FF8000,a4

loc_13A90:				              ; CODE XREF: sub_13A68+22↑j
				move.w  #$120,d0
			;	bra.w   loc_13F9C
loc_13F9C:				              ; CODE XREF: sub_13A68+2C↑j
								        ; sub_13A98+3E↑j
				movem.l d0/d7-a1,-(sp)
				jsr     (nemdec).l
				movem.l (sp)+,d0/d7-a1

loc_13FAA:				              ; CODE XREF: sub_13A68+548↓j
				move.w  (a4),d1
				add.w   d0,d1
				move.w  d1,(a4)+
				dbf     d7,loc_13FAA
				rts
				
;	============================================================================!
		align		$220000				 ;	CHUNK DATA							!
;	============================================================================!  
		
		incbin	"SonLVL/chunks.nem"
		
;	============================================================================!
		align		$228000				 ;	BLOCK DATA							!
;	============================================================================!  

		incbin	"SonLVL/blocks.nem"
ArtMZ:	incbin	"SonLVL/ArtMZ.bin"

;	============================================================================!
		align		$230000				 ;	LAYOUT DATA							!
;	============================================================================!  
		incbin	"SonLVL/map.bin"