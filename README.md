HxRemoteCompiler
================

HxRemoteCompiler is a small app developed with Haxe to run on Neko that connects to Haxe compiler by its remote interface.
It mimics the Haxe compiler so it can be used with IDE's like FlashDevelop.

It reads a hxremote.xml file from exe path and from cwd where tou can specify some options, like the ip and port to connect.

I use it as the default compiler on FlashDevelop that i run on a Windows XP virtual machine that run's on top of Linux.

So i can have Haxe and all libraries setup on Linux and run them remotely on windows.
It's also possible to bind paths, so your network drives paths on guest will bound to the real file path on the host.
Eg.: I:\Projects\Haxe\MyProject will become /home/porfirio/Haxe/MyProject so the compiler will find the files.

The XML may look like this:

<?xml version="1.0" encoding="utf-8" ?>
<hxremote>
	<connect ip="192.168.1.65" port="6000" />
	<bindpaths separator="/">
		<path from="I:" to="/home/porfirio" />
	</bindpaths>
</hxremote>

For the Haxe server to accept external connections run:
haxe --wait 0.0.0.0:6000
On the host machine

Having a fixed IP is also a good idea.


TODO: 
	Expand README to be more conclusive
	Add documentation for the hxremote.xml file
	Recognize and use the --connect ip:port parameter, override the settings and dont send the arg to server
	
