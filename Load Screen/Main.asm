;	============================================================================!
;                                                                               !
;	Loading Screen:																!
;		The checksum takes a few seconds, so I've added this so people don't	!
;		think that the game isn't working. A lot of setup is required,			!
;		since the game isn't fully set up yet.									!
;                                                                               !
;	============================================================================!

LoadScreen:
		move.b	(a5)+,		$11(a3)			;	Chunk of existing initialization routine.
		dbf     d5,			LoadScreen		;		There was not enough room to jump into it
		move.w  d0,			(a2)			;		at the end, so it's been jumped near the end
		movem.l (a6),		d0-d7/a0-a6		;		and the rest of the routine has been
		move    #$2700,		sr				;		appended to the routine here.
		
;		REAL CODE STARTS BELOW!

	;	▼ Set up VDP ▼
		move.w	#$8100+%01010100,(VDPCTRL)	;	Set VDP modes, mainly to render the screen
		move.w	#$8200+(PLANE_A/$400),(VDPCTRL)	;	Set plane A to read at $C000
		
		move.l	#CRAMWRITE,	(VDPCTRL)		;	Set VDP control mode to manually write a palette to CRAM
		move.w	#$0000,		VDPDATA			;	Palleting...
		move.w	#$00EE,		VDPDATA			;	Palleting...
		move.w	#$00CE,		VDPDATA			;	Palleting...
		move.w	#$008C,		VDPDATA			;	Palleting...
		move.w	#$0004,		VDPDATA			;	Palleting...
		
		lea		Font,		a0				;	Load loading text...
		move.l  #$40000000,($C00004).l		;	...to VRAM
		jsr		(nemdec_vram).l				;	Call VRAM Nemesis decompress
		lea		(LoadMap).l,a0				;	Load loading tilemap...
		lea		$FF0000.l,a4				;   ...to $FF0000 (RAM)
		jsr		(nemdec).l					;	Call RAM Nemesis decompress
		
		copyTilemap	$FF0000,$C620,9,3		;	Copy loaded tilemap into plane
		
		jmp		$300						;	Jump back to main routine
				
Font:		incbin	"Load Screen/LoadArt.nem"
LoadMap:	incbin	"Load Screen/LoadMap.nem"