@echo off

clownnemesis -c SonLVL\chunks.unc SonLVL\chunks.nem
clownnemesis -c SonLVL\blocks.unc SonLVL\blocks.nem
clownnemesis -c SonLVL\index.unc SonLVL\index.nem

IF EXIST "RIBUILT.BIN" move /Y "RIBUILT.BIN" "RIBUILT.PREV.BIN" >NUL
asm68k /k /p /o ae- Compile.asm, "RIBUILT.BIN" >errors.txt, chaotx.sym, chaotx.lst

fixheadr	"RIBUILT.BIN"

pause