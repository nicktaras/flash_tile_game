package com.nicktaras.enemy {
	
	import flash.display.MovieClip;
	
	public class EnemyY extends Enemy{
		
		public function EnemyY() {
			// constructor code
			//trace("enemy found");
			
			speed = 2;
			ai = "simpleY";
			projectiles = "none";
			attackType = "touch_of_death";
			currFacingDir = "up";
			freeze = false;
			crazy = false;
			canFire = false;
			isFiring = false;
			
		}

	}
	
}
