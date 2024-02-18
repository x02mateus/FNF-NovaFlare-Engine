package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;
import backend.DiffCalc;
import backend.Difficulty;

import lime.utils.Assets;
import openfl.utils.Assets as OpenFlAssets;

import objects.HealthIcon;
import states.editors.ChartingState;

import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;

import flixel.addons.ui.FlxInputText;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.addons.ui.FlxInputText;
import flixel.util.FlxStringUtil;
import flixel.sound.FlxSound;
import flixel.ui.FlxBar;

#if MODS_ALLOWED
import sys.FileSystem;
#end

import states.FreeplayState;
import backend.Mods;
import flixel.FlxG;
import flixel.text.FlxText;
import backend.MusicBeatState;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import states.PlayState;
import states.LoadingState;
import states.MainMenuState;
import options.OptionsState;

class FreeplayState extends MusicBeatState {

	var bg:FlxSprite;
	var bgColorChange:FlxTween;
	var songsbg:FlxSprite;
	var difficultyRight:FlxSprite;
	var difficultyLeft:FlxSprite;
	var backButton:FlxSprite;
	var startButton:FlxSprite;
	var backText:FlxText;
	var startText:FlxText;
	
	var mousechecker:FlxSprite;
	var searching:Bool = false;
	var searchbg:FlxSprite;
	var searchtext:FlxText;
	
	var listening:Bool = false;
	var listenbg:FlxSprite;
	
	var songBarSelected:FlxSprite;
	var infoBar:FlxSprite;
	var songNameText:FlxText;
	var songIcon:HealthIcon;
	
	var accText:FlxText;
	var difficultyText:FlxText;
	var rateText:FlxText;
	var scoreText:FlxText;
	var timeText:FlxText;
	
	var rate:FlxSprite;
	var timerTween:FlxTimer;
	var swagRect:FlxRect;
    public static var songs:Array<SongMetadata> = [];
    var songtextsGroup:Array<FlxText> = [];
    var iconsArray:Array<HealthIcon> = [];
    var barsArray:Array<FlxSprite> = [];
    
    var holdOptions:Bool = false;
    var holdOptionsTime:Float = 0;
    var curHoldOptions:Int;
    var holdOptionsChecker:Array<FlxSprite> = [];
    var bars1Option:FlxSprite;
    var bars2Option:FlxSprite;
    var bars3Option:FlxSprite;
    var bars4Option:FlxSprite;
    
    var searchButton:FlxSprite;
    var musicButton:FlxSprite;
    var randomButton:FlxSprite;
    
    var intendedColor:Int;
    var colorTween:FlxTween;
    
    var font = Paths.font('montserrat.ttf');
    var filePath:String = 'menuExtend/FreePlayState/';
    
    private static var curSelected:Int = 0;
	var lerpSelected:Float = 0;
	public static var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = Difficulty.getDefault();
	
	var camGame:FlxCamera;
    var camSong:FlxCamera;
    var camUI:FlxCamera;
    var camInfo:FlxCamera;
    var camSearch:FlxCamera;
    var camListen:FlxCamera;
    
	override function create()
	{
		camGame = new FlxCamera();
		camGame.bgColor = 0x00;
		
		camSong = new FlxCamera();
		camSong.bgColor = 0x00;
		
		camInfo = new FlxCamera();
		camInfo.bgColor = 0x00;
		
		camSearch = new FlxCamera(-FlxG.width);
		camSearch.bgColor = 0x00;
		
		camListen = new FlxCamera(-FlxG.width);
		camListen.bgColor = 0x00;
		
		camUI = new FlxCamera();
		camUI.bgColor = 0x00;
		
		FlxG.cameras.add(camGame, false);
		FlxG.cameras.add(camSong, false);
		FlxG.cameras.add(camInfo, false);
		//FlxG.cameras.add(camUI, false);
		FlxG.cameras.add(camSearch, false);
		FlxG.cameras.add(camListen, false);
		FlxG.cameras.add(camUI, false);
		    	
    	songsbg = new FlxSprite(700, -75).makeGraphic(550, 900, FlxColor.WHITE);
    	songsbg.camera = camGame;
    	songsbg.angle = 15;
    	songsbg.updateHitbox();
    	songsbg.alpha = 1;
    	add(songsbg);
    	
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
    	bg.antialiasing = ClientPrefs.data.antialiasing;
    	bg.camera = camGame;
    	add(bg);
    	bg.screenCenter();
    	
    	mousechecker = new FlxSprite(114, 514).makeGraphic(1, 1, FlxColor.WHITE);
    	
    	mousechecker.updateHitbox();
    	mousechecker.alpha = 0.1;
    	add(mousechecker);
    	mousechecker.camera = camUI;
    	
    	loadSong();
    	addSongTxt();
    	
    	if(curSelected >= songs.length) curSelected = 0;
    	bg.color = songs[curSelected].color;
    	intendedColor = bg.color;
    	
    	curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));    	    	
    	
    	songBarSelected = new FlxSprite().loadGraphic(Paths.image(filePath + 'songBarSelected'));
    	songBarSelected.antialiasing = ClientPrefs.data.antialiasing;
    	songBarSelected.camera = camUI;
    	add(songBarSelected);
    	songBarSelected.screenCenter();
    	
    	songIcon = new HealthIcon(songs[curSelected].songCharacter);
    	add(songIcon);
    	songIcon.scale.set(0.5, 0.5);
    	songIcon.camera = camUI;
    	songIcon.x = 1120;
    	songIcon.y = 300;
    	songIcon.updateHitbox();
    	
    	songNameText = new FlxText(0, 0, 0, "", 32);
    	songNameText.setFormat(font, 40, FlxColor.BLACK, LEFT/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
    	songNameText.camera = camUI;
    	songNameText.antialiasing = ClientPrefs.data.antialiasing;
    	songNameText.x = 660;
    	songNameText.y = 348;
    	add(songNameText);
    	
    	rate = new FlxSprite().loadGraphic(Paths.image(filePath + 'rateBG'));
    	rate.antialiasing = ClientPrefs.data.antialiasing;
    	rate.camera = camInfo;
    	rate.updateHitbox();
    	rate.x = 61;
    	rate.y = 304;
    	add(rate);
    	
    	difficultyRight = new FlxSprite().loadGraphic(Paths.image(filePath + 'difficultyRight'));
    	difficultyRight.antialiasing = ClientPrefs.data.antialiasing;
    	difficultyRight.camera = camInfo;
    	difficultyRight.updateHitbox();
    	add(difficultyRight);
    	
    	difficultyLeft = new FlxSprite().loadGraphic(Paths.image(filePath + 'difficultyLeft'));
    	difficultyLeft.antialiasing = ClientPrefs.data.antialiasing;
    	difficultyLeft.camera = camInfo;
    	difficultyLeft.updateHitbox();
    	add(difficultyLeft);
    		
    	for (i in 1...9)
    	{
    		var back:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'infoBar' + i));
    		back.antialiasing = ClientPrefs.data.antialiasing;
    		back.camera = camInfo;
    		back.updateHitbox();
    		add(back);
    		
    		if (i >= 4 && i <= 7)
    			holdOptionsChecker.push(back);
    	}
    	
    	var RateBarText = new FlxText(0, 0, 0, "RATE:", 32);
    	RateBarText.setFormat(font, 21, FlxColor.BLACK, LEFT/*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
    	RateBarText.camera = camInfo;
    	RateBarText.antialiasing = ClientPrefs.data.antialiasing;
    	RateBarText.x = 0;
    	RateBarText.y = 305;
    	add(RateBarText);
    	
    	var diffText:FlxText = new FlxText(360, 355, 0, "DIFFICULTY", 15);
    	diffText.setFormat(font, 15, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	diffText.camera = camInfo;
    	diffText.antialiasing = ClientPrefs.data.antialiasing;
    	add(diffText);
    	
    	difficultyText = new FlxText(300, 360, 0, "difficulty", 55);
    	difficultyText.setFormat(font, 55, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	difficultyText.camera = camInfo;
    	difficultyText.antialiasing = ClientPrefs.data.antialiasing;
    	add(difficultyText);
    	
    	rateText = new FlxText(60, 270, 0, "rate", 30);
    	rateText.setFormat(font, 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	rateText.camera = camInfo;
    	rateText.antialiasing = ClientPrefs.data.antialiasing;
    	add(rateText);
    	
    	accText = new FlxText(75+115, 270, 0, "acc", 30);
    	accText.setFormat(font, 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	accText.camera = camInfo;
    	accText.antialiasing = ClientPrefs.data.antialiasing;
    	add(accText);
    	
    	scoreText = new FlxText(75+270, 270, 0, "score", 30);
    	scoreText.setFormat(font, 30, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	scoreText.camera = camInfo;
    	scoreText.antialiasing = ClientPrefs.data.antialiasing;
    	add(scoreText);
    	
    	timeText = new FlxText(50, 240, 0, "time", 28);
    	timeText.setFormat(font, 28, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	timeText.camera = camInfo;
    	timeText.antialiasing = ClientPrefs.data.antialiasing;
    	add(timeText);
    
    	var alpha = 0;
		bars1Option = new FlxSprite().loadGraphic(Paths.image(filePath + 'optionbar'));
		bars1Option.camera = camInfo;
		bars1Option.scale.set(0.66, 0.65);
		bars1Option.antialiasing = ClientPrefs.data.antialiasing;
		bars1Option.alpha = alpha;
		add(bars1Option);
		
		bars2Option = new FlxSprite().loadGraphic(Paths.image(filePath + 'optionbar'));
		bars2Option.camera = camInfo;
		bars2Option.scale.set(0.62, 0.65);
		bars2Option.antialiasing = ClientPrefs.data.antialiasing;
		bars2Option.alpha = alpha;
		add(bars2Option);
		
		bars3Option = new FlxSprite().loadGraphic(Paths.image(filePath + 'optionbar'));
		bars3Option.camera = camInfo;
		bars3Option.scale.set(0.65, 0.65);
		bars3Option.antialiasing = ClientPrefs.data.antialiasing;
		bars3Option.alpha = alpha;
		add(bars3Option);
		
		bars4Option = new FlxSprite().loadGraphic(Paths.image(filePath + 'optionbar'));
		bars4Option.camera = camInfo;
		bars4Option.scale.set(0.62, 0.65);
		bars4Option.antialiasing = ClientPrefs.data.antialiasing;
		bars4Option.alpha = alpha;
		add(bars4Option);
    	
    	bars1Option.setPosition(-52-1.5, 395.5);
    	bars2Option.setPosition(195+8, 395.5);
    	bars3Option.setPosition(-82, 457.5);
    	bars4Option.setPosition(170+6, 457.5);
			
    	var options = new FlxText(140, 457, 0, "Options", 28);
    	options.setFormat(font, 28, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	options.camera = camInfo;
    	options.antialiasing = ClientPrefs.data.antialiasing;
    	add(options);
    	
    	var options = new FlxText(380, 445, 0, "Gameplay\nChanger", 28);
    	options.setFormat(font, 25, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	options.camera = camInfo;
    	options.antialiasing = ClientPrefs.data.antialiasing;
    	add(options);
    	
    	var options = new FlxText(80, 520, 0, "Reset Score", 28);
    	options.setFormat(font, 28, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	options.camera = camInfo;
    	options.antialiasing = ClientPrefs.data.antialiasing;
    	add(options);
    	
    	for (i in [0, 3]) {
    		var back:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'overlaps' + i));
    		back.antialiasing = ClientPrefs.data.antialiasing;
    		back.camera = camUI;
    		back.updateHitbox();
    		add(back);
    	}
    	
    	startButton = new FlxSprite().loadGraphic(Paths.image(filePath + 'overlaps2'));
    	startButton.antialiasing = ClientPrefs.data.antialiasing;
    	startButton.camera = camUI;
    	startButton.updateHitbox();
    	add(startButton);
    	
    	backButton = new FlxSprite().loadGraphic(Paths.image(filePath + 'overlaps1'));
    	backButton.antialiasing = ClientPrefs.data.antialiasing;
    	backButton.camera = camUI;
    	backButton.updateHitbox();
    	add(backButton);
    	
    	startText = new FlxText(1140, 640, 0, "PLAY", 28);
    	startText.setFormat(font, 35, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	startText.camera = camUI;
    	startText.antialiasing = ClientPrefs.data.antialiasing;
    	add(startText);
    	
    	backText = new FlxText(30, 30, 0, "EXIT", 28);
    	backText.setFormat(font, 35, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	backText.camera = camUI;
    	backText.antialiasing = ClientPrefs.data.antialiasing;
    	add(backText);
    	
    	searchbg = new FlxSprite(-150, -200).makeGraphic(750, 1000, FlxColor.BLACK);
    	searchbg.camera = camSearch;
    	searchbg.angle = 15;
    	searchbg.updateHitbox();
    	searchbg.alpha = 0.75;
    	add(searchbg);
    	
    	listenbg = new FlxSprite(-150, -200).makeGraphic(750, 1000, FlxColor.BLACK);
    	listenbg.camera = camListen;
    	listenbg.angle = 15;
    	listenbg.updateHitbox();
    	listenbg.alpha = 0.75;
    	add(listenbg);
    	
    	randomButton = new FlxSprite().loadGraphic(Paths.image(filePath + 'random'));
    	randomButton.camera = camUI;
    	add(randomButton);
    	
    	musicButton = new FlxSprite().loadGraphic(Paths.image(filePath + 'musicplayer'));
    	musicButton.camera = camUI;
    	add(musicButton);
    	
    	searchButton = new FlxSprite().loadGraphic(Paths.image(filePath + 'search'));
    	searchButton.camera = camUI;
    	add(searchButton);
    	
    	var objs:Array<FlxSprite> = [randomButton, musicButton, searchButton];
    	for (i in 0...objs.length) {
    		objs[i].scale.set(60/1500, 60/1500);
    		objs[i].updateHitbox();
    		objs[i].x = FlxG.width - i*90 - 90;
    	}
    	
    	var optionsText = new FlxText(190, 8, 0, 'E to Search Song | SPACE to Listen Song | O to get a random Song');
    	optionsText.setFormat(font, 25, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	optionsText.camera = camUI;
    	add(optionsText);
    	optionsText.scale.x = 0.9;
    	
    	var optionsText = new FlxText(5, FlxG.height - 45, 0, 'Mouse wheel/Arrow keys to change Song | All UI can Control By Mouse');
    	optionsText.setFormat(font, 25, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    	optionsText.camera = camUI;
    	add(optionsText);
    	
    	makeSearchUI();
    	makeListenMenu();
    	
    	changeSong(0);
    }
    
    var startMouseY:Float;
    var curSelectedFloat:Float;
    var lastCurSelected:Int;
    var canMove:Bool;
    public static var vocals:FlxSound = null;
    public static var instPlaying:Int = 0;
    override function update(elapsed:Float)
    {
    	if (controls.UI_DOWN_P)
    		changeSong(1);
    	if (controls.UI_UP_P)
    		changeSong(-1);
    	//debugPrint(mousechecker.x + ' || ' + mousechecker.y);
    	mousechecker.setPosition(FlxG.mouse.getScreenPosition(camUI).x, FlxG.mouse.getScreenPosition(camUI).y);
    	if ((FlxG.mouse.justPressed && FlxG.pixelPerfectOverlap(difficultyLeft, mousechecker, 25)) || controls.UI_LEFT_P)
    		changeDiff(-1);
    	if ((FlxG.mouse.justPressed && FlxG.pixelPerfectOverlap(difficultyRight, mousechecker, 25)) || controls.UI_RIGHT_P)
    		changeDiff(1);
    		
    	if ((FlxG.mouse.overlaps(searchButton) && !searching && FlxG.mouse.justPressed) || FlxG.keys.justPressed.E) {
    		searching = true;
    		listening = false;
			backText.text = 'BACK';
    	}
    	
    	if ((FlxG.mouse.overlaps(musicButton) && !listening && FlxG.mouse.justPressed) || FlxG.keys.justPressed.SPACE) {
    		listening = true;
    		searching = false;
			backText.text = 'BACK';
    	}
    	
    	if ((FlxG.mouse.overlaps(randomButton) && FlxG.mouse.justPressed) || FlxG.keys.justPressed.O) {
    		curSelected = FlxG.random.int(0, songs.length-1);
    		changeSong(0);
    	}
    	
    	if (searching) searchUpdate(elapsed);
    	if (listening) listenUpdate(elapsed);
    	checkButton(elapsed);
    	mouseControl(elapsed);
    	
    	if(FlxG.mouse.wheel != 0 && FlxG.mouse.x > FlxG.width/2)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
			changeSong(-2 * FlxG.mouse.wheel);
		}
		
		if (controls.RESET) {
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
		} else if (FlxG.keys.justPressed.CONTROL)
			openSubState(new GameplayChangersSubstate());
		else if (FlxG.keys.justPressed.P)
			LoadingState.loadAndSwitchState(new OptionsState());
			
    	camSearch.x = FlxMath.lerp(searching ? 0 : -1280, camSearch.x, FlxMath.bound(1 - (elapsed * 6), 0, 1));
    	camListen.x = FlxMath.lerp(listening ? 0 : -1280, camListen.x, FlxMath.bound(1 - (elapsed * 6), 0, 1));
    	camInfo.x = FlxMath.lerp((!listening && !searching) ? 0 : -1280, camInfo.x, FlxMath.bound(1 - (elapsed * 6), 0, 1));
    	
    	camSong.scroll.x = FlxMath.lerp(-(curSelectedFloat) * 20 * 0.75, camSong.scroll.x, FlxMath.bound(1 - (elapsed * 9), 0, 1));
        camSong.scroll.y = FlxMath.lerp((curSelectedFloat) * 75 * 0.75, camSong.scroll.y, FlxMath.bound(1 - (elapsed * 9), 0, 1));
    }
    
    var listeningSongName:FlxText;
    var playingSongName:FlxText;
    var listeningSongTime:FlxText;
    public static var playingSong:Int = -1;
    var maxTime:Float = 0;
    
    var playText:FlxText;
    var playButton:FlxSprite;
    var pauseText:FlxText;
    var pauseButton:FlxSprite;
    var pausedsong:Bool = false;
    
    var progressBar:FlxSprite;
    var timeLeft:FlxSprite;
    var timeRight:FlxSprite;
    var changingTime:Bool = false;
    function makeListenMenu() {
    	startMusic(false);
    	listeningSongName = new FlxText(50, 190, 500, songs[curSelected].songName);
    	listeningSongName.setFormat(font, 50, FlxColor.WHITE, CENTER);
    	listeningSongName.camera = camListen;
    	add(listeningSongName);
    	
    	playingSongName = new FlxText(50, 235, 500, 'Playing: ' + (playingSong == -1 ? songs[curSelected].songName : songs[playingSong].songName));
    	playingSongName.setFormat(font, 30, FlxColor.WHITE, CENTER);
    	playingSongName.camera = camListen;
    	add(playingSongName);
    	
    	listeningSongTime = new FlxText(350, 350, 0, '-:-/-:-');
    	listeningSongTime.setFormat(font, 30, FlxColor.WHITE, LEFT);
    	listeningSongTime.camera = camListen;
    	add(listeningSongTime);
    	
    	playText = new FlxText(120, 350, 0, 'PLAY');
    	playText.setFormat(font, 30, FlxColor.WHITE, LEFT);
    	playText.camera = camListen;
    	add(playText);
    	
    	playButton = new FlxSprite(110, 340).makeGraphic(105, 60, FlxColor.WHITE);
    	playButton.camera = camListen;
    	playButton.alpha = 0;
    	add(playButton);
    	
    	pauseText = new FlxText(50, 440, 0, 'PAUSE');
    	pauseText.setFormat(font, 30, FlxColor.WHITE, LEFT);
    	pauseText.camera = camListen;
    	add(pauseText);
    	
    	pauseButton = new FlxSprite(40, 430).makeGraphic(135, 60, FlxColor.WHITE);
    	pauseButton.camera = camListen;
    	pauseButton.alpha = 0;
    	add(pauseButton);
    	
    	timeLeft = new FlxSprite(215, 445).makeGraphic(160, 30, FlxColor.WHITE);
    	timeLeft.camera = camListen;
    	timeLeft.alpha = 0.25;
    	add(timeLeft);
    	
    	timeRight = new FlxSprite(375, 445).makeGraphic(160, 30, FlxColor.WHITE);
    	timeRight.camera = camListen;
    	timeRight.alpha = 0.25;
    	add(timeRight);
    	
    	progressBar = new FlxSprite(225, 455).makeGraphic(1, 10, FlxColor.WHITE);
    	progressBar.camera = camListen;
    	add(progressBar);
    }
    
    function startMusic(play:Bool)
	{
		destroyFreeplayVocals();
		var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);
    	PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
    	
    	if (PlayState.SONG.needsVoices)
		{
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
			FlxG.sound.list.add(vocals);
			vocals.persist = true;
			vocals.looped = true;
		}
		else if (vocals != null)
		{
			vocals.stop();
			vocals.destroy();
			vocals = null;
		}
	
		if (play) {
			FlxG.sound.music.time = 0;
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.8);
			maxTime = FlxG.sound.music.length;
			if(vocals != null)
			{
				vocals.play();
				
				vocals.volume = 0.8;
			}
			listeningSongTime.text = timeConverter(0) + '/' + timeConverter(maxTime);
			
			playingSong = curSelected;
			playingSongName.text = 'Playing: ' + (playingSong == -1 ? songs[curSelected].songName : songs[playingSong].songName);
		}
	}
    
    function listenUpdate(elapsed:Float) {
    	if (playButton.alpha > 0)
    		playButton.alpha -= elapsed;
    	
    	if (playingSong == curSelected)
    		playText.text = 'STOP';
    	else
    		playText.text = 'PLAY';
    		
    	if (FlxG.mouse.overlaps(playButton) && FlxG.mouse.justPressed) {
    		playButton.alpha = 0.75;
    		
    		if (playText.text == 'STOP') {
    			destroyFreeplayVocals();
    			FlxG.sound.music.stop();
    			playingSong = -1;
    			return;
    		}
    		
    		if (playingSong != curSelected)
    			startMusic(true);
    	}
    	
    	if (pauseButton.alpha > 0)
    		pauseButton.alpha -= elapsed;
    	
    	if (playingSong != -1) {
        	if (FlxG.mouse.overlaps(pauseButton) && FlxG.mouse.justPressed) {
        		pauseButton.alpha = 0.75;
        		
        		if (pausedsong) {
        			FlxG.sound.music.play();
        			if (vocals != null) vocals.play();
        		} else {
        			FlxG.sound.music.pause();
        			if (vocals != null) vocals.pause();
        		}
        		
        		if (vocals != null) {
        			vocals.time = FlxG.sound.music.time;
        		}
        		
        		pausedsong = !pausedsong;
        	}
        	
        	if (FlxG.mouse.overlaps(timeLeft) && !pausedsong) {
    			if (FlxG.mouse.justPressed) {
    				FlxG.sound.music.pause();
    				vocals.pause();
    				changingTime = true;
    			}
    			
    			if (FlxG.mouse.pressed && changingTime) {
    				timeLeft.alpha = 0.25;
    				timeRight.alpha = 0;
    				FlxG.sound.music.time -= 12000*elapsed;
    				if (FlxG.sound.music.time <= 0)
    					FlxG.sound.music.time = 0;
    			}
    		}else if (FlxG.mouse.overlaps(timeRight) && !pausedsong) {
    			if (FlxG.mouse.justPressed) {
    				FlxG.sound.music.pause();
    				vocals.pause();
    				changingTime = true;
    			}
    			
    			if (FlxG.mouse.pressed && changingTime) {
    				timeRight.alpha = 0.25;
    				timeLeft.alpha = 0;
    				FlxG.sound.music.time += 12000*elapsed;
    				if (FlxG.sound.music.time >= maxTime)
    					FlxG.sound.music.time = maxTime;
    			}
    		}
    		
    		if (changingTime && FlxG.mouse.justReleased) {
    			changingTime = false;
    			FlxG.sound.music.play();
    			vocals.play();
    			vocals.time = FlxG.sound.music.time;
    			timeLeft.alpha = 0;
    			timeRight.alpha = 0;
    		}
    		
    		listeningSongTime.text = timeConverter(FlxG.sound.music.time) + '/' + timeConverter(maxTime);
    		progressBar.scale.x = FlxG.sound.music.time/FlxG.sound.music.length*300;
    		progressBar.updateHitbox();
    	} else {
    		progressBar.scale.x = 0;
    		timeLeft.alpha = 0;
    		timeRight.alpha = 0;
    	}
	}
    
    public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}
    
    function closeListenMenu() {
    	listening = false;
    }
    
    override function destroy() {
    	destroyFreeplayVocals();
    	FlxG.sound.music.stop();
    }
    
    function timeConverter(time:Float) {
		var secondsTotal:Int = Math.floor(time / 1000);
		return FlxStringUtil.formatTime(secondsTotal, false);
	}
    
    var searchInput:FlxInputText;
    public static var searchSelected:Int = 0;
    var searchSelectedObj:FlxSprite;
    var searchTextGroup:Array<FlxText> = [];
    var searchCheckGroup:Array<FlxSprite> = [];
    var oldText:String = '';
    function makeSearchUI() {
    	searchtext = new FlxText(60, 150, 0, 'Type Song Name...');
    	searchtext.setFormat(font, 28, FlxColor.WHITE, LEFT);
    	searchtext.camera = camSearch;
    	add(searchtext);
    	searchtext.alpha = 0.5;
    	
    	var underbar = new FlxSprite(60, 190).makeGraphic(450, 2, FlxColor.WHITE);
    	underbar.camera = camSearch;
    	underbar.updateHitbox();
    	add(underbar);
    	
    	searchInput = new FlxInputText(60, 150, 450, '', 30, 0x00FFFFFF);
		searchInput.focusGained = () -> FlxG.stage.window.textInputEnabled = true;
		searchInput.backgroundColor = FlxColor.TRANSPARENT;
		searchInput.fieldBorderColor = FlxColor.TRANSPARENT;
		searchInput.font = font;
		searchInput.antialiasing = ClientPrefs.data.antialiasing;
		searchInput.camera = camSearch;
		add(searchInput);
		
		for (i in 0...6) {
			var searchobj = new FlxText(125-i*15, 260+i*60, 0, '');
    		searchobj.setFormat(font, 35, FlxColor.WHITE, LEFT);
    		searchobj.camera = camSearch;
    		searchTextGroup.push(searchobj);
    		
    		var underbar = new FlxSprite(125-i*15, 260+i*60).makeGraphic(1, 1, FlxColor.WHITE);
    		underbar.camera = camSearch;
    		underbar.updateHitbox();
    		underbar.alpha = 0;
    		add(underbar);
    		searchCheckGroup.push(underbar);
    		
    		add(searchobj);
		}
    }
    
    function closeSearchMenu() {
    	searching = false;
    }
    
    public static var songsSearched:Array<SongMetadata> = [];
    var startMouseYsearch:Float = 0;
    var fakecurSelected = 0;
    function searchUpdate(elapsed:Float) {
    	searchtext.visible = searchInput.text == '';
    	
    	if (oldText != searchInput.text) {
    		oldText = searchInput.text;
    		if (searchInput.text == '') return;
    		songsSearched = [];
    		for (i in 0...songs.length) {
    			if ((songs[i].songName.toLowerCase()).indexOf(searchInput.text.toLowerCase()) != -1) {
    				songs[i].searchnum = i;
    				songsSearched.push(songs[i]);
    			}
    		}
    		searchChangeSong(0);
    	}
    	
    	if (FlxG.mouse.justPressed && FlxG.pixelPerfectOverlap(searchbg, mousechecker, 0))
    	{
    		startMouseYsearch = FlxG.mouse.y;
    		fakecurSelected = searchSelected;
    	}
    	
    	if (FlxG.mouse.pressed && FlxG.pixelPerfectOverlap(searchbg, mousechecker, 0))
    	{
    		searchSelected = Math.floor(fakecurSelected - (FlxG.mouse.y - startMouseYsearch) / (75*0.75));
    		
    		searchChangeSong(0);
    	}
    	
    	for (i in 0...searchTextGroup.length) {
    		if (FlxG.mouse.overlaps(searchCheckGroup[i]) && FlxG.mouse.justPressed && searchTextGroup[i].text != '') {
    			curSelected = songsSearched[searchSelected + i].searchnum;
    			changeSong(0);
    		}
    	}
    	
    	if(FlxG.mouse.wheel != 0 && FlxG.mouse.x <= FlxG.width/2)
    	{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
			searchChangeSong(-2 * FlxG.mouse.wheel);
		}
	}
    
    function searchChangeSong(num:Int) {
    	searchSelected += num;
    	if (searchSelected > songsSearched.length-6)
    		searchSelected = songsSearched.length-6;
    	
    	if (searchSelected < 0)
    		searchSelected = 0;
    		
    	for (i in 0...searchTextGroup.length) {
    		var id:Int = 0;
    			id = i+searchSelected;
    		if (songsSearched[id] != null)
    			searchTextGroup[i].text = songsSearched[id].songName;
    		else
    			searchTextGroup[i].text = '';
    			
    		searchCheckGroup[i].makeGraphic(Std.int(searchTextGroup[i].width), Std.int(searchTextGroup[i].height), FlxColor.WHITE);
   		}
    }
    
    var selectedThing:String = 'Nothing';
    function checkButton(elapsed:Float) {
    	if (FlxG.pixelPerfectOverlap(startButton, mousechecker, 25) || controls.ACCEPT) {
    		selectedThing = 'start';
    	} else if (FlxG.pixelPerfectOverlap(backButton, mousechecker, 25) || controls.BACK) {
    		selectedThing = 'back';
    	} else
    		selectedThing = 'Nothing';
    		
    	if (FlxG.mouse.justReleased || controls.ACCEPT || controls.BACK) {
    		if (selectedThing == 'start' || controls.ACCEPT) {
    			var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName);
        		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
        		try
        		{
        			PlayState.SONG = Song.loadFromJson(poop, songLowercase);
        			PlayState.isStoryMode = false;
        			PlayState.storyDifficulty = curDifficulty;
        
        			if(colorTween != null) {
        				colorTween.cancel();
        			}
        			
        			if(bgColorChange != null) {
        				bgColorChange.cancel();
        			}
        			
        			FlxG.sound.play(Paths.sound('confirmMenu'));
        		}
        		catch(e:Dynamic)
        		{
        			FlxG.sound.play(Paths.sound('cancelMenu'));
        
        			return;
        		}
        		
        		LoadingState.loadAndSwitchState(new PlayState());
    			FlxG.mouse.visible = false;
    	
    			FlxG.sound.music.volume = 0;
    				
    			destroyFreeplayVocals();
    			/*#if desktop
    			DiscordClient.loadModRPC();
    			#end*/
    		} else if (selectedThing == 'back' || controls.BACK) {
    			if (searching) {closeSearchMenu(); backText.text = 'EXIT'; return;}
    			if (listening) {closeListenMenu(); backText.text = 'EXIT'; return;}
    			FlxG.mouse.visible = false;
    			if(colorTween != null) {
    				colorTween.cancel();
    			}
    			if(bgColorChange != null) {
    				bgColorChange.cancel();
    			}
    			destroyFreeplayVocals();
    			if (playingSong == -1) FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
    			FlxG.sound.play(Paths.sound('cancelMenu'));
    			MusicBeatState.switchState(new MainMenuState());
    		}
    	}
    	
    	startButton.x = FlxMath.lerp(selectedThing == 'start' ? 15 : 0, startButton.x, FlxMath.bound(1 - (elapsed * 12), 0, 1));
    	backButton.x = FlxMath.lerp(selectedThing == 'back' ? -15 : 0, backButton.x, FlxMath.bound(1 - (elapsed * 12), 0, 1));
    	
    	startText.x = FlxMath.lerp(selectedThing == 'start' ? 1155 : 1140, startText.x, FlxMath.bound(1 - (elapsed * 12), 0, 1));
    	backText.x = FlxMath.lerp(selectedThing == 'back' ? 15 : 30, backText.x, FlxMath.bound(1 - (elapsed * 12), 0, 1));
    }
    
    function mouseControl(elapsed:Float){
        if (FlxG.mouse.justPressed && !canMove)
    	{
    		curSelectedFloat = curSelected;
    		lastCurSelected = curSelected;
    		startMouseY = FlxG.mouse.y;
    		
    		if (FlxG.pixelPerfectOverlap(songsbg, mousechecker, 0) && selectedThing == 'Nothing' && FlxG.mouse.y > 50 && FlxG.mouse.y < FlxG.height - 50)
    			canMove = true;
    		else
    			canMove = false;
    	}
    	
    	if (FlxG.mouse.pressed && canMove)
    	{
    		curSelectedFloat = lastCurSelected - (FlxG.mouse.y - startMouseY) / (75*0.75);
    		if (curSelectedFloat < (songs.length - 1) && curSelectedFloat > 0)
    		{
    			curSelected = Math.floor(curSelectedFloat+0.5);
    		} else {
    			if (curSelectedFloat >= (songs.length - 1))
    				curSelected = songs.length - 1;
    			else if (curSelectedFloat <= 0)
    				curSelected = 0;
    		}
    		changeSong(0);
    	}
    	
    	if (FlxG.mouse.justReleased && canMove)
    	{
    		if (curSelectedFloat < -3)
    			curSelected = songs.length - 1;
    		else if (curSelectedFloat > songs.length + 2)
    			curSelected = 0;
    			
    		curSelectedFloat = curSelected;
    		changeSong(0);
    		canMove = false;
    	}
    	
    	var optionsGroup:Array<FlxSprite> = [bars1Option, bars2Option, bars3Option, bars4Option];
    	for (i in 0...holdOptionsChecker.length) {
    		if (FlxG.mouse.justPressed && FlxG.pixelPerfectOverlap(holdOptionsChecker[i], mousechecker, 25) && !searching && !listening) {
    			holdOptions = true;
    			curHoldOptions = i;
    		//	debugPrint('ttttt');
    		}

    		if (curHoldOptions != i || !holdOptions) {
    			if (optionsGroup[i].alpha > 0)
    				optionsGroup[i].alpha -= elapsed*2;
    				
    			if (optionsGroup[i].alpha <= 0)
    				optionsGroup[i].alpha = 0;
    		}
    	}
    	
    	if (!FlxG.pixelPerfectOverlap(holdOptionsChecker[curHoldOptions], mousechecker, 25))
    		holdOptions = false;
    		
    	if (FlxG.mouse.pressed && holdOptions && !searching && !listening && optionsGroup[curHoldOptions] != null) {
    		if (optionsGroup[curHoldOptions].alpha <= 1)
    			optionsGroup[curHoldOptions].alpha += elapsed;
    			
    		if (optionsGroup[curHoldOptions].alpha > 1)
    			optionsGroup[curHoldOptions].alpha = 1;
    	}
    	
    	if (searching) holdOptions = false;
    	
    	if (FlxG.mouse.justReleased) {
    		holdOptions = false;

    		if (optionsGroup[curHoldOptions].alpha >= 0.99) {
    			switch(curHoldOptions) {
    				case 0: //Options
    					LoadingState.loadAndSwitchState(new OptionsState());
    				case 2: // Gameplay Changer
    					openSubState(new GameplayChangersSubstate());
    				case 3: // Reset Score
    					openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
    				case 4: // idk
    			}
    		}
    	}
    }
    
    var modCheck = Mods.currentModDirectory;
    
    function changeSong(iiiiint:Int)
    {
    	curSelected += iiiiint;
    	if (curSelected > songs.length-1)
    		curSelected = 0;
    	else if (curSelected < 0)
    		curSelected = songs.length-1;
    	
    	Mods.currentModDirectory = songs[curSelected].folder;
    	PlayState.storyWeek = songs[curSelected].week;
		Difficulty.loadFromWeek();
		
    	bgCheck();
    	changeDiff(0);
		
    	songNameText.text = songs[curSelected].songName;
    	songNameText.scale.x = 1;
    	var length = 450;
    	if (songNameText.width > length) songNameText.scale.x =  length / songNameText.width;
    	songNameText.offset.x = songNameText.width * (1 -songNameText.scale.x) / 2;
    	
    	listeningSongName.text = songs[curSelected].songName;
    /*	destroyFreeplayVocals();
    	PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
		if (PlayState.SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);*/
		
    	songIcon.changeIcon(songs[curSelected].songCharacter);
    	songIcon.updateHitbox();
    }
    
    function changeDiff(value:Int)
    {
    	curDifficulty += value;
    	if (curDifficulty < 0)
    		curDifficulty = Difficulty.list.length-1;
    	if (curDifficulty > Difficulty.list.length - 1)
    		curDifficulty = 0;
		var rate:Float = 0;
		
		try {
			var song = songs[curSelected].songName.toLowerCase();
			if (Paths.fileExists('data/' + Paths.formatToSongPath(song) + '/' + Paths.formatToSongPath(song) + Difficulty.getFilePath(curDifficulty)+'.json', TEXT)) {
				var poop:String = Highscore.formatSong(song, curDifficulty);
				rate = DiffCalc.CalculateDiff(Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase())) / 4;
			}
		} catch(e:Dynamic) {
			rate = -1;
			songNameText.text = 'ERROR';
		}
		
		rateCheck(rate);
		updateInfoText();
    }
    
    function updateInfoText()
    {
    	/*if (Difficulty.list.length > 1)
    		
    	else
    		difficultyText.text = Difficulty.list[curDifficulty];*/
    	
    	try {
    	difficultyText.text = Difficulty.list[curDifficulty];
    	difficultyText.x = (820 - difficultyText.width) / 2;
    		
    	var score = Highscore.getScore(songs[curSelected].songName, curDifficulty);
    	scoreText.text = 'Score: ' + score;
    	//debugPrint(scoreText.width);

    	scoreText.scale.x = 1;
		scoreText.updateHitbox();
		
		if (scoreText.width > 230)
			scoreText.scale.x = 215 / scoreText.width;
			scoreText.updateHitbox();
    	
		var rating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		accText.text = 'ACC: ' + rating + '%';
		accText.scale.x = 1;
		accText.updateHitbox();
		
		if (accText.width > 145)
			accText.scale.x = 120 / accText.width;
			accText.updateHitbox();
			
		timeText.text = 'N/A';
		} catch(e:Dynamic) {
			songNameText.text = 'ERROR';
		}
    }
	
	function returnSearchSong(string:String) {
		var coolSongs:Array<SongMetadata> = [];
		for (i in songs) {
			if (i.songName.indexOf(string) != -1)
				coolSongs.push(i);
		}
		
		return coolSongs;
	}
	
	function loadSong()
	{
		songs = [];
		for (i in 0...WeekData.weeksList.length) {
    		if(weekIsLocked(WeekData.weeksList[i])) continue;
    
    		var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
    		var leSongs:Array<String> = [];
    		var leChars:Array<String> = [];
    
    		for (j in 0...leWeek.songs.length)
    		{
    			leSongs.push(leWeek.songs[j][0]);
    			leChars.push(leWeek.songs[j][1]);
    		}
    
    		WeekData.setDirectoryFromWeek(leWeek);
    		for (song in leWeek.songs)
    		{
    			var colors:Array<Int> = song[2];
    			if(colors == null || colors.length < 3)
    			{
    				colors = [146, 113, 253];
    			}
    			addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
    		}
       	}
	}
	
	function addSongTxt()
	{
    	songtextsGroup = [];
    	iconsArray = [];
    	barsArray =  [];
    	
		for (i in 0...songs.length)
    	{
    		var songText = new FlxText(750 - (i-curSelected)*20 * 0.75, (i-curSelected)*75 * 0.75 + 355, 0, songs[i].songName, 30);
    		songText.setFormat(font, 30, FlxColor.WHITE, LEFT);
    		songText.camera = camSong;
    		var length = 400;
    		if (songText.width > length) songText.scale.x =  length / songText.width;
    		songText.offset.x += songText.width * (1 -songText.scale.x) / 2;
    		songtextsGroup.push(songText);
    		
    		Mods.currentModDirectory = songs[i].folder;
    		
    		var barShadow:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'songBarShadow'));
    		add(barShadow);
    		barShadow.camera = camSong;
    		barShadow.scale.set(1, 1);
    		barShadow.x = songText.x - 750;
    		barShadow.y = songText.y -300;
    		barShadow.updateHitbox();
    		barShadow.color = songs[i].color;
    		barsArray.push(barShadow);
		
    		var bar:FlxSprite = new FlxSprite().loadGraphic(Paths.image(filePath + 'songBar'));
    		add(bar);
    		bar.camera = camSong;
    		bar.scale.set(1, 1);
    		bar.x = songText.x - 750;
    		bar.y = songText.y - 300;
    		bar.updateHitbox();
    		barsArray.push(bar);
    		
    		var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
    		add(icon);
    		icon.scale.set(0.35, 0.35);
    		icon.camera = camSong;
    		icon.x = songText.x + 370;
    		icon.y = songText.y + songText.height / 2 - icon.height / 2;
    		icon.updateHitbox();
    		icon.scrollFactor.set(1,1);
    		iconsArray.push(icon);
    		
    		add(songText);
    		camSong.alpha = 0.6;
    	}
	}
	
	function weekIsLocked(name:String):Bool {
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
	}
	
	 function addSong(songName:String, weekNum:Int, songCharacter:String, color:Int)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, color));
	}
	
	function bgCheck()
	{
	    if (modCheck != Mods.currentModDirectory){
    	    modCheck = Mods.currentModDirectory;
    	    
    	    if (bgColorChange != null) bgColorChange.cancel();
    	    if (colorTween != null) colorTween.cancel();
       			
    	    bgColorChange = FlxTween.color(bg, 0.35, bg.color, FlxColor.BLACK, {
				onComplete: function(twn:FlxTween) {
					bg.loadGraphic(Paths.image('menuDesat'));
    	            bg.screenCenter();
    	            
    	            bgColorChange = FlxTween.color(bg, 0.35, FlxColor.BLACK, songs[curSelected].color);
			    }
    	    });
    	}else{    	
          	var newColor:Int = songs[curSelected].color;
      		if(newColor != intendedColor) {
      		
      			if (bgColorChange != null) bgColorChange.cancel();
    	        if (colorTween != null){
    	            colorTween.cancel();
    	            bg.loadGraphic(Paths.image('menuDesat'));
    	            bg.screenCenter();
    	        }
    	        
       			intendedColor = newColor;
       			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
    				onComplete: function(twn:FlxTween) {
					    colorTween = null;
   				    }
   			    });
    	    }
    	}
	}
	
	var saveVar:Float = 0;
	function rateCheck(Rate:Float = 0)
	{
		rateText.text = 'Lv. ' + (Math.floor(Rate*100)/100);
		
		if (Rate == -1) {rateText.text = 'RATE ERROR'; return;}
	    if (Rate > 20) Rate = 20;
	    var showWidth = 0;
	    
	    if (timerTween != null){
    	    saveVar = swagRect.width;
    	    timerTween.cancel();
	    }
	    timerTween = new FlxTimer().start(0.0001, function(tmr:FlxTimer) {
	        showWidth++;
    		swagRect = rate.clipRect;
			if(swagRect == null) swagRect = new FlxRect(0, 0, 0, 0);
		    swagRect.x = 0;
		    swagRect.y = 0;
		    swagRect.width = saveVar + (rate.width * (Rate / 20) - saveVar) * showWidth / 20;
		    swagRect.height = rate.height;
		    rate.clipRect = swagRect;
		    
		    if (showWidth == 20){ 
		        tmr.cancel();
		        saveVar = swagRect.width;
		    }
        }, 0);
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var lastDifficulty:String = null;
	public var bg:Dynamic;
	public var searchnum:Int = 0;

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Mods.currentModDirectory;
		this.bg = Paths.image('menuDesat');
		this.searchnum = 0;
		if(this.folder == null) this.folder = '';
	}
}