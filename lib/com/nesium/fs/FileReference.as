//
//  ZZFileReference.as
//
//  Created by Marc Bauer on 2010-04-03.
//  Copyright (c) 2010 nesiumdotcom. All rights reserved.
//

package com.nesium.fs{

	import com.nesium.logging.TrazzleFileService;
	import com.nesium.logging.TrazzleLogger;
	import com.nesium.logging.zz;
	import com.nesium.remoting.InvocationResult;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	public class FileReference extends EventDispatcher{

		use namespace zz;
		
		//*****************************************************************************************
		//*                                   Private Properties                                  *
		//*****************************************************************************************
		private var m_path:String;
		private var m_refId:Number;
		
		private var m_creationDate:Date;
		private var m_creator:String;
		private var m_data:ByteArray;
		private var m_extension:String;
		private var m_modificationDate:Date;
		private var m_name:String;
		private var m_size:Number;
		private var m_type:String;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function FileReference(){
			TrazzleFileService.instance().registerFileRef(this);
		}

		
		public function get creationDate():Date{
			return m_creationDate;
		}
		
		public function get creator():String{
			return m_creator;
		}
		
		public function get data():ByteArray{
			return m_data;
		}
		
		public function get extension():String{
			return m_extension;
		}
		
		public function get modificationDate():Date{
			return m_modificationDate;
		}
		
		public function get name():String{
			return m_name;
		}
		
		public function get size():Number{
			return m_size;
		}
		
		public function get type():String{
			return m_type;
		}
		
		
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
		
		override public function toString():String{
			return '[com.nesium.fs.FileReference] ' + fileAttribsToString();
		}
		
		
		
		//*****************************************************************************************
		//*                                    Internal Methods                                   *
		//*****************************************************************************************
		zz function setRefId(anId:Number):void{
			m_refId = anId;
		}
		
		
		
		//*****************************************************************************************
		//*                                    Private Methods                                    *
		//*****************************************************************************************
		private function applyFileAttribDict(aDict:Object):void{
			m_path = aDict['path'];
			m_creationDate = aDict['creationDate'];
			m_creator = aDict['creator'];
			m_extension = aDict['extension'];
			m_modificationDate = aDict['modificationDate'];
			m_name = aDict['name'];
			m_size = aDict['size'];
			m_type = aDict['type'];
		}
		
		private function fileAttribsToString():String{
			return 'creationDate: ' + m_creationDate + ', creator: ' + m_creator + 
				', extension: ' + m_extension + ', modificationDate: ' + m_modificationDate + 
				', name: ' + m_name + ', size: ' + m_size + ', type: ' + m_type + 
				', _path: ' + m_path + ', _refId: ' + m_refId;
		}
		
		
		
		//*****************************************************************************************
		//*                                         Events                                        *
		//*****************************************************************************************
		private function browseInvocation_complete(e:Event):void{
			var result:InvocationResult = e.target as InvocationResult;
			result.removeEventListener(Event.COMPLETE, browseInvocation_complete);
			if (!result.result){
				dispatchEvent(new Event(Event.CANCEL));
			}else{
				applyFileAttribDict(result.result);
				trace(this);
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