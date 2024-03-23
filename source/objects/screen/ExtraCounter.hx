package objects.screen;

class ExtraCounter extends Sprite
{
	public var delay:TextField;
	public var mem:TextField;
	
	public var delayData:TextField;
	public var memData:TextField;

	public var bgSprite:FPSBG;
	
	public function new(x:Float = 10, y:Float = 10)
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
			label.defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/FPS.ttf").fontName, 15, 0xFFFFFFFF, false, null, null, LEFT, 0, 0);			
			label.multiline = label.wordWrap = false;
			addChild(label);
		}
		
		this.delayData.autoSize = this.memData.autoSize = LEFT;
		this.memData.autoSize = this.memData.autoSize = LEFT;
		this.delay.y = this.delayData.y = 20;

		this.delayData.y += 0.5;
		this.memData.y += 0.5;

		this.delay.y += 2;
		this.mem.y += 2;
		this.delayData.y += 2;
		this.memData.y += 2;

		this.memData.x = this.memData.x + 35 * 2;
		this.delayData.x = this.delayData.x + 28 * 2;
		
    	this.delay.text = "Delay:MS";
		this.mem.text = "Memory:MB";

		this.delay.width = 300;
		this.mem.width = 300;

		this.delay.x += 4;
		this.mem.x += 4;
		this.delayData.x += 4;
		this.memData.x += 4;
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
    	
        var showTime:Float = Math.floor((DataGet.displayedFrameTime) * 10) / 10;
        this.delayData.text = Std.string(showTime);
        this.memData.text = Std.string(DataGet.memory);
	}
}