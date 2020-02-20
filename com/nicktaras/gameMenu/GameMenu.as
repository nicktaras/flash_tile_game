package com.nicktaras.gameMenu  {
	
	import com.nicktaras.Game;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	public class GameMenu extends MovieClip{
		
		public var title_mc:MovieClip;
		public var start_mc:MovieClip;
		public var levels_mc:MovieClip;
		public var settings_mc:MovieClip;
		public var menuButtonArray:Array;
		public var menuButtonNameArray:Array = ["start", "levels", "settings"];
		public var initButtonPosY:Number;
		public var initLogoPosY:Number;
		
		public function GameMenu() {} /* constructor code */
		
		public function initGameMenu(){
			menuButtonArray = [start_mc, levels_mc, settings_mc];
			addGameMenuOptions();
			centerAlignObj(title_mc);
		}
		
		public function addGameMenuOptions(){
		
			for(var i:Number = 0; i < menuButtonArray.length; i++){
				
				centerAlignObj(menuButtonArray[i]);
				menuButtonArray[i].txt.htmlText = menuButtonNameArray[i];
				addMenuListeners(menuButtonArray[i]);
				menuButtonArray[i].visible = true;
			}
			
			title_mc.visible = true;
			
		}
				
		public function centerAlignObj(mc:MovieClip){
			mc.x = Game.deviceSize.width/2 - mc.width/2;
		}
		
		public function addMenuListeners(mc:MovieClip){
			mc.addEventListener(MouseEvent.CLICK, menuClickHandler);
		}
		
		public function removeMenuListeners(mc:MovieClip){
			mc.removeEventListener(MouseEvent.CLICK, menuClickHandler);
		}
		
		private function showGameMenu(){
			initGameMenu();
		}
		
		private function hideGameMenu(){
			for(var i:Number = 0; i < menuButtonArray.length; i++){
				menuButtonArray[i].visible = false;
				removeMenuListeners(menuButtonArray[i]);
			}
			title_mc.visible = false;
		}
		
		public function menuClickHandler(e:MouseEvent){
			if(e.currentTarget.name == menuButtonArray[0].name){
				Game.instance.initGame();
				hideGameMenu();
			} else if(e.currentTarget.name == menuButtonArray[1].name){
				trace("show levels");
			} else if(e.currentTarget.name == menuButtonArray[2].name){
				trace("show settings");
			}
		}

	}
	
}
