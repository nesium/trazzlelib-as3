//
//  TrazzleFileService.as
//
//  Created by Marc Bauer on 2010-04-05.
//  Copyright (c) 2010 nesiumdotcom. All rights reserved.
//

package com.nesium.logging{
	
	import com.nesium.fs.FileReference;
	import com.nesium.logging.zz;
	
	import flash.utils.Dictionary;
	
	public class TrazzleFileService{
		
		use namespace zz;
		
		//*****************************************************************************************
		//*                                   Private Properties                                  *
		//*****************************************************************************************
		private static var g_instance:TrazzleFileService;
		
		private var m_userDir:String;
		private var m_desktopDir:String;
		private var m_documentsDir:String;
		private var m_refRegistry:Dictionary;
		private var m_nextRefId:Number = 0;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function TrazzleFileService(){
			m_refRegistry = new Dictionary(true);
		}
		
		
		public static function instance():TrazzleFileService{
			if (!g_instance)
				g_instance = new TrazzleFileService();
			return g_instance;
		}
		
		
		
		//*****************************************************************************************
		//*                                    Internal Methods                                   *
		//*****************************************************************************************
		zz function registerFileRef(ref:FileReference):void{
			m_refRegistry[ref] = m_nextRefId;
			ref.setRefId(m_nextRefId++);
		}
		
		
		
		//*****************************************************************************************
		//*                                     Remote Methods                                    *
		//*****************************************************************************************
		zz function setConstants(constants:Object):void{
			m_userDir = constants['User'];
			m_desktopDir = constants['Desktop'];
			m_documentsDir = constants['Documents'];
			trace('userDir: ' + m_userDir);
			trace('documentsDir: ' + m_documentsDir);
			trace('desktopDir: ' + m_desktopDir);
		}
		
		
		
		//*****************************************************************************************
		//*                                    Private Methods                                    *
		//*****************************************************************************************
		private function fileRefWithId(refId:Number):FileReference{
			for (var key:* in m_refRegistry){
				if (!key) continue; // can this even happen? never use a dict with weak keys before
				if (m_refRegistry[key] == refId)
					return key as FileReference;
			}
			return null;
		}
	}
}