package com.Elements  
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	
		
	public class Snake extends Sprite
	{
		//DO NOT GIVE THEM A VALUE HERE! Give them a value in the init() function
		private var snake_vector:Vector.<Element>; //the snake's parts are held in here
		private var markers_vector:Vector.<Object>; //the markers are held in here
		private var timer:Timer; 
		private var dead:Boolean;
		private var min_elements:int; //holds how many parts should the snake have at the beginning
		private var apple:Element; //Our apple
		private var space_value:Number; //space between the snake parts
		private var last_button_down:uint; //the keyCode of the last button pressed
		private var flag:Boolean; //is it allowed to change direction?
		private var score:Number;
		private var score_tf:TextField; //the Textfield showing the score
		
		public function Snake() 
		{
			//if(stage)
			this.addEventListener(Event.ADDED_TO_STAGE, init);
			//else
				//init();
		}
		
		private function init(e:Event = null):void
		{
			snake_vector = new Vector.<Element>;
			markers_vector = new Vector.<Object>;
			space_value = 2;
			timer = new Timer(500); //Every 50th millisecond, the moveIt() function will be fired!
			dead = false;
			min_elements = 1;
			apple = new Element(0xFF0000, 1,10, 10); //red, not transparent, width:10, height: 10;
			apple.catchValue = 0; //pretty obvious
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
			
			placeApple(false);
			timer.addEventListener(TimerEvent.TIMER,moveIt);
			stage.addEventListener(KeyboardEvent.KEY_DOWN,directionChanged);
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
		
		private function placeApple(caught:Boolean = true):void
		{
			if (caught)
				apple.catchValue += 10;
			
			var boundsX:int = (Math.floor(stage.stageWidth / (snake_vector[0].width + space_value)))-1;
			var randomX:Number = Math.floor(Math.random()*boundsX);
			
			var boundsY:int = (Math.floor(stage.stageHeight/(snake_vector[0].height + space_value)))-1;
			var randomY:Number = Math.floor(Math.random()*boundsY);

			apple.x = randomX * (apple.width + space_value);
			apple.y = randomY * (apple.height + space_value);
			
			for(var i:uint=0;i<snake_vector.length-1;i++)
			{
				if(snake_vector[i].x == apple.x && snake_vector[i].y == apple.y)
					placeApple(false);
			}
			if (!apple.stage)
				this.addChild(apple);
		}
		
		private function moveIt(e:TimerEvent):void
		{
			if (snake_vector[0].x == apple.x && snake_vector[0].y == apple.y)
			{
				placeApple();
				//show the current Score
				score += apple.catchValue;
				score_tf.text = "Score:" + String(score);
				//Attach a new snake Element
				snake_vector.push(new Element(0x00AAFF,1,10,10));
				snake_vector[snake_vector.length-1].direction = snake_vector[snake_vector.length-2].direction; //lastOneRichtung
				attachElement(snake_vector[snake_vector.length-1],
									  (snake_vector[snake_vector.length-2].x),
									  snake_vector[snake_vector.length-2].y,
									  snake_vector[snake_vector.length-2].direction);
			}
			if (snake_vector[0].x > stage.stageWidth-snake_vector[0].width || snake_vector[0].x < 0 || snake_vector[0].y > stage.stageHeight-snake_vector[0].height || snake_vector[0].y < 0)
			{
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
			stage.removeEventListener(KeyboardEvent.KEY_DOWN,directionChanged);
			init();
		}
	
		private function directionChanged(e:KeyboardEvent):void 
		{
			var m:Object = new Object(); //MARKER OBJECT

			if (e.keyCode == Keyboard.LEFT && last_button_down != e.keyCode && last_button_down != Keyboard.RIGHT && flag)
			{
				snake_vector[0].direction = "L";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"L"};
				last_button_down = Keyboard.LEFT;
				flag = false;
			}
			else if (e.keyCode == Keyboard.RIGHT && last_button_down != e.keyCode && last_button_down != Keyboard.LEFT && flag)
			{
				snake_vector[0].direction = "R";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"R"};
				last_button_down = Keyboard.RIGHT;
				flag = false;
			}
			else if (e.keyCode == Keyboard.UP && last_button_down != e.keyCode && last_button_down != Keyboard.DOWN && flag)
			{
				snake_vector[0].direction = "U";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"U"};
				last_button_down = Keyboard.UP;
				flag = false;
			}
			else if (e.keyCode == Keyboard.DOWN && last_button_down != e.keyCode && last_button_down != Keyboard.UP && flag)
			{
				snake_vector[0].direction = "D";
				m = {x:snake_vector[0].x, y:snake_vector[0].y, type:"D"};
				last_button_down = Keyboard.DOWN;
				flag = false;
			}
			markers_vector.push(m);
		}
		
	}

}