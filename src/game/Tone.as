package game
{
	import org.flixel.*;

	public class Tone extends FlxSprite
	{
		private var player:Player;
		private var sound:Class;
		private var order:int;
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
			if( collide(this.player)){
				FlxG.play(sound,1,false);
			}
			super.update();
		}
		
		
		public function getSound():Class{
			return this.sound;
		}
		
		public function getOrder():int{
			return this.order;
		}
		

		public function get isCollided():Boolean{
			return collide(this.player);
		}
	}
}