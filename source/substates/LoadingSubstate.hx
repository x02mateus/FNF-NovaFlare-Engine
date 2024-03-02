package substates;

import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxSubState;

import sys.thread.Thread;
import sys.thread.Mutex;

class LoadingSubstate extends MusicBeatSubstate
{
    
    var game = PlayState.instance;
    var loadingStep:Int = 0;
    
	override function create()
	{
		
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
	    if (game.loadingStep == 9) close();
	    if (game.loadingStep != loadingStep) game.cacheCreate();
	    if (game.reload){
	        game.reload = false;
	        game.cacheCreate();
	    }
		super.update(elapsed);
	}

	override function destroy(){
		
		super.destroy();
	}
}