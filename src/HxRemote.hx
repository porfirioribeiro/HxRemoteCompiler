package ;

import haxe.io.Path;
import neko.Lib;
import sys.FileSystem;
import sys.io.File;
import sys.net.Host;
import sys.net.Socket;

using Lambda;
using StringTools;

/**
 * ...
 * @author Porfirio
 */

class HxRemote 
{
	public static var nativeSeparator:String=(Sys.systemName() == "Windows")?"\\":"/";
	public var verbose = false;
	
	public var args:Array<String>;
	public var opt:Options;
	
	public function new(rargs:Array<String>) {		
		args = rargs;		
	}
	
	function parseHxrArgs():Void {
		if (args.has("--v")) {
			verbose = true;
			args.remove("--v");
		}	
		//TODO Allow to use --connect ip:port for a direct connection, overriding hxremote defaults.
	}
	
	public function connect() {

		
		opt = new Options(this);
		
		var exePath = Path.directory(Sys.executablePath());
		var cwdPath = Path.directory(Sys.getCwd());
		
		var xmlFile = "hxremote.xml";
		
		var exeXmlFile = exePath + nativeSeparator + xmlFile;
		var cwdXmlFile = cwdPath + nativeSeparator + xmlFile;
		
		if (FileSystem.exists(exeXmlFile)) {
			logv("Parsing " + exeXmlFile);
			opt.parseFile(exeXmlFile);		
		}
		if (FileSystem.exists(cwdXmlFile)) {
			logv("Parsing " + cwdXmlFile);
			opt.parseFile(cwdXmlFile);
		}
		
		replacePaths();

		var boundCwd = opt.bindPath(cwdPath);
		logv("Using cwd: " + boundCwd);
		
		
		var s:Socket;
		try {
			s = new Socket();
			s.connect(new Host(opt.ip), opt.port);
			logv('Connected to ' + opt.ip + ':' + opt.port);
		} catch (z:Dynamic) {
			error('Could not connect to ' + opt.ip + ':' + opt.port);
			error("Please check if the server is running on the specified host:port");
			error("Run the server on the target machine with the command:");
			error("\thaxe --wait 0.0.0.0:" + opt.port);
			error("Or change the hxremote.xml files");
			Sys.exit(1);
			return;
		}
		
		// haxe -v --connect 192.168.1.65:8081 --cwd  /media/Data/Dev/Haxe/AgroGest AgroGest.hxml  
		s.write("--cwd " + boundCwd + "\n");
		s.write(opt.runArgs());
		s.write("\n\000");
		
		s.waitForRead();

		var str:String = s.input.readAll().toString();
				
        var hasError = false;
		var lines:Array<String> = str.split("\n");
				
        for ( line in lines )
            switch( line.charCodeAt(0) ) {
				case 0x01: Sys.print(line.substr(1).split("\x01").join("\n"));
				case 0x02: hasError = true;
				default: {
					if (line.length>0)
						Sys.stderr().writeString(line+"\n");
				}
            }
        if ( hasError ) {
			Sys.exit(1);
		}
		
		logv("Compile with success!");
		Sys.exit(0);
	}
	
	public function replacePaths() {
		var pathOpt:Array<String> = [
			  "-cp", // <path> : add a directory to find source files
			  "-js", // <file> : compile code to JavaScript file
			  "-swf", // <file> : compile code to Flash SWF file
			  "-as3", // <directory> : generate AS3 code into target directory
			  "-neko", // <file> : compile code to Neko Binary
			  "-php", // <directory> : generate PHP code into target directory
			  "-cpp", // <directory> : generate C++ code into target directory
			  "-cs", // <directory> : generate C# code into target directory
			  "-java", // <directory> : generate Java code into target directory
			  "-xml", // <file> : generate XML types description
			  "-swf-lib", // <file> : add the SWF library to the compiled SWF
			  "-swf-lib-extern", // <file> : use the SWF library for type checking
			  "-java-lib", // <file> : add an external JAR or class directory library
			  "-x", // <file> : shortcut for compiling and executing a neko file
			  "-resource", // <file>[@name] : add a named resource file
			  "-cmd", // : run the specified command after successful compilation
			  "--display", // : display code tips
			  "--php-front", // <filename> : select the name for the php front file
			  "--php-lib" // <filename> : select the name for the php lib folder
		];
		
		for (o in pathOpt) {
			var ind = args.indexOf(o);
			if (ind > -1) {
				args[ind + 1] = opt.bindPath(args[ind + 1]);			
			}
		}
		
		args=args.map(function(arg:String) {
			if (arg.endsWith(".hxml")) 
				return opt.bindPath(arg);
			return arg;
		});
	}
	
	public inline function logv(msg:Dynamic) {
		if (verbose)
			log("hxr: "+msg);
	}	
	public inline function log(msg:Dynamic) {
		#if debug
			trace(msg);
		#else
			Sys.println(msg);
		#end
	}

	public inline function error(msg:Dynamic) {
		Sys.stderr().writeString(msg + "\n");
	}
	
    public static function run(args:Array<String>) {
		var hxr = new HxRemote(args);
		hxr.parseHxrArgs();
		hxr.connect();
		
		return hxr;
    }
	
}