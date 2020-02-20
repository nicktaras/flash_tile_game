package com.nicktaras.enemy {
	
	import flash.display.MovieClip;
	
	public class EnemyX extends Enemy {
		
		public function EnemyX() {
			// constructor code
			//trace("enemy found");
			
			speed = 2;
			ai = "simpleX";
			projectiles = "none";
			attackType = "touch_of_death";
			currFacingDir = "left";
			freeze = false;
			crazy = false;
			canFire = false;
			isFiring = false;
			
		}

	}
	
}
