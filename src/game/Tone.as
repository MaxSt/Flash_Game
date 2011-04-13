package game
{
	import org.flixel.*;

	public class Tone extends FlxSprite
	{
		[Embed(source="../assets/images/toneA.png")] private var ImgA:Class;
		[Embed(source="../assets/sounds/toneA.mp3")] private var SoundA:Class;
		
		[Embed(source="../assets/images/toneB.png")] private var ImgB:Class;
		
		[Embed(source="../assets/images/toneC.png")] private var ImgC:Class;
		[Embed(source="../assets/sounds/toneC.mp3")] private var SoundC:Class;
		
		private var player:Player;
		private var tone:String;
		
		public function Tone(X:Number, Y:Number, tone:String, player:Player)
		{
			super(X,Y);
			this.tone = tone;
			switch(this.tone){
				case "A": loadGraphic(ImgA,false);
						  FlxG.play(SoundA,1,false);	
						  break;
				case "B": loadGraphic(ImgB,false);
						  break;
				default: loadGraphic(ImgC,false);
						 FlxG.play(SoundC,1,false);
						 break;
			}
			flicker(2);
			this.player = player;
		}
		
		override public function update():void
		{
			if( collide(this.player ) && this.tone == "A" ){
				FlxG.play(SoundA,1,false);
			}
			else if( collide(this.player ) && this.tone == "C" ){
				FlxG.play(SoundC,1,false);
			}
			super.update();
		}
	}
}