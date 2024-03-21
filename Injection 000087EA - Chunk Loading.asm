sub_87EA:				               ; CODE XREF: sub_7B32+492↑p

				move.b  $FFE500,d0
				jsr     $13D0E			;	Load level palette
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
				
				lea		ArtMZ,	a0		;	Load art
				move.l  #$64000000,($C00004).l
				jsr     (nemdec_vram).l
				
				move.b  $FFE500,d0		;	Load 16x16 tiles
				jsr     sub_13A68		
				
				lea	  (Indexes).l,a0	;	Load collision indexes
				lea     $FFB000.l,a4
				jsr     (nemdec).l
				
				jmp     $13A2E			;	Jump back to main routine
; End of function sub_87EA
