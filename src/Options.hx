package ;

import haxe.xml.Check;
import haxe.xml.Fast;
import sys.io.File;
using StringTools;

/**
 * ...
 * @author Porfirio
 */

typedef BindPath = {
	from:String,
	to:String
}
 
class Options 
{
	public var hxr:HxRemote;
	public var ip:String="localhost";
	public var port:Int=6000;
	
	var bindPaths:List<BindPath>;
	var separator = "/";
	
	public var args:String;
	
	static var checkRule:Rule= RNode('hxremote', [], RList([
		ROptional(RNode("connect", [Att("ip",null,"localhost"), Att("port",FInt,"6000")])),
		ROptional(RNode("bindpaths", [Att("separator",FEnum(["\\","/"]),"/"),Att("replace",FBool,"false")], RMulti(
			RNode("path", [Att("from"), Att("to")])
		, true)))/*,
		ROptional(RNode("args",[],RData()))*/
	]));

	public function new(m:HxRemote) 
	{
		hxr = m;
		bindPaths = new List<BindPath>();
	}
		
	public function parse(xml:Xml) {
		if (xml.nodeType == Xml.Document)
			xml = xml.firstElement();
		try {
			Check.checkNode(xml,checkRule);
		} catch (m:String) {
			trace(m);
			return;
		}
		
		var fast = new Fast(xml);
		
		if (fast.hasNode.connect) {
			var con = fast.node.connect;
			ip = con.att.ip;
			port = Std.parseInt(con.att.port);
		}
				
		if (fast.hasNode.bindpaths) {
			var bp = fast.node.bindpaths;
			if (bp.has.separator)
				separator = bp.att.separator;
			if (bp.att.replace == "true")
				bindPaths.clear();
			for (path in bp.nodes.path) 
				bindPaths.push( { from:path.att.from, to:path.att.to } );
		}
		
		if (fast.hasNode.args) {
			if (args == null)
				args = fast.node.args.innerData;
			else
				args += " " + fast.node.args.innerData;
		}		
	}
	
	public function parseFile(file:String) {
		parse(Xml.parse(File.getContent(file)));
	}
	
	public function bindPath(pathToGo:String) {
		for (path in bindPaths) {
			if (pathToGo.startsWith(path.from)) {
				var p=pathToGo.replace(path.from, path.to);
					p = p.replace(HxRemote.nativeSeparator, separator);
				hxr.logv("Bound path: " + pathToGo + " to: " + p);
				return p;
			}
		}
		hxr.logv("Path not bound: " + pathToGo);
		return pathToGo;
	}
	
	public inline function runArgs() {
		var a = (args == null)?"":(args+"\n");
		return a + hxr.args.join("\n");
	}
	
}