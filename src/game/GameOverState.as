package game
{
	import org.flixel.*;

	public class GameOverState extends FlxState
	{
		//public var arrow:Arrow = new Arrow();
		
		public function GameOverState( score:int )
		{
			FlxG.score = score;
			super();	
		}
		
		override public function create():void{
			FlxState.bgColor = 0xffaaaaff;
			
			/*
			var back:FlxSprite = new FlxSprite(FlxG.width *0.5 -300, 0, Back);
			add(back);*/
			
			/*
			var logo:FlxText = new FlxText(FlxG.width * 0.5 - 150, FlxG.height * 0.5 + 50, 300, "REMTONE");
			logo.setFormat(null, 40, 0xFFFFFF, "center",2);
			add(logo);
			*/
			
			var start:FlxText = new FlxText(FlxG.width * 0.5 -150, 50, 300, "GAME OVER\n\nPress ENTER to PLAY AGAIN");
			start.setFormat(null, 20, 0x0000AA, "center",2);
			var labelScore:FlxText = new FlxText(FlxG.width * 0.5 -150, 180, 300, "Your Score: " + FlxG.score );
			labelScore.setFormat(null, 15, 0xAA0000, "center",2);
			
			add(start);
			add(labelScore);
		}
		
		override public function update():void{
			if (FlxG.keys.justReleased("ENTER") ) //&& arrow.y == 255)
			{
				//arrow.play("blink");
				
			}
			else if (FlxG.keys.ENTER )//&& arrow.y == 305)
			{
				FlxG.state = new PlayState();
			}
			/*else if (FlxG.keys.ENTER )//&& arrow.y == 355)
			{
				//FlxG.state = new ExitState();
			}
			
			if (FlxG.keys.justReleased("UP"))
			{
				/*
				if (arrow.y == 255)
				{
					arrow.y = 355;
				}
				else
				{
					arrow.y -= 50;
				}
			}
			
			if (FlxG.keys.justReleased("DOWN"))
			{
				/*
				FlxG.play(MenuSnd);
				
				if (arrow.y == 355)
				{
					arrow.y = 255;
				}
				else
				{
					arrow.y += 50;
				}
			}
			*/
			super.update();
		}
	}
}