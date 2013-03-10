@echo off

::This wont work beause it will kill the Haxe server
::"%~dp0haxe.exe" --run tools.haxelib.Main %*
"%~dp0haxe.exe" -cmd "haxelib %*"

@echo on