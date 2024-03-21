package objects.screen;

import cpp.vm.Gc;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.utils.Assets;
import openfl.display.Sprite;
import objects.screen.Graphics;

class FPSCounter extends Sprite
{  
    public var data:TextField;
	public var title:TextField;

	public var bgSprite:FPSBG;
	
	public function new(x:Float = 10, y:Float = 10)
	{
		super();

		this.x = x;
		this.y = y;		
		
		bgSprite = new FPSBG();
		addChild(bgSprite);
		
		this.data = new TextField();
		this.title = new TextField();

		for(label in [this.data, this.title]) {
			label.x = 0;
			label.y = 0;
			label.defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/FPS.ttf").fontName, label == this.data ? 25 : 13, color, false, null, null, label == this.data ? CENTER : RIGHT, 0, 0);			
			label.multiline = label.wordWrap = false;
			addChild(label);
		}				
		
		this.title.y = bgSprite.height - this.title.height;
		 								
		this.data.text = "0";
		this.title.text = "/${ClientPrefs.data.framerate}FPS";  		
	}

    public function update():Void
	{
	    for(label in [this.data, this.title]) {		                          
    		if (ClientPrefs.data.rainbowFPS)
    	    {
    	        label.textColor = ColorReturn.transfer(DataGet.currentFPS, ClientPrefs.data.framerate);
    		}
    		else
    		{
    		    label.textColor = 0xFFFFFFFF;		
    		}                      
            
            if (!ClientPrefs.data.rainbowFPS && DataGet.currentFPS <= ClientPrefs.data.framerate / 2){
    		    label.textColor = 0xFFFF0000;
    		}								       
    	}
    	
    	this.data.text = DataGet.currentFPS;
    	this.title.text = "/${ClientPrefs.data.framerate}FPS";
	}
}

class ExtraCounter extends Sprite
{
	public var delay:TextField;
	public var mem:TextField;
	
	public var delayData:TextField;
	public var memData:TextField;

	public var bgSprite:FPSBG;
	
	public function new(x:Float = 10, y:Float = 60)
	{
		super();

		this.x = x;
		this.y = y;		
		
		bgSprite = new FPSBG();
		addChild(bgSprite);
		
		this.delay = new TextField();
		this.delayData = new TextField();
		this.mem = new TextField();		
		this.memData = new TextField();

		for(label in [this.delay, this.delayData, this.mem, this.memData]) {	
			label.x = 0;
			label.y = 0;
			label.defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/FPS.ttf").fontName, 15, color, false, null, null, LEFT, 0, 0);			
			label.multiline = label.wordWrap = false;
			addChild(label);
		}
		
		this.delayData.autoSize = this.memData.autoSize = CENTER;
		this.mem.y = this.memData.y = 20;
		
		this.delay.text = "Delay:           MS";
		this.mem.text = "Memory         MB";
    }
    
    public function update():Void
	{
	    for(label in [this.delay, this.delayData, this.mem, this.memData]) {                          
    		if (ClientPrefs.data.rainbowFPS)
    	    {
    	        label.textColor = ColorReturn.transfer(DataGet.currentFPS, ClientPrefs.data.framerate);
    		}
    		else
    		{
    		    label.textColor = 0xFFFFFFFF;		
    		}                      
            
            if (!ClientPrefs.data.rainbowFPS && DataGet.currentFPS <= ClientPrefs.data.framerate / 2){
    		    label.textColor = 0xFFFF0000;
    		}								       
    	}
    	
    	this.delay.text = "Delay:           MS";
		this.mem.text = "Memory          ${DataGet.memType}";
    	
        var showTime:Float = Math.floor((DataGet.displayedFrameTime + 0.5) * 10) / 10;
        this.delayData.text = showTime;
        this.memData.text = DataGet.memory;
	}
}
	
//////////////////////////////////////  ↓数据计算↓  //////////////////////////////////////

class DataGet {
    static public var currentFPS:Float = 0;
	static public var displayedFrameTime:Float;
	
	static public var memory:Float = 0;
	static public var memType:String = "MB";
    
    static public var wait:Float = 0;
    static public var number:Float = 0;
    
    static public function update(){
        
        wait += FlxG.elapsed * 1000;
        number++;
        if (wait < 50) return;
        
        /////////////////// →更新
        
        displayedFrameTime = displayedFrameTime * 0.9 + wait / number * 0.1;        				
		currentFPS = Math.floor(1000 / displayedFrameTime + 0.5);   		
		if (currentFPS > ClientPrefs.data.framerate) currentFPS = ClientPrefs.data.framerate;  
		
		/////////////////// →fps计算
		
		var mem = FlxMath.roundDecimal(Gc.memInfo64(ClientPrefs.data.memoryType) / 1000000, 1); //转化为MB
		if (Math.abs(mem) < 1000) {
		    memory = Math.abs(mem);
		    memType = "MB";
		} else {
		    memory = Math.ceil(Math.abs(mem / 1024) * 100) / 100;
		    memType = "GB";		
		}
		
		/////////////////// →memory计算
				
		wait = number = 0;
    }
}

class ColorReturn {
    static public function transfer(data:Float, maxData:Float):FlxColor
    {
        var red = 0;
        var green = 0;
        var blue = 126;
        
        if (data < maxData / 2) {
            red = 255;
            green = Std.int(255 * data / maxData * 2);
        } else {
            red = Std.int(255 * (maxData - data) / maxData * 2);
            green = 255;        
        }      
        
        return FlxColor.fromRGB(red, green, blue, 255);
   }
}