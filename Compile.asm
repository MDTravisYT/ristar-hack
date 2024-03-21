;	TO ADD CODE:	4E F9 (ADDRESS LONGWORD)

		include		"Constants.asm"
		include		"Macros.asm"

		incbin     "ristar.j - Copy.bin"	;	Include hex edited Ristar ROM
											;		to jump to custom code
;	============================================================================!
		align		$200000				 ;	SPLASH								!
;	============================================================================!
											
		include		"Splash Screen.asm"

;	============================================================================!
		align		$210000				 ;	CHUNK LOADING						!
;	============================================================================!        

		include		"Injection 000087EA - Chunk Loading.asm"
				
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