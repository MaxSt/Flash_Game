package game
{
	import org.flixel.*;

	public class Tone extends FlxSprite
	{
		private var player:Player;
		private var sound:Class;
		private var order:int;
		private var collided:Boolean = false;
		private var pS:PlayState;
		
		public function Tone(X:Number, Y:Number, sound:Class, ImgSound:Class, pS:PlayState, player:Player, order:int)
		{
			super(X,Y);
			this.pS = pS;
			this.player = player;
			this.sound = sound;
			this.order = order;
			loadGraphic(ImgSound,false);
			//FlxG.play(sound,1,false);	
		}
		
		override public function update():void
		{
			if( collide(this.player ) && !isCollided ){
				FlxG.play(sound,1,false);
				pS.playedToneOrder.push(this.order);
				isCollided = true;
			}
			super.update();
		}
		
		
		public function getSound():Class{
			return this.sound;
		}
		
		public function getOrder():int{
			return this.order;
		}
		
		public function set isCollided(col:Boolean):void{
			this.collided = col;
		}
		
		public function get isCollided():Boolean{
			return this.collided;
		}
	}
}