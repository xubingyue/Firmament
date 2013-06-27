
package firmament.util.loader;

import firmament.util.FMisc;
import firmament.util.loader.serializer.FSerializerFactory;
import openfl.Assets;
import flash.events.EventDispatcher;
#if (cpp || neko)
import sys.io.File;
#end

/*
	Class: FDataLoader
*/
class FDataLoader 
{
	static var _cache:Map<String,Dynamic> = new Map<String,Dynamic>();
	static var _recursionCount:Int;
	public static function loadData(fileName:String, ?allowEmpty:Bool=false):Dynamic{

		//trace("Processing: " + fileName);
		if(_cache.exists(fileName)){
			return FMisc.deepClone(_cache.get(fileName));
		}
		var serializer = FSerializerFactory.getSerializerForFile(fileName);
		if (serializer == null) {
			throw ("Appropriate serializer for fileName "+fileName+" could not be found.");
		}
		var string = Assets.getText(fileName);
		
		#if (cpp || neko)
			//trace('attempting load with file.getContents');
			if (string == null || string == '') {
				string = File.getContent(fileName);
			}
		#end

		if(string==null || (!allowEmpty && string == '')){
			throw("Error reading data from "+fileName);
		}
		var data = serializer.unserialize(string,fileName);
		if (data == null) {
			throw("Data could not be unserialized for "+fileName);
		}
		data.entityFile = fileName;
		data = checkForExtension(data,fileName);
		//trace(fileName+ ' '+Std.string(data));
		
		_cache.set(fileName,FMisc.deepClone(data));
		return data;
	}
	
	//recursivly check for '_extends' directives
	private static function checkForExtension(data:Dynamic,fileName):Dynamic{
		if (Std.is(data,Array)){
			var d:Array<Dynamic> = cast(data,Array<Dynamic>);
			for(key in 0...d.length){
				d[key] = checkForExtension(d[key],fileName);
			}
		}
		else if(Reflect.isObject(data)){
			if(Std.is(data._extends,String)){
				trace(fileName+" extends "+ data._extends);
				_recursionCount++;
				if(_recursionCount > 1000 )throw "recursive _extends detected in "+fileName;
				var parent = loadData(data._extends);
				_recursionCount--;
				FMisc.mergeInto(data,parent);
				data = parent;
				//trace(Std.string(data));
			}

			for(field in Reflect.fields(data)){
				var val = Reflect.field(data, field);
				if(Reflect.isObject(val)){
					val = checkForExtension(val,fileName);
				}
			}
		}
		
		return data;
	}

}
