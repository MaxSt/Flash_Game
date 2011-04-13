package game
{
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var player:Player;
		
		[Embed(source="../assets/sounds/toneA.mp3")] private var SoundA:Class;
		
		[Embed(source="../assets/sounds/toneC.mp3")] private var SoundC:Class;
		
		[Embed(source="../assets/images/Level_1.png")] private var PNGLevel_1:Class;
		
		public function PlayState()
		{	
			
			//FlxG.playMusic(bgmusic);
			
		}
		

		
		override public function create():void
		{
			FlxState.bgColor = 0xffaaaaff;
			
			//level structure
			level = new FlxTilemap();
			level.auto = FlxTilemap.ALT;
			level.loadMap(FlxTilemap.pngToCSV(PNGLevel_1,false,2),FlxTilemap.ImgAuto);
			level.follow();
			add(level);
			
			//Add game objects
			var player:Player = new Player(150,10);
			setPlayer(player);
			FlxG.follow(player);
			add(player);
			
			var tonA:Tone = new Tone(1,210,"A",player);
			tonA.fixed = true;
			tonA.moves = false;
			add(tonA);
			
			var tonC:Tone = new Tone(300,220,"C",player);
			tonC.fixed = true;
			tonC.moves = false;
			add(tonC);
			
			//add(new FlxText(0,0,100,"Hallo, Max!")); //adds a 100px wide text field at position 0,0 (upper left)
		}
		
		override public function update():void
		{
			super.update();
			collide();
		}
		
		public function setPlayer(player:Player):void
		{
			this.player = player;
		}
		
		public function getPlayer():Player
		{
			return this.player;	
		}
		
	}
}