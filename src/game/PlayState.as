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
		
		public var levelToneOrder:Array = new Array();
		public var playedToneOrder:Array = new Array();
		
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
			
			timerAddTone.addEventListener(TimerEvent.TIMER_COMPLETE,addTone);
			timerSuccesGame.addEventListener(TimerEvent.TIMER_COMPLETE,playAgain);
			
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
			
			if( !checkOrder() && (tonA.isCollided || tonC.isCollided) ){
				FlxG.state = new GameOverState();
			}
			
			if( checkOrder() && (playedToneOrder.length == levelToneOrder.length) ){
				timerSuccesGame.start();
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
		
		private function checkOrder():Boolean{
			for(var i:int = 0; i < playedToneOrder.length; i++){
				if( levelToneOrder[i] == playedToneOrder[i] ){
					continue;
				}
				else
					return false;
			}
			return true;
		}
		
		private function loadSoundGroup():Vector.<Tone>
		{
			tonA = new Tone(50,5,SoundA,ImgA,this,player,1);
			tonA.fixed = true;
			tonA.moves = false;
			levelToneOrder.push(tonA.getOrder());
			
			tonC = new Tone(290,20,SoundC,ImgC,this,player,2);
			tonC.fixed = true;
			tonC.moves = false;
			levelToneOrder.push(tonC.getOrder());
			
			sounds.push(tonA);
			sounds.push(tonC);
			
			return new Vector.<Tone>(sounds);
		}
		
		private function addTone(e:TimerEvent):void
		{
			var sound:Tone = sounds.shift(); //shift removes the first of the vector, and the others shift 1 position to left
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