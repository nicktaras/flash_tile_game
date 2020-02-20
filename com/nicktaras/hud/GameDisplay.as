package com.nicktaras.hud  {
	
	import com.nicktaras.Game;
	import com.nicktaras.level.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class GameDisplay extends MovieClip{
		
		public var pause_mc:MovieClip;
		public var lives_txt:TextField;
		public var level_txt:TextField;
		public var score_txt:TextField;
	
		public function GameDisplay() {
			// constructor code
			this.visible = false;
			addMenuListeners(pause_mc);
		}
		
		public function addMenuListeners(mc:MovieClip){
			mc.addEventListener(MouseEvent.CLICK, menuClickHandler);
		}
				
		public function menuClickHandler(e:MouseEvent){
			Game.instance.pauseGame();
		}
		
		public function initGameDisplay(){
			this.visible = true;
			lives_txt.htmlText = "Lives: " + Game.instance.livesNum;
			level_txt.htmlText = "Level: " + Game.instance.currLevel;
			score_txt.htmlText = "Score: " + Game.instance.scoreNum;
			
		}

	}
	
}
