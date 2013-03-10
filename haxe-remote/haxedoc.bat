@echo off

::This wont work beause it will kill the Haxe server
"%~dp0haxe.exe" --run tools.haxedoc.Main %*
::"%~dp0haxe.exe" -cmd "haxedoc %*"

@echo on