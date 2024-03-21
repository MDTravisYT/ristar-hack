@echo off

nemcmp Levels\Chunks.unc Levels\Compressed\Chunks.nem
nemcmp Levels\Blocks.unc Levels\Compressed\Blocks.nem
nemcmp Levels\Collision.unc Levels\Compressed\Collision.nem

IF EXIST "RIBUILT.BIN" move /Y "RIBUILT.BIN" "RIBUILT.PREV.BIN" >NUL
asm68k /k /p /o ae- Compile.asm, "RIBUILT.BIN" >errors.txt, RIBUILT.sym, RIBUILT.lst

fixheadr	"RIBUILT.BIN"

pause