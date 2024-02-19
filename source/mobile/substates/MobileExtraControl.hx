package mobile.substates;

import flixel.addons.transition.FlxTransitionableState;

class MobileExtraControl extends MusicBeatSubstate
{
    var returnArray:Array<Array<String>> = [
        ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'G', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'],
        ['ZERO', 'ONE', 'TWO', 'THREE', 'FOUR', 'FIVE', 'SIX', 'SEVEN', 'EIGHT', 'NINE'],
        ['F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12'],
        ['SPACE', 'BACKSPACE', 'ENTER', 'SHIFT', 'TAB', 'ESCAPE'],
    ];
    
    var showArray:Array<String> = [
        'A-Z',
        '0-9',
        'F1-F12',
        'OTHERS'
    ];
    
    var chooseArray:Array<String> = [];                
    
    var mainNum:Int = 0; //所处阶段
    
    var keysNum:Int = 0; //选择设置
    var optionNumber:FlxTypedGroup<ChooseButton>;
    
    var typeNum:Int = 0; //4选1
    var typeNumber:FlxTypedGroup<FlxText>;
    var typeTween:Array<FlxTween> = [];
    
    var chooseNum:Int = 0; //小类准确
    var buttonNumber:FlxTypedGroup<ChooseButton>;
    var chooseTween:Array<FlxTween> = [];
    
