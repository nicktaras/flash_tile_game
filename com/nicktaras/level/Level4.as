package com.nicktaras.level {
	
	import flash.display.MovieClip;
	
	public class Level4 extends Level {
		
		public var jump1_mc:MovieClip;
		public var jump2_mc:MovieClip;
		public var jump3_mc:MovieClip;
		
		// constructor code
		public function Level4() {
						
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
			
		}
		
		public function addTraps(){
			
		}
		
		public function addSpecial(){
			addInteractiveObject(jump1_mc);
			addInteractiveObject(jump2_mc);
			addInteractiveObject(jump3_mc);
		}
		
		public function addInteractiveObjects(){
			
		}
		
		public function addBonusItems(){}
		
		
	}
	
}
