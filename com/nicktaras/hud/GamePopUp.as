package com.nicktaras.hud  {
	
	import com.nicktaras.Game;
	import com.nicktaras.level.*;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class GamePopUp extends MovieClip{
				
		public var continue_mc:MovieClip;
		public var retry_mc:MovieClip;
		public var settings_mc:MovieClip;
		public var quit_mc:MovieClip;
				
		public function GamePopUp() {
			// constructor code
			this.visible = false;
			initbuttons();
		}
		
		public function initGamePopUp(){
			this.visible = true;
			
			continue_mc.txt.htmlText = "Continue";
			retry_mc.txt.htmlText = "Retry";
			settings_mc.txt.htmlText = "Game Settings";
			quit_mc.txt.htmlText = "Quit";
			
		}
		
		public function addMenuListeners(mc:MovieClip){
			mc.addEventListener(MouseEvent.CLICK, menuClickHandler);
		}
		
		public function removeMenuListeners(mc:MovieClip){
			mc.removeEventListener(MouseEvent.CLICK, menuClickHandler);
		}
		
		public function initbuttons(){
			addMenuListeners(continue_mc);
			addMenuListeners(retry_mc);
			addMenuListeners(settings_mc);
			addMenuListeners(quit_mc);
		}
		
		public function quitGame(){
			Game.instance.quitGame();
		}
		
		public function menuClickHandler(e:MouseEvent){
			if(e.currentTarget.name == "continue_mc"){
				Game.instance.unPauseGame();
			} else if(e.currentTarget.name == "retry_mc"){
				Game.instance.retryGameLevel();
			} else if(e.currentTarget.name == "settings_mc"){
				trace("open settings");
			} else if(e.currentTarget.name == "quit_mc"){
				quitGame();
			}
		}

	}
	
}
