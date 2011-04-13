package game
{
	import org.flixel.*;
	
	
	public class Player extends FlxSprite
	{
		[Embed(source="../assets/images/player.png")] private var ImgPlayer:Class;		
		
		public function Player(X:Number, Y:Number)
		{
			super(X,Y);
			loadGraphic(ImgPlayer,false);
			maxVelocity.x = 80;
			maxVelocity.y = 400;
			acceleration.y = 300;
			drag.x = maxVelocity.x * 4;
		}
		
		override public function update():void
		{
			acceleration.x = 0;
			if(FlxG.keys.LEFT)
				acceleration.x -= drag.x;
			if(FlxG.keys.RIGHT)
				acceleration.x += drag.x;
			
			if(onFloor)
			{
				//Jump controls	
				if(FlxG.keys.SPACE){
					velocity.y = -acceleration.y/2;
					play("jump");
				}
				//animations
				/*
				else if(velocity.x > 0)
					play("walk");
				else if(velocity.x < 0)
					play("walk_back");
				else
					play("idle");
				*/
			}
			/*
			else if(velocity.y < 0)
				play("jump");
			else
				play("idle"); //bzw. "fall"
			*/
			
			super.update();
		}
	}
}