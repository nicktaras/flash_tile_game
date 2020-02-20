package com.nicktaras.level {
	
	import com.nicktaras.Game;
	import com.nicktaras.Levels;
	import com.nicktaras.player.Player;
	import com.nicktaras.PointBurst;
	import caurina.transitions.Tweener;
	
	import flash.display.Stage;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.nicktaras.collectable.Bonus;
	
	public class Level extends MovieClip {
		
		public var playMode:Boolean = true; // when the game can be played
		public var wallObjectsArray = new Array(); // for storing all of the wall boundaries 
		public var interactiveObjects = new Array(); // for storing all of the collectable objects inside the level
		public var levelItemCollectionArray = new Array(); // for pushing things which will be useful in the level only, empties each level
		public var gameCollectionArray = new Array(); // for pushing items in which the player will keep level to level e.g. skills / weapons.
		public var enemiesArray = new Array (); // push each enemy into this array
		public var player_mc:MovieClip;
		public var begin_mc:MovieClip;
		public var end_mc:MovieClip;
		public var playerTween;
		public var trapBridgeHit:Boolean = false; // if a trap bridge has been collided with in game //
		public var trapBridgeX:Number;
		public var trapBridgeY:Number;
		public var speedNumberdefault:Number;
		public var boundariesOn:Boolean = true;
		
		/* constructor code */ 
		public function Level() {
			player_mc.safePoint(player_mc.x, player_mc.y);
			buildLevel();
		}
		
		/* 
		FUNCTION: pauseGame 
		PURPOSE: pause the game
		*/
		public function pauseGame(){
			playMode = false;
			for(var i:int = 0; i < interactiveObjects.length; i++) {
				interactiveObjects[i].stop();
			}
		}
				
		/* 
		FUNCTION: unPauseGame 
		PURPOSE: un pause the game
		*/
		public function unPauseGame(){
			playMode = true;
			for(var i:int = 0; i < interactiveObjects.length; i++) {
				interactiveObjects[i].play();
			}
		}
		
		/* 
		FUNCTION: initGame 
		PURPOSE: called at the start of each level, it triggers the fundamental methods to set up the stage.
		*/
		public function initGame(){

			speedNumberdefault =  player_mc.speedNum;
			//empty arrays//
			initBoundaries(); // set boundaries
			player_mc.spawn(begin_mc.x, begin_mc.y, begin_mc.width, begin_mc.height); // spawn player
			
			addEventListener(MouseEvent.MOUSE_DOWN, addWayFinder); // add game listeners
			addEventListener(Event.ENTER_FRAME, wayFinder); 
			
		}
		 
		/* 
		FUNCTION: clearLevelData 
		PURPOSE: Clear the arrays used inside the level where they are not needed
		*/
		public function clearLevelData(){
			levelItemCollectionArray = [];
			interactiveObjects = [];
			enemiesArray = [];
			wallObjectsArray = []; 	
		}
		
		public function buildLevel(){
			
			trace("lets build the level here");
			trace("This is level" + Game.instance.currLevel);
			trace("This is level" + Game.instance.currLevel);
			
		}
	
		/* 
		FUNCTION: initBoundaries 
		PURPOSE: pushes all of the levels wall boundaries into an array object
		*/
		public function initBoundaries(){
			
			for(var i:int = 0; i < this.numChildren; i++) {
				
				var mc = this.getChildAt(i);
				
				if (mc is Wall || mc is HiddenWall || mc is TrapBridge || mc is FinishBlock) {
					
					var wallObject:Object = new Object();
						wallObject.inst = i;
						wallObject.name = "mc"+i;
						wallObject.width = mc.width;
						wallObject.height = mc.height;
						wallObject.leftside = mc.x;
						wallObject.rightside = mc.x+mc.width;
						wallObject.topside = mc.y;
						wallObject.bottomside = mc.y+mc.height;
						
						if(mc is Wall || mc is HiddenWall){
							wallObject.name = "Wall";
						}
						if(mc is TrapBridge){
							wallObject.name = "TrapBridge";
						}
						if(mc is HiddenWall){
							mc.visible = false;
						}
						wallObjectsArray.push(wallObject);
				}
			}
		}
	
		/* 
		FUNCTION: addWayFinder 
		PURPOSE: saves the requested position of where the user wants to move the player_mc to
		CONDITIONALS: gameMode must be "play" and the user must be selecting a paht object to move
		*/
		public function addWayFinder(e:MouseEvent) {
			
			var mc = e.target;
			
			if (mc is Wall || mc is HiddenWall|| mc is TrapBridge) {
				
				//don't move player
				trace("don't move");
				
			} else if(mc is Path || e.target.name == "end_mc" || e.target.name == "begin_mc") {
				
				if(player_mc.canMove == true){
				
					// work out if the player wants to move forwards or backwards
					if(player_mc.x > e.target.x && e.target.x){
						
						player_mc.distX = Math.abs(player_mc.x - e.target.x); 
						player_mc.timeOverDist = 20;//Math.abs(player_mc.x - e.target.x);
						
					} else if(player_mc.x < e.target.x){
						
						player_mc.distX = Math.abs(player_mc.x + e.target.x);
						player_mc.timeOverDist = 20;//Math.abs(player_mc.x - e.target.x);
						
					}
					
					// work out if the player wants to move up or down
					if(player_mc.y > e.target.y){
						
						player_mc.distY = Math.abs(player_mc.y - e.target.y);
						player_mc.timeOverDist = 20;//Math.abs(player_mc.x - e.target.x);
						
					} else if(player_mc.y < e.target.y){
						
						player_mc.distY = Math.abs(player_mc.y + e.target.y); 
						player_mc.timeOverDist = 20;//Math.abs(player_mc.x - e.target.x);
						
					}
					
					player_mc.wayFindToY = e.target.y + wallObjectsArray[0].height/2;
					player_mc.wayFindToX = e.target.x + wallObjectsArray[0].width/2;
					
					player_mc.setDirToMove();
					movePlayer();
					
				}
			}
			
		}
		
		/* 
		FUNCTION: checkPlayerAndEnemyInteraction 
		PURPOSE: checks if the player or the enemies have interated with any objects on stage
		*/
		public function checkPlayerAndEnemyInteraction(){
			
			if(boundariesOn){
				checkWallCollisions();
				checkItemCollisions();
				checkIfAtDestination();
			}
			
			checkPlayerEnemyCollisions();
			checkComplete();
			checkEnemyItemCollisions();
			checkEnemyCollisions();
			showDown();

		}
		
		/* 
		FUNCTION: movePlayer 
		PURPOSE: move the player to users requested position
		CONDITIONALS: the player has to be allowed to move in the requested direction from its namespace values
		*/
		public function movePlayer(){
			
			if(player_mc.dirToMove == "vertical"){
				
				if(player_mc.y < player_mc.wayFindToY && player_mc.canMoveDown){
					player_mc.isMovingDir = "down";
					player_mc.rotation = 180;
				} 
				if(player_mc.y > player_mc.wayFindToY && player_mc.canMoveUp){
					player_mc.isMovingDir = "up";
					player_mc.rotation = 0;
				}
			}
			
			if(player_mc.dirToMove == "horizontal"){
				
				if(player_mc.x < player_mc.wayFindToX && player_mc.canMoveRight){
					player_mc.isMovingDir = "right";
					player_mc.rotation = 90;
				} 
				if(player_mc.x > player_mc.wayFindToX && player_mc.canMoveLeft){
					player_mc.isMovingDir = "left";
					player_mc.rotation = -90;
				}
			}
			
			if(player_mc.dirToMove == "vertical"){
				player_mc.canMove = false;
				playerTween = Tweener.addTween(player_mc, {y:player_mc.wayFindToY, x:player_mc.x, time:player_mc.timeOverDist/player_mc.speedNum, transition:"linear", onComplete:player_mc.safePoint, onCompleteParams:[player_mc.x, player_mc.y]});
			} 
			if(player_mc.dirToMove == "horizontal"){
				playerTween = Tweener.addTween(player_mc, {x:player_mc.wayFindToX, y:player_mc.y, time:player_mc.timeOverDist/player_mc.speedNum, transition:"linear", onComplete:player_mc.safePoint, onCompleteParams:[player_mc.x, player_mc.y]});
				player_mc.canMove = false;
			}
				
		}
		
		/*public function safePoint(){
			
			player_mc.lastSafePointX = player_mc.x;
			player_mc.lastSafePointY = player_mc.y;
			player_mc.canMove = true;
			
			if(trapBridgeHit){
				
				var newBlock:Wall = new Wall();
				newBlock.x = trapBridgeX;
				newBlock.y = trapBridgeY;
				addChild(newBlock);
				
				initBoundaries();
				trapBridgeHit = false;
				
			}

		}*/
		
		/* 
		FUNCTION: moveEnemy 
		PURPOSE: move enemies around the stage 
		CONDITIONALS: based on the enemy class configuration
		*/
		public function moveEnemy(){
			
			for(var j:int = 0; j < enemiesArray.length; j++) {
				for(var i:int = 0; i < wallObjectsArray.length; i++) {
					
					if(enemiesArray[j].ai == "simpleX" || enemiesArray[j].ai == "simpleXY"){
						
						if(enemiesArray[j].y > wallObjectsArray[i].topside && enemiesArray[j].y < wallObjectsArray[i].bottomside){
							//left
							if(enemiesArray[j].currFacingDir == "left"){
								if(enemiesArray[j].x - enemiesArray[j].speed - wallObjectsArray[i].width/2 > wallObjectsArray[i].leftside && enemiesArray[j].x - enemiesArray[j].speed - wallObjectsArray[i].width/2 < wallObjectsArray[i].rightside){
									
									if(enemiesArray[j].ai == "simpleX"){
										reverseEnemyDirection(j);
									}
									if(enemiesArray[j].ai == "simpleXY"){
										randomiseEnemyDirection(j);
									}
									if(enemiesArray[j].crazy){
										randomiseEnemySpeed(j);
									}
									
								}
							} else if(enemiesArray[j].currFacingDir == "right"){
								if(enemiesArray[j].x + enemiesArray[j].speed + wallObjectsArray[i].width/2 > wallObjectsArray[i].leftside && enemiesArray[j].x + enemiesArray[j].speed  + wallObjectsArray[i].width/2 < wallObjectsArray[i].rightside){
									
									if(enemiesArray[j].ai == "simpleX"){
										reverseEnemyDirection(j);
									}
									if(enemiesArray[j].ai == "simpleXY"){
										randomiseEnemyDirection(j);
									}
									if(enemiesArray[j].crazy){
										randomiseEnemySpeed(j);
									}
									
								}
							}
						}
					}
					
					if(enemiesArray[j].ai == "simpleY" || enemiesArray[j].ai == "simpleXY"){
						if(enemiesArray[j].x > wallObjectsArray[i].leftside && enemiesArray[j].x < wallObjectsArray[i].rightside){
							//up
							if(enemiesArray[j].currFacingDir == "up"){
								if(enemiesArray[j].y - enemiesArray[j].speed - wallObjectsArray[i].height/2 > wallObjectsArray[i].topside && enemiesArray[j].y - enemiesArray[j].speed  - wallObjectsArray[i].height/2 < wallObjectsArray[i].bottomside){
									
									if(enemiesArray[j].ai == "simpleY"){
										reverseEnemyDirection(j);
									}
									if(enemiesArray[j].ai == "simpleXY"){
										randomiseEnemyDirection(j);
									}
									if(enemiesArray[j].crazy){
										randomiseEnemySpeed(j);
									}
									
								}
							} else if(enemiesArray[j].currFacingDir == "down"){
								if(enemiesArray[j].y + enemiesArray[j].speed + wallObjectsArray[i].height/2 > wallObjectsArray[i].topside && enemiesArray[j].y + enemiesArray[j].speed + wallObjectsArray[i].height/2 < wallObjectsArray[i].bottomside){
									
									if(enemiesArray[j].ai == "simpleY"){
										reverseEnemyDirection(j);
									}
									if(enemiesArray[j].ai == "simpleXY"){
										randomiseEnemyDirection(j);
									}
									if(enemiesArray[j].crazy){
										randomiseEnemySpeed(j);
									}
									
								}
							}
						}
					}
				}
			}
			moveEnemyDir();
		}
		
		public function randomiseEnemySpeed(inst:Number){
			var randomSpeedNum:Number = Math.floor(Math.random()*3)+3;
			enemiesArray[inst].speed = randomSpeedNum;
		}
		
		public function randomiseEnemyDirection(inst:Number){
			
			var upBoo:Boolean = true;
			var downBoo:Boolean = true;
			var leftBoo:Boolean = true;
			var rightBoo:Boolean = true;
			var availableDirections = [];
			
			for(var i:int = 0; i < wallObjectsArray.length; i++) {
								
				if(enemiesArray[inst].y > wallObjectsArray[i].topside && enemiesArray[inst].y < wallObjectsArray[i].bottomside){
					
					//check right hit
					if(enemiesArray[inst].x - enemiesArray[inst].speed + wallObjectsArray[i].width > wallObjectsArray[i].leftside && enemiesArray[inst].x - enemiesArray[inst].speed + wallObjectsArray[i].width < wallObjectsArray[i].rightside){
						rightBoo = false;
					}
				
					//check left hit
					if(enemiesArray[inst].x + enemiesArray[inst].speed - wallObjectsArray[i].width > wallObjectsArray[i].leftside && enemiesArray[inst].x + enemiesArray[inst].speed - wallObjectsArray[i].width < wallObjectsArray[i].rightside){
						leftBoo = false;
					} 
				}
				
				if(enemiesArray[inst].x > wallObjectsArray[i].leftside && enemiesArray[inst].x < wallObjectsArray[i].rightside){
					
					//check right hit
					if(enemiesArray[inst].y - enemiesArray[inst].speed + wallObjectsArray[i].height > wallObjectsArray[i].bottomside && enemiesArray[inst].y - enemiesArray[inst].speed + wallObjectsArray[i].height < wallObjectsArray[i].topside){
						upBoo = false;
					}
				
					//check left hit
					if(enemiesArray[inst].y + enemiesArray[inst].speed - wallObjectsArray[i].height > wallObjectsArray[i].bottomside && enemiesArray[inst].y + enemiesArray[inst].speed - wallObjectsArray[i].height < wallObjectsArray[i].topside){
						downBoo = false;
					} 
				}

			}
			
			if(leftBoo){
				availableDirections.push("left");
			}
			if(rightBoo){
				availableDirections.push("right");
			}
			if(upBoo){
				availableDirections.push("up");
			}
			if(downBoo){
				availableDirections.push("down");
			}
			
			//select random direction//
			var randomDirectionNum:Number = Math.floor(Math.random()*availableDirections.length);
			enemiesArray[inst].currFacingDir = availableDirections[randomDirectionNum];
			enemyCorrectCoords(inst);
			//*/
		}
		
		public function moveEnemyDir(){
			
			for(var j = 0; j < enemiesArray.length; j++) {
				if(!enemiesArray[j].freeze){
					if(enemiesArray[j].currFacingDir == "right"){
						enemiesArray[j].x += enemiesArray[j].speed;
						enemiesArray[j].rotation = 180;
					} 
					if(enemiesArray[j].currFacingDir == "left"){
						enemiesArray[j].x -= enemiesArray[j].speed;
						enemiesArray[j].rotation = 0;
					} 
					if(enemiesArray[j].currFacingDir == "up"){
						enemiesArray[j].y -= enemiesArray[j].speed;
						enemiesArray[j].rotation = 90;
					} 
					if(enemiesArray[j].currFacingDir == "down"){
						enemiesArray[j].y += enemiesArray[j].speed;
						enemiesArray[j].rotation = -90;
					}
				}
			}
			
		}
		
		/* 
		FUNCTION: showDown 
		PURPOSE: showdown time, shoot at player
		CONDITIONALS: if the enemy can fire, and they are inline with the player
		*/
		public function showDown(){
			
			for(var j:int = 0; j < enemiesArray.length; j++) {
				
				if(!enemiesArray[j].isFiring && enemiesArray[j].canFire){
					
					//if the player is within range of the player// to come later.
					
					if(enemiesArray[j].y >= player_mc.y - wallObjectsArray[0].height/2 && enemiesArray[j].y <= player_mc.y + wallObjectsArray[0].height/2){
						
						if(enemiesArray[j].currFacingDir == "left" && player_mc.x < enemiesArray[j].x){
							//trace("can fire left");
							enemyCreateBullet(j,"left");
						}
						if(enemiesArray[j].currFacingDir == "right" && player_mc.x > enemiesArray[j].x){
							//trace("can fire right");
							enemyCreateBullet(j,"right");
						}
						
					}
					
					if(enemiesArray[j].x >= player_mc.x - wallObjectsArray[0].width/2 && enemiesArray[j].x <= player_mc.x + wallObjectsArray[0].width/2){
						
						if(enemiesArray[j].currFacingDir == "up" && player_mc.y < enemiesArray[j].y){
							//trace("can fire up");
							enemyCreateBullet(j,"up");
						}
						if(enemiesArray[j].currFacingDir == "down" && player_mc.y > enemiesArray[j].y){
							//trace("can fire down");
							enemyCreateBullet(j,"down");
						}
						
					}
					
				}
			}
		}
		
		/* 
		FUNCTION: enemyFire 
		PURPOSE: create bullet
		CONDITIONALS: these are sent to the next function enemyFire
		*/
		public function enemyCreateBullet(inst:Number,dir:String){

			var bullet:Bullet = new Bullet();
				bullet.x = enemiesArray[inst].x;
				bullet.y = enemiesArray[inst].y;
				enemiesArray[inst].bulletDir = dir;
				bullet.name = "bullet"+inst;
				addChild(bullet);
				
			enemiesArray[inst].isFiring = true;
			
		}
	
		public function bulletTrain(){
			
			for(var j:int = 0; j < enemiesArray.length; j++) {
				
				if(enemiesArray[j].isFiring){
					
					if(enemiesArray[j].bulletDir == "left"){
						getChildByName("bullet"+j).rotation = 180;
						getChildByName("bullet"+j).x -= enemiesArray[j].speed*2;
					}
					if(enemiesArray[j].bulletDir == "right"){
						getChildByName("bullet"+j).rotation = 0;
						getChildByName("bullet"+j).x += enemiesArray[j].speed*2;
					}
					if(enemiesArray[j].bulletDir == "up"){
						getChildByName("bullet"+j).rotation = 270;
						getChildByName("bullet"+j).y -= enemiesArray[j].speed*2;
					}
					if(enemiesArray[j].bulletDir == "down"){
						getChildByName("bullet"+j).rotation = 90;
						getChildByName("bullet"+j).y += enemiesArray[j].speed*2;
					}
					
					if(player_mc.hitTestObject(MovieClip(getChildByName("bullet"+j)))){
						player_mc.spawn(begin_mc.x, begin_mc.y, begin_mc.width, begin_mc.height);
						playerRemoveLife();
						removeChild(MovieClip(getChildByName("bullet"+j)));
						enemiesArray[j].isFiring = false;
					}
					
				}
				
			}
			
		}
		
		/* 
		FUNCTION: wayFinder 
		PURPOSE: this is a core function in the game, it checks to see if the enemies have hit any wall objects on stage. 
		CONDITIONALS: if the distance is greater in one co-ordinate rather than another (X/Y), it will be set to move that way.
		*/
		public function wayFinder(e:Event){
			if(playMode){
				checkPlayerAndEnemyInteraction();
				moveEnemy();
				bulletTrain();
			}
		}
		
		public function checkIfAtDestination(){
			if(hasEventListener(Event.ENTER_FRAME)) {
				if(player_mc.dirToMove == "horizontal" && player_mc.x >= player_mc.wayFindToX - 20 && player_mc.x + player_mc.width <= player_mc.wayFindToX + 20) {
				} else if(player_mc.dirToMove == "vertical" && player_mc.y >= player_mc.wayFindToY - 20 && player_mc.y + player_mc.height <= player_mc.wayFindToY + 20) {
				}
			}
		}
		
		/* 
		FUNCTION: checkPlayerEnemyCollisions 
		PURPOSE: check if the enemy is hitting the player 
		CONDITIONALS: hittestObject
		*/
		public function checkPlayerEnemyCollisions(){
			for(var j:int = 0; j < enemiesArray.length; j++) {
				if(player_mc.hitTestObject(enemiesArray[j])){
					if(enemiesArray[j].attackType == "touch_of_death"){
						pauseGame();
						Game.instance.removeLevel();
						Game.instance.initLevel();
						playerRemoveLife();
					}
				}
			}
		}
		
		/* 
		FUNCTION: playerRemoveLife 
		PURPOSE: take a life from the player
		CONDITIONALS: check if the player has no lives left
		*/
		public function playerRemoveLife(){
			if(Game.instance.livesNum >= 1){
				Game.instance.livesNum --;
				Game.instance.initGameDisplayMenu();
			} else {
				playerGameOver();
			}
		}
		
		/* 
		FUNCTION: playerAddLife 
		PURPOSE: Add player life 
		CONDITIONALS: the limit is 99 lives
		*/
		public function playerAddLife(inst:Number){
			if(Game.instance.livesNum < 99 && interactiveObjects[inst].isOn){
				
				var pb:PointBurst = new PointBurst(this,"EXTRA LIFE",interactiveObjects[inst].x,interactiveObjects[inst].y);

				Game.instance.livesNum += 1;
				Game.instance.initGameDisplayMenu();
				removeInterActiveObject(inst);
			}
		}
		
		/* 
		FUNCTION: playerGameOver 
		PURPOSE: Game Over
		*/
		function playerGameOver(){
			trace("game over dude");
		}
		
		
		public function disablePlayerMove(directionString:String){
			player_mc[directionString] = false;
		}
		
		public function removeTweens(){
			
			Tweener.removeTweens(player_mc);
			player_mc.canMove = true;
			
		}
		
		/* 
		FUNCTION: checkInteractiveWallCollisions 
		PURPOSE: check if the player has hit a wall
		CONDITIONALS: wall object array co ordinates
		*/
		public function checkInteractiveWallCollisions(j:Number){
			
			var mUp:Boolean = true;
			var mDown:Boolean = true;
			var mLeft:Boolean = true;
			var mRight:Boolean = true;
			
			for(var i:int = 0; i < this.numChildren; i++) {
				
				var mc = this.getChildAt(i);
				
					if (mc is Wall || mc is HiddenWall || mc is TrapBridge) {
				
						if(interactiveObjects[j].hitTestObject(mc)){
							
							//up
							if(player_mc.isMovingDir == "up" && mc.y < interactiveObjects[j].y && mc.x == interactiveObjects[j].x){
								mUp = false;
							}
							//down
							if(player_mc.isMovingDir == "down" && mc.y > interactiveObjects[j].y && mc.x == interactiveObjects[j].x){
								mDown = false;
							}
							//left
							if(player_mc.isMovingDir == "left" && mc.x < interactiveObjects[j].x && mc.y == interactiveObjects[j].y){
								mLeft = false;
							}
							//right
							if(player_mc.isMovingDir == "right" && mc.x > interactiveObjects[j].x && mc.y == interactiveObjects[j].y){
								mRight = false;
							}
							
						}
					
					}
			}
			
			for(var k:Number = 0; k < interactiveObjects.length; k ++){
					
				if(Number(j) != Number(k)){
					
					if(interactiveObjects[j].hitTestObject(interactiveObjects[k]) && interactiveObjects[j].x == interactiveObjects[k].x || interactiveObjects[j].y == interactiveObjects[k].y){
						
						//up
						if(player_mc.isMovingDir == "up"){
							mUp = false;
						}
						//down
						if(player_mc.isMovingDir == "down"){
							mDown = false;
						}
						//left
						if(player_mc.isMovingDir == "left"){
							mLeft = false;
						}
						//right
						if(player_mc.isMovingDir == "right"){
							mRight = false;
						}

					}
				}
				
			}
			
			if(player_mc.isMovingDir == "up" && mUp){
				interactiveObjects[j].y = interactiveObjects[j].y - interactiveObjects[j].width +1;
			}
			else if(player_mc.isMovingDir == "down" && mDown){
				interactiveObjects[j].y = interactiveObjects[j].y + interactiveObjects[j].width -1;
			}
			else if(player_mc.isMovingDir == "left" && mLeft){
				interactiveObjects[j].x = interactiveObjects[j].x - interactiveObjects[j].width +1;
			}
			else if(player_mc.isMovingDir == "right" && mRight){
				interactiveObjects[j].x = interactiveObjects[j].x + interactiveObjects[j].width -1;
			} else {
				Tweener.removeTweens(player_mc);
				movePlayerToSafePoint();
				player_mc.canMove = true;
			}
			
		}
		
		/* 
		FUNCTION: checkWallCollisions 
		PURPOSE: check if the player has hit a wall
		CONDITIONALS: wall object array co ordinates
		*/
		public function checkWallCollisions(){
			
			// loop through all objects to see if character has bumped into a wall
			for(var i:int = 0; i < wallObjectsArray.length; i++) {
				
				//move on y position
				if(player_mc.dirToMove == "vertical"){
					
					if(player_mc.y + player_mc.height/2 > wallObjectsArray[i].topside - player_mc.height/2 && player_mc.y - player_mc.height/2 < wallObjectsArray[i].bottomside + player_mc.height/2){
						
						if(player_mc.x > wallObjectsArray[i].leftside && player_mc.x < wallObjectsArray[i].rightside){
							
							if(wallObjectsArray[i].name == "Wall" || wallObjectsArray[i].name == "HiddenWall"){
						
								if(Math.abs(player_mc.y - wallObjectsArray[i].topside) > Math.abs(player_mc.y - wallObjectsArray[i].bottomside)){
									
									removeTweens();
									
									if(player_mc.isMovingDir == "up"){
										
										player_mc.y = wallObjectsArray[i].bottomside + wallObjectsArray[i].height/2;
										
									} else if(player_mc.isMovingDir == "down"){
										
										player_mc.y = wallObjectsArray[i].topside - wallObjectsArray[i].height/2;
										
									}
									
								} else {
									
									removeTweens();
									
									if(player_mc.isMovingDir == "up"){
										
										player_mc.y = wallObjectsArray[i].bottomside + wallObjectsArray[i].height/2;
										
									} else if(player_mc.isMovingDir == "down"){
										
										player_mc.y = wallObjectsArray[i].topside - wallObjectsArray[i].height/2;
										
									}
									
								}
								
							} 
							
							if(wallObjectsArray[i].name == "TrapBridge"){

								if(player_mc.isMovingDir == "up"){
									
									if(Math.abs(player_mc.y - wallObjectsArray[i].topside) > Math.abs(player_mc.y  - wallObjectsArray[i].bottomside)){
										MovieClip(this.getChildAt(wallObjectsArray[i].inst)).gotoAndPlay(2);
										trapBridgeHit = true;
										trapBridgeX = wallObjectsArray[i].leftside;
										trapBridgeY = wallObjectsArray[i].topside;
										
									} 
									
								}
								
								if(player_mc.isMovingDir == "down"){
									
									if(Math.abs(player_mc.y - wallObjectsArray[i].topside) > Math.abs(player_mc.y - wallObjectsArray[i].bottomside)){
										MovieClip(this.getChildAt(wallObjectsArray[i].inst)).gotoAndPlay(2);
										
										if(!trapBridgeHit){ //only collect the first hit co ords//
											trapBridgeX = wallObjectsArray[i].leftside;
											trapBridgeY = wallObjectsArray[i].topside;
										}
										
										trapBridgeHit = true;
										
									} 
									
								}
								
							}
							
						}
					} 
				}
				
				//move on x position
				if(player_mc.dirToMove == "horizontal"){
					if(player_mc.x + player_mc.width/2 > wallObjectsArray[i].leftside - player_mc.width/2 && player_mc.x - player_mc.width/2 < wallObjectsArray[i].rightside + player_mc.width/2){
						if(player_mc.y > wallObjectsArray[i].topside && player_mc.y < wallObjectsArray[i].bottomside){
						
							if(wallObjectsArray[i].name == "Wall" || wallObjectsArray[i].name == "HiddenWall"){
							
								if(Math.abs(player_mc.x - wallObjectsArray[i].leftside) < Math.abs(player_mc.x - wallObjectsArray[i].rightside)){
									
									removeTweens();
									
									if(player_mc.isMovingDir == "right"){
										
										player_mc.x = wallObjectsArray[i].leftside - wallObjectsArray[i].height/2;
										
									} else if(player_mc.isMovingDir == "left"){
										
										player_mc.x = wallObjectsArray[i].rightside + wallObjectsArray[i].height/2;
										
									}
									
								} else {
									
									removeTweens();
									
									if(player_mc.isMovingDir == "right"){
										
										player_mc.x = wallObjectsArray[i].leftside - wallObjectsArray[i].height/2;
										
									} else if(player_mc.isMovingDir == "left"){
										
										player_mc.x = wallObjectsArray[i].rightside + wallObjectsArray[i].height/2;
										
									}
						
								}
								
							}
							
							if(wallObjectsArray[i].name == "TrapBridge"){

								if(Math.abs(player_mc.x - wallObjectsArray[i].leftside) <= Math.abs(player_mc.x - wallObjectsArray[i].rightside)){
									MovieClip(this.getChildAt(wallObjectsArray[i].inst)).gotoAndPlay(2);
								} 
								
							}
							
						}
					} 
				}
			}

		}
		
		/* 
		FUNCTION: checkItemCollisions 
		PURPOSE: check if the player has hit a collectable object
		CONDITIONALS: wall object array co ordinates
		*/
		public function checkItemCollisions(){
			
			for(var i:int = 0; i < interactiveObjects.length; i++) {
				if(player_mc.hitTestObject(interactiveObjects[i])){
					if(interactiveObjects[i].itemType == "key"){ //
						keyFound(i);
					} else if(interactiveObjects[i].itemType == "jump"){ //
						Tweener.removeTweens(player_mc);
						playerJump(i);
					} else if(interactiveObjects[i].itemType == "lock"){ //locks
						lockFound(i); // check if we have a key for this lock
						if(interactiveObjects[i].isOn){ // if the lock is active check the boundaries
							Tweener.removeTweens(player_mc);
							movePlayerToSafePoint();
						}
					} else if(interactiveObjects[i].itemType == "trap"){
						
						if(interactiveObjects[i].trapType == "push"){
							checkInteractiveWallCollisions(i);
						}
						if(interactiveObjects[i].trapType == "crush" ){
							if(player_mc.hitTestObject(interactiveObjects[i].border_mc)){
								Tweener.removeTweens(player_mc);
								movePlayerToSafePoint();
							}
							if(player_mc.hitTestObject(interactiveObjects[i].hit_mc)){
								player_mc.spawn(begin_mc.x, begin_mc.y, begin_mc.width, begin_mc.height);
								playerRemoveLife();
							}
						}						
					} else if(interactiveObjects[i].itemType == "fruit"){
						fruitFound(i);
					} else if(interactiveObjects[i].itemType == "life"){
						playerAddLife(i);
					}
				}
			}
		}
		
		public function playerJump(inst:Number){
			
			player_mc.enableBoundaries(false, boundariesOn);
						
			if(player_mc.isMovingDir == "right" && player_mc.wayFindToX > interactiveObjects[inst].x + interactiveObjects[inst].width){
				Tweener.addTween(player_mc, {x:player_mc.wayFindToX, time:0.3, transition:"EaseOut", onComplete:scaleBack});
				player_mc.scaleUp();
			} else if(player_mc.isMovingDir == "right" && player_mc.wayFindToX < interactiveObjects[inst].x + interactiveObjects[inst].width){
				Tweener.addTween(player_mc, {x:player_mc.lastSafePointX, time:0.5, transition:"EaseOut", onComplete:scaleBack});
				player_mc.scaleUp();
			}
			
			if(player_mc.isMovingDir == "left" && player_mc.wayFindToX > interactiveObjects[inst].x + interactiveObjects[inst].width){
				Tweener.addTween(player_mc, {x:player_mc.wayFindToX, time:0.3, transition:"EaseOut", onComplete:scaleBack});
				player_mc.scaleUp();
			} else if(player_mc.isMovingDir == "left" && player_mc.wayFindToX < interactiveObjects[inst].x + interactiveObjects[inst].width){
				Tweener.addTween(player_mc, {x:player_mc.lastSafePointX, time:0.5, transition:"EaseOut", onComplete:scaleBack});
				player_mc.scaleUp();
			}
			
			if(player_mc.isMovingDir == "up" && player_mc.wayFindToY < interactiveObjects[inst].y + interactiveObjects[inst].height){
				
				Tweener.addTween(player_mc, {y:player_mc.wayFindToY, time:0.3, transition:"EaseOut", onComplete:scaleBack});
				player_mc.scaleUp();
				
			} else if(player_mc.isMovingDir == "up" && player_mc.wayFindToY > interactiveObjects[inst].y + interactiveObjects[inst].height){
				
				Tweener.addTween(player_mc, {y:player_mc.lastSafePointY, time:0.5, transition:"EaseOut", onComplete:scaleBack});
				player_mc.scaleUp();
				
			}
			
			if(player_mc.isMovingDir == "down" && player_mc.wayFindToY > interactiveObjects[inst].y + interactiveObjects[inst].height){
				
				Tweener.addTween(player_mc, {y:player_mc.wayFindToY, time:0.3, transition:"EaseOut", onComplete:scaleBack});
				player_mc.scaleUp();
				
			} else if(player_mc.isMovingDir == "down" && player_mc.wayFindToY < interactiveObjects[inst].y + interactiveObjects[inst].height){
				
				Tweener.addTween(player_mc, {y:player_mc.lastSafePointY, time:0.5, transition:"EaseOut", onComplete:scaleBack});
				player_mc.scaleUp();
				
			}
			
		}
		
		public function scaleBack(){
			Tweener.addTween(player_mc, {scaleX:1, scaleY:1, time:0.5, transition:"EaseInOut", onComplete:player_mc.enableBoundaries, onCompleteParams:[true,boundariesOn]});
		}
		
		public function movePlayerToSafePoint(){
			player_mc.x = player_mc.lastSafePointX;
			player_mc.y = player_mc.lastSafePointY;
			player_mc.enableBoundaries(true, boundariesOn);
		}
		
		/* 
		FUNCTION: fruitFound 
		PURPOSE: pick up fruit
		*/
		public function fruitFound(inst:Number){
			if(interactiveObjects[inst].isOn){
				var pb:PointBurst = new PointBurst(this,interactiveObjects[inst].scoreValue,interactiveObjects[inst].x,interactiveObjects[inst].y);
				Game.instance.scoreNum += interactiveObjects[inst].scoreValue;
				Game.instance.initGameDisplayMenu();
				removeInterActiveObject(inst);
			}
		}
		
		/* 
		FUNCTION: keyFound 
		PURPOSE: pick up key
		*/
		public function keyFound(inst:Number){
			levelItemCollectionArray.push(interactiveObjects[inst]); //key collected
			if(interactiveObjects[inst].isOn){
				var pb:PointBurst = new PointBurst(this,"KEY FOUND",interactiveObjects[inst].x,interactiveObjects[inst].y);
			}
			removeInterActiveObject(inst);
		}
		
		public function removeInterActiveObject(inst:Number){
			interactiveObjects[inst].isOn = false;
			interactiveObjects[inst].visible = false; //hide for now, but will show animation
		}
		
		/* 
		FUNCTION: lockFound 
		PURPOSE: check if the player has a key to the lock
		*/
		public function lockFound(inst:Number){
			for(var i:int = 0; i < levelItemCollectionArray.length; i++) {
				if(levelItemCollectionArray[i].itemType == "key"){ // if the player has collected a key
					//trace("the player has a key");
					if(interactiveObjects[inst].lockType == levelItemCollectionArray[i].canUnlock || levelItemCollectionArray[i].canUnlock == "skeleton"){ // if the key the player has collected can unlock this lock
						//the player has the key required
						interactiveObjects[inst].isOn = false;
						interactiveObjects[inst].visible = false; //hide for now, but will show animationes
					}
				} else {
					//
				}
			}
			if(levelItemCollectionArray.length == 0){
				//trace("the player has no items yet");
			}
			player_mc.canMove = true;
		}
				
		/* 
		FUNCTION: checkEnemyCollisions 
		PURPOSE: check if an enemy hits another enemy
		*/
		public function checkEnemyCollisions(){
			for(var j:int = 0; j < enemiesArray.length; j++) {
				for(var k:int = 0; k < enemiesArray.length; k++) {
					if(enemiesArray[j].hitTestObject(enemiesArray[k]) && j != k){
						reverseEnemyDirection(j);
						
					}
				}
			}
		}
		
		/* 
		FUNCTION: checkEnemyItemCollisions 
		PURPOSE: check if an enemy hits an item on stage
		*/
		public function checkEnemyItemCollisions(){
			for(var i:int = 0; i < interactiveObjects.length; i++) {
				for(var j:int = 0; j < enemiesArray.length; j++) {
					if(enemiesArray[j].hitTestObject(interactiveObjects[i]) && interactiveObjects[i].isOn){
						
						if(interactiveObjects[i].itemType == "trap"){
							if(enemiesArray[j].hitTestObject(interactiveObjects[i].enemyWait_mc)){
								interactiveObjects[i].gotoAndPlay(124);
							}
						} else {
							reverseEnemyDirection(j);
						}
					}
				}
			}
		}
		
		/* 
		FUNCTION: checkComplete 
		PURPOSE: check if the player_mc is at the end
		*/
		public function checkComplete(){
			if(player_mc.hitTestObject(end_mc)){
				levelComplete();
			}
		}
		
		/* 
		FUNCTION: removeGameListeners 
		PURPOSE: remove game event listeners
		*/
		public function removeGameListeners(){
			if(hasEventListener(MouseEvent.MOUSE_DOWN)) {
				removeEventListener(MouseEvent.MOUSE_DOWN, addWayFinder); // add game listeners
			}
			if(hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, wayFinder); 
			}
		}
		
		/* 
		FUNCTION: levelComplete 
		PURPOSE: ends the level and sets up the game for the next
		*/
		public function levelComplete(){
			clearLevelData();
			removeGameListeners();
			Game.instance.levelComplete();
		}
		
	
		/* 
		FUNCTION: freezeEnemyDirection 
		PURPOSE:true/false freezes enemy until the collision object has moved out the way
		*/
		public function freezeEnemyDirection(inst:Number, freeze:Boolean){
			if(freeze){
				enemiesArray[inst].freeze = true;
			} else {
				enemiesArray[inst].freeze = false;
			}
		}
		
		/* 
		FUNCTION: reverseEnemyDirection 
		PURPOSE: changes the direction the enemy is moving in
		*/
		public function reverseEnemyDirection(inst:Number){
			if(enemiesArray[inst].currFacingDir == "left"){
				enemiesArray[inst].currFacingDir = "right";
			} else if(enemiesArray[inst].currFacingDir == "right"){
				enemiesArray[inst].currFacingDir = "left";
			}
			if(enemiesArray[inst].currFacingDir == "up"){
				enemiesArray[inst].currFacingDir = "down";
			} else if(enemiesArray[inst].currFacingDir == "down"){
				enemiesArray[inst].currFacingDir = "up";
			}
			enemyCorrectCoords(inst);
		}
		
		/* 
		FUNCTION: enemyCorrectCoords 
		PURPOSE: ensure the enemy is centered in its tile
		*/
		public function enemyCorrectCoords(inst:Number){
			
			for(var i:int = 0; i < this.numChildren; i++) {
				
				var mc = this.getChildAt(i);
				
				if (mc is Path && enemiesArray[inst].hitTestObject(mc)){
					
					if(enemiesArray[inst].currFacingDir == "left" || enemiesArray[inst].currFacingDir == "right"){ 
						enemiesArray[inst].y = mc.y + mc.height/2;
					}
					if(enemiesArray[inst].currFacingDir == "up" || enemiesArray[inst].currFacingDir == "down"){ 
						enemiesArray[inst].x = mc.x + mc.width/2;

					}

				}
					
			}
		}
		
		/* 
		FUNCTION: addEnemy 
		PURPOSE: adds enemies to the enemiesArray array
		*/
		public function addEnemy(enemyRef:MovieClip){
			enemiesArray.push(enemyRef);
		}
		
		/* 
		FUNCTION: addInteractiveObjects 
		PURPOSE: adds collectables, traps, bonus point object to the interactiveObjects array
		*/
		public function addInteractiveObject(interactiveObjRef:MovieClip){
			interactiveObjects.push(interactiveObjRef);
		}
				
	}
	
}
