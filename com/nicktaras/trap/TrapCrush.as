package com.nicktaras.trap {
	
	import flash.display.MovieClip;
	
	public class TrapCrush extends Trap{
		
		public var hit_mc:MovieClip;
		public var border_mc:MovieClip;
		public var enemyWait_mc:MovieClip;
		
		public function TrapCrush() {
			
			itemType = "trap";
			trapType = "crush";
			reversePlay = false;
			isOn = true;
			
			
		}

	}
	
}
