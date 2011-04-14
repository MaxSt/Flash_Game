package game
{
	import org.flixel.*;

	public class YouWonState extends FlxState
	{
		public function YouWonState()
		{
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
			
			var start:FlxText = new FlxText(FlxG.width * 0.5 -150, 50, 300, "CONGRATULATIONS!\n\nPress ENTER to PLAY AGAIN");
			start.setFormat(null, 20, 0x0000AA, "center",2);
			add(start);
		}
		
		override public function update():void{
			if (FlxG.keys.ENTER )
			{
				FlxG.state = new PlayState();
			}
			super.update();
		}
	}
}