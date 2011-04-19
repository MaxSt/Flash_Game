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
		
		public var levelOrder:Array = new Array(1,1,2);
		public var levelMaxOrder:int = 3;
		public var orderPos:int = 0;
		
		public var activeSound:Tone;
		
		private var timerAddTone:Timer = new Timer(2000,1);
		private var timerSuccesGame:Timer = new Timer(1000,1);
		private var timerRepeatSound:Timer = new Timer(1000,1);
		
		private var sound:Tone;
		private var sounds:Vector.<Tone> = new Vector.<Tone>();
		private var soundsCopy:Vector.<Tone> = new Vector.<Tone>();

		public function PlayState()
		{	
			FlxG.mouse.show();
			this.addEventListener(Event.ACTIVATE,onFocus);
			//FlxG.playMusic(bgmusic);
		}
		
		
		override public function create():void
		{
			FlxState.bgColor = 0xffaaaaff;
			
			timerAddTone.addEventListener(TimerEvent.TIMER_COMPLETE,addTone);
			timerSuccesGame.addEventListener(TimerEvent.TIMER_COMPLETE,playAgain);
			timerRepeatSound.addEventListener(TimerEvent.TIMER_COMPLETE,repeatSound);
			
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
			sounds = loadSoundGroup();
			
			for each(var s:Tone in sounds){
				soundsCopy.push(s);	
			}
		}
		
		override public function update():void
		{
			if( sounds.length != 0 && soundsCopy.length != 0)
				timerAddTone.start();
			
			if( !this.player.onScreen() ){
				this.player.kill();
				FlxG.state = new GameOverState();
			}
		
			activeSound = getColidedSound();
			trace(activeSound);
			if(activeSound){
				if( checkOrder(activeSound) ){
					orderPos += 1;
					//showScore();
					activeSound.Collided = false;
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
			return (sound.getOrder() == levelOrder[orderPos])
		}
		
		private function getColidedSound():Tone{
			for each(var s:Tone in soundsCopy){
				if (s.isCollided){
					return s;
				}
			}
			return null;
		}
		
		private function loadSoundGroup():Vector.<Tone>
		{
			tonA = new Tone(50,5,SoundA,ImgA,this,player,1,2);
			tonA.fixed = true;
			tonA.moves = false;
			
			tonC = new Tone(290,20,SoundC,ImgC,this,player,2,1);
			tonC.fixed = true;
			tonC.moves = false;
			
			var s:Vector.<Tone>  = new Vector.<Tone>();
			
			s.push(tonA);
			s.push(tonC);
			
			return s;
		}
		
		private function addTone(e:TimerEvent):void
		{
			sound = sounds.shift(); //shift removes the first of the vector, and the others shift 1 position to left
			this.add(sound);
			FlxG.play(sound.getSound(),1,false);
			while( sound.Repeat > 1 ){
				timerRepeatSound.start();
				sound.Repeat--;
			}
			//FlxG.play(sound.getSound(),1,false);
			timerAddTone.stop();
		}
		
		private function repeatSound(e:TimerEvent):void{
			FlxG.play(sound.getSound(),1,false);
			timerRepeatSound.stop();
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