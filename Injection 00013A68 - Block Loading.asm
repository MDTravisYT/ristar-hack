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