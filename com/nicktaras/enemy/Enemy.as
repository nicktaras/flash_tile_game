package com.nicktaras.enemy  {
	
	import flash.display.MovieClip;
	
	public class Enemy extends MovieClip{

		public var speed:Number;
		public var ai:String;
		public var projectiles:String;
		public var attackType:String;
		public var currFacingDir:String;
		public var freeze:Boolean;
		public var canFire:Boolean;
		public var isFiring:Boolean;
		public var crazy:Boolean;
		public var bulletDir:String;
		
		public function Enemy() {
			// constructor code
		}

	}
	
}
