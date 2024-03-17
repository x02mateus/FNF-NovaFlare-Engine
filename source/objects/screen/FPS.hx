package objects.screen;

import openfl.display.Sprite;

import objects.screen.DataCounter;
import objects.screen.Graphics;

class FPS extends Sprite
{
	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;
		
		create();
	}
    
    public static var blackBG:FPSBG;    
    public static var fpsShow:FPSCounter;
    public static var msShow:MSCounter;    
    
    function create()
    {
        blackBG = new FPSBG(10, 10);
        addChild(blackBG);
        
        fpsShow = new FPSCounter();
        addChild(fpsShow);
    
        msShow = new MSCounter();
        addChild(msShow);
    }
    
    private override function __enterFrame(deltaTime:Float):Void
	{
	    fpsShow.x = blackBG.x;
	    fpsShow.y = blackBG.y;
	    
	    msShow.x = blackBG.x;
	    msShow.y = blackBG.y + fpsShow.height - 3 * ClientPrefs.data.FPSScale;
	    
	    DataGet.update();
	    
	    fpsShow.update();
	    msShow.update();
    }
}