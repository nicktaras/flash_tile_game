package com.nicktaras.level {
	
	import flash.display.MovieClip;
	
	public class Level1 extends Level {
		
		// constructor code
		public function Level1() {
						
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
			
		}
		
		public function addInteractiveObjects(){
			
		}
		
		public function addBonusItems(){
			
		}
		
		
	}
	
}
