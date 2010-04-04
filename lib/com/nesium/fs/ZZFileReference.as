//
//  ZZFileReference.as
//
//  Created by Marc Bauer on 2010-04-03.
//  Copyright (c) 2010 nesiumdotcom. All rights reserved.
//

package com.nesium.fs{

	import com.nesium.logging.TrazzleLogger;
	import com.nesium.remoting.InvocationResult;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	public class ZZFileReference extends EventDispatcher{
		
		//*****************************************************************************************
		//*                                   Private Properties                                  *
		//*****************************************************************************************
		private var m_path:String;
		private var m_data:ByteArray;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function ZZFileReference(){}

		
		public function browse(typeFilter:Array = null):Boolean{
			TrazzleLogger.instance().gateway().invokeRemoteService('FileService', 'browseForFile', 
				typeFilter).addEventListener(Event.COMPLETE, browseInvocation_complete);
			return true;
		}
		
		public function load():void{
			TrazzleLogger.instance().gateway().invokeRemoteService('FileService', 
				'readContentsOfFile', m_path).addEventListener(Event.COMPLETE, 
				loadInvocation_complete);
		}
		
		
		
		//*****************************************************************************************
		//*                                    Private Methods                                    *
		//*****************************************************************************************
		private function browseInvocation_complete(e:Event):void{
			var result:InvocationResult = e.target as InvocationResult;
			result.removeEventListener(Event.COMPLETE, browseInvocation_complete);
			trace(describeType(result.result));
			if (!result.result){
				dispatchEvent(new Event(Event.CANCEL));
			}else{
				m_path = result.result;
				dispatchEvent(new Event(Event.SELECT));
				load();
			}
		}
		
		private function loadInvocation_complete(e:Event):void{
			var result:InvocationResult = e.target as InvocationResult;
			result.removeEventListener(Event.COMPLETE, browseInvocation_complete);
			if (!result.result){
				dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			}else{
				m_data = result.result as ByteArray;
				trace('result: ' + m_data.readUTFBytes(m_data.bytesAvailable));
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
	}
}