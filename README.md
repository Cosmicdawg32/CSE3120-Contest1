# CSE3120-Contest1
Repository for CSE3120 project

Build Instrucitons:
1. Ensure that the src folder and build.bat are located in the same directory
2. Open build.bat in notepad or an IDE
3. On line 18, change "%USERPROFILE%\Documents\ASM\Irvine\IRVINE32.inc" to where IRVINE32.inc is located on your machine
4. Save changes and run build.bat
5. Run masmTD.exe and resize console window to the correct size
6. Have fun!

List of all sources used (Sources are also mentioned in their respective .asm file):

build.bat sources:
    Batch commands found from: https://learn.microsoft.com/en-us/cpp/assembler/masm/ml-and-ml64-command-line-reference?view=msvc-170
    Linker information found from: https://learn.microsoft.com/en-us/cpp/build/reference/linker-options?view=msvc-170
    SAFESESH information found from: https://learn.microsoft.com/en-us/cpp/build/reference/safeseh-image-has-safe-exception-handlers?view=msvc-170
    ml.exe and link.exe PATH information found from: https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=msvc-170

map.asm sources:
    Usage of OR was utilized from: https://learn.microsoft.com/en-us/cpp/assembler/masm/operator-or?view=msvc-170
    Usage of SHL was utilized from: https://learn.microsoft.com/en-us/cpp/assembler/masm/operator-shl?view=msvc-170
    IMUL information found from: https://www.felixcloutier.com/x86/imul.html

masmTD.inc sources:
    Fixed tick rate information from: https://gameprogrammingpatterns.com/game-loop.html

ui.asm sources:
    @f information from: https://learn.microsoft.com/en-us/cpp/assembler/masm/at-f?view=msvc-170
    @@ information from: https://learn.microsoft.com/en-us/cpp/assembler/masm/at-at?view=msvc-170
    Key Codes found from: https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes
    ReadKey information from: https://csc.csudh.edu/mmccullough/asm/help/source/irvinelib/readkey.htm
    Background and foreground color information from: https://csc.csudh.edu/mmccullough/asm/help/source/irvinelib/settextcolor.htm
    screenCache inspired from: https://gameprogrammingpatterns.com/dirty-flag.html

BalloonObj.asm sources:
    Usage of STRUCT was utilized from https://learn.microsoft.com/en-us/cpp/assembler/masm/struct-masm?view=msvc-170
    Usage of call was utilized from https://www.coddykit.com/courses/assembly/defining-and-calling-procedures-2278939
    Usage of .IF and .ELSE utilized from https://learn.microsoft.com/en-us/cpp/assembler/masm/if-masm?view=msvc-170
    USage of OR from https://www.tutorialspoint.com/assembly_programming/assembly_logical_instructions.htm
    BalloonsArr utilized from https://gameprogrammingpatterns.com/object-pool.html

