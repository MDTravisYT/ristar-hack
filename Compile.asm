;	TO ADD CODE:	4E F9 (ADDRESS LONGWORD)

align    macro
    cnop 0,\1
    endm


copyTilemap:	macro source,loc,width,height
		lea	(source).l,a1
		move.l	#$40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14),d0
		moveq	#width,d1
		moveq	#height,d2
		jsr		DrawTileMap
		endm

		incbin     "ristar.j - Copy.bin"	;	Include hex edited Ristar ROM
											;		to jump to custom code
											
;	============================================================================!
		align		$200000				 ;	SHC SPLASH							!
;	============================================================================!
											
CustomGameMode:				             ;	
		
;		jsr	SHC				             ;	Play SHC screen
	
		lea		VDPCTRL,	A6
	;	move.w	#$8000+%00000001,(A6)
		move.w	#$8100+%01010100,(A6)
		move.w	#$8200+(PLANE_A/$400),(A6)
		move.w	#$8400+(PLANE_B/$2000),(A6)
		move.l	#CRAMWRITE,	VDPCTRL
		move.w	#$0000,	VDPDATA
		move.w	#$00EE,	VDPDATA
		move.w	#$00CE,	VDPDATA
		move.w	#$008C,	VDPDATA
		move.w	#$0004,	VDPDATA
		
		lea		Font,	a0		;	load graphics
		move.l  #$40000000,($C00004).l
		jsr     (nemdec_vram).l
		
		lea	  (LoadMap).l,a0	;	map
		lea     $FF0000.l,a4
		jsr     (nemdec).l
		
		copyTilemap	$FF0000,$C620,9,3
		
		move.b	#$01,	$FFE00A
		
		moveq	#60-1,	d7
	;	move	#$2700,sr
		
	.vint:
	;	bsr.s	VSync
		dbf		d7,	.vint

		move.w	#0,	$FFEA00				 ;	Move 0 to game mode RAM (i moved the level mode here)
		jmp	$789E				           ;	Jump to level code
											
;SHC:	incbin	"SHC_Advanced.bin"          ;	SHC screen include

;****************************************************************************
; VSync
; Waits until the next frame
;****************************************************************************

VSync:
    lea     ($C00004),a6

@Loop1:                             ; Wait until current VBlank is over
    move.w    (a6),d7
    btst.l    #3,d7
    bne.s    @Loop1

@Loop2:                             ; Wait until next VBlank starts
    move.w    (a6),d7
    btst.l    #3,d7
    beq.s    @Loop2

    rts                             ; End of subroutine

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
				
				lea	  (Indexes).l,a0	;	collision indexes
				lea     $FFB000.l,a4
				jsr     (nemdec).l
				
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
Indexes:incbin	"SonLVL/index.nem"

;	============================================================================!
		align		$230000				 ;	LAYOUT DATA							!
;	============================================================================!  
		incbin	"SonLVL/map.bin"
		
;	============================================================================!
		align		$238000				 ;	MUSIC DATA							!
;	============================================================================!  

dkick	=	$81
dsnare	=	$87
dhitom	=	$82
dmidtom	=	$82
dlowtom	=	$82
		include		"_smps2asm_inc.asm"
		include		"Marble Zone Act 1.asm"
				
;	============================================================================!
		align		$300000				 ;	LOADING SCREEN						!
;	============================================================================! 

PLANE_A		=	$C000
PLANE_B		=	$E000
VDPDATA		=	$C00000
VDPCTRL		=	$C00004
CRAMWRITE:	=	$C0000000

LoadScreen:
				move.b  (a5)+,$11(a3)
				dbf     d5,LoadScreen
				move.w  d0,(a2)
				movem.l (a6),d0-d7/a0-a6
				move    #$2700,sr
				
		;		above is a chunk of the init routine, as it's jumped to in the middle of it
				
				lea		VDPCTRL,	A6
		;		move.w	#$8000+%00000001,(A6)
				move.w	#$8100+%01010100,(A6)
				move.w	#$8200+(PLANE_A/$400),(A6)
				move.w	#$8400+(PLANE_B/$2000),(A6)
		;		move.w	#$9000+%11111111,	(A6)
				
				move.l	#CRAMWRITE,	(A6)
				move.w	#$0000,	VDPDATA
				move.w	#$00EE,	VDPDATA
				move.w	#$00CE,	VDPDATA
				move.w	#$008C,	VDPDATA
				move.w	#$0004,	VDPDATA
				
				lea		Font,	a0		;	load graphics
				move.l  #$40000000,($C00004).l
				jsr     (nemdec_vram).l
				
				lea	  (LoadMap).l,a0	;	map
				lea     $FF0000.l,a4
				jsr     (nemdec).l
				
				copyTilemap	$FF0000,$C620,9,3
				
				jmp		$300	;	jump to checksum check
				
DrawTileMap:		;	SUBROUTINE
                lea     VDPDATA,a6
                move.l  #$800000,d4

.LoopRow:                           
                move.l  d0,4(a6)    ; VDPCTRL
                move.w  d1,d3

.LoopColumn: 
                move.w  (a1)+,(a6)
                dbf     d3,.LoopColumn
                add.l   d4,d0
                dbf     d2,.LoopRow
                rts

				
Font:		incbin	"Font.nem"
LoadMap:	incbin	"LoadMap.nem"