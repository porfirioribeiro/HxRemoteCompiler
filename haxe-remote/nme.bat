@echo off

::Sample batch file for running a library, in this case NME

::This wont work beause it will kill the Haxe server
::"%~dp0haxe.exe" --run tools.haxelib.Main run nme %*
"%~dp0haxe.exe" -cmd "haxelib run nme %*"

@echo on