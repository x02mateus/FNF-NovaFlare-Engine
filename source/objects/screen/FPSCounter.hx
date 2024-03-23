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
		
		title.defaultTextFormat = new TextFormat(Assets.getFont("assets/fonts/FPS.ttf").fontName, 16, 0xFFFFFFFF, false, null, null, LEFT, 0, 0);	
		this.title.x = this.title.x + this.data.width / 2 - 2;
		this.title.y = this.title.y + this.data.height - this.title.height / 1.35;

		this.data.y -= 2;
		 								
		this.data.text = "0";
		this.title.text = "/" + ClientPrefs.data.framerate + "FPS ";  
		
		this.data.x += 12;
		this.title.x += 12;
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
    	
    	this.title.text = "/" + ClientPrefs.data.framerate + "FPS "; 
    	
    	this.data.text = Std.string(DataGet.currentFPS) + " ";
	}
}