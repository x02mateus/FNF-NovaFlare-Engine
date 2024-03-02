package substates;

import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxSubState;

import sys.thread.Thread;
import sys.thread.Mutex;

class LoadingSubstate extends MusicBeatSubstate
{
    
    var game = PlayState.instance;
    var loadingStep:Int = -1;
    var RateBarText:FlxText;
    
	override function create()
	{
		/*RateBarText = new FlxText(50, 50, 0, "0", 32);
    	RateBarText.setFormat(font, 21, FlxColor.BLACK, LEFT);    	
    	RateBarText.antialiasing = ClientPrefs.data.antialiasing;
    	RateBarText.x = 0;
    	RateBarText.y = 305;
    	add(RateBarText);
    	*/
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
	    //RateBarText.text = 'data' + game.loadingStep;
	    if (game.loadingStep == 1) close();
	    
	    if (game.loadingStep != loadingStep) {
    	    loadingStep = game.loadingStep;
    	    game.cacheCreate();
	    }/*
	    if (game.reload){
	        game.reload = false;
	        game.cacheCreate();
	    }*/
		super.update(elapsed);
	}

	override function destroy(){
		
		super.destroy();
	}
}