package game
{
	import org.flixel.*;

	public class Tone extends FlxSprite
	{
		private var player:Player;
		private var sound:Class;
		
		public function Tone(X:Number, Y:Number, sound:Class, ImgSound:Class, player:Player)
		{
			super(X,Y);
			this.player = player;
			this.sound = sound;
			loadGraphic(ImgSound,false);
			//FlxG.play(sound,1,false);	
			flicker(2);
		}
		
		override public function update():void
		{
			if( collide(this.player ) ){
				FlxG.play(sound,1,false);
			}
			super.update();
		}
	}
}