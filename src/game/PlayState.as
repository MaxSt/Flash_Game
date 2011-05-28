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
		[Embed(source="../assets/sounds/toneB.mp3")] private var SoundB:Class;
		[Embed(source="../assets/sounds/toneC.mp3")] private var SoundC:Class;

		//private var all_tones:Vector.<Class,Class> = new Vector.<Class,Class>((ImgA,SoundA),(ImgB,SoundB),(ImgC,SoundC));
		//private var all_positions:Vector.<int,int> = new Vector.<int,int>((50,5),(290,20),(170,210));
		
		private var all_tones:Array = new Array( new Array(ImgA,SoundA), new Array(ImgB,SoundB), new Array(ImgC,SoundC) );
		private var all_positions:Array = new Array( new Array(50,5), new Array(290,20), new Array(170,210) );
		
		
		//level maps
		[Embed(source="../assets/images/Level_1.png")] private var PNGLevel_1:Class;
		
		private var level:FlxTilemap;
		private var score:FlxText
		private var player:Player;
		private var tonA:Tone;
		private var tonC:Tone;
		private var tonB:Tone;

		
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
			if( sounds.length >= 0)
				timerAddTone.start();
			
			if( !this.player.onScreen() ){
				this.player.kill();
				FlxG.state = new GameOverState();
			}
		
			
			
			activeSound = getColidedSound();
			//trace(activeSound);
			if(activeSound){
				if( checkOrder(activeSound) ){
					orderPos += 1;
					//showScore();
					activeSound.Collided = false;
					activeSound.kill();
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
			add(new FlxText(50,50,100, "sount.getOrder = " + sound.getOrder())); //DEBUG ZEILE
			//return (sound.getOrder() == orderPos)
			return true;
		}
		
		private function getColidedSound():Tone{
			for each(var s:Tone in soundsCopy){
				if(s){
					if (s.isCollided){
						return s;
					}	
				}
				else continue;
			}
			return null;
		}
		
		private function loadSoundGroup():Vector.<Tone>
		{
			var randomToneIndex:int;
			var randomPositionIndex:int;
			var randomTone:Tone;
			var s:Vector.<Tone>  = new Vector.<Tone>(levelMaxOrder);
			
			for(var i:int = 0; i < levelMaxOrder; i++){
				randomToneIndex = FlxU.random() * all_tones.length;
				randomPositionIndex = FlxU.random() * all_positions.length;
				add(new FlxText(150,10 + 30*i,100, "pos = " + randomPositionIndex + ", bild = 0" + randomToneIndex)); // DEBUG Zeile INFO: Er kann nicht mehrere Elemente mit dem gleichen Ton bzw. Bild erzeugen! TOFIX
				randomTone= new Tone(all_positions[randomPositionIndex][0],all_positions[randomPositionIndex][1],all_tones[randomToneIndex][1],all_tones[randomToneIndex][0],this,player,i);
				randomTone.fixed = true;
				randomTone.moves = false;
				s[randomToneIndex] = randomTone;
			}
			
			return s;
		}
		
		private function countSound(arr:Array, i:int):int{
			var count:int = 0;
			
			for each(var j:int in arr){
				if( j == i )
					count++;
			}
			return count;
		}
		
		private function addTone(e:TimerEvent):void
		{
			sound = sounds.shift(); //shift removes the first of the vector, and the others shift 1 position to left
			this.add(sound);
			add(new FlxText(70,10 + 80*sounds.length,100, "sound = " + sound.getOrder())); //DEBUG ZEILE
			sound.Added = true;
			FlxG.play(sound.getSound(),1,false);
			sound.flicker(0.2);
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