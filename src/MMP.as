package
{
	import org.flixel.*;
	[SWF(width="640", height="480", backgroundColor="#000000")]
	
	public class MMP extends FlxGame
	{
		public function MMP()
		{
			super(320,240,PlayState,2); //Create a new FlxGame object at 320x240 with 2x pixels, then load PlayState
		}
	}
}