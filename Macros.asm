;	============================================================================!
;																				!
;		align:																	!
;			Aligns the following data to the specified ROM location.			!
;			Make sure your data isn't too big!									!
;																				!
;		USAGE:		align	(address)											!
;		EXAMPLE:	align	$200000												!
;																				!
;	============================================================================!

align	macro
		cnop 0,\1
		endm

;	============================================================================!
;																				!
;		copyTilemap:	Taken from the Sonic 1 disassembly at Sonic Retro		!
;			An easy to use tilemap setup.										!
;																				!
;		USAGE:		copyTilemap		(source),(location),(width),(height)		!
;		EXAMPLE:	copyTilemap		$FF0000,$C206,$21,$15						;
;																				!
;	============================================================================!

copyTilemap:	macro	source,loc,width,height
		lea		(source).l,a1
		move.l	#$40000000+((loc&$3FFF)<<16)+((loc&$C000)>>14),d0
		moveq	#width,d1
		moveq	#height,d2
		jsr		DrawTileMap
		endm