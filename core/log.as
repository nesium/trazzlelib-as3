package{
	import flash.display.BitmapData;
	public function log(...rest):void{
		if (!initialized)
			initLogger();
		if (!logger)
			return;
		if (rest.length == 1 && rest[0] is BitmapData)
			logger.logBitmapData(rest[0]);
		else if (rest.length == 1 && isComplexObject(rest[0])){
			logger.logObject(rest[0].toString(), rest[0]);
		}else{
			logger.log(rest.toString());
		}
	}
}

var logger : Object;
var initialized : Boolean;

import flash.utils.getDefinitionByName;
function initLogger():void{
	initialized = true;
	try{
		var loggerClass:Class = getDefinitionByName('com.nesium.logging.TrazzleLogger') as Class;
		logger = loggerClass['instance']();
	}
	catch (e:Error) {}
}

function isComplexObject(o:Object):Boolean{
	return o != null && 
		!(o is String) && 
		!(o is Number) && 
		!(o is Boolean) && 
		!(o is Date) && 
		!(o is Function) && 
		!(o is int) && 
		!(o is uint);
}