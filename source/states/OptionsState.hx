package options;

import states.MainMenuState;
import substates.PauseSubState;

import options.Option;
import options.OptionsHelpers;
import options.base.ControlsSubState;
import options.base.NoteOffsetState;
import options.base.NotesSubState;

import backend.ClientPrefs;

import flixel.addons.display.FlxBackdrop;

import backend.StageData;

import flixel.addons.transition.FlxTransitionableState;
import flixel.input.gamepad.FlxGamepad;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;


class OptionCata extends FlxSprite
{
	public var title:String;
	public var options:Array<Option>;

	public var optionObjects:FlxTypedGroup<FlxText>;

	public var titleObject:FlxText;
	
	public var positionFix:Int;

	public var middle:Bool = false;

	public function new(x:Float, y:Float, _title:String, _options:Array<Option>, middleType:Bool = false)
	{
		super(x, y);
		title = _title;
		middle = middleType;
		if (!middleType)
			makeGraphic(295, 64, FlxColor.BLACK);
		alpha = 0.4;

		options = _options;

		optionObjects = new FlxTypedGroup();
		
		var langTTF:String = '';		
	    langTTF = OptionsName.setTTF();
		langTTF = langTTF + '.ttf'; //fix

		titleObject = new FlxText((middleType ? 1180 / 2 : x), y + (middleType ? 16 + 64 : 16), 1180, title);
		titleObject.setFormat(Paths.font(langTTF), 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.antialiasing = ClientPrefs.data.antialiasing;
		titleObject.borderSize = 2;
        
		if (middleType)
		{
			titleObject.x = 50 + ((1180 / 2) - (titleObject.fieldWidth / 2));
		}
		else
			titleObject.x += (width / 2) - (titleObject.fieldWidth / 2);

		titleObject.scrollFactor.set();

		scrollFactor.set();
		
		positionFix = 40 + 64 + (middleType ? 16 + 64 + 16: 16); // work like titleObject.y but set line is two.
        //midd的40是16＋24
		for (i in 0...options.length)
		{
			var opt = options[i];
			var text:FlxText = new FlxText((middleType ? 1180 / 2 : 72), positionFix + 54 + (46 * i), 0, opt.getValue());
			if (middleType)
			{
				text.screenCenter(X);
			}
			text.setFormat(Paths.font(langTTF), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.antialiasing = ClientPrefs.data.antialiasing;
			text.borderSize = 2;
			text.borderQuality = 1;
			text.scrollFactor.set();
			optionObjects.add(text);
		}
	}

	public function changeColor(color:FlxColor)
	{
		makeGraphic(295, 64, color);
	}
}

class OptionsState extends MusicBeatState
{
	public static var instance:OptionsState;

	public var background:FlxSprite;

	public var selectedCat:OptionCata;
	
	public var CatTeam:FlxTypedGroup<FlxSprite>;

	public var selectedOption:Option;

	public var selectedCatIndex = 0;
	public var selectedOptionIndex = 0;
	
	private static var savePosition:Int = 0;
	private static var saveSelectedCatIndex:Int = 0;
	private static var saveSelectedOptionIndex:Int = 0;
	
	public var startFix:Bool = false;

	public var isInMain:Bool; //true 是大类，false是小类
	public var options:Array<OptionCata>;

	public static var onPlayState = false;	
	public static var isReset = false;

	public var shownStuff:FlxTypedGroup<FlxText>;

	public var visibleRange = [114, 640];

	var ColorArray:Array<Int> = [
		0xFF9400D3,
		0xFF4B0082,
		0xFF0000FF,
		0xFF00FF00,
		0xFFFFFF00,
		0xFFFF7F00,
		0xFFFF0000
	                                
	    ];
	    
	public static var currentColor:Int = 1;    
	public static var currentColorAgain:Int = 0;    

	public var menu:FlxTypedGroup<FlxSprite>;

	public var descText:FlxText;
	public var descBack:FlxSprite;
    
	override function create()
	{     
	    #if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end
		
		options = [
			new OptionCata(50, 40, OptionsName.setGameplay(), [				
				new Downscroll(OptionsName.setDownscrollOption()),
				new MiddleScroll("Put your lane in the center or on the right."), 								
				new FilpChart('If checked, filp chart for playing.'),				
				new GuitarHeroSustains("If checked, Hold Notes can't be pressed if you miss\nUncheck this if you prefer the old Input System."),
				new FixLNL('reduce Long Note length\nFix for some mod engines have been reduced'),												
				new GhostTap("Toggle counting pressing a directional input when no arrow is there as a miss."),								
				new NoReset("Toggle pressing R to gameover."),								               
                new ResultsScreen('If checked, Open Results Screen at end song'),            
				new Judgement("Create a custom judgement preset"),
			]),
			new OptionCata(345, 40, OptionsName.setAppearance(), [
                new NoteSkin("Change your current noteSkin"),
                new NoteRGB('Easier to set RGB for Note.'),
                new SplashSkin('Change your current splashSkin'),              
				new SplashRGB('Easier to to RGB for Splash.'),
                new HitSound("Adds 'hitsound' on note hits."),				               
				new CamZoom("Toggle the camera zoom in-game."),
				new ScoreZoom("Zoom score on 2'nd beat."),				
				new JudgementCounter("Show your judgements that you've gotten in the song"),								
                new HideHud("Shows to you hud."),           
                new HideOppStrums("Shows/Hides opponent strums on screen."),		
                new ShowComboNum("Combo sprite appearance."),
                new ComboColor("Allow Combe Sprite to get and use rating color."),		    		
                new ShowRating("Rating sprite appearance."),               
                new ShowSplashes("Show particles on SICK hit."),
                new SplashAlpha('How much transparent should the Note Splashes be.'),                 
                new HealthBarAlpha("Healthbar Transparceny."),     
                new HealthBarVersion('Reduced version for healthbar work better at old mods'),
                new TimeBarType('What should the Time Bar display?'),     
			]),
			new OptionCata(640, 40, OptionsName.setMisc(), [			    
			    new HscriptVersion('Reduced version to use hscript work for runhaxecode'),							
				new PauseMusic('What song do you prefer for the Pause Screen?'),
				#if CHECK_FOR_UPDATES new CheckForUpdates('On Release builds, turn this on to check for updates when you start the game.'), #end
				#if desktop new DiscordRPC('Uncheck this to prevent accidental leaks, it will hide the Application from your \"Playing\" box on Discord'), #end				
				#if mobile new GameOverVibration('If checked, your device will vibrate at game over.'),    	
				new ScreenSaver('If checked, the phone will sleep after going inactive for few seconds.'), #end
        		]),
			new OptionCata(935, 40, OptionsName.setOpponentMode(), [
			    new PlayOpponent('If checked, playing as opponent\nmay have bug in some mods\n(your score will not be recorded.'),			    
				new OpponentCodeFix('If checked, goodNoteHit and opponentNoteHit not follow playOpponent setting to change (if you playing it will return goodNoteHit function.'),
				new BotOpponentFix('Bot Opponent Fix'),				
				new HealthDrainOPPO('Health Drain on opponent mode'),
				new HealthDrainOPPOMult('Health Drain multiplier on opponent mode'),			 
			]),			
			new OptionCata(50, 40 + 64, OptionsName.setMenuExtend(), [
			    new CustomFadeType('Change Custom Fade Type'),
				new CustomFadeSound('Change Custom Fade Sound Volume.'),	
				new CustomFadeText('Check for showcase engine version and loading condition.'),								
				new SkipTitleVideo('Check for skip intro video'),
			]),
			new OptionCata(345, 40 + 64, OptionsName.setControls(), [
			    //new ControllerMode("Enables you to play with controller."),	
                new KeyboardControls('Change your keyboard control.'),
			    new AndroidControls('Change your android control.'),
			    new ExtraControls('Change android extra key return'),
			    new ExtraControlsNum('How many extra key need'),
			    new ControlsAlpha('Virtual pad alpha at state.'),
            	new PlayControlsAlpha('android control alpha for play.'),
			    new HitboxLocation('Hitbox extra key location.'),
            	new HitboxSkin('Hitbox skin choose'),            	                 	
			]),
			new OptionCata(640, 40 + 64, "System", [
			    //new Language("Change language in some state."), //will use fot NF1.2.0
			    new FPSCap("Change your FPS Cap."),					    
			    new ColorblindMode("You can set colorblind filter (makes the game more playable for colorblind people)\nCode from Indie Cross'"),
			    new Shaders("Shaders used for some visual effects, and also CPU intensive for weaker PCs."),
				new GPUcache("If checked, allows the GPU to be used for caching textures, decreasing RAM usage."),				
				new LoadingScreen("Add a LoadingScreen for PlayState and load faster\nif have some problem please disable it"),
				new FlashingLights("Toggle flashing lights that can cause epileptic seizures and strain."),
				new QualityLow("Turn off some object on stages"),
                new Antialiasing("Toggle antialiasing, improving graphics quality at a slight performance penalty."),				  
				new AutoPause("Stops game, when its unfocused"),				              
			]),			
			new OptionCata(935, 40 + 64, "Watermark", [                
				new FPSOption("Toggle the FPS Counter."),
				new FPSRainbowOption("Make the FPS Counter flicker through rainbow colors."),
                new MEMOption("Toggle the memory counter."),
                new MEMType("Choose memory showcase data."),
                new DelayOption("Toggle the delay time counter."),
                new WaterMarkOption('Toggle the watermark.'),
			]),			
			new OptionCata(-1, 125, "Editing Judgements", [			
				new FrameOption("Changes how many frames you have for hitting a note earlier or late."),
                new RatingOffset('Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.'),			
				new MarvelousMsOption("How many milliseconds are in the MARVELOUS hit window."),
				new SickMsOption("How many milliseconds are in the SICK hit window."),
				new GoodMsOption("How many milliseconds are in the GOOD hit window."),
				new BadMsOption("How many milliseconds are in the BAD hit window."),
				new MarvelousRating('Extend marvelous rate for playing.'),
				new MarvelousSprite('If unchecked,Marvelous rate will also use sick sprite.'),
			], true)
		];
		
		persistentUpdate = persistentDraw = true;

		instance = this;

		menu = new FlxTypedGroup<FlxSprite>();

		shownStuff = new FlxTypedGroup<FlxText>();
		
		CatTeam = new FlxTypedGroup<FlxSprite>();
        
		background = new FlxSprite(50, 40).makeGraphic(1180, 670, FlxColor.BLACK);
		background.alpha = 0.5;
		background.scrollFactor.set();
		menu.add(background);
        
		descBack = new FlxSprite(50, 640).makeGraphic(1180, 70, FlxColor.BLACK);
		descBack.alpha = 0.3;
		descBack.scrollFactor.set();
		menu.add(descBack);
        
		if (onPlayState)
		{
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.alpha = 0;
			bg.scrollFactor.set();
			menu.add(bg);

			background.alpha = 0.3;
			bg.alpha = 0.4;

			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		}else{
		    var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
    		bg.scrollFactor.set(0,0);
    		bg.setGraphicSize(Std.int(bg.width));
    		bg.updateHitbox();
    		bg.screenCenter();
    		bg.antialiasing = ClientPrefs.data.antialiasing;
    		add(bg);		
		}

		add(menu);

		add(shownStuff);
		
		add(CatTeam);

		for (i in 0...options.length - 1)
		{
			var cat = options[i];
			CatTeam.add(cat);
			add(cat.titleObject);
		}
		
		var langTTF:String = '';		
	    langTTF = OptionsName.setTTF();
		langTTF = langTTF + '.ttf'; //fix

		descText = new FlxText(62, 648);
		descText.setFormat(Paths.font(langTTF), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.antialiasing = ClientPrefs.data.antialiasing;
		descText.borderSize = 2;

		add(descBack);
		add(descText);

		isInMain = isReset ? false : true;		
		
		selectedCat = isReset ? options[saveSelectedCatIndex] : options[0];
		switchCat(selectedCat);
		selectedCatIndex = isReset ? saveSelectedCatIndex : 0;
		
		selectedOption = isReset ? selectedCat.options[saveSelectedOptionIndex] : selectedCat.options[0];
		selectedOptionIndex = isReset ? saveSelectedOptionIndex : 0;       
		
		isReset = false;                  
        
		#if android
        addVirtualPad(LEFT_FULL, A_B_C);        
        #end
		
		super.create();
	}
	
	var firstClose:Bool = false;
	override function closeSubState() {
    	super.closeSubState();
        ClientPrefs.saveSettings();
	}

	public function switchCat(cat:OptionCata, checkForOutOfBounds:Bool = true)
	{
		try
		{
			visibleRange = [Std.int(cat.positionFix + 64), 640]; /*
			/*变量乱七八糟的我都服了，显示你得加64px去修复到开始第2个格下面
			  因为text在positionFix那里还加了偏移
			*/
			
			if (cat.middle) isReset = true;				
			
			startFix = false;
				
			if (selectedOption != null)
			{
				var object = selectedCat.optionObjects.members[selectedOptionIndex];
				object.text = selectedOption.getValue();
			}

			if (selectedCat.middle)
				remove(selectedCat.titleObject);

			selectedCat.changeColor(FlxColor.BLACK);
			selectedCat.alpha = 0.4;

			for (i in 0...selectedCat.options.length)
			{
				var opt = selectedCat.optionObjects.members[i];
				opt.y = selectedCat.positionFix + 54 + (46 * i);
			}

			while (shownStuff.members.length != 0)
			{
				shownStuff.members.remove(shownStuff.members[0]);
			}
			selectedCat = cat;
			selectedCat.alpha = 0.2;
			selectedCat.changeColor(FlxColor.WHITE);

			if (selectedCat.middle)
				add(selectedCat.titleObject);

			for (i in selectedCat.optionObjects)
				shownStuff.add(i);

			selectedOption = selectedCat.options[0];

			if (selectedOptionIndex > options[selectedCatIndex].options.length - 1)
			{
				for (i in 0...selectedCat.options.length)
				{
					var opt = selectedCat.optionObjects.members[i];
					opt.y = selectedCat.positionFix + 54 + (46 * i);
				}
			}

			selectedOptionIndex = 0;

			if (!isInMain)
				selectOption(selectedOption);

			for (i in selectedCat.optionObjects.members)
			{
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
				{
					i.alpha = 0.4;
				}
			}
		}
	}

	public function selectOption(option:Option)
	{
		var object = selectedCat.optionObjects.members[selectedOptionIndex];

		selectedOption = option;

		if (!isInMain)
		{
			object.text = option.getValue();

			descText.text = option.getDescription();
		}
	}

    var accept = false;
    var back = false;
	var reset = false;
	 
	var right = false;
	var left = false;
	var up = false;
	var down = false;
	 
	var right_hold = false;
	var left_hold = false;
	var up_hold = false;
	var down_hold = false;
	 
	var anyKey = false;
	 
	var holdTime:Float = 0;	
    var checkTime:Float = 0;	
    var updateTime:Float = 0;
    
    public var closeUpdate:Bool = false;
	 
	override function update(elapsed:Float)
	{
	    if (closeUpdate){
	        persistentUpdate = false;
	        removeVirtualPad();
	    }
	    
		super.update(elapsed);

		for (c in options) {
			c.titleObject.text = c.title;
			for (o in 0...c.optionObjects.length) {
				c.optionObjects.members[o].text = c.options[o].getValue();
			}
		}
				
		for (numP in 0...options.length - 1) {
			if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(CatTeam.members[numP])){
			    isInMain = false;		
		        
        		switchCat(options[numP]);
        		selectedCatIndex = numP;
		
        		selectedOption = selectedCat.options[0];
        		selectedOptionIndex = 0;
        		
        		selectedOption.change();
        		
        		FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
			}
		}		
       
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;		

		accept = controls.ACCEPT;
		right = controls.UI_RIGHT_P;
		left = controls.UI_LEFT_P;
		up = controls.UI_UP_P;
		down = controls.UI_DOWN_P;
		
		right_hold = false;
        left_hold = false;
	    up_hold = false;
		down_hold = false;				
	 
		if (controls.UI_RIGHT_P || controls.UI_LEFT_P || controls.UI_UP_P || controls.UI_DOWN_P){
    		holdTime = 0;		
    		checkTime = 0;
	    	updateTime = 0.1;
		}
		
		if(controls.UI_LEFT || controls.UI_RIGHT)
			{
			    holdTime += elapsed;
			    checkTime += elapsed;
                
				if(holdTime > 0.5 && checkTime >= updateTime){
				    checkTime = 0;
				    if (updateTime > 1 / ClientPrefs.data.framerate)
				    updateTime = updateTime - 0.005;
				    else if (updateTime < 1 / 30)
				    updateTime = 1 / 30;
				    
				    right_hold = controls.UI_RIGHT;
				    left_hold = controls.UI_LEFT;
				    up_hold = controls.UI_UP;
				    down_hold = controls.UI_DOWN;
				}	            
			}

		anyKey = FlxG.keys.justPressed.ANY || (gamepad != null ? gamepad.justPressed.ANY : false);
		back = controls.BACK;
		reset = controls.RESET #if android || virtualPad.buttonC.justPressed #end;
		
			if (isInMain)
			{
				descText.text = "Please select a category";
				if (right)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();

					if ((selectedCatIndex + 1) % 4 == 0)
						selectedCatIndex -= 3;
					else
						selectedCatIndex += 1;

					switchCat(options[selectedCatIndex]);
				}
				else if (left)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					
					if (selectedCatIndex % 4 == 0)
						selectedCatIndex += 3;
					else
						selectedCatIndex -= 1;

					switchCat(options[selectedCatIndex]);
				}				
				else if (up || down)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();				

					if (selectedCatIndex >= 4)
						selectedCatIndex -= 4;
					else
                        selectedCatIndex += 4;
					switchCat(options[selectedCatIndex]);
				}

				if (accept)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
					selectedOptionIndex = 0;
					isInMain = false;
					selectOption(selectedCat.options[0]);
					selectedOption.change();
				}

				if(reset)
				{
					if (!onPlayState)
					{
						resetOptions();
						
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							
                         //   FlxG.sound.music.fadeOut(0.3);
                         //   FlxG.camera.fade(FlxColor.BLACK, 0.5, false, FlxG.resetGame, false);
						});
					}
					else
					{
						
					}
				}

				if (back)
				{
					if (!onPlayState) {
					    ClientPrefs.saveSettings();
						MusicBeatState.switchState(new MainMenuState());
						persistentUpdate = false;
                        //FlxG.sound.music.stop();
					    }
					else
					{
						PauseSubState.goBack = true;
						ClientPrefs.saveSettings();
						//close();
					}
				}
			}
			else
			{
				if (selectedOption != null)
					if (selectedOption.acceptType)
					{
						if (back && selectedOption.waitingType)
						{
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
							selectedOption.waitingType = false;
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							object.text = selectedOption.getValue();
							return;
						}
						else if (anyKey)
						{
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							selectedOption.onType(gamepad == null ? FlxG.keys.getIsDown()[0].ID.toString() : gamepad.firstJustPressedID());
							object.text = selectedOption.getValue();
						}
					}
				if (selectedOption.acceptType || !selectedOption.acceptType) //这啥玩意这
				{
					if (accept)
					{
						var prev = selectedOptionIndex;
						var object = selectedCat.optionObjects.members[selectedOptionIndex];																		
           				
						selectedOption.press();
                        selectedOption.change();
						if (selectedOptionIndex == prev)
						{
							ClientPrefs.saveSettings();

							object.text = selectedOption.getValue();
						}
					}

					if (down || down_hold)
					{					    					    
						if (selectedOption.acceptType)
							selectedOption.waitingType = false;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						
						var DOWNmoveFix = false;
					    if (selectedOptionIndex == options[selectedCatIndex].options.length - 1 - 5/* && startFix*/) DOWNmoveFix = true;
						
						selectedOptionIndex++;

						if (selectedOptionIndex > options[selectedCatIndex].options.length - 1)
						{
						    
							for (i in 0...selectedCat.options.length)
							{
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.positionFix + 54 + (46 * i);
							}
							selectedOptionIndex = 0;
							startFix = false;
						}																		

						if (selectedOptionIndex != 0
							&& selectedOptionIndex != options[selectedCatIndex].options.length - 1
							&& options[selectedCatIndex].options.length > 10 
							&& selectedOptionIndex >= 5
							&& (selectedOptionIndex <= options[selectedCatIndex].options.length - 1 - 5 || DOWNmoveFix)
							)
						{
							for (i in selectedCat.optionObjects.members)
							{
								i.y -= 46;
							}							
						}
						
						moveCheak();

						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}
					else if (up || up_hold)
					{
					    
						if (selectedOption.acceptType)
							selectedOption.waitingType = false;
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						
						var UPmoveFix:Bool = false;
						if (selectedOptionIndex == 5/* && !startFix*/) UPmoveFix = true;
						
						selectedOptionIndex--;

						if (selectedOptionIndex < 0)
						{						    
							selectedOptionIndex = options[selectedCatIndex].options.length - 1;
							
                            if (options[selectedCatIndex].options.length > 10)
							for (i in 0...selectedCat.options.length)
							{
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.positionFix + 54 + (46 * (i - (selectedCat.options.length - 10))); 
							}
							startFix = true;
						}																							

						if (selectedOptionIndex != 0 
    						&& options[selectedCatIndex].options.length > 10
    						&& (selectedOptionIndex >= 5 || UPmoveFix)
    						&& selectedOptionIndex <= options[selectedCatIndex].options.length - 1 - 5
    						)						
						{							
								for (i in selectedCat.optionObjects.members)
								{
									i.y += 46;
								}
						}
                        
                        moveCheak();
                        
						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}

					if (right || right_hold)
					{
						if (!right_hold) FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.right();
                        selectedOption.change();
						ClientPrefs.saveSettings();

						object.text = selectedOption.getValue();
					}
					else if (left || left_hold)
					{
						if (!left_hold) FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.left();
                        selectedOption.change();
						ClientPrefs.saveSettings();

						object.text = selectedOption.getValue();
					}

					if(reset)
					{
						if (!onPlayState)
						{
							resetOptions();
							
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
							
						}
						else
						{
							
						}
					}

					if (back)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'), 0.6);
                        
						if (selectedCatIndex >= 9)  //这是干啥用的,但是目前来看没用
							selectedCatIndex = 0;

						for (i in 0...selectedCat.options.length)
						{
							var opt = selectedCat.optionObjects.members[i];
							opt.y = selectedCat.positionFix + 54 + (46 * i);
						}
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();													
						
						if (selectedCat.middle){
						    resetOptionChoose();						    
						}else{
						    isInMain = true;
						}
						
						if (selectedCat.optionObjects != null){ //别删这个if包含的代码，会出问题
							for (i in selectedCat.optionObjects.members)
							{
								if (i != null)
								{
									if (i.y < visibleRange[0] - 24)
										i.alpha = 0;
									else if (i.y > visibleRange[1] - 24)
										i.alpha = 0;
									else
									{
										i.alpha = 0.4;
									}
								}
						    }
						}    
					}
				}
			}
		
		if (!selectedCat.middle){
		    saveSelectedOptionIndex = selectedOptionIndex;
		    saveSelectedCatIndex = selectedCatIndex;
		    savePosition = Std.int((selectedCat.optionObjects.members[0].y - (selectedCat.positionFix + 54)) / 46);
		}
		
		if (selectedCat != null && !isInMain)
		{
			for (i in selectedCat.optionObjects.members)
			{
				if (selectedCat.middle)
				{
					i.screenCenter(X);
				}

				// I wanna die!!!
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
				{
					if (selectedCat.optionObjects.members[selectedOptionIndex].text != i.text)
						i.alpha = 0.4;
					else
						i.alpha = 1;
				}
			}
		}
	}

	public static function resetOptions()
	{

	}
	
	public function resetOptionChoose()  //用于返回原来选择
	{
        isReset = false;
        isInMain = false;  
        
        selectedCatIndex = saveSelectedCatIndex;
		switchCat(options[saveSelectedCatIndex]);       
		
		selectedOptionIndex = saveSelectedOptionIndex;    					        					
        selectOption(selectedCat.options[saveSelectedOptionIndex]);	
        
        
        if (selectedOptionIndex != 0 
    	&& options[selectedCatIndex].options.length > 10
    	&& selectedOptionIndex >= 5
    	&& selectedOptionIndex <= options[selectedCatIndex].options.length - 1 - 5
    	){
			for (i in 0...selectedCat.options.length)
			{
			    var opt = selectedCat.optionObjects.members[i];
				opt.y = selectedCat.positionFix + 54 + (46 * (i + (selectedOptionIndex - 5))); 
			}
		}
	}
	
	public function moveCheak() //I have no idea to fix kade shit problem so I think this is the best way to fix shit choose problem
	{
        if (options[selectedCatIndex].options.length > 10 && !selectedCat.middle){
            if (selectedCat.optionObjects.members[0].y > selectedCat.positionFix + 54){
                for (i in selectedCat.optionObjects.members){
					i.y -= 46;
				}
                moveCheak(); //check again until not have problem
            }
        
            if (selectedCat.optionObjects.members[selectedCat.options.length - 1].y < selectedCat.positionFix + 54 + 46 * 9){
                for (i in selectedCat.optionObjects.members){
					i.y += 46;
				}
                moveCheak(); //check again until not have problem
            }
        }
	}
	
	public static function openSub(){	    
	    isReset = true;		
	    instance.closeUpdate = true;	    	    
	}
}

