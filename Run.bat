@echo off

:: This is just a simple test file.
:: Better tests need to be added here.

::This wont work beause it will kill the Haxe server
::"%~dp0%haxe-remote\haxe.exe" --v --run tools.haxedoc.Main
::"%~dp0%haxe-remote\haxe.exe" --v --run tools.haxelib.Main

"%~dp0%haxe-remote\haxe.exe" --v


pause
