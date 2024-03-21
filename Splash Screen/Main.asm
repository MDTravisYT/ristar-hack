;	============================================================================!
;                                                                               !
;	MDT Splash Screen															!
;                                                                               !
;	============================================================================!

	;	▼ Load palette ▼
		lea		MDTPal,		a0				;	Load palette address into a0
		lea		$FFEF00,	a1				;	Load address it'll be printed at
		rept	32							;	Prepare the compiler loop!
		move.l	(a0)+,		(a1)+			;	This line is repeated 32 times in the ROM.
		endr								;	Stop the compiler loop.

	;	▼ Load Nemesis archives ▼
		move	#$2700,		sr				;	Disable interrupts
		lea		MDTArt,		a0				;	Load MDT splash art address...
		move.l	#$40000001,	($C00004).l		;	...to VRAM
		jsr		(nemdec_vram).l				;	Call VRAM Nemesis decompress
		lea		(MDTMap).l,	a0				;	Load MDT splash tilemap...
		lea		$FF0000.l,	a4				;	...to $FF0000 (RAM)
		jsr		(nemdec).l					;	Call RAM Nemesis decompress
		move	#$2300,		sr				;	Enable interrupts
		
		copyTilemap	$FF0000,$C206,$21,$15	;	Copy loaded tilemap into plane
		
	;	▼ Main screen routine ▼
		moveq	#60-1,		d4				;	Set main timer to d4
		move.b	#$25,		$FFE00A			;	Play sound effect
	.vint:									;	                 ...here! ◄──────┐
		jsr		VSync						;	Wait for VSync                   │
		dbf		d4,			.vint			;	Decrement timer, jump back to... ┘ (Ignored if d4 is 0)
		jsr		Pal_FadeBlack				;	Fade screen to black
	
	;	▼ Go to level mode ▼
		move.w	#0,			$FFEA00			;	Opmode is now 0, which I moved the level mode to
		jmp	$789E							;	Jump to the level code, fully activating the level mode

;	============================================================================!
;                                                                               !
;	BELOW IS CODE BORROWED FROM EXTERNAL SOURCES!                               !
;                                                                               !
;	============================================================================!

;	KatKuriN - Custom
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

;	ProjectFM - Alien Shooty Game
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

;	Yuji Naka(?) - Palette Fade Out (Sonic 1)
;	Disassembly from Sonic Retro
; ---------------------------------------------------------------------------
; Subroutine to fade a palette to black at the speed of d0
; ---------------------------------------------------------------------------

Pal_FadeBlack:						; Offset: 000006CC
		clr.w	$FFFFEF00
		moveq	#$15,d4

PFB_FadeFrame:
		bsr.s	VSync

		bsr.s	PFB_FadeBuffer
		dbf	d4,	PFB_FadeFrame

PFB_NotFinished:					; Offset: 000006FC
		rts						; return

; ---------------------------------------------------------------------------
; Subroutine to fade a buffer's colours to black once
; ---------------------------------------------------------------------------

PFB_FadeBuffer:							; Offset: 000006FE
		lea	($FFFFEF00).w,a0			; load palette buffer address
		move.w	#$0040,d0				; set repeat times
	;	adda.w	d0,a0
	;	subq.w	#$01,d0					; subtract 1 (most likely for the dbf instruction)

PFB_NextColour:						; Offset: 00000708
	;	move.w	d2,d0					; copy colour to d0
		bsr.s	PFB_DecreaseColour			; process red
		dbf	d0,PFB_NextColour			; repeat til all colours processed
		rts						; return

; ---------------------------------------------------------------------------
; Subroutine to decrease a single colour nybble
; ---------------------------------------------------------------------------

PFB_DecreaseColour:					; Offset: 0000072C
dered:
		move.w	(a0),d2
		beq.s	next
		move.w	d2,d1
		andi.w	#$E,d1
		beq.s	degreen
		subq.w	#2,(a0)+	; decrease red value
		rts	
; ===========================================================================

degreen:
		move.w	d2,d1
		andi.w	#$E0,d1
		beq.s	deblue
		subi.w	#$20,(a0)+	; decrease green value
		rts	
; ===========================================================================

deblue:
		move.w	d2,d1
		andi.w	#$E00,d1
		beq.s	next
		subi.w	#$200,(a0)+	; decrease blue	value
		rts	
; ===========================================================================

next:
		addq.w	#2,a0
		rts						; return

;	============================================================================!
;                                                                               !
;	Non-code data for splash screen												!
;                                                                               !
;	============================================================================!

		even
MDTPal:	incbin	"Splash Screen/MDT Splash Palette.pal"			;	Palette
		even
MDTMap:	incbin	"Splash Screen/MDT Splash Map.nem"		;	Tilemap
		even
MDTArt:	incbin	"Splash Screen/MDT Splash Art.nem"			;	Art