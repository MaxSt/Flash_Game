package game
{
	import org.flixel.*;

	public class Tone extends FlxSprite
	{
		private var player:Player;
		private var sound:Class;
		private var order:int;
		private var pS:PlayState;
		private var collided:Boolean;
		private var repeat:int;
		
		public function Tone(X:Number, Y:Number, sound:Class, ImgSound:Class, pS:PlayState, player:Player, order:int, repeat:int)
		{
			super(X,Y);
			this.pS = pS;
			this.player = player;
			this.sound = sound;
			this.order = order;
			this.repeat = repeat;
			loadGraphic(ImgSound,false);
			//FlxG.play(sound,1,false);	
		}
		
		override public function update():void
		{
			if( collide(this.player) && !isCollided){
				FlxG.play(sound,1,false);
				flicker(0.2);
				player.reset(player.x - 2, player.y);
				Collided = true;
			}
			super.update();
		}
		
		
		public function getSound():Class{
			return this.sound;
		}
		
		public function getOrder():int{
			return this.order;
		}
		
		public function set Collided(col:Boolean):void{
			this.collided = col;
		}
		
		public function get isCollided():Boolean{
			return this.collided;
		}
		
		public function set Repeat(rep:int):void{
			this.repeat = rep;
		}
		
		public function get Repeat():int{
			return this.repeat;
		}
	}
}