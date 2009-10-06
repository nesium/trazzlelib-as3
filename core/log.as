package
{
	import flash.display.BitmapData;
	import flash.utils.getDefinitionByName;
	public function log(...rest):void
	{
		try
		{
			var logger:Class = getDefinitionByName('com.nesium.logging.TrazzleLogger') as Class;
			if (rest.length == 1 && rest[0] is BitmapData)
				logger['instance']().logBitmapData(rest[0]);
			else
				logger['instance']().log(rest.toString());
		}
		catch (e:Error) {}
	}
}