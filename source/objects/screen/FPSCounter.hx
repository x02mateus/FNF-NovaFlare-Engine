package objects.screen;

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
			label.defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/FPS.ttf").fontName, label == this.data ? 25 : 13, 0xFFFFFFFF, false, null, null, label == this.data ? CENTER : RIGHT, 0, 0);			
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
    	
    	this.data.text = Std.string(DataGet.currentFPS);
    	this.title.text = "/${ClientPrefs.data.framerate}FPS";
	}
}