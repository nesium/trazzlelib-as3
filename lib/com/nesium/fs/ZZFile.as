//
//  ZZFile.as
//
//  Created by Marc Bauer on 2010-04-03.
//  Copyright (c) 2010 nesiumdotcom. All rights reserved.
//

package com.nesium.fs{
	
	public class ZZFile{
		
		//*****************************************************************************************
		//*                                   Private Properties                                  *
		//*****************************************************************************************
		private var m_path:String;
		
		
		
		//*****************************************************************************************
		//*                                     Public Methods                                    *
		//*****************************************************************************************
		public function ZZFile(path:String){
			m_path = path;
		}
		
		public function get applicationDirectory():ZZFile{
			return null;
		}
		
		public function get desktopDirectory():ZZFile{
			return null;
		}
		
		public function get documentsDirectory():ZZFile{
			return null;
		}
		
		public function get exists():Boolean{
			return false;
		}
		
/*		public function get icon():Icon{
			
		}*/
		
		public function get isDirectory():Boolean{
			return false;
		}
		
		public function get isHidden():Boolean{
			return false;
		}
		
		public function get isPackage():Boolean{
			return false;
		}
		
		public function get isSymbolicLink():Boolean{
			return false;
		}
		
		public static function get lineEnding():String{
			return "\n";
		}
		
		public function get nativePath():String{
			return null;
		}
		
		public function set nativePath(value:String):void{
			
		}
		
		public function get parent():ZZFile{
			return null;
		}
		
		public static function get separator():String{
			return '/';
		}
		
		public function get spaceAvailable():Number{
			return -1;
		}
		
		public static function get systemCharset():String{
			return 'utf-8';
		}
		
		public function get url():String{
			return null;
		}
		
		public function set url(value:String):void{
			
		}
		
		public function get userDirectory():ZZFile{
			return null;
		}
		
		public function browseForDirectory(title:String):void{
			
		}
		
		public function browseForOpen(title:String, typeFilter:Array = null):void{
			
		}
		
		public function browseForOpenMultiple(title:String, typeFilter:Array = null):void{
			
		}
		
		public function browseForSave(title:String):void{
			
		}
		
		public function cancel():void{
			
		}
		
		public function canonicalize():void{
			
		}
		
		public function clone():ZZFile{
			return null;
		}
		
		public function copyToAsync(newLocation:ZZFile, overwrite:Boolean = false):void{
			
		}
		
		public function createDirectory():void{
			
		}
		
		public function createTempDirectory():ZZFile{
			return null;
		}
		
		public function deleteDirectoryAsync(deleteDirectoryContents:Boolean = false):void{
			
		}
		
		public function deleteFileAsync():void{
			
		}
		
		public function getDirectoryListingAsync():void{
			
		}
		
		public function getRelativePath(ref:ZZFile, useDotDot:Boolean = false):String{
			return null;
		}
		
		public static function getRootDirectories():Array{
			return null;
		}
		
		public function moveToAsync(newLocation:ZZFile, overwrite:Boolean = false):void{
			
		}
		
		public function moveToTrashAsync():void{
			
		}
		
		public function resolvePath(path:String):ZZFile{
			return null;
		}
	}
}