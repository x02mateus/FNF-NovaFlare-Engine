package objects.screen;

import cpp.vm.Gc;
import haxe.Timer;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets;

class FPSCounter extends TextField
{
    public var currentFPS(default, null):Float;
	public var displayedFrameTime(default, null):Float;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		displayedFrameTime = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/FPS.ttf").fontName, 18, color, false, null, null, LEFT, 0, 0);
		autoSize = LEFT;
		
		multiline = true; //多行文本
		wordWrap = false; //禁用自动换行
		
		text = "FPS: ";		
	}

    public function update():Void
	{		
		displayedFrameTime = DampInterpolation.damp(displayedFrameTime, FlxG.elapsed * 1000, 1, FlxG.elapsed * 1000);
		
		currentFPS = Math.floor(1000 / displayedFrameTime  * 10) / 10;
        
        if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;             
        
		if (ClientPrefs.data.rainbowFPS)
	    {
	        this.textColor = ColorReturn.transfer(currentFPS, ClientPrefs.data.framerate);
		}
		else
		{
		this.textColor = 0xFFFFFFFF;		
		}                      
        
        if (!ClientPrefs.data.rainbowFPS && currentFPS <= ClientPrefs.data.framerate / 2){
		    this.textColor = 0xFFFF0000;
		}								       
		
		this.text = "FPS: " + currentFPS;
	}
}

class MSCounter extends TextField
{
    public var currentFPS(default, null):Float;
	public var displayedFrameTime(default, null):Float;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		displayedFrameTime = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/FPS.ttf").fontName, 12, color, false, null, null, LEFT, 0, 0);
		autoSize = LEFT;
		
		multiline = true; //多行文本
		wordWrap = false; //禁用自动换行
		
		text = "FPS: ";		
	}

	public function update():Void
	{			
		displayedFrameTime = DampInterpolation.damp(displayedFrameTime, FlxG.elapsed * 1000, 1, FlxG.elapsed * 1000);				
        
        if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;             
        
		if (ClientPrefs.data.rainbowFPS)
	    {
	        this.textColor = ColorReturn.transfer(currentFPS, ClientPrefs.data.framerate);
		}
		else
		{
		this.textColor = 0xFFFFFFFF;		
		}                      
        
        if (!ClientPrefs.data.rainbowFPS && currentFPS <= ClientPrefs.data.framerate / 2){
		    this.textColor = 0xFFFF0000;
		}								       
		
		this.text = "Delay: " + displayedFrameTime + "MS";
	}
}


class ColorReturn {
    static public function transfer(data:Float, maxData:Float):FlxColor
    {
        var red = 0;
        var green = 0;
        var blue = 126;
        
        if (data < maxData) {
            red = 255;
            green = Std.int(255 * data / maxData);
        } else {
            red = Std.int(255 * (maxData - data) / maxData);
            green = 255;        
        }      
        
        return FlxColor.fromRGB(red, green, blue, 255);
   }
}

class DampInterpolation {
    static public function damp(a:Float, b:Float, k:Float, dt:Float):Float {
        var damping = Math.exp(-k * dt);
        return (1.0 - damping) * a + damping * b;
    }

}