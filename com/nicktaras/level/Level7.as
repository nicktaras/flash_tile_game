package com.nicktaras.level {
	
	import flash.display.MovieClip;
	
	public class Level7 extends Level {
		
		public var enemy1_mc:MovieClip;
		public var trap1_mc:MovieClip;
		public var trap2_mc:MovieClip;
		
		// constructor code
		public function Level7() {
						
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
			
		}
		
		public function addTraps(){
			addInteractiveObject(trap1_mc);
			addInteractiveObject(trap2_mc);
		}
		
		public function addSpecial(){
			
		}
		
		public function addInteractiveObjects(){
		
			
		}
		
		public function addBonusItems(){}
		
		
	}
	
}
