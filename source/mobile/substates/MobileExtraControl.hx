package mobile.substates;

import flixel.addons.transition.FlxTransitionableState;

class MobileExtraControl extends MusicBeatSubstate
{
    var returnArray:Array<Array<String>> = [
        ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'G', 'K', 'L', 'M'],
        ['N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
        ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'],
        ['ZERO', 'ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE'],        
        ['SPACE', 'BACKSPACE', 'ENTER', 'SHIFT', 'TAB', 'ESCAPE'],
    ];
    
    var displayArray:Array<Array<String>> = [
        ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'G', 'K', 'L', 'M'],
        ['N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
        ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'],
        ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'],        
        ['SPACE', 'BACK\nSPACE', 'ENTER', 'SHIFT', 'TAB', 'ESCAPE'],
    ];
    
    var titleTeam:FlxTypedGroup<ChooseButton>;           
    var optionTeam:FlxTypedGroup<ChooseButton>;   
    
    var isMain:Bool = true;
    
    var titleNum:Int = 0;
    var percent:Float = 0;
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
			var _x = FlxG.width / 2 + (titleWidth + 50) * ((i-1) - 4 / 2);
	        var titleObject = new ChooseButton(_x, 150, titleWidth, titleHeight, data, "Key " + Std.string(i));    		    			 			
    		titleTeam.add(titleObject);	    		
	    }
	    
	    optionTeam = new FlxTypedGroup<ChooseButton>();
		add(optionTeam);			
	    
	    for (type in 0...returnArray.length){
	        var _length:Int = returnArray[type].length;
	        for (number in 0..._length){
	            var _x = FlxG.width / 2 + optionWidth * (number - _length / 2);
	            var titleObject = new ChooseButton(_x, 300 + (optionHeight + 20) * type, optionWidth, optionHeight, displayArray[type][number]);    		    			 			
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
		
		if (left || right){		   
		    if (isMain){		        		    
    		    chooseNum += left ? -1 : 1;
    		    if (chooseNum > displayArray[typeNum].length - 1)
    		        chooseNum = 0;
    		    if (chooseNum < 0)
    		        chooseNum = displayArray[typeNum].length - 1;
    		    updateChoose(0);
    		} else {
    		    titleNum += left ? -1 : 1;
    		    if (titleNum > displayArray.length - 1)
    		        titleNum = 0;
    		    if (titleNum < 0)
    		        titleNum = displayArray.length - 1;
    		    updateTitle(titleNum + 1, true);
    		}
		}
		
		if (up || right){
		    if (isMain){		
    		    percent = chooseNum / displayArray[typeNum].length - 1;
    		    typeNum += up ? -1 : 1;
    		    if (typeNum > displayArray.length - 1)
    		        typeNum = 0;
    		    if (typeNum < 0)
    		        typeNum = displayArray.length - 1;    
    		    chooseNum = Std.Int(percent * (displayArray.length - 1));
    		    updateChoose(0);
    		}
		}
		
		if (accept){
		    if (isMain){
		        isMain = false;		        
		        updateChoose(1);
		    } else {
		        switch(titleNum + 1){
		            case 1:
		                ClientPrefs.data.extraKeyReturn1 = returnArray[typeNum][chooseNum];
		            case 2:
		                ClientPrefs.data.extraKeyReturn2 = returnArray[typeNum][chooseNum];
		            case 3:
		                ClientPrefs.data.extraKeyReturn3 = returnArray[typeNum][chooseNum];
		            case 4:
		                ClientPrefs.data.extraKeyReturn4 = returnArray[typeNum][chooseNum];
		        }
		        ClientPrefs.saveSettings();
		        updateTitle(titleNum + 1);
		    }					
		}
		
		if (back){
		    if (isMain){
		        ClientPrefs.saveSettings();
		        FlxG.sound.play(Paths.sound('cancelMenu'));
                FlxTransitionableState.skipNextTransIn = true;
    			FlxTransitionableState.skipNextTransOut = true;
    			MusicBeatState.switchState(new options.OptionsState());		    
		    } else {
		        isMain = true;
		        percent = chooseNum = typeNum = 0;
		        updateChoose(2);		    		        
		    }					          
        }
	}	        
	
	function updateChoose(soundsType:Int = 0){
	    switch(soundsType){
	        case 0:
	            FlxG.sound.play(Paths.sound('scrollMenu'));
	        case 1:
	            FlxG.sound.play(Paths.sound('confirmMenu'));
	        case 2:
	            FlxG.sound.play(Paths.sound('cancelMenu'));	        
	    }
	    
	    var chooseNum = 0;
	    
	    for (type in 0...displayArray.length){
	        if (type < typeNum) chooseNum += displayArray[type].length;	      
	    }
	    
	    for (i in 0...optionTeam.length)
		{
			var option:ChooseButton = optionTeam.members[i];
			
			if (option == optionTeam.members[chooseNum] && !isMain)
			    option.changeColor(FlxColor.WHITE);
			else
			    option.changeColor(FlxColor.BLACK);
		}	
	}
	
	function updateTitle(number:Int = 0, changeBG:Bool = false){
	    FlxG.sound.play(Paths.sound('confirmMenu'));
	    
	    for (i in 0...titleTeam.length)
		{
			var title:ChooseButton = titleTeam.members[i];
			
			if (title == titleTeam.members[chooseNum]){
			    title.changeExtraText(Reflect.field(ClientPrefs.data, "extraKeyReturn" + number));
			    if (changeBG) title.changeColor(FlxColor.WHITE);
			} else {
			    if (changeBG) title.changeColor(FlxColor.BLACK);
			}
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
	    
	    bg = new FlxSprite(0, 0).makeGraphic(width, height, FlxColor.BLACK);
	    bg.color = FlxColor.WHITE;
	    bg.alpha = 0.4;
		bg.scrollFactor.set();
		add(bg);
	
	    titleObject = new FlxText(0, 0, width, title);
		titleObject.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.antialiasing = ClientPrefs.data.antialiasing;
		titleObject.borderSize = 2;
		titleObject.x = bg.width / 2 - titleObject.width / 2;
		titleObject.y = bg.height / 2 - titleObject.height / 2;
		add(titleObject);
		
		if (extendTitle != null){ 
    		extendTitleObject = new FlxText(0, 0, width, extendTitle);
    		extendTitleObject.setFormat("VCR OSD Mono", 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		extendTitleObject.antialiasing = ClientPrefs.data.antialiasing;
    		extendTitleObject.borderSize = 2;
    		extendTitleObject.x = bg.width / 2 - extendTitleObject.width / 2;
		    extendTitleObject.y = 30;
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