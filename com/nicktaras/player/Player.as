package com.nicktaras.player  {
	
	import flash.display.MovieClip;
	import caurina.transitions.Tweener;
	
	public class Player extends MovieClip {
		
		public var playerX:Number = 0;
		public var playerY:Number = 0;
		public var canMove:Boolean = true;
		public var speedNum:Number = 50;
		public var wayFindToX:Number;
		public var wayFindToY:Number;
		public var canMoveUp:Boolean = true;
		public var canMoveDown:Boolean = true;
		public var canMoveLeft:Boolean = true;
		public var canMoveRight:Boolean = true;
		public var dirToMove:String = "horizontal" // only move in one direction at a time //
		public var distX:Number;
		public var distY:Number;
		public var timeOverDist:Number;
		public var isMovingDir:String = "";
		public var moveToblockArrayX:Array = []; // when the user slides their finger over available blocks it collects the x value of the selected block 
		public var moveToblockArrayY:Array = []; // when the user slides their finger over available blocks it collects the y value of the selected block
		public var lastSafePointX:Number = 0;
		public var lastSafePointY:Number = 0;

		public function Player() {
			// constructor code
		}
				
		/* 
		FUNCTION: safePoint 
		PURPOSE: move the player_mc back to the last safe point (playable point) they were in
		*/
		public function safePoint(pX:Number, pY:Number) {
			
			lastSafePointX = pX;
			lastSafePointY = pY;
			canMove = true;
			
		}
		
		/* 
		FUNCTION: spawn 
		PURPOSE: places the player_mc back to the start of the level
		*/
		public function spawn(beginX:Number, beginY:Number, beginWidth:Number, beginHeight:Number){
		
			this.x = beginX + (beginWidth/2);
			this.y = beginY + (beginHeight/2);
			wayFindToX = beginX + (beginWidth/2);
			wayFindToY = beginY + (beginHeight/2);
		
		}
		
		/* 
		FUNCTION: setDirToMove 
		PURPOSE: this determines the direction the user wants to move in.
		CONDITIONALS: if the distance is greater in one co-ordinate rather than another (X/Y), it will be set to move that way.
		*/
		public function setDirToMove(){
			
			if(distX <= distY){ // vertical
				dirToMove = "vertical";
			} else { // horizontal
				dirToMove = "horizontal";
			} 
		}
		
		/* 
		FUNCTION: enableBoundaries 
		PURPOSE: enables player to move through boundaries
		CONDITIONALS: none
		*/
		public function enableBoundaries(boundariesBoo:Boolean, boundariesOn:Boolean){
			if(boundariesBoo){
				canMove = true;
				boundariesOn = true;
			} else {
				canMove = false;
				boundariesOn = false;
			}
			return boundariesOn;
		}
		
		/* 
		FUNCTION: enablePlayToMove 
		PURPOSE: allows the player to move in all directions again
		*/
		function enablePlayToMove(){
			canMoveUp = true;
			canMoveDown = true;
			canMoveLeft = true;
			canMoveRight = true;
		}
		
		public function scaleUp(){
			this.scaleX = 1.5;
			this.scaleY = 1.5;
		}
		
		//public function scaleBack(){
			//Tweener.addTween(this, {scaleX:1, scaleY:1, time:0.5, transition:"EaseInOut", onComplete:player_mc.enableBoundaries, onCompleteParams:[true,boundariesOn]});
		//}

	}
	
}
