package mobile.substates;

import flixel.addons.transition.FlxTransitionableState;

class MobileExtraControl extends MusicBeatSubstate
{
    var returnArray:Array<Array<String>> = [
        ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'G', 'K', 'L', 'M'],
        ['N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
        ['ZERO', 'ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE'],
        ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'],
        ['SPACE', 'BACKSPACE', 'ENTER', 'SHIFT', 'TAB', 'ESCAPE'],
    ];
    
    var displayArray:Array<Array<String>> = [
        ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'G', 'K', 'L', 'M'],
        ['N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
        ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],
        ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'],
        ['SPACE', 'BACKSPACE', 'ENTER', 'SHIFT', 'TAB', 'ESCAPE'],
    ];
    
    var titleTeam:FlxTypedGroup<ChooseButton>;           
    var optionTeam:FlxTypedGroup<ChooseButton>;   
    
    var isMain:Bool = true;
    
    var titleNum:Int = 0;
    var typeNum:Int = 0;
    var chooseNum:Int = 0;
    
    var titleWidth:Int = 200;
    var titleHeight:Int = 100;
    
    var optionWidth:Int = 80;
    var optionHeight:Int = 30;
    
    override function create()
	{
	    cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	    
	    var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		bg.scrollFactor.set();
		bg.alpha = 0.5;
		add(bg);  
		
		titleTeam = new FlxTypedGroup<ChooseButton>();
		add(titleTeam);				
		
		for (i in 1...5){    
			var data:String = Reflect.field(ClientPrefs.data, "extraKeyReturn" + i);    	
			var _x = FlxG.width / 2 - titleWidth / 2 + titleWidth * ((i-1) - 4 / 2);
	        var titleObject = new ChooseButton(_x, 100, titleWidth, titleHeight, data, "Key " + Std.string(i));    		    			 			
    		titleTeam.add(titleObject);	    		
	    }
	    
	    optionTeam = new FlxTypedGroup<ChooseButton>();
		add(optionTeam);			
	    
	    for (type in 0...returnArray.length){
	        var _length:Int = returnArray[type].length;
	        for (number in 0..._length){
	            var _x = FlxG.width / 2 - optionWidth / 2 + optionWidth * (number - _length / 2);
	            var titleObject = new ChooseButton(_x, 400 + (optionHeight + 20) * type, optionWidth, optionHeight, displayArray[type][number]);    		    			 			
    		    optionTeam.add(titleObject);	   	                
	        }	    	    	    
	    }        
	    
	    addVirtualPad(OptionStateC, OptionStateC);
		addVirtualPadCamera(false);
		
		super.create();
    }   
    
    override function update(elapsed:Float)
	{
	    super.update(elapsed);
	    
	    var accept = controls.ACCEPT;
		var right = controls.UI_RIGHT_P;
		var left = controls.UI_LEFT_P;
		var up = controls.UI_UP_P;
		var down = controls.UI_DOWN_P;
		var back = controls.BACK;
		
		if (back){
            ClientPrefs.saveSettings();
            FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			MusicBeatState.switchState(new options.OptionsState());
        }
	}	        
}

class ChooseButton extends FlxSpriteGroup
{    
    public var bg:FlxSprite;
    public var titleObject:FlxText;
    public var extendTitleObject:FlxText;
    
    public function new(x:Float, y:Float, width:Int, height:Int, title:String, ?extendTitle:String = null)
	{
	    super(x, y);
	    
	    bg = new FlxSprite(0, 0).makeGraphic(width, height, FlxColor.WHITE);
	    bg.color = FlxColor.WHITE;
	    bg.alpha = 0.4;
		bg.scrollFactor.set();
		bg.alpha = 0;
		add(bg);
	
	    titleObject = new FlxText(0, 0, width, title);
		titleObject.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.antialiasing = ClientPrefs.data.antialiasing;
		titleObject.borderSize = 2;
		titleObject.x = bg.width / 2 - titleObject.width / 2;
		titleObject.y = bg.height / 2 - titleObject.height / 2;
		add(titleObject);
		
		if (extendTitle != null){ 
    		extendTitleObject = new FlxText(0, 0, width, extendTitle);
    		extendTitleObject.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		extendTitleObject.antialiasing = ClientPrefs.data.antialiasing;
    		extendTitleObject.borderSize = 2;
    		extendTitleObject.x = bg.width / 2 - extendTitleObject.width / 2;
		    extendTitleObject.y = 10;
    		add(extendTitleObject);
    		
    		titleObject.y = extendTitleObject.y + 30;
		}
	}
	
	public function changeColor(color:FlxColor){
	    bg.color = color;
		alpha = 0.4;
	    updateHitbox();	
	}
	
	public function changeExtraText(text:String){
	    extendTitleObject.text = text;
	}
}