package com.nicktaras.level {
	
	import flash.display.MovieClip;
	
	public class Level9 extends Level {
		
		public var enemy1_mc:MovieClip;
		public var enemy2_mc:MovieClip;
		public var lock1_mc:MovieClip;
		public var key1_mc:MovieClip;
		public var apple1_mc:MovieClip;
		public var jump1_mc:MovieClip;
		public var trap1_mc:MovieClip;
		public var trap2_mc:MovieClip;
		public var extraLife1_mc:MovieClip;
		
		// constructor code
		public function Level9() {
						
			addEnemies();
			addInteractiveObjects();
			addBonusItems();
			addTraps();
			addSpecial();
			initPlayer();
			
		}
		
		public function initPlayer(){
			
			player_mc.speedNum = player_mc.speedNum;
			player_mc.canMoveUp = true;
			player_mc.canMoveDown = true;
			player_mc.canMoveLeft = true;
			player_mc.canMoveRight = true;
			player_mc.dirToMove = "horizontal" // only move in one direction at a time //
			
		}
		
		public function addEnemies(){
			
			addEnemy(enemy1_mc);
			addEnemy(enemy2_mc);
			
		}
		
		public function addTraps(){
			addInteractiveObject(trap1_mc);
			addInteractiveObject(trap2_mc);
		}
		
		public function addSpecial(){
			addInteractiveObject(jump1_mc);
		}
		
		public function addInteractiveObjects(){
			
			addInteractiveObject(extraLife1_mc);
			addInteractiveObject(lock1_mc);
			addInteractiveObject(key1_mc);
			addInteractiveObject(apple1_mc);
			
		}
		
		public function addBonusItems(){}
		
		
	}
	
}
