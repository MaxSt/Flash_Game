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
		
		private var level:FlxTilemap;
		private var score:FlxText
		private var player:Player;
		private var tonA:Tone;
		private var tonC:Tone;
		
		//public var levelToneOrder:Vector.<int> = new Vector.<int>();
		//public var playedToneOrder:Vector.<int> = new Vector.<int>();
		
		public var levelMaxOrder:int = 3;
		public var orderPos:int = 1;
		
		public var activeSound:Tone;
		
		private var timerAddTone:Timer = new Timer(1000,1);
		private var timerSuccesGame:Timer = new Timer(1000,1);
		
		private var sounds:Vector.<Tone> = new Vector.<Tone>();
		private var soundsCopy:Vector.<Tone>;

		public function PlayState()
		{	
			FlxG.mouse.show();
			this.addEventListener(Event.ACTIVATE,onFocus);
			//FlxG.playMusic(bgmusic);
		}
		
		
		override public function create():void
		{
			FlxState.bgColor = 0xffaaaaff;
			
			soundsCopy = loadSoundGroup();
			timerAddTone.addEventListener(TimerEvent.TIMER_COMPLETE,addTone);
			timerSuccesGame.addEventListener(TimerEvent.TIMER_COMPLETE,playAgain);
			sounds = loadSoundGroup();
			
			//level structure
			level = new FlxTilemap();
			level.auto = FlxTilemap.ALT;
			level.loadMap(FlxTilemap.pngToCSV(PNGLevel_1,false,2),FlxTilemap.ImgAuto);
			level.follow();

			//score FlxText
			score = new FlxText(160,230,200);
			score.setFormat(null, 5, 0x0000AA, "center",2);
			
			//Add game objects
			var player:Player = new Player(150,210);
			setPlayer(player);
			FlxG.follow(player);
			
			add(level);
			add(score);
			add(player);
			
			//saves a copy of the sounds into the Vector.<Tone> soundsCopy
			soundsCopy = loadSoundGroup();
			 
		}
		
		override public function update():void
		{
			if( sounds.length != 0)
				timerAddTone.start();
			
			if( !this.player.onScreen() ){
				this.player.kill();
				FlxG.state = new GameOverState();
			}
		
			activeSound = getColidedSound();
			if(activeSound){
				if( checkOrder(activeSound) ){
					orderPos += 1;
					if(orderPos == levelMaxOrder){
						timerSuccesGame.start();
					}	
				}else{
					FlxG.state = new GameOverState();
				}
			}
			
			
			/*if( !checkOrder() ){
				playedToneOrder[playedToneOrder.length]
				var s:Tone = this.soundsCopy.pop();
				this.soundsCopy.pop().isCollided = false;
			}
			else
				FlxG.state = new GameOverState();*/
				
			//else
			
			super.update();
			collide();
		}
		
		private function checkOrder(sound:Tone):Boolean{
			return (sound.getOrder() == orderPos)
		}
		
		private function getColidedSound():Tone{
			var sound:Tone = null;
			for each(var s:Tone in sounds){
				if (s.isCollided){
					sound = s;
				}
			}
			return sound;
		}
		
		private function loadSoundGroup():Vector.<Tone>
		{
			tonA = new Tone(50,5,SoundA,ImgA,this,player,1);
			tonA.fixed = true;
			tonA.moves = false;
			
			tonC = new Tone(290,20,SoundC,ImgC,this,player,2);
			tonC.fixed = true;
			tonC.moves = false;
			
			var s:Vector.<Tone>  = new Vector.<Tone>();
			
			s.push(tonA);
			s.push(tonC);
			
			return s;
		}
		
		private function addTone(e:TimerEvent):void
		{
			var sound:Tone = soundsCopy.shift(); //shift removes the first of the vector, and the others shift 1 position to left
			this.add(sound);
			FlxG.play(sound.getSound(),1,false);
			timerAddTone.stop();
		}
		
		private function playAgain(e:TimerEvent):void{
			FlxG.state = new YouWonState();
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