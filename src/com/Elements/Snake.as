/**
 * @author Balakrishna [vamsibalu@gmail.com]
 * @version 2.0
 */
package com.Elements  
{
	import com.view.Board;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	
	public class Snake extends Sprite
	{
		//DO NOT GIVE THEM A VALUE HERE! Give them a value in the init() function
		public var snake_vector:Vector.<Element>; //the snake's parts are held in here and visible to Board bala
		public var markers_vector:Vector.<Object>; //the markers are held in here bala
		private var timer:Timer; 
		private var dead:Boolean;
		private var min_elements:int; //holds how many parts should the snake have at the beginning
		//private var apple:Element; //Our apple
		private var space_value:Number; //space between the snake parts
		public var last_button_down:uint; //the keyCode of the last button pressed to any snake (bala)
		public var flag:Boolean; //is it allowed to change direction? bala
		private var score:Number;
		private var score_tf:TextField; //the Textfield showing the score
		private var board:Board;
		
		public function Snake() 
		{
			//if(stage)
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			board = Board(this.parent)
			snake_vector = new Vector.<Element>;
			markers_vector = new Vector.<Object>;
			space_value = 2;
			timer = new Timer(500); //Every 50th millisecond, the moveIt() function will be fired!
			dead = false;
			min_elements = 1;
			//apple = new Element(0xFF0000, 1,10, 10); //red, not transparent, width:10, height: 10;
			//apple.catchValue = 0; //pretty obvious
			last_button_down = Keyboard.RIGHT; //The starting direction of the snake (only change it if you change the 'for cycle' too.)
			score = 0;
			score_tf = new TextField();
			this.addChild(score_tf);
			
			//Create the first <min_elements> Snake parts
			for(var i:int=0;i<min_elements;++i)
			{
				snake_vector[i] = new Element(0x00AAFF,1,10,10);
				snake_vector[i].direction = "R"; //The starting direction of the snake
				if (i == 0)
				{
					//you have to place the first element on a GRID. (now: 0,0) [possible x positions: (snake_vector[0].width+space_value)*<UINT> ]
					attachElement(snake_vector[i],0,0,snake_vector[i].direction) 
					snake_vector[0].alpha = 0.7;
				}
				else
				{
					attachElement(snake_vector[i], snake_vector[i - 1].x, snake_vector[i - 1].y, snake_vector[i - 1].direction);
				}
			}
			
			//placeApple(false);  //for 1st time board will add
			timer.addEventListener(TimerEvent.TIMER,moveIt);
			//stage.addEventListener(KeyboardEvent.KEY_DOWN,directionChanged);
			timer.start();
		}
		
		private function attachElement(who:Element,lastXPos:Number = 0,lastYPos:Number = 0,dirOfLast:String = "R"):void
		{
			if (dirOfLast == "R")
			{
				who.x = lastXPos - snake_vector[0].width - space_value;
				who.y = lastYPos;
			}
			else if(dirOfLast == "L")
			{
				who.x = lastXPos + snake_vector[0].width + space_value;
				who.y = lastYPos;
			}
			else if(dirOfLast == "U")
			{
				who.x = lastXPos;
				who.y = lastYPos + snake_vector[0].height + space_value;
			}
			else if(dirOfLast == "D")
			{
				who.x = lastXPos;
				who.y = lastYPos - snake_vector[0].height - space_value;
			}
			this.addChild(who);
		}
		
		private function moveIt(e:TimerEvent):void{
			if(board.apple){
				if (snake_vector[0].x == board.apple.x && snake_vector[0].y == board.apple.y){
					//placeApple();
					dispatchEvent(new Event(Board.PLACEFOOD));
					//show the current Score
					score += board.apple.catchValue;
					score_tf.text = "Score:" + String(score);
					//Attach a new snake Element
					snake_vector.push(new Element(0x00AAFF,1,10,10));
					snake_vector[snake_vector.length-1].direction = snake_vector[snake_vector.length-2].direction; //lastOneRichtung
					attachElement(snake_vector[snake_vector.length-1],
						(snake_vector[snake_vector.length-2].x),
						snake_vector[snake_vector.length-2].y,
						snake_vector[snake_vector.length-2].direction);
				}
			}
			
			if (snake_vector[0].x > stage.stageWidth-snake_vector[0].width || snake_vector[0].x < 0 || snake_vector[0].y > stage.stageHeight-snake_vector[0].height || snake_vector[0].y < 0){
				GAME_OVER();
			}
			
			for (var i:int = 0; i < snake_vector.length; i++)
			{
				if (markers_vector.length > 0)
				{
					for(var j:uint=0;j < markers_vector.length;j++)
					{
						if(snake_vector[i].x == markers_vector[j].x && snake_vector[i].y == markers_vector[j].y)
						{
							snake_vector[i].direction = markers_vector[j].type;
							if(i == snake_vector.length-1)
							{
								markers_vector.splice(j, 1);
							}
						}
					}
				}
				if (snake_vector[i] != snake_vector[0] && (snake_vector[0].x == snake_vector[i].x && snake_vector[0].y == snake_vector[i].y))
				{
					GAME_OVER();
				}
				
				//Move the boy
				var DIRECTION:String = snake_vector[i].direction;
				switch (DIRECTION)
				{
					case "R" :
						snake_vector[i].x += snake_vector[i].width + space_value;
						break;
					case "L" :
						snake_vector[i].x -= snake_vector[i].width + space_value;
						break;
					case "D" :
						snake_vector[i].y += snake_vector[i].height + space_value;
						break;
					case "U" :
						snake_vector[i].y -= snake_vector[i].width + space_value;
						break;
				}
				
			}
			
			flag = true;
		}
		
		private function GAME_OVER():void 
		{
			dead = true;
			timer.stop();
			while (this.numChildren)
				this.removeChildAt(0);
			timer.removeEventListener(TimerEvent.TIMER,moveIt);
			//stage.removeEventListener(KeyboardEvent.KEY_DOWN,directionChanged);
			init();
		}
		
	}
	
}