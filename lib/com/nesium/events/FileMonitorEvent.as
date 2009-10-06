//
//  FileMonitorEvent.as
//
//  Created by Marc Bauer on 2008-09-10.
//  Copyright (c) 2008 Fork Unstable Media GmbH. All rights reserved.
//

package com.nesium.events
{

	import flash.events.Event;
	
	public class FileMonitorEvent extends Event
	{
		/***************************************************************************
		*                             Public properties                            *
		***************************************************************************/
		public static const FILE_CHANGED:String = 'fileChangedEvent';
		
		public var path:String;
		
		
		/***************************************************************************
		*                              Public methods                              *
		***************************************************************************/
		public function FileMonitorEvent(type:String, aPath:String)
		{
			super(type);
			path = aPath;
		}
	}
}