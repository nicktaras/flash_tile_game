package com.nicktaras.enemy {
	
	import flash.display.MovieClip;
	
	public class EnemyXY extends Enemy {

		public function EnemyXY() {
			// constructor code
			speed = 2;
			ai = "simpleXY";
			projectiles = "none";
			attackType = "touch_of_death";
			currFacingDir = "left";
			freeze = false;
			crazy = false;
			canFire = false;
			isFiring = false;
			bulletDir;
		}

	}
	
}
