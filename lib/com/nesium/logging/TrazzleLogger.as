package com.nesium.logging
{
	
	import com.nesium.remoting.DuplexGateway;
	
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.registerClassAlias;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	import mx.graphics.codec.PNGEncoder;
	
	
	public class TrazzleLogger extends EventDispatcher
	{
		
		
		//*****************************************************************************************
		//*                                   Private Properties                                  *
		//*****************************************************************************************
		private static const k_host:String = 'localhost';
		private static const k_port:Number = 3457;
		private static var g_instance:TrazzleLogger;
		private static var g_gateway:DuplexGateway;
		private static var g_stage:Stage;
		private static var g_notInitedErrorThrown:Boolean = false;
		private static var g_lastFrames:int;
		private static var g_lastTimeStamp:Number;
		private static var g_monitorTimer:Timer;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function TrazzleLogger()
		{
			g_gateway = new DuplexGateway(k_host, k_port);
			g_gateway.connectToRemote();
		}
		
		
		public function setParams(theStage:Stage, title:String):void
		{
			if (g_stage) return;
			g_stage = theStage;
			var objCopy:ByteArray = new ByteArray();
			objCopy.writeObject(theStage.loaderInfo.parameters);
			objCopy.position = 0;
			var params:Object = objCopy.readObject();
			params.swfURL = theStage.loaderInfo.url;
			params.applicationName = title;
			g_gateway.invokeRemoteService('CoreService', 'setConnectionParams', params);
		}
		
		public function stage():Stage
		{
			return g_stage;
		}
		
		public function log(msg:String):void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			send(msg);
		}
		
		public function logBitmapData(bmp:BitmapData):void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			g_gateway.invokeRemoteService('LoggingService', 'logPNG_width_height', 
				new PNGEncoder().encode(bmp), bmp.width, bmp.height);
		}
		
		public function addI18NKeyToFile(key:String, file:String):void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			g_gateway.invokeRemoteService('LoggingService', 'addI18NKey_toFile', key, file);
		}
		
		public function startPerformanceMonitoring():void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			if (g_monitorTimer) return;
			g_lastTimeStamp = getTimer();
			g_lastFrames = 0;
			g_monitorTimer = new Timer(500);
			g_monitorTimer.addEventListener(TimerEvent.TIMER, monitorTimer_tick);
			g_monitorTimer.start();
			g_stage.addEventListener(Event.ENTER_FRAME, stage_enterFrame);
			g_gateway.invokeRemoteService('MonitoringService', 'startMonitoring', g_stage.frameRate);
		}
		
		public function stopPerformanceMonitoring():void
		{
			if (!g_monitorTimer) return;
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			g_monitorTimer.stop();
			g_monitorTimer.removeEventListener(TimerEvent.TIMER, monitorTimer_tick);
			g_monitorTimer = null;
			g_stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrame);
			g_gateway.invokeRemoteService('MonitoringService', 'stopMonitoring');
		}
		
		public function inspectObject(obj:*):void
		{
			if (!g_stage)
			{
				throwNotInitedError();
				return;
			}
			g_gateway.invokeRemoteService('InspectionService', 'inspectObject_metadata', obj, 
				describeType(obj));
		}
		
		public function gateway():DuplexGateway
		{
			return g_gateway;
		}
		
		public static function instance():TrazzleLogger
		{
			if (!g_instance) 
				g_instance = new TrazzleLogger();
			return g_instance;
		}
		
		public static function throwNotInitedError():void
		{
			if (g_notInitedErrorThrown) return;
			g_notInitedErrorThrown = true;
			throw new Error('TrazzleLogger not inited. Please make sure to call zz_init before ' + 
				'using any logger methods!');
		}
		
		
		
		//*****************************************************************************************
		//*                                    Private Methods                                    *
		//*****************************************************************************************
		private function send(message:String, stackIndex:uint=0):void
		{
			var stacktrace:StackTrace = new StackTrace();
			var logMessage:LogMessageVO = new LogMessageVO(message, stacktrace, stackIndex + 4);
			g_gateway.invokeRemoteService('LoggingService', 'log', logMessage);
		}
		
		
		
		//*****************************************************************************************
		//*                                         Events                                        *
		//*****************************************************************************************
		private function stage_enterFrame(e:Event):void
		{
			g_lastFrames++;
		}
		
		private function monitorTimer_tick(e:TimerEvent):void
		{
			var now:Number = getTimer();
			var fps:Number = g_lastFrames / (getTimer() - g_lastTimeStamp) * 1000;
			g_lastFrames = 0;
			g_lastTimeStamp = now;
			g_gateway.invokeRemoteService('MonitoringService', 'trackFPS_memoryUse_timestamp', 
				fps, System.totalMemory, now);
		}
	}
}


import flash.net.registerClassAlias;
import flash.utils.getTimer;

internal class LogMessageVO
{
	
	{registerClassAlias('FlashLogMessage', LogMessageVO);}
	
	
	//*****************************************************************************************
	//*                                   Public Properties                                   *
	//*****************************************************************************************
	public var message:String;
	public var encodeHTML:Boolean = true;
	public var stacktrace:String;
	public var levelName:String;
	public var timestamp:Number;
	public var stackIndex:uint;
	
	
	
	//*****************************************************************************************
	//*                                   Private Properties                                  *
	//*****************************************************************************************
	private static var g_levels:Object =
	{
		d:'debug',
		i:'info',
		n:'notice',
		w:'warning',
		e:'error',
		c:'critical',
		f:'fatal'
	};
	
	
	
	//*****************************************************************************************
	//*                                     Public Methods                                    *
	//*****************************************************************************************
	public function LogMessageVO(aMessage:String, aStacktrace:StackTrace, 
		aStackIndex:uint)
	{
		levelName = '';
		if (aMessage.charAt(0) == '#')
		{
			aMessage = aMessage.substr(1);
			encodeHTML = false;
		}
		if (aMessage.charAt(1) == ' ')
		{
			levelName = g_levels[aMessage.charAt(0)] || '';
			aMessage = aMessage.substr(2);
		}
		timestamp = getTimer();
		message = aMessage;
		stacktrace = aStacktrace.toString();
		stackIndex = aStackIndex;
	}
}



internal class StackTrace
{

	//*****************************************************************************************
	//*                                   Private Properties                                  *
	//*****************************************************************************************
	private var m_stackTrace:String;
	
	
	
	//*****************************************************************************************
	//*                                     Public Methods                                    *
	//*****************************************************************************************
	public function StackTrace()
	{
		try
		{
			throw new Error();
		}
		catch (error:Error)
		{
			m_stackTrace = error.getStackTrace();
		}
	}
	
	public function toString():String
	{
		return m_stackTrace;
	}
}