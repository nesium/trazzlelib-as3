package com.nesium.logging
{

	import com.nesium.events.FileMonitorEvent;
	import com.nesium.logging.TrazzleLogger;
	
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	
	
	public class FileMonitor extends EventDispatcher
	{
		
		/***************************************************************************
		*                           Protected properties                           *
		***************************************************************************/
		protected static var g_instance:FileMonitor;
		
		
		
		/***************************************************************************
		*                              Public methods                              *
		***************************************************************************/
		public function FileMonitor() 
		{
			//TrazzleLogger.instance().socket().addEventListener(DataEvent.DATA, socket_data);
		}
		
		
		public static function instance():FileMonitor
		{
			if (!g_instance)
			{
				g_instance = new FileMonitor();
			}
			return g_instance;
		}
		
		public function startMonitoringFile(path:String):void
		{
			var msg:XML = <cmd action="monitorFile" path={path}/>
			//TrazzleLogger.instance().sendRawMessage(msg.toXMLString());
		}
		
		public function stopMonitoringFile(path:String):void
		{
			var msg:XML = <cmd action="unmonitorFile" path={path}/>
			//TrazzleLogger.instance().sendRawMessage(msg.toXMLString());
		}
		
		
		/***************************************************************************
		*                             Protected methods                            *
		***************************************************************************/
		protected function socket_data(e:DataEvent):void
		{
			var node:XML = new XML(e.data);
			if (node.localName().toLowerCase() == 'event')
			{
				dispatchEvent(new FileMonitorEvent(FileMonitorEvent.FILE_CHANGED, node.@path));
			}
		}
	}
}