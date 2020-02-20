package com.nicktaras  {
	
	import com.nicktaras.level.*;
	import com.nicktaras.gameMenu.GameMenu;
	import com.nicktaras.hud.GameDisplay;
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.utils.*;
	import flash.geom.Rectangle;
	
	public class Game extends MovieClip {
	
		public var levelClass;
		public var level_mc:MovieClip;
		private var levelPrefix:String = "com.nicktaras.level." //level classes path prefix
		public var livesNum; // players lives
		public var scoreNum; //players score
		public var currLevel; //current game level 
		public var hud_mc:MovieClip; // the hud_mc on stage
		public var gameDisplay_mc:MovieClip; // the gameDisplay_mc on stage
		public var gamePopUp_mc:MovieClip; // the game pop up display on stage
		public var levelContainer:MovieClip; // levelContainer on stage
		public var gameMenuContainer:MovieClip; // gameMenuContainer on stage
		public static var _instance:Game; // instance of the Game Class
		public static var deviceSize:Rectangle; // Device size rectangle
		
		/* 
		FUNCTION: Game 
		PURPOSE: sets up initial vars
		*/
		public function Game(){
			livesNum = 3;
			scoreNum = 0;
			currLevel = 1;
			_instance = this;
			deviceSize = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			initGameMenu();
		}
		
		public function quitGame(){
			hud_mc.gameDisplay_mc.visible = false;
			hud_mc.gamePopUp_mc.visible = false;
			removeLevel();
			gameMenuContainer.initGameMenu();
			saveProgress();
		}
		
		public function saveProgress(){
			//trace("save level");
		}
		
		/* 
		FUNCTION: initGameMenu 
		PURPOSE: initializes main game menu
		*/
		public function initGameMenu(){
			gameMenuContainer.initGameMenu();
		}
		
		/* 
		FUNCTION: initGame 
		PURPOSE: initializes the level and in game display interface
		*/
		public function initGame(){
			initLevel();
			initGameDisplayMenu();
		}
		
		/* 
		FUNCTION: pauseGame 
		PURPOSE: pause the game
		*/
		public function pauseGame(){
			level_mc.pauseGame();
			hud_mc.gamePopUp_mc.initGamePopUp();
		}
		
		/* 
		FUNCTION: unPauseGame 
		PURPOSE: un pause the game
		*/
		public function unPauseGame(){
			level_mc.unPauseGame();
			hud_mc.gamePopUp_mc.visible = false;
		}
		
		/* 
		FUNCTION: initGameDisplayMenu 
		PURPOSE: initializes the game display menu
		*/
		public function initGameDisplayMenu(){
			hud_mc.gameDisplay_mc.initGameDisplay();
		}
		
		/* 
		FUNCTION: initLevel 
		PURPOSE: adds and initializes a level into the game
		*/
		public function initLevel(){
			levelClass = getDefinitionByName(levelPrefix+"Level"+currLevel) as Class;
			level_mc = new levelClass();
			level_mc.name = "level_mc";
			levelContainer.addChild(level_mc);
			level_mc.initGame();
			
			//levelClass = new Level1;
			//addChild(levelClass);
			
		}
		
		/* 
		FUNCTION: removeLevel 
		PURPOSE: removes level from the game
		*/
		public function removeLevel(){
			var currLevel = levelContainer.getChildAt(0);
			levelContainer.removeChild(currLevel);
		}
		
		/* 
		returns an instance of the game class
		*/
		public static function get instance():Game { 
   			return _instance; 
  		}
		
		/* 
		FUNCTION: retryGameLevel 
		PURPOSE: retry the level
		*/
		public function retryGameLevel(){
			removeLevel();
			initLevel();
			hud_mc.gameDisplay_mc.initGameDisplay();
			hud_mc.gamePopUp_mc.visible = false;
			return; 
		}
		
		/* 
		FUNCTION: levelComplete 
		PURPOSE: handles the level completion
		*/
		public function levelComplete(){
			currLevel++;
			removeLevel();
			initLevel();
			hud_mc.gameDisplay_mc.initGameDisplay();
			return; 
		}

	}
	
}
