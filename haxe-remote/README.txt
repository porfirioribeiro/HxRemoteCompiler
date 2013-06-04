This is a fake compiler, it just runs commands on a external haxe compiler.
On the host machine start:
  haxe --wait 0.0.0.0:6000
  
For the compiler be accepted by FlashDevelop it needs to find a CHANGES.txt.
I have a simple one just for make it work, but you can copy it from the haxe dir on the host machine.

For "Goto Declaration" and other features to work ok, copy the std file from the haxe dir.
Or set in 'Tools -> Global Classpaths...', the Haxe classpath to point in your Haxe instalation.

I've included neko.dll and gc.dll so you can run the exe without have to install Neko and add it to PATH
  