    override function create()
	{
	    var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		bg.alpha = 0;
		add(bg);
		FlxTween.tween(bg, {alpha: 0.5}, 0.5, {ease: FlxEase.circInOut});        
        
        optionNumber = new FlxTypedGroup<ChooseButton>();
        add(optionNumber);
        
        buttonNumber = new FlxTypedGroup<ChooseButton>();
        add(buttonNumber);
        
        typeNumber = new FlxTypedGroup<FlxText>();
        add(typeNumber);
        
        for (i in 0...4){
	        var realKey:Int = i + 1;
	        var controlReturn:String = '';
	        
            switch(i){
                case 0:
                    controlReturn = ClientPrefs.data.extraKeyReturn1;
                case 1:
                    controlReturn = ClientPrefs.data.extraKeyReturn2;
                case 2:
                    controlReturn = ClientPrefs.data.extraKeyReturn3;
                case 3:
                    controlReturn = ClientPrefs.data.extraKeyReturn4;            
            }	        
	        
	        var button:ChooseButton = new ChooseButton(0, -100, 200, 100, 'key' + realKey, controlReturn);
	        button.x = 640 + 250 * (i - 2);	        	  
	        
	        FlxTween.tween(button, {y: 100}, 0.5, {ease: FlxEase.quadInOut});                
	        
	        optionNumber.add(button);	    
	    }	
	    
	    for (i in 0...5){	    	    	    
	        if (i != 0){
    	        var titleObject = new FlxText(0, 250 + 50 * i + 500, 0, showArray[i-1]);
        		titleObject.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        		titleObject.antialiasing = ClientPrefs.data.antialiasing;
        		titleObject.borderSize = 1;
        		titleObject.screenCenter(X);
        		if (i != 1)titleObject.alpha = 0.5;
        		typeTween[i] = FlxTween.tween(titleObject, {y: 250 + 50 * i}, 0.5 + i * 0.05, {ease: FlxEase.quadInOut});    
        		typeNumber.add(titleObject);	
    		}else{
    		    var titleObject = new FlxText(0, 250 + 50 * i + 500, 0, 'Choose Controls Type');
        		titleObject.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        		titleObject.antialiasing = ClientPrefs.data.antialiasing;
        		titleObject.borderSize = 1;
        		titleObject.screenCenter(X);
        		typeTween[i] = FlxTween.tween(titleObject, {y: 250 + 50 * i}, 0.5 + i * 0.05, {ease: FlxEase.quadInOut});    
        		typeNumber.add(titleObject);	    		
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
		
		switch (mainNum){
		    case 0: //最初
		        if (up){
		            typeNum--;
		            if (typeNum < 0) typeNum = returnArray.length - 1;	
		            displayReturn();       		        
		        }
		        
		        if (down){
		            typeNum++;
		            if (typeNum > returnArray.length - 1) typeNum = 0;	
		            displayReturn();	  	        
		        }
		        
		        if (left){
		            keysNum--;
		            if (keysNum < 0) keysNum = 3;
		            displayOption();	 
		        }
		        
		        if (right)
		        {
		            keysNum++;
		            if (keysNum > 3) keysNum = 0;
		            displayOption();	 
		        }
		        
		        if (accept){
		            mainNum++;
		            changeMain();		   
		        }
		        if (back){
		            ClientPrefs.saveSettings();
                    FlxTransitionableState.skipNextTransIn = true;
        			FlxTransitionableState.skipNextTransOut = true;
        			MusicBeatState.switchState(new options.OptionsState());
		        }
		    case 1:
		        if (left){
		            chooseNum--;
		            if (chooseNum < 0) chooseNum = chooseArray.length - 1;	
		            displayChoose();	        		        
		        }
		        
		        if (right){
		            chooseNum++;
		            if (chooseNum > chooseArray.length - 1) chooseNum = 0;	
		            displayChoose();	    
		        }
		        if (accept){
		            saveChoose();
		        }
		        if (back){
		            mainNum--;
		            moveBack();
		        }				
		}
		
	    
	}
	
	function displayOption(){
	    for (i in 0...3)
		{
			var button:ChooseButton = optionNumber.members[i];
			
			if (i == keysNum) button.changeColor(FlxColor.WHITE);
			else button.changeColor(FlxColor.BLACK);	
	    }	
	}
	
	function displayReturn(){
	    for (i in 0...4)
		{
			var text:FlxText = typeNumber.members[i];
			if (i != 0){
			    if (i - 1 == typeNum) text.alpha = 1;
			    else text.alpha = 0.5;
			}
	    }	
	}
	
	function displayChoose(){
	    for (i in 0...chooseArray.length)
		{
			var button:ChooseButton = optionNumber.members[i];
			
			if (i == chooseNum) button.changeColor(FlxColor.WHITE);
			else button.changeColor(FlxColor.BLACK);	
	    }	
	}
	
	function displayData(){
	    for (i in 0...3)
		{
		    var controlReturn:String = '';
	        
            switch(i){
                case 0:
                    controlReturn = ClientPrefs.data.extraKeyReturn1;
                case 1:
                    controlReturn = ClientPrefs.data.extraKeyReturn2;
                case 2:
                    controlReturn = ClientPrefs.data.extraKeyReturn3;
                case 3:
                    controlReturn = ClientPrefs.data.extraKeyReturn4;            
            }	        
            
			var button:ChooseButton = optionNumber.members[i];
			
			if (i == keysNum) button.extendTitleObject.text = controlReturn;
	    }			
	}
	
	function changeMain(){		    
		    	    
	    for (i in 0...4){	    	    	   
    	        var obj = typeNumber.members[i];        		
        	    if (typeTween[i] != null) typeTween[i].cancel();
        		typeTween[i] = FlxTween.tween(obj, {y: 250 + 50 * i + 600}, 0.7 - i * 0.05, {ease: FlxEase.quadInOut});            		    		
	    }
	    
	    new FlxTimer().start(0.7, function(tmr:FlxTimer){
	        resetButton();	    	    
	    });			
	}
	
	function moveBack(){
	    for (i in 0...chooseArray.length)
		{
			var button:ChooseButton = optionNumber.members[i];
			
			if (chooseTween[i] != null) chooseTween[i].cancel();
        		chooseTween[i] = FlxTween.tween(button, {y: 250 + 50 * i}, 0.5 + i * 0.05, {ease: FlxEase.quadInOut});
	    }	
	    
	    for (i in 0...4)
		{
			var obj = typeNumber.members[i];        		
        	    if (typeTween[i] != null) typeTween[i].cancel();
        		typeTween[i] = FlxTween.tween(obj, {y: obj.y + 500}, 0.5, {ease: FlxEase.quadInOut});
	    }	
	
	}
	
	function resetButton(){
	    
	    chooseArray = returnArray[typeNum];	    
	    
	    if (buttonNumber != null){
            for (sprite in buttonNumber.members) {
                sprite.destroy();
            }        
            buttonNumber.clear();
        }
        
        var num:Int = 0;
	    var nowLine:Int = 0;
	    var plistLine:Int = 0;
	    switch(typeNum){
	        case 0:
	            plistLine = 2;
	        case 1:
	            plistLine = 0;
	        case 2:
	            plistLine = 1;
	        case 3:
	            plistLine = 0; 	    
	    }
	    
	    for (i in 0...chooseArray.length){
	        var button:ChooseButton = new ChooseButton(0, 360, 80, 50,chooseArray[i]);
	        if (nowLine == plistLine) button.x = 640 + (num - chooseArray.length /2) * 100;
	        else button.x = 40 + 100 * num;	        
	        button.y += nowLine * 70;
	        
	        var realPosition = button.y;
	        button.y += 500;
	        if (chooseTween[i] != null) chooseTween[i].cancel();
	        chooseTween[i] = FlxTween.tween(button, {y: realPosition}, 0.5, {ease: FlxEase.quadInOut});
	        buttonNumber.add(button);
	        	        
	        if (i == 0) button.changeColor(FlxColor.WHITE);
	        
	        num++;	        
	        if (num == 10){
	            num = 0;
	            nowLine++;
	        }
	    }			
	}
	
	function saveChoose(){        	 
        switch(keysNum){
            case 0:
                ClientPrefs.data.extraKeyReturn1 = chooseArray[chooseNum];
            case 1:
                ClientPrefs.data.extraKeyReturn2 = chooseArray[chooseNum];
            case 2:
                ClientPrefs.data.extraKeyReturn3 = chooseArray[chooseNum];
            case 3:
                ClientPrefs.data.extraKeyReturn4 = chooseArray[chooseNum];            
        }	        	    
	    ClientPrefs.saveSettings();
	    
	    displayData();	    
	}
	
}

class ChooseButton extends FlxSprite
{
    
    public var titleObject:FlxText;
    public var extendTitleObject:FlxText;
    
    public var _width:Int = 0;
    public var _height:Int = 0;
    
    public function new(x:Float, y:Float, width:Int, height:Int, title:String, ?extendTitle:String = null)
	{
	    super(x, y);
	    _width = width;
	    _height = height;
	    
	    makeGraphic(width, height, FlxColor.BLACK);
		alpha = 0.4;
	
	    titleObject = new FlxText(x, y, 100, title);
		titleObject.setFormat(Paths.font('vcr.ttf'), 20, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.antialiasing = ClientPrefs.data.antialiasing;
		titleObject.borderSize = 2;
		titleObject.x -= titleObject.width / 2;
		titleObject.y -= titleObject.height / 2;
		
		if (extendTitle != null){
		    titleObject.y = y;
		
    		extendTitleObject = new FlxText(x, y, 100, title);
    		extendTitleObject.setFormat(Paths.font('vcr.ttf'), 14, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		extendTitleObject.antialiasing = ClientPrefs.data.antialiasing;
    		extendTitleObject.borderSize = 2;
    		extendTitleObject.x -= extendTitleObject.width / 2;
    		extendTitleObject.y += height - extendTitleObject.height;
    			
		}
	}
	
	public function changeColor(color:FlxColor){
	    makeGraphic(_width, _height, FlxColor.BLACK);
		alpha = 0.4;
	    updateHitbox();	
	}
}