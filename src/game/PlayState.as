package game
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.flixel.*;
	import org.flixel.data.FlxList;
	
	public class PlayState extends FlxState
	{
		public var level:FlxTilemap;
		public var player:Player;
		public var tonA:Tone;
		public var tonC:Tone;
		
		//tone pictures
		[Embed(source="../assets/images/toneA.png")] private var ImgA:Class;
		[Embed(source="../assets/images/toneB.png")] private var ImgB:Class;
		[Embed(source="../assets/images/toneC.png")] private var ImgC:Class;
		
		//tone sounds
		[Embed(source="../assets/sounds/toneA.mp3")] private var SoundA:Class;
		[Embed(source="../assets/sounds/toneC.mp3")] private var SoundC:Class;
		
		//level maps
		[Embed(source="../assets/images/Level_1.png")] private var PNGLevel_1:Class;
		
		private var timer:Timer = new Timer(2000,1);
		private var soundGroup:Vector.<Tone> = new Vector<Tone>();

		public function PlayState()
		{	
			loadSoundGroup();
			//FlxG.playMusic(bgmusic);
			
		}
		
		
		override public function create():void
		{
			FlxState.bgColor = 0xffaaaaff;
			
			for(var sound:Tone in soundGroup){
				timer.addEventListener(TimerEvent.TIMER_COMPLETE,addTone);	
			}
			
			//level structure
			level = new FlxTilemap();
			level.auto = FlxTilemap.ALT;
			level.loadMap(FlxTilemap.pngToCSV(PNGLevel_1,false,2),FlxTilemap.ImgAuto);
			level.follow();
			add(level);
			
			//Add game objects
			var player:Player = new Player(150,210);
			setPlayer(player);
			FlxG.follow(player);
			add(player);

			/*
			tonA = new Tone(30,10,SoundA,ImgA,player);
			tonA.fixed = true;
			tonA.moves = false;
			add(tonA);*/
			
			tonC = new Tone(290,20,SoundC,ImgC,player);
			tonC.fixed = true;
			tonC.moves = false;
			add(tonC);
			
			//add(new FlxText(0,0,100,"Hallo, Max!")); //adds a 100px wide text field at position 0,0 (upper left)
		}
		
		override public function update():void
		{
			timer.start();
			
			super.update();
			collide();
		}
		
		private function loadSoundGroup():void{
			soundGroup.add(tonA);
			soundGroup.add(tonC);
		}
		
		private function addTone(e:TimerEvent):void
		{
			for(var tone:Tone in soundGroup){
				add(tone);	
			}
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