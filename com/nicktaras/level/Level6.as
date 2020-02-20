package com.nicktaras.level {
	
	import flash.display.MovieClip;
	
	public class Level6 extends Level {
		
		public var enemy1_mc:MovieClip;
		public var enemy2_mc:MovieClip;
		public var enemy3_mc:MovieClip;
		
		public var extraLife1_mc:MovieClip;
		
		// constructor code
		public function Level6() {
						
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
			addEnemy(enemy3_mc);
			
		}
		
		public function addTraps(){
		}
		
		public function addSpecial(){
			
		}
		
		public function addInteractiveObjects(){
			
			addInteractiveObject(extraLife1_mc);
			extraLife1_mc.mouseEnabled=false;

			
		}
		
		public function addBonusItems(){}
		
		
	}
	
}
