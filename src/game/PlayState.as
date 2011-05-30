package game
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.ui.*;
	import flash.utils.Timer;
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import org.flixel.*;
	
	public class PlayState extends FlxState
	{
		//tone pictures
		[Embed(source="../assets/images/toneA.png")] private var ImgA:Class;
		[Embed(source="../assets/images/toneB.png")] private var ImgB:Class;
		[Embed(source="../assets/images/toneC.png")] private var ImgC:Class;
		[Embed(source="../assets/images/toneD.png")] private var ImgD:Class;
		[Embed(source="../assets/images/toneE.png")] private var ImgE:Class;
		[Embed(source="../assets/images/toneF.png")] private var ImgF:Class;
		
		
		//tone sounds
		[Embed(source="../assets/sounds/toneA.mp3")] private var SoundA:Class;
		[Embed(source="../assets/sounds/toneB.mp3")] private var SoundB:Class;
		[Embed(source="../assets/sounds/toneC.mp3")] private var SoundC:Class;
		[Embed(source="../assets/sounds/toneD.mp3")] private var SoundD:Class;
		[Embed(source="../assets/sounds/toneE.mp3")] private var SoundE:Class;
		[Embed(source="../assets/sounds/toneF.mp3")] private var SoundF:Class;

		//private var all_tones:Vector.<Class,Class> = new Vector.<Class,Class>((ImgA,SoundA),(ImgB,SoundB),(ImgC,SoundC));
		//private var all_positions:Vector.<int,int> = new Vector.<int,int>((50,5),(290,20),(170,210));
		
		private var all_tones:Array = new Array( new Array(ImgA,SoundA), new Array(ImgB,SoundB), new Array(ImgC,SoundC), new Array(ImgD,SoundD), new Array(ImgE,SoundE), new Array(ImgF,SoundF) );
		private var all_positions:Array = new Array( new Array(50,5), new Array(290,20), new Array(170,210) );
		
		
		//level maps
		[Embed(source="../assets/images/Level_1.png")] private var PNGLevel_1:Class;
		
		private var level:FlxTilemap;
		private var score:FlxText
		private var player:Player;
		private var tonA:Tone;
		private var tonC:Tone;
		private var tonB:Tone;
		
		private var timer:Number = 1;

		
		public var levelMaxOrder:int = 3;
		public var orderPos:int = 0;
		
		public var activeSound:Tone;
		
		public var kill:Boolean = false;
		
		private var timerAddTone:Timer = new Timer(2000,1);
		private var timerSuccesGame:Timer = new Timer(1000,1);
		private var timerRepeatSound:Timer = new Timer(1000,1);
		
		private var sound:Tone;
		private var sounds:Vector.<Tone> = new Vector.<Tone>();
		private var soundsShow:Vector.<Tone> = new Vector.<Tone>();
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
			score = new FlxText(170,5,200);
			score.setFormat(null, 5, 0x0000AA, "center",2);
			
			score.text = "Score: " + FlxG.score.toString();
			
			//Add game objects
			var player:Player = new Player(150,210);
			setPlayer(player);
			FlxG.follow(player);
			
			add(level);
			add(score);
			add(player);
			

	
			sounds = loadSoundGroup();
			
			for each(var i:Tone in sounds){
				for each(var j:Tone in sounds){
					if(i.overlaps(j))
						if(j.getOrder() < i.getOrder())
							i.visible = false;
				}
			}
			
			
			for each(var s:Tone in sounds){
				soundsCopy.push(s); 
			}
	
			
			
			
		}
		
		override public function update():void
		{
			
			if (sounds.length > 0 ){
				player.fixed = true;
				player.moves = false;	
				player.visible = false;
			}else{
				player.fixed = false;
				player.moves = true;
				player.visible = true;
			}
			
			if (kill == true){
				timer -= FlxG.elapsed;
				if (timer <= 0)
				{
					timer = 1;
					sound.kill();
					kill = false;
				}
			}
			else{
				if( soundsShow.length > 0){
					timerAddTone.start();
				}
				else{
					if(sounds.length > 0){
						sound = sounds.shift(); //shift removes the first of the vector, and the others shift 1 position to left
						this.add(sound);
					}
							
				}
			}
			
			
			if( !this.player.onScreen() ){
				this.player.kill();
				FlxG.state = new GameOverState();
			}
			
		
			
			
			activeSound = getColidedSound();
			if(activeSound){
				if( checkOrder(activeSound) ){
					orderPos += 1;
					//showScore();
					activeSound.Collided = false;
					activeSound.Killed = true;
					activeSound.kill();
					
					for each(var s:Tone in soundsCopy){
						s.visible = true;
						sounds.push(s); 
					}
					
					for each(var i:Tone in sounds){
						for each(var j:Tone in sounds){
							if(i.isKilled)
								i.visible = false;
							if(i.overlaps(j))
								if(j.getOrder() < i.getOrder())
									if(j.isKilled == false)
										i.visible = false;
						}
					}
					
					
					
					
					
					if(orderPos == levelMaxOrder){
						timerSuccesGame.start();
					}	
				}else{
					FlxG.state = new GameOverState();
				}
			}
			
			
			super.update();
			collide();
		}
		
		private function checkOrder(sound:Tone):Boolean{
			return (sound.getOrder() == orderPos)
		}
		
		private function getColidedSound():Tone{
			for each(var s:Tone in soundsCopy){
					if (s.isCollided){
						return s;
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
				randomTone= new Tone(all_positions[randomPositionIndex][0],all_positions[randomPositionIndex][1],all_tones[randomToneIndex][1],all_tones[randomToneIndex][0],player,i);
				randomTone.fixed = true;
				randomTone.moves = false;
				s[i] = randomTone;
				soundsShow.push(new Tone(all_positions[randomPositionIndex][0],all_positions[randomPositionIndex][1],all_tones[randomToneIndex][1],all_tones[randomToneIndex][0],player,i));	
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
			sound = soundsShow.shift(); //shift removes the first of the vector, and the others shift 1 position to left
			this.add(sound);
			FlxG.play(sound.getSound(),1,false);
			sound.flicker(0.2);
			kill = true;
			
		}
		
		private function playAgain(e:TimerEvent):void{
			//FlxG.state = new YouWonState();
			FlxG.state = new LevelState(levelMaxOrder + 1);
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