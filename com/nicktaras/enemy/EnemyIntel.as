package com.nicktaras.enemy {
	
	import flash.display.MovieClip;
	
	public class EnemyIntel extends Enemy {

		public function EnemyIntel() {
			// constructor code
			speed = 2;
			ai = "intel";
			projectiles = "none";
			attackType = "touch_of_death";
			currFacingDir = "";
			freeze = false;
			
		}

	}
	
}
