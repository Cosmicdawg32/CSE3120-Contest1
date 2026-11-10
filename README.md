# CSE3120-Contest1
Repository for CSE3120 project

Build Instructions:
1. Ensure that the src folder and build.bat are located in the same directory
2. Open build.bat in Notepad or an IDE
3. On line 18, change "%USERPROFILE%\Documents\ASM\Irvine\IRVINE32.inc" to where IRVINE32.inc is located on your machine
4. Save changes and run build.bat
5. Run masmTD.exe and resize the console window to the correct size
6. Have fun!

List of all sources used (Sources are also mentioned in their respective .asm file):<br>
<br>
build.bat sources:<br>
    Batch commands found from: https://learn.microsoft.com/en-us/cpp/assembler/masm/ml-and-ml64-command-line-reference?view=msvc-170<br>
    Linker information found from: https://learn.microsoft.com/en-us/cpp/build/reference/linker-options?view=msvc-170<br>
    SAFESESH information found from: https://learn.microsoft.com/en-us/cpp/build/reference/safeseh-image-has-safe-exception-handlers?view=msvc-170<br>
    ml.exe and link.exe PATH information found from: https://learn.microsoft.com/en-us/cpp/build/building-on-the-command-line?view=msvc-170<br>
<br>
map.asm sources:<br>
    Usage of OR was utilized from: https://learn.microsoft.com/en-us/cpp/assembler/masm/operator-or?view=msvc-170<br>
    Usage of SHL was utilized from: https://learn.microsoft.com/en-us/cpp/assembler/masm/operator-shl?view=msvc-170<br>
    IMUL information found from: https://www.felixcloutier.com/x86/imul.html<br>
<br>
masmTD.inc sources:<br>
    Fixed tick rate information from: https://gameprogrammingpatterns.com/game-loop.html<br>
<br>
ui.asm sources:<br>
    @f information from: https://learn.microsoft.com/en-us/cpp/assembler/masm/at-f?view=msvc-170<br>
    @@ information from: https://learn.microsoft.com/en-us/cpp/assembler/masm/at-at?view=msvc-170<br>
    Key Codes found from: https://learn.microsoft.com/en-us/windows/win32/inputdev/virtual-key-codes<br>
    ReadKey information from: https://csc.csudh.edu/mmccullough/asm/help/source/irvinelib/readkey.htm<br>
    Background and foreground color information from: https://csc.csudh.edu/mmccullough/asm/help/source/irvinelib/settextcolor.htm<br>
    screenCache inspired from: https://gameprogrammingpatterns.com/dirty-flag.html<br>
<br>
BalloonObj.asm sources:<br>
    Usage of STRUCT was utilized from https://learn.microsoft.com/en-us/cpp/assembler/masm/struct-masm?view=msvc-170<br>
    Usage of call was utilized from https://www.coddykit.com/courses/assembly/defining-and-calling-procedures-2278939<br>
    Usage of .IF and .ELSE utilized from https://learn.microsoft.com/en-us/cpp/assembler/masm/if-masm?view=msvc-170<br>
    USage of OR from https://www.tutorialspoint.com/assembly_programming/assembly_logical_instructions.htm<br>
    BalloonsArr utilized from https://gameprogrammingpatterns.com/object-pool.html<br>

