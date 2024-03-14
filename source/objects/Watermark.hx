package objects;

import openfl.display.Bitmap;
import openfl.display.BitmapData;

import cpp.vm.Gc;
import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;

#if flash
import openfl.Lib;
#end

import haxe.Timer;

import openfl.utils.Assets;

class Watermark extends Bitmap
{
    public function new(x:Float = 10, y:Float = 10, Alpha:Float = 0.5){

        super();
        
        var image:String = Paths.modFolders('images/menuExtend/Others/watermark.png');
        
        bitmapData = BitmapData.fromFile(image);

		this.x = x;
		this.y = y;
        this.alpha = Alpha;        
    }
} 


class FPS extends TextField
{
	public var currentFPS(default, null):Float;
    public var logicFPStime(default, null):Float;
    public var timeSave(default, null):Float;
	
	@:noCompletion private var currentTime:Float;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		timeSave = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/montserrat.ttf").fontName, 16, color, false, null, null, LEFT, 0, 0);
		autoSize = LEFT;
		
		multiline = true; //多行文本
		wordWrap = false; //禁用自动换行
		
		text = "FPS: ";		
	}
	
	var currentColor = 0;    
	var skippedFrames:Float = 0;	 
    var logicFPSnum = 0;
	
    var ColorArray:Array<Int> = [
		0xFF9400D3,
		0xFF4B0082,
		0xFF0000FF,
		0xFF00FF00,
		0xFFFFFF00,
		0xFFFF7F00,
		0xFFFF0000
	                                
	    ];

	// Event Handlers
	private override function __enterFrame(deltaTime:Float):Void
	{			
		deltaTime = haxe.Timer.stamp() - timeSave;
		
		currentFPS = DampInterpolation.damp(currentFPS, 1000 / deltaTime, 100, deltaTime);
        
        if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;             
        
        var changeNum:Int = 20;  //change color num for 1s
		
		if (ClientPrefs.data.rainbowFPS)
	    {
	        if (skippedFrames >= 1000 / changeNum)
		    {
		    	if (currentColor >= ColorArray.length)
    				currentColor = 0;
    			textColor = ColorArray[currentColor];
    			currentColor++;
    			skippedFrames = 0;
    		}
    		else
    		{
    			skippedFrames += deltaTime;
    		}
		}
		else
		{
		textColor = 0xFFFFFFFF;		
		}                      
        
        if (!ClientPrefs.data.rainbowFPS && currentFPS <= ClientPrefs.data.framerate / 2){
		    textColor = 0xFFFF0000;
		}								       
		
		text = "FPS: " + currentFPS + "/" + ClientPrefs.data.framerate;

		var memoryMegas:Float = 0;
        var memType:String = ' MB';					

		// be a real man and calculate memory from hxcpp
		var actualMem:Float = Gc.memInfo64(ClientPrefs.data.memoryType); // update: this sucks
		
		memoryMegas = Math.abs(FlxMath.roundDecimal(actualMem / 1000000, 1));
		
		if (ClientPrefs.data.showMEM){
			if (memoryMegas > 1000){
			    memoryMegas = Math.ceil( Math.abs( actualMem ) / 10000000 / 1.024)/100;
			    memType = ' GB';
			}    
			
			text += "\nMEM: " + memoryMegas + memType;          
		}
            
        if (ClientPrefs.data.showMS) text += '\n' + "Delay: " + Math.floor(1 / currentFPS * 10000 + 0.5) / 10 + " MS";
        
        text += "\nNovaFlare V1.1.0";            
		text += "\n";	
			
		timeSave = haxe.Timer.stamp();
	}
}

class DampInterpolation {
    static public function damp(current:Float, target:Float, maxSpeed:Float, deltaTime:Float):Float {
        var velocity:Float = (target - current) / deltaTime;
        var dampedVelocity = velocity * (1 - Math.exp(-deltaTime * 0.002));
        var dampedPosition = current + dampedVelocity * deltaTime;

        if (Math.abs(velocity) > maxSpeed) {
            dampedVelocity = Math.sign(velocity) * maxSpeed;
        }

        return dampedPosition;
    }
}