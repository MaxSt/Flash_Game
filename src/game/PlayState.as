package game
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.ui.*;
	import flash.utils.Timer;
	
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		//tone pictures
		[Embed(source="../assets/images/toneA.png")] private var ImgA:Class;
		[Embed(source="../assets/images/toneB.png")] private var ImgB:Class;
		[Embed(source="../assets/images/toneC.png")] private var ImgC:Class;
		
		//tone sounds
		[Embed(source="../assets/sounds/toneA.mp3")] private var SoundA:Class;
		[Embed(source="../assets/sounds/toneC.mp3")] private var SoundC:Class;
		
		//level maps
		[Embed(source="../assets/images/Level_1.png")] private var PNGLevel_1:Class;
		
		public var level:FlxTilemap;
		public var player:Player;
		public var tonA:Tone;
		public var tonC:Tone;
		
		private var timer:Timer = new Timer(1000,1);
		private var soundGroup:Vector.<Tone> = new Vector.<Tone>();
		private var soundGroupCopy:Vector.<Tone>;

		public function PlayState()
		{	
			FlxG.mouse.show();
			this.addEventListener(Event.ACTIVATE,onFocus);
			//FlxG.playMusic(bgmusic);
		}
		
		
		override public function create():void
		{
			FlxState.bgColor = 0xffaaaaff;
			
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,addTone);	
			
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
			
			soundGroupCopy = loadSoundGroup();
			//add(new FlxText(0,0,100,"Hallo, Max!")); //adds a 100px wide text field at position 0,0 (upper left)
		}
		
		override public function update():void
		{
			if( soundGroup.length != 0)
				timer.start();
			
			super.update();
			collide();
		}
		
		private function loadSoundGroup():Vector.<Tone>
		{
			tonA = new Tone(140,210,SoundA,ImgA,player,1);
			tonA.fixed = true;
			tonA.moves = false;			
			
			tonC = new Tone(290,20,SoundC,ImgC,player,2);
			tonC.fixed = true;
			tonC.moves = false;
			
			soundGroup.push(tonA);
			soundGroup.push(tonC);
			
			return new Vector.<Tone>(soundGroup);
		}
		
		private function addTone(e:TimerEvent):void
		{
			var sound:Tone = soundGroup.shift();
			this.add(sound);
			FlxG.play(sound.getSound(),1,false);
			timer.stop();
		}
		
		public function setPlayer(player:Player):void
		{
			this.player = player;
		}
		
		public function getPlayer():Player
		{
			return this.player;	
		}
		
		protected function onFocus(event:Event=null):void
		{
			FlxG.mouse.show();
		}
	}
}