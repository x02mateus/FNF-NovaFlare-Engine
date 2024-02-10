package substates;

/*
    ResultsScreen made by NF|beihu (北狐丶逐梦)
    youtube: https://b23.tv/SnqG443
    bilbil: https://youtube.com/@beihu235?si=NHnWxcUWPS46EqUt
    discord: beihu235
    
    you can use it but must give me credit(dont forget my icon)
    logic is very easy so I think everyone can understand it
    
    Who cares about rudy's hscript so I continue to choose to use my lua logic
    Her hscript weren't worth stole and I didn't stole it
    
    by the way dont move this to hscript,I dont allow it
*/

import flixel.addons.transition.FlxTransitionableState;

import states.PlayState;
import states.FreeplayState;

import backend.Conductor;
import backend.Mods;
import backend.Highscore;
import backend.DiffCalc;

import flixel.util.FlxSpriteUtil;
import flixel.math.FlxRect;

import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.utils.Assets;

class ResultsScreen extends MusicBeatSubstate
{
	var background:FlxSprite;	
	//BG
		    
    var modsBG:FlxSprite;
    var modsMenu:FlxSprite;
    var modsText:FlxText;
    //Results for what mod you played
    
    var mesBG:FlxSprite;
    var mesTextNumber:FlxTypedGroup<FlxText>;
    //Results for song message
    
    var scBG:FlxSprite;
    var scTextNumber:FlxTypedGroup<FlxText>;
    //Results for score
    
    var opBG:FlxSprite;
    var opTextNumber:FlxTypedGroup<FlxText>;
    //Results for option
    
    var graphBG:FlxSprite;
    var graphNote:FlxSprite;
    //Results for note offset
    
    var percentBG:FlxSprite;
    var percentRectNumber:FlxTypedGroup<FlxSprite>;
    var percentRectBGNumber:FlxTypedGroup<FlxSprite>;
    var percentTextNumber:FlxTypedGroup<FlxText>;
    //Results for note rate percent
    
	var backText:FlxText;
    var backBG:FlxSprite;
	//back image
	
	var camOther:FlxCamera;        
    //camera
    
    var game = PlayState.instance;
    
    var ColorArray:Array<FlxColor> = [
    		0xFFFFFF00, //marvelous
    		0xFF00FFFF, //sick
    	    0xFF00FF00, //good
    	    0xFFFF7F00, //bad
    	    0xFFFF5858, //shit
    	    0xFFFF0000 //miss
    		];
    var ColorArrayAlpha:Array<FlxColor> = [
    		0x7FFFFF00, //marvelous
    		0x7F00FFFF, //sick
    	    0x7F00FF00, //good
    	    0x7FFF7F00, //bad
    	    0x7FFF5858, //shit
    	    0x7FFF0000 //miss
    		];
    				
    var safeZoneOffset:Float = (ClientPrefs.data.safeFrames / 60) * 1000;
    		
	public function new(x:Float, y:Float)
	{
	    
		super();	
	    cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	    
	    camOther = new FlxCamera();
	    camOther.bgColor.alpha = 0;
	    FlxG.cameras.add(camOther, false);				
	    
		background = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);		
		background.alpha = 0;
		add(background);		
		
		//--------------------------
		
		modsBG = new FlxSprite(20, 20).makeGraphic(600, 340 + 20, FlxColor.BLACK);		
		modsBG.alpha = 0;
		add(modsBG);		
		
		modsMenu = new FlxSprite(20, 20).loadGraphic(Paths.image('menuBG'));
		modsMenu.setGraphicSize(600, 338);		
		modsMenu.updateHitbox();		
		modsMenu.antialiasing = ClientPrefs.data.antialiasing;
		modsMenu.alpha = 0;
		add(modsMenu);		
		
		modsText = new FlxText(20, 20 + modsMenu.height, 0, 'Mod name: ' + Mods.currentModDirectory);
		modsText.size = 16;		
		modsText.font = Paths.font('vcr.ttf');
		modsText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);		
		modsText.antialiasing = ClientPrefs.data.antialiasing;
	    modsText.alignment = CENTER;	
	    modsText.alpha = 0;
	    add(modsText);		
	    if (modsText.width > 600) modsText.scale.x = 600 / modsText.width; //fix width problem
	    modsText.offset.x = 0;
	    
	    //-------------------------		    		    
		
		mesBG = new FlxSprite(20, 20 + modsBG.height + 20).makeGraphic(600, 60, FlxColor.BLACK);
		mesBG.alpha = 0;
		add(mesBG);		
		
		mesTextNumber = new FlxTypedGroup<FlxText>();
		add(mesTextNumber);
	    
	    mesTextAdd('SongName: ' + PlayState.SONG.song + ' - ' + Difficulty.getString());
		mesTextAdd('Played Time: ' + Date.now().toString());
		
		//var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
       // var rate:Float = DiffCalc.CalculateDiff(Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase())) / 3;
			var rate = 0;
		mesTextAdd('Difficult: ' + rate);		
		
		//-------------------------
		
		scBG = new FlxSprite(20, 20 + modsBG.height + 20 + mesBG.height + 20).makeGraphic(600, 60, FlxColor.BLACK);	
		scBG.alpha = 0;
		add(scBG);		
		
		scTextNumber = new FlxTypedGroup<FlxText>();
		add(scTextNumber);
		
		scTextAdd('Score: ' + game.songScore, 1);
		scTextAdd('Highest Combe: ' + game.songMisses, 2);
		scTextAdd('Accuracy: ' + game.ratingPercent, 1);
		if (game.ratingFC == '') scTextAdd('Rank: N/A', 2);
		else scTextAdd('Rank: ' + game.ratingName + ' - ' + game.ratingFC, 2);
		scTextAdd('Hits: ' + game.songHits, 1);
		scTextAdd('Combo Break: ' + game.songMisses, 2);
		
		//-------------------------
		
		opBG = new FlxSprite(20, 20 + modsBG.height + 20 + mesBG.height + 20 + scBG.height).makeGraphic(600, 180, FlxColor.BLACK);	
		opBG.alpha = 0;
		add(opBG);		
		
		opTextNumber = new FlxTypedGroup<FlxText>();
		add(opTextNumber);
		
		opTextAdd('HealthGain: ' + ClientPrefs.getGameplaySetting('healthgain'));
		opTextAdd('HealthLoss: ' + ClientPrefs.getGameplaySetting('healthloss'));
		
		var speed:String = ClientPrefs.getGameplaySetting('scrollspeed');
		if (ClientPrefs.getGameplaySetting('scrolltype') == 'multiplicative')
        speed = 'X' + speed;
        
		opTextAdd('SongSpeed: ' + speed);
		opTextAdd('PlaybackRate: X' + ClientPrefs.getGameplaySetting('songspeed'));
		
		var botplay:String = 'Disable';
		if (ClientPrefs.getGameplaySetting('botplay')) botplay = 'Enable';
		var practice:String = 'Disable';
		if (ClientPrefs.getGameplaySetting('practice')) practice = 'Enable';
		var instakill:String = 'Disable';
		if (ClientPrefs.getGameplaySetting('instakill')) instakill = 'Enable';		
		
		opTextAdd('PracticeMode: ' + practice);
		opTextAdd('Instakill On Miss: ' + instakill);		
		opTextAdd('Botplay: ' + botplay);
		
		var opponent:String = 'Disable';
		if (ClientPrefs.data.playOpponent) opponent = 'Enable';
		var filpChart:String = 'Disable';
		if (ClientPrefs.data.filpChart) filpChart = 'Enable';
		
		
		opTextAdd('PlayOpponent: ' + opponent);
		opTextAdd('FilpChart: ' + filpChart);
		
		//-------------------------
		
		graphBG = new FlxSprite(20 + 640, 20).makeGraphic(600, 300, FlxColor.BLACK);
		graphBG.alpha = 0;
		add(graphBG);
		
		graphNote = new FlxSprite(20 + 640, 20).makeGraphic(600, 300, FlxColor.TRANSPARENT);
		graphNote.alpha = 0;
		add(graphNote);
		
		graphNoteDraw();
		
		//-------------------------
		
		percentBG = new FlxSprite(20 + 640, 20 + 300 + 20).makeGraphic(600, 300, FlxColor.BLACK);
		percentBG.alpha = 0;
		add(percentBG);									
		
		percentRectBGNumber = new FlxTypedGroup<FlxSprite>();
		add(percentRectBGNumber);
		
		percentRectNumber = new FlxTypedGroup<FlxSprite>();
		add(percentRectNumber);
		
		percentTextNumber = new FlxTypedGroup<FlxText>();
		add(percentTextNumber);
		
		percentRateAdd();
		
		//-------------------------
		
		var backTextShow:String = 'Press Enter to continue';
		#if android backTextShow = 'Press Text to continue'; #end
		
		backText = new FlxText(FlxG.width, 0, backTextShow);
		backText.size = 28;
		backText.font = Paths.font('vcr.ttf');
		backText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		backText.scrollFactor.set();
		backText.antialiasing = ClientPrefs.data.antialiasing;
	    backText.alignment = RIGHT;			    

		backBG = new FlxSprite(FlxG.width, FlxG.height).loadGraphic(Paths.image('menuExtend/ResultsScreen/backBG'));
		backBG.scrollFactor.set(0, 0);
		backBG.scale.x = 0.5;
		backBG.scale.y = 0.5;
		backBG.updateHitbox();
		backBG.antialiasing = ClientPrefs.data.antialiasing;
		backBG.y -= backBG.height;		
		add(backBG);
		add(backText);		
		
		backBG.cameras = [camOther];
		backText.cameras = [camOther];
		
		backText.y = backBG.y + backBG.height / 2 - backText.height / 2;
							
		//-------------------------				
		
	    startTween();
	}
	
	var getReadyClose:Bool = false;    
	var closeCheck:Bool = false;
	override function update(elapsed:Float)
	{ 					
		if(!closeCheck && (FlxG.keys.justPressed.ENTER || ((FlxG.mouse.getScreenPosition(camOther).x > backBG.x && FlxG.mouse.getScreenPosition(camOther).x < backBG.x + backBG.width && FlxG.mouse.getScreenPosition(camOther).y > backBG.y && FlxG.mouse.getScreenPosition(camOther).y < backBG.y + backBG.height) && FlxG.mouse.justPressed) #if android || FlxG.android.justReleased.BACK #end))
		{
		    if (getReadyClose){
    		    NewCustomFadeTransition();
                //PlayState.cancelMusicFadeTween();
                closeCheck = true;
            }else{
                getReadyClose = true;
                FlxG.sound.play(Paths.sound('scrollMenu'));
                
                backText.text = 'Press Again to continue';
                
                new FlxTimer().start(1, function(tmr:FlxTimer){    		        		                        		
		            var backTextShow:String = 'Press Enter to continue';
            		#if android backTextShow = 'Press Text to continue'; #end		
            		backText.text = backTextShow;
            		
		            getReadyClose = false;
        		});
            }
		}		    
	}
	
	function mesTextAdd(text:String = '', sameLine:Int = 0){
	    TextAdd(mesBG, mesTextNumber, text, sameLine);	
	}
	
	function scTextAdd(text:String = '', sameLine:Int = 0){
	    TextAdd(scBG, scTextNumber, text, sameLine);	
	}
	
	function opTextAdd(text:String = '', sameLine:Int = 0){
	    TextAdd(opBG, opTextNumber, text, sameLine);	
	}
	
	var textSize = 20;	
	function TextAdd(BG:Dynamic, type:Dynamic, text:String = '', sameLine:Int = 0){
	    var textWidth = 600;
	    var numberText = new FlxText(BG.x, BG.y + type.length * textSize, 0, text, textSize);	
	    numberText.x += sameLine * 300;
		numberText.font = Paths.font('vcr.ttf');
		numberText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		numberText.scrollFactor.set();
		numberText.antialiasing = ClientPrefs.data.antialiasing;
	    numberText.alignment = LEFT;			
	    numberText.alpha = 0;    	
	    if (sameLine > 0) textWidth = 300;
	    if (numberText.width > textWidth) numberText.scale.x = (textWidth - 1) / numberText.width; //fix width problem
	    numberText.offset.x = 0;
	    type.add(numberText);		
	}
	
	function graphNoteDraw(){
	
	    FlxSpriteUtil.beginDraw(0xFFFFFFFF);
	    
	    var noteSize = 2.3;
	    var MoveSize = 0.8;
	    var color:FlxColor;
	    
	    for (i in 0...game.NoteTime.length - 1){
		    if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.marvelousWindow && ClientPrefs.data.marvelousRating) color = ColorArray[0];
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.sickWindow) color = ColorArray[1];
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.goodWindow) color = ColorArray[2];
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.badWindow) color = ColorArray[3];
		    else if (Math.abs(game.NoteMs[i]) <= safeZoneOffset) color = ColorArray[4];
		    else color = ColorArray[5];		    		    		    
		    		    
		    FlxSpriteUtil.beginDraw(color);
		    if (Math.abs(game.NoteMs[i]) <= safeZoneOffset){
    		    FlxSpriteUtil.drawCircle(graphNote, graphNote.width * (game.NoteTime[i] / game.songLength), graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (game.NoteMs[i] / safeZoneOffset), noteSize);
    		}else{
    		    FlxSpriteUtil.drawCircle(graphNote, graphNote.width * (game.NoteTime[i] / game.songLength), graphNote.height * 0.5 + graphNote.height * 0.5 * 0.9, noteSize);		
    		}    				    
		}
		
		if (!ClientPrefs.data.marvelousRating){
    		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.marvelousWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[0]);
    		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.marvelousWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[0]);
		} //marvelous
		
		if (ClientPrefs.data.marvelousWindow >= ClientPrefs.data.sickWindow && ClientPrefs.data.marvelousRating){
		    FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.sickWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[1]);
    		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.sickWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[1]);		
		} //sick
		
		if ((ClientPrefs.data.marvelousWindow >= ClientPrefs.data.goodWindow && ClientPrefs.data.marvelousRating) || ClientPrefs.data.sickWindow >= ClientPrefs.data.goodWindow){
		    FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.goodWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[2]);
    		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.goodWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[2]);		
		} //good
		
		if ((ClientPrefs.data.marvelousWindow >= ClientPrefs.data.badWindow && ClientPrefs.data.marvelousRating) || ClientPrefs.data.sickWindow >= ClientPrefs.data.badWindow || ClientPrefs.data.goodWindow >= ClientPrefs.data.badWindow){
		    FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.badWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[3]);
    		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize * (ClientPrefs.data.badWindow / safeZoneOffset) - 1, graphNote.width, 2, ColorArrayAlpha[3]);				
		} //bad
		
		FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 + graphNote.height * 0.5 * MoveSize - 1, graphNote.width, 2, ColorArrayAlpha[4]); 
    	FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * MoveSize - 1, graphNote.width, 2, ColorArrayAlpha[4]); 
    	//shit
    	
    	FlxSpriteUtil.drawRect(graphNote, 0, graphNote.height * 0.5 - graphNote.height * 0.5 * 0.9 - 1, graphNote.width, 2, ColorArrayAlpha[3]);
    	//miss
		
		graphNote.updateHitbox();			
	
	}
	
	function percentRateAdd(){
	
	    var numMarvelous:Int = 0;
    	var numSicks:Int = 0;
    	var numGoods:Int = 0;
    	var numBads:Int = 0;
    	var numShits:Int = 0;
	
	    for (i in 0...game.NoteTime.length - 1){
		    if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.marvelousWindow && ClientPrefs.data.marvelousRating) numMarvelous++;
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.sickWindow) numSicks++;
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.goodWindow) numGoods++;
		    else if (Math.abs(game.NoteMs[i]) <= ClientPrefs.data.badWindow) numBads++;
		    else if (Math.abs(game.NoteMs[i]) <= safeZoneOffset) numShits++;		    	    		    		 
	    }
	    
	    var height:Int = ClientPrefs.data.marvelousRating ? Std.int(300 / 5) : Std.int(300 / 4);	    
	    if (ClientPrefs.data.marvelousRating) addRate(height, 'Marvelous', Reflect.field(ClientPrefs.data, 'marvelous'), numMarvelous, ColorArray[0]);
	    addRate(height, 'Sick', Reflect.field(ClientPrefs.data, 'sick'), numSicks, ColorArray[1]);
	    addRate(height, 'Good', Reflect.field(ClientPrefs.data, 'good'), numGoods, ColorArray[2]);
	    addRate(height, 'Bad', Reflect.field(ClientPrefs.data, 'bad'), numBads, ColorArray[3]);
	    addRate(height, 'Shit', (ClientPrefs.data.safeFrames / 60) * 1000, numShits, ColorArray[4]);		    	    	
	}
	
	function addRate(height:Int, RateName:String, ms:Float, number:Int, color:FlxColor){
	
	    var numberBG:FlxSprite = new FlxSprite(percentBG.x + 5, percentBG.y + 5 + percentRectBGNumber.length * height).makeGraphic(Std.int(percentBG.width - 10), 30, FlxColor.BLACK);
		numberBG.alpha = 0;
		percentRectBGNumber.add(numberBG);		
		
		var numberRect:FlxSprite = new FlxSprite(percentBG.x + 5, percentBG.y + 5 + percentRectBGNumber.length * height).makeGraphic(Std.int(percentBG.width - 10), 30, color);
		numberRect.alpha = 0;
		percentRectNumber.add(numberRect);	
	
	    var numberText = new FlxText(percentBG.x + 5, numberBG.y + numberBG.height, 0, RateName, 16);		    
		numberText.font = Paths.font('vcr.ttf');
		numberText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		numberText.scrollFactor.set();
		numberText.antialiasing = ClientPrefs.data.antialiasing;
	    numberText.alignment = LEFT;			
	    numberText.alpha = 0;    	
	    numberText.color = color;    
	    percentTextNumber.add(numberText);
	    
	    var numberText = new FlxText(percentBG.x + 5 + percentBG.width / 2, numberBG.y + numberBG.height, 0, number + '(' + Math.ceil(number / game.NoteTime.length * 100) / 100 + '%)', 16);		    
		numberText.font = Paths.font('vcr.ttf');
		numberText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		numberText.scrollFactor.set();
		numberText.antialiasing = ClientPrefs.data.antialiasing;
	    numberText.alignment = LEFT;			
	    numberText.alpha = 0;    	
	    numberText.color = color;    
	    numberText.x -= numberText.width * 0.5;
	    percentTextNumber.add(numberText);
	    
	    var numberText = new FlxText(percentBG.x + 5 + percentBG.width, numberBG.y + numberBG.height, 0, ms + 'MS', 16);		    
		numberText.font = Paths.font('vcr.ttf');
		numberText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 1, 1);
		numberText.scrollFactor.set();
		numberText.antialiasing = ClientPrefs.data.antialiasing;
	    numberText.alignment = LEFT;			
	    numberText.alpha = 0;    	
	    numberText.color = color;    	
	    numberText.x -= numberText.width;
	    percentTextNumber.add(numberText);	
	}
	
	function startTween(){
	
	    FlxTween.tween(background, {alpha: 0.5}, 0.5);	
	    
	    
	    new FlxTimer().start(1, function(tmr:FlxTimer){				    
								
    		FlxTween.tween(modsBG, {alpha: 0.5}, 0.5);		
    		FlxTween.tween(mesBG, {alpha: 0.5}, 0.5);		
    		FlxTween.tween(scBG, {alpha: 0.5}, 0.5);		
    		FlxTween.tween(opBG, {alpha: 0.5}, 0.5);		
    		
    		FlxTween.tween(graphBG, {alpha: 0.5}, 0.5);		
    		FlxTween.tween(percentBG, {alpha: 0.5}, 0.5);
		});			
		
		
		new FlxTimer().start(1, function(tmr:FlxTimer){
		    modsMenu.alpha = 1;
		    rectTween(modsMenu);
            
            FlxTween.tween(modsText, {alpha: 1}, 0.5);	
		
		});						
		
		new FlxTimer().start(1.5, function(tmr:FlxTimer){
			for (i in 0...mesTextNumber.length - 1){
			    var tweenTimer:FlxTimer = new FlxTimer();
                tweenTimer.start((0.5 - 0.1) / mesTextNumber.length, function(tmr:FlxTimer){
			        FlxTween.tween(mesTextNumber.members[i], {alpha: 1}, 0.1);
			    });
			}
			
			for (i in 0...scTextNumber.length - 1){
			    var tweenTimer:FlxTimer = new FlxTimer();
                tweenTimer.start((0.5 - 0.1) / scTextNumber.length, function(tmr:FlxTimer){			
			        FlxTween.tween(scTextNumber.members[i], {alpha: 1}, 0.1);
			    });								
			}
			
			for (i in 0...opTextNumber.length - 1){
			    var tweenTimer:FlxTimer = new FlxTimer();
                tweenTimer.start((0.5 - 0.1) / opTextNumber.length, function(tmr:FlxTimer){	
			        FlxTween.tween(opTextNumber.members[i], {alpha: 1}, 0.1);
			    });						
			}
		});
		
		new FlxTimer().start(2, function(tmr:FlxTimer){
		
		    rectTween(graphNote);
		
		    for (i in 0...percentRectBGNumber.length - 1){		    
		        FlxTween.tween(percentRectBGNumber.members[i], {alpha: 1}, 0.3);
		    }
		
		    for (i in 0...percentRectNumber.length - 1){
		        percentRectNumber.members[i].alpha = 1;
		        rectTween(percentRectNumber.members[i]);
		    }
		    
		    for (i in 0...percentTextNumber.length - 1){
		        FlxTween.tween(percentTextNumber.members[i], {alpha: 1}, 0.5);
		    }
		});
		
		
		new FlxTimer().start(2.5, function(tmr:FlxTimer){
			FlxTween.tween(backBG, {x:  1280 - backBG.width}, 1, {ease: FlxEase.cubeInOut});
			FlxTween.tween(backText, {x: 1280 - backText.width - 50}, 1.2, {ease: FlxEase.cubeInOut});
		});
	
		
	}
	
	var timerTween:FlxTimer;
    function rectTween(sprite:FlxSprite){
    
        var swagRect:FlxRect;
	    var showNum:Int = 0;
	    
	    timerTween = new FlxTimer().start(0.01, function(tmr:FlxTimer) {
		    showNum++;
    		swagRect = sprite.clipRect;
    		if(swagRect == null) swagRect = new FlxRect(0, 0, 0, 0);
    		swagRect.x = 0;
	        swagRect.y = 0;
	        swagRect.width = sprite.width;
		    swagRect.height = sprite.height * (showNum / 50);    		    
		    modsMenu.clipRect = swagRect;
		    
		    if (showNum == 50){
		        timerTween.cancel();		        		        
		    }
        }, 0);            
    }







	
	//NewCustomFadeTransition is work for better close Substate

	var finishCallback:Void->Void;
	private var leTween:FlxTween = null;
	
	var isTransIn:Bool = false;
	
	var loadLeft:FlxSprite;
	var loadRight:FlxSprite;
	var loadAlpha:FlxSprite;
	var WaterMark:FlxText;
	var EventText:FlxText;
	
	var loadLeftTween:FlxTween;
	var loadRightTween:FlxTween;
	var loadAlphaTween:FlxTween;
	var EventTextTween:FlxTween;
	var loadTextTween:FlxTween;

	function NewCustomFadeTransition(duration:Float = 0.6, TransIn:Bool = false) {
		
		isTransIn = TransIn;
				
		if(ClientPrefs.data.CustomFade == 'Move'){
    		loadRight = new FlxSprite(isTransIn ? 0 : 1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingR'));
    		loadRight.scrollFactor.set();
    		loadRight.antialiasing = ClientPrefs.data.antialiasing;		
    		add(loadRight);
    		loadRight.cameras = [camOther];
    		loadRight.setGraphicSize(FlxG.width, FlxG.height);
    		loadRight.updateHitbox();
    		
    		loadLeft = new FlxSprite(isTransIn ? 0 : -1280, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingL'));
    		loadLeft.scrollFactor.set();
    		loadLeft.antialiasing = ClientPrefs.data.antialiasing;
    		add(loadLeft);
    		loadLeft.cameras = [camOther];
    		loadLeft.setGraphicSize(FlxG.width, FlxG.height);
    		loadLeft.updateHitbox();
		
    		WaterMark = new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 50 * 2, 0, 'NF ENGINE V1.1.0', 50);
    		WaterMark.scrollFactor.set();
    		WaterMark.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		WaterMark.antialiasing = ClientPrefs.data.antialiasing;
    		add(WaterMark);
    		WaterMark.cameras = [camOther];
        
            EventText = new FlxText(isTransIn ? 50 : -1230, 720 - 50 - 50, 0, 'LOADING . . . . . . ', 50);
    		EventText.scrollFactor.set();
    		EventText.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		EventText.antialiasing = ClientPrefs.data.antialiasing;
    		add(EventText);
    		EventText.cameras = [camOther];
		
			FlxG.sound.play(Paths.sound('loading_close'),ClientPrefs.data.CustomFadeSound);
			if (!ClientPrefs.data.CustomFadeText) {
			    EventText.text = '';
			    WaterMark.text = '';
			}
			loadLeftTween = FlxTween.tween(loadLeft, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
				    FlxTransitionableState.skipNextTransIn = true;
					MusicBeatState.switchState(new FreeplayState());
				},
			ease: FlxEase.expoInOut});
			
			loadRightTween = FlxTween.tween(loadRight, {x: 0}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});
			
			loadTextTween = FlxTween.tween(WaterMark, {x: 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});
			
			EventTextTween = FlxTween.tween(EventText, {x: 50}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.expoInOut});					
		}else{
    		loadAlpha = new FlxSprite( 0, 0).loadGraphic(Paths.image('menuExtend/CustomFadeTransition/loadingAlpha'));
    		loadAlpha.scrollFactor.set();
    		loadAlpha.antialiasing = ClientPrefs.data.antialiasing;		
    		add(loadAlpha);
    		loadAlpha.cameras = [camOther];
    		loadAlpha.setGraphicSize(FlxG.width, FlxG.height);
    		loadAlpha.updateHitbox();
		
    		WaterMark = new FlxText( 50, 720 - 50 - 50 * 2, 0, 'NF ENGINE V1.1.0', 50);
    		WaterMark.scrollFactor.set();
    		WaterMark.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		WaterMark.antialiasing = ClientPrefs.data.antialiasing;
    		add(WaterMark);
            WaterMark.cameras = [camOther];
            
            EventText = new FlxText( 50, 720 - 50 - 50, 0, 'LOADING . . . . . . ', 50);
    		EventText.scrollFactor.set();
    		EventText.setFormat(Assets.getFont("assets/fonts/loadText.ttf").fontName, 50, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		EventText.antialiasing = ClientPrefs.data.antialiasing;
        	add(EventText);
		    EventText.cameras = [camOther];
		
			FlxG.sound.play(Paths.sound('loading_close'),ClientPrefs.data.CustomFadeSound);
			if (!ClientPrefs.data.CustomFadeText) {
			    EventText.text = '';
			    WaterMark.text = '';
			}
			WaterMark.alpha = 0;
			EventText.alpha = 0;
			loadAlpha.alpha = 0;
			loadAlphaTween = FlxTween.tween(loadAlpha, {alpha: 1}, duration, {
				onComplete: function(twn:FlxTween) {
				    FlxTransitionableState.skipNextTransIn = true;
					MusicBeatState.switchState(new FreeplayState());
				},
			ease: FlxEase.sineInOut});
			
			loadTextTween = FlxTween.tween(WaterMark, {alpha: 1}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.sineInOut});
			
			EventTextTween = FlxTween.tween(EventText, {alpha: 1}, duration, {
				onComplete: function(twn:FlxTween) {
					if(finishCallback != null) {
						finishCallback();
					}
				},
			ease: FlxEase.sineInOut});
		}

	}

	override function destroy() {
		if(leTween != null) {
			finishCallback();
			leTween.cancel();
			
			if (loadLeftTween != null) loadLeftTween.cancel();
			if (loadRightTween != null) loadRightTween.cancel();
			if (loadAlphaTween != null) loadAlphaTween.cancel();
			
			loadTextTween.cancel();
			EventTextTween.cancel();
		}
		super.destroy();
	}
}
