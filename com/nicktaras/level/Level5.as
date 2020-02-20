package com.nicktaras.level {
	
	import flash.display.MovieClip;
	
	public class Level5 extends Level {
		
		public var trapCrush1_mc:MovieClip;
		public var trapCrush2_mc:MovieClip;
		public var trapCrush3_mc:MovieClip;
		public var trapCrush4_mc:MovieClip;
		public var trapCrush5_mc:MovieClip;
		public var trapCrush6_mc:MovieClip;
		public var trapCrush7_mc:MovieClip;
		public var trapCrush8_mc:MovieClip;
		public var trapCrush9_mc:MovieClip;
		public var trapCrush10_mc:MovieClip;
		public var trapCrush11_mc:MovieClip;
		public var trapCrush12_mc:MovieClip;
		public var trapCrush13_mc:MovieClip;
		public var trapCrush14_mc:MovieClip;
		
		// constructor code
		public function Level5() {
						
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
			addInteractiveObject(trapCrush1_mc);
			addInteractiveObject(trapCrush2_mc);
			addInteractiveObject(trapCrush3_mc);
			addInteractiveObject(trapCrush4_mc);
			addInteractiveObject(trapCrush5_mc);
			addInteractiveObject(trapCrush6_mc);
			addInteractiveObject(trapCrush7_mc);
			addInteractiveObject(trapCrush8_mc);
			
			//offset
			addInteractiveObject(trapCrush9_mc);
			addInteractiveObject(trapCrush10_mc);
			addInteractiveObject(trapCrush11_mc);
			addInteractiveObject(trapCrush12_mc);
			addInteractiveObject(trapCrush13_mc);
			addInteractiveObject(trapCrush14_mc);
			
			for(var i = 9; i <= 14; i++){
				this["trapCrush"+i+"_mc"].gotoAndPlay(65);
			}
			
		}
		
		public function addSpecial(){
			
		}
		
		public function addInteractiveObjects(){
		
		}
		
		public function addBonusItems(){}
		
		
	}
	
}
