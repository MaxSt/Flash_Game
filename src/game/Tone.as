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
		private var added:Boolean = false;
		private var ImgSound:Class;
		
		public function Tone(X:Number, Y:Number, sound:Class, ImgSound:Class, pS:PlayState, player:Player, order:int)
		{
			super(X,Y);
			this.x = x;
			this.y = y;
			this.pS = pS;
			this.player = player;
			this.sound = sound;
			this.order = order;
			this.ImgSound = ImgSound;
			anzeigen();
			//FlxG.play(sound,1,false);	
		}
		
		public function anzeigen():void
		{
			this.loadGraphic(ImgSound,false);
		}
		
		override public function update():void
		{
			if( collide(this.player) && !isCollided){
				this.kill();
				FlxG.play(sound,1,false);
				flicker(0.2);
				if( collideLeft )
					player.reset(player.x - 2, player.y);
				else if( collideRight )
					player.reset(player.x + 2, player.y);
				else if( collideTop )
					player.reset(player.x - 15, player.y - 10);
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
	
		
		public function set Added(a:Boolean):void{
			this.added = a;
		}
		
		public function get isAdded():Boolean{
			return this.added;
		}
	}
}