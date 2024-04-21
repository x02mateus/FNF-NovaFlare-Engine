package states;

import haxe.Json;
import lime.utils.Assets;
import openfl.display.BitmapData;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.FlxGraphic;
import flixel.FlxState;

import states.editors.ChartingState;

import backend.Song;
import backend.StageData;
import backend.Section;
import backend.Rating;

import objects.Note.EventNote; //why
import objects.*;

import haxe.ds.StringMap;

import sys.thread.Thread;
import sys.thread.Mutex;

class LoadingState extends MusicBeatState
{
	public static var loaded:Int = 0;
	public static var loadMax:Int = 0;

	static var requestedBitmaps:Map<String, BitmapData> = [];
	static var mutex:Mutex = new Mutex();
	
	static var isPlayState:Bool = false;

	function new(target:FlxState, stopMusic:Bool)
	{
		this.target = target;
		this.stopMusic = stopMusic;
		startThreads();
		
		super();
	}

	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false, intrusive:Bool = true)
		MusicBeatState.switchState(getNextState(target, stopMusic, intrusive));
	
	var target:FlxState = null;
	var stopMusic:Bool = false;
	var dontUpdate:Bool = false;

	var bar:FlxSprite;
	var barWidth:Int = 0;
	var intendedPercent:Float = 0;
	var curPercent:Float = 0;
	var canChangeState:Bool = true;
	
	var timePassed:Float;

	#if PSYCH_WATERMARKS
	var logo:FlxSprite;
	var loadingText:FlxText;
	#else
	var funkay:FlxSprite;
	#end
	
	public static var instance:LoadingState;

	override function create()
	{
	    instance = this;
	    
		if (checkLoaded())
		{
			dontUpdate = true;
			super.create();
			onLoad();
			return;
		}

		#if PSYCH_WATERMARKS // PSYCH LOADING SCREEN
		var bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.setGraphicSize(Std.int(FlxG.width));
		bg.color = 0xFFD16FFF;
		bg.updateHitbox();
		add(bg);
	
		loadingText = new FlxText(520, 600, 400, 'Now Loading...', 32);
		loadingText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, OUTLINE_FAST, FlxColor.BLACK);
		loadingText.borderSize = 2;
		add(loadingText);
	
		logo = new FlxSprite(0, 0).loadGraphic(Paths.image('loading_screen/icon'));
		logo.scale.set(0.75, 0.75);
		logo.updateHitbox();
		logo.antialiasing = ClientPrefs.data.antialiasing;
		logo.screenCenter();
		logo.x -= 50;
		logo.y -= 40;
		add(logo);

		#else // BASE GAME LOADING SCREEN
		var bg = new FlxSprite().makeGraphic(1, 1, 0xFFCAFF4D);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		funkay = new FlxSprite(0, 0).loadGraphic(Paths.image('funkay'));
		funkay.antialiasing = ClientPrefs.data.antialiasing;
		funkay.setGraphicSize(0, FlxG.height);
		funkay.updateHitbox();
		add(funkay);
		#end

		var bg:FlxSprite = new FlxSprite(0, 660).makeGraphic(1, 1, FlxColor.BLACK);
		bg.scale.set(FlxG.width - 300, 25);
		bg.updateHitbox();
		bg.screenCenter(X);
		add(bg);

		bar = new FlxSprite(bg.x + 5, bg.y + 5).makeGraphic(1, 1, FlxColor.WHITE);
		bar.scale.set(0, 15);
		bar.updateHitbox();
		add(bar);
		barWidth = Std.int(bg.width - 10);

		persistentUpdate = true;
		super.create();
	}

	var transitioning:Bool = false;
	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (dontUpdate) return;
		
		if (pushNotes.length == lineUse)
		{
		    sortNotes();
		}

		if (!transitioning)
		{
			if (canChangeState && !finishedLoading && checkLoaded() && intendedPercent > 0.99)
			{
				transitioning = true;
				onLoad();
				return;
			}
			intendedPercent = loaded / loadMax;
		}

		if (curPercent != intendedPercent)
		{
			if (Math.abs(curPercent - intendedPercent) < 0.001) curPercent = intendedPercent;
			else curPercent = FlxMath.lerp(intendedPercent, curPercent, Math.exp(-elapsed * 15));

			bar.scale.x = barWidth * curPercent;
			bar.updateHitbox();
		}

		#if PSYCH_WATERMARKS // PSYCH LOADING SCREEN
		timePassed += elapsed;
		var txt:String = 'Now Loading.';
		switch(Math.floor(timePassed % 1 * 3))
		{
			case 1:
				txt += '.';
			case 2:
				txt += '..';
		}
		loadingText.text = txt;		
		#end
	}
	
	var finishedLoading:Bool = false; //use for stop update
	function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
			
		

		imagesToPrepare = [];
		soundsToPrepare = [];
		musicToPrepare = [];
		songsToPrepare = [];
        
        if (isPlayState){
            isPlayState = false;
            unspawnNotes.remove;
            MusicBeatState.switchState(new PlayState(unspawnNotes, noteTypes));
        } else {
		    MusicBeatState.switchState(target);
	    }
		transitioning = true;
		finishedLoading = true;
	}

	static function checkLoaded():Bool {
		for (key => bitmap in requestedBitmaps)
		{
			if (bitmap != null && Paths.cacheBitmap(key, bitmap) != null) trace('finished preloading image $key');
			else trace('failed to cache image $key');
		}
		requestedBitmaps.clear();
		return (loaded == loadMax);
	}

	static function getNextState(target:FlxState, stopMusic = false, intrusive:Bool = true):FlxState
	{
		var directory:String = 'shared';
		var weekDir:String = StageData.forceNextDirectory;
		StageData.forceNextDirectory = null;

		if (weekDir != null && weekDir.length > 0 && weekDir != '') directory = weekDir;

		Paths.setCurrentLevel(directory);
		trace('Setting asset folder to ' + directory);

		var doPrecache:Bool = false;
		if (ClientPrefs.data.loadingScreen)
		{
			clearInvalids();
			if(intrusive)
			{
				if (imagesToPrepare.length > 0 || soundsToPrepare.length > 0 || musicToPrepare.length > 0 || songsToPrepare.length > 0)
					return new LoadingState(target, stopMusic);
			}
			else doPrecache = true;
		}

		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		if(doPrecache)
		{
			startThreads();
			while(true)
			{
				if(checkLoaded())
				{
					imagesToPrepare = [];
					soundsToPrepare = [];
					musicToPrepare = [];
					songsToPrepare = [];
					break;
				}
				else Sys.sleep(0.01);
			}
		}
		return target;
	}

	static var imagesToPrepare:Array<String> = [];
	static var soundsToPrepare:Array<String> = [];
	static var musicToPrepare:Array<String> = [];
	static var songsToPrepare:Array<String> = [];
	public static function prepare(images:Array<String> = null, sounds:Array<String> = null, music:Array<String> = null)
	{
		if (images != null) imagesToPrepare = imagesToPrepare.concat(images);
		if (sounds != null) soundsToPrepare = soundsToPrepare.concat(sounds);
		if (music != null) musicToPrepare = musicToPrepare.concat(music);
	}

	static var dontPreloadDefaultVoices:Bool = false;
	public static function prepareToSong()
	{
		if (!ClientPrefs.data.loadingScreen) return;
		
		isPlayState = true;

		var song:SwagSong = PlayState.SONG;
		var folder:String = Paths.formatToSongPath(song.song);
		try
		{
			var path:String = Paths.json('$folder/preload');
			var json:Dynamic = null;

			#if MODS_ALLOWED
			var moddyFile:String = Paths.modsJson('$folder/preload');
			if (FileSystem.exists(moddyFile)) json = Json.parse(File.getContent(moddyFile));
			else json = Json.parse(File.getContent(path));
			#else
			json = Json.parse(Assets.getText(path));
			#end

			if (json != null)
				prepare((!ClientPrefs.data.lowQuality || json.images_low) ? json.images : json.images_low, json.sounds, json.music);
		}
		catch(e:Dynamic) {}

		if (song.stage == null || song.stage.length < 1)
			song.stage = StageData.vanillaSongStage(folder);

		var stageData:StageFile = StageData.getStageFile(song.stage);
		if (stageData != null && stageData.preload != null)
			prepare((!ClientPrefs.data.lowQuality || stageData.preload.images_low) ? stageData.preload.images : stageData.preload.images_low, stageData.preload.sounds, stageData.preload.music);

		songsToPrepare.push('$folder/Inst');

		var player1:String = song.player1;
		var player2:String = song.player2;
		var gfVersion:String = song.gfVersion;
		var needsVoices:Bool = song.needsVoices;
		var prefixVocals:String = needsVoices ? '$folder/Voices' : null;
		if (gfVersion == null) gfVersion = 'gf';

		dontPreloadDefaultVoices = false;
		preloadCharacter(player1, prefixVocals);
		if (player2 != player1) preloadCharacter(player2, prefixVocals);
		if (!stageData.hide_girlfriend && gfVersion != player2 && gfVersion != player1) preloadCharacter(gfVersion);
		
		preloadMisc();
		preloadScript();		
		
		if (!dontPreloadDefaultVoices && needsVoices) songsToPrepare.push(prefixVocals);
	}

	public static function clearInvalids()
	{
		clearInvalidFrom(imagesToPrepare, 'images', '.png', IMAGE);
		clearInvalidFrom(soundsToPrepare, 'sounds', '.${Paths.SOUND_EXT}', SOUND);
		clearInvalidFrom(musicToPrepare, 'music',' .${Paths.SOUND_EXT}', SOUND);
		clearInvalidFrom(songsToPrepare, 'songs', '.${Paths.SOUND_EXT}', SOUND, 'songs');

		for (arr in [imagesToPrepare, soundsToPrepare, musicToPrepare, songsToPrepare])
			while (arr.contains(null))
				arr.remove(null);
	}

	static function clearInvalidFrom(arr:Array<String>, prefix:String, ext:String, type:AssetType, ?library:String = null)
	{
		for (i in 0...arr.length)
		{
			var folder:String = arr[i];
			if(folder.trim().endsWith('/'))
			{
				for (subfolder in Mods.directoriesWithFile(Paths.getSharedPath(), '$prefix/$folder'))
					for (file in FileSystem.readDirectory(subfolder))
						if(file.endsWith(ext))
							arr.push(folder + file.substr(0, file.length - ext.length));

				//trace('Folder detected! ' + folder);
			}
		}

		var i:Int = 0;
		while(i < arr.length)
		{

			var member:String = arr[i];
			var myKey = '$prefix/$member$ext';
			if(library == 'songs') myKey = '$member$ext';

			//trace('attempting on $prefix: $myKey');
			var doTrace:Bool = false;
			if(member.endsWith('/') || (!Paths.fileExists(myKey, type, false, library) && (doTrace = true)))
			{
				arr.remove(member);
				if(doTrace) trace('Removed invalid $prefix: $member');
			}
			else i++;
		}
	}

	public static function startThreads()
	{
		loadMax = imagesToPrepare.length
		            + soundsToPrepare.length 
		            + musicToPrepare.length 
		            + songsToPrepare.length 
		            + PlayState.SONG.notes.length
		            + 1;
		loaded = 0;

		//then start threads
		for (sound in soundsToPrepare) initThread(() -> Paths.sound(sound), 'sound $sound');
		for (music in musicToPrepare) initThread(() -> Paths.music(music), 'music $music');
		for (song in songsToPrepare) initThread(() -> Paths.returnSound(null, song, 'songs'), 'song $song');

		// for images, they get to have their own thread
		for (image in imagesToPrepare)
			Thread.create(() -> {
				mutex.acquire();
				try {
					var bitmap:BitmapData;
					var file:String = null;

					#if MODS_ALLOWED
					file = Paths.modsImages(image);
					if (Paths.currentTrackedAssets.exists(file)) {
						mutex.release();
						loaded++;
						return;
					}
					else if (FileSystem.exists(file))
						bitmap = BitmapData.fromFile(file);
					else
					#end
					{
						file = Paths.getPath('images/$image.png', IMAGE);
						if (Paths.currentTrackedAssets.exists(file)) {
							mutex.release();
							loaded++;
							return;
						}
						else if (OpenFlAssets.exists(file, IMAGE))
							bitmap = OpenFlAssets.getBitmapData(file);
						else {
							trace('no such image $image exists');
							mutex.release();
							loaded++;
							return;
						}
					}
					mutex.release();

					if (bitmap != null) requestedBitmaps.set(file, bitmap);
					else trace('oh no the image is null NOOOO ($image)');
				}
				catch(e:Dynamic) {
					mutex.release();
					trace('ERROR! fail on preloading image $image');
				}
				loaded++;
			});
		setSpeed();
		preloadChart();
	}

	static function initThread(func:Void->Dynamic, traceData:String)
	{
		Thread.create(() -> {
			mutex.acquire();
			try {
				var ret:Dynamic = func();
				mutex.release();

				if (ret != null) trace('finished preloading $traceData');
				else trace('ERROR! fail on preloading $traceData');
			}
			catch(e:Dynamic) {
				mutex.release();
				trace('ERROR! fail on preloading $traceData');
			}
			loaded++;
		});
	}

	inline private static function preloadCharacter(char:String, ?prefixVocals:String)
	{
		try
		{
			var path:String = Paths.getPath('characters/$char.json', TEXT, null, true);
			#if MODS_ALLOWED
			var character:Dynamic = Json.parse(File.getContent(path));
			#else
			var character:Dynamic = Json.parse(Assets.getText(path));
			#end
			
			imagesToPrepare.push(character.image);
			if (prefixVocals != null && character.vocals_file != null)
			{
				songsToPrepare.push(prefixVocals + "-" + character.vocals_file);
				if(char == PlayState.SONG.player1) dontPreloadDefaultVoices = true;
			}
		}
		catch(e:Dynamic) {}
	}
	
	static function preloadMisc(){		    
	    var ratingsData:Array<Rating> = Rating.loadDefault();
	    var stageData:StageFile = StageData.getStageFile(PlayState.SONG.stage);
		
	    var uiPrefix:String = '';
		var uiSuffix:String = '';
		
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = StageData.dummy();
		}
		var stageUI = "normal";
		
		if (stageData.stageUI != null && stageData.stageUI.trim().length > 0)
			stageUI = stageData.stageUI;
		else {
			if (stageData.isPixelStage)
				stageUI = "pixel";
		}		
		if (stageUI != "normal")
		{
			uiPrefix = '${stageUI}UI/';
			if (PlayState.isPixelStage) uiSuffix = '-pixel';
		}

		for (rating in ratingsData){
			imagesToPrepare.push(uiPrefix + rating.image + uiSuffix);			         
		}
		
		for (i in 0...10)
		imagesToPrepare.push(uiPrefix + 'num' + i + uiSuffix);		
	}
	
	static function preloadScript(){	
        #if ((LUA_ALLOWED || HSCRIPT_ALLOWED) && sys)
    		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'scripts/'))
    			for (file in FileSystem.readDirectory(folder))
    			{
    				#if LUA_ALLOWED
    				
    				if(file.toLowerCase().endsWith('.lua'))
    					filesCheck(folder + file);					
    				#end
                    /*
    				#if HSCRIPT_ALLOWED
    				if(file.toLowerCase().endsWith('.hx'))
    					initHScript(folder + file);
    				#end
    				*/
    			}
    		
    		var songName = PlayState.SONG.song;
    		for (folder in Mods.directoriesWithFile(Paths.getSharedPath(), 'data/$songName/'))
    			for (file in FileSystem.readDirectory(folder))
    			{
    				#if LUA_ALLOWED
    				if(file.toLowerCase().endsWith('.lua'))
    					filesCheck(folder + file);
    				#end
                    /*
    				#if HSCRIPT_ALLOWED
    				if(file.toLowerCase().endsWith('.hx'))
    					initHScript(folder + file);
    				#end
    				*/
    			}
    			
    		startLuasNamed('stages/' + PlayState.SONG.stage + '.lua');	
		#end	        	    	
	}
	
	static function startLuasNamed(luaFile:String)
	{
		#if MODS_ALLOWED
		var luaToLoad:String = Paths.modFolders(luaFile);
		if(!FileSystem.exists(luaToLoad))
			luaToLoad = Paths.getSharedPath(luaFile);

		if(FileSystem.exists(luaToLoad))
		#elseif sys
		var luaToLoad:String = Paths.getSharedPath(luaFile);
		if(Assets.exists(luaToLoad))
		#end
		{			
			filesCheck(luaToLoad);		
		}
	}	
	
	static function filesCheck(path:String)
	{
    	var input:String = File.getContent(path);
    	var regex = ~/makeLuaSprite\('(\S+)', '(\S+)', .*?\)/g; // Global flag 'g' added for multiple matches 
    	while (regex.match(input)) {
    	    var result = regex.matched(2); // Extract the first capture group 
    	    imagesToPrepare.push(result); // Output each match 
    	    input = regex.matchedRight(); // Move to the next match 
    	}				
    	
    	var regex = ~/makeAnimatedLuaSprite\('(\S+)', '(\S+)', .*?\)/g; // Global flag 'g' added for multiple matches 
    	while (regex.match(input)) {
    	    var result = regex.matched(2);
    	    imagesToPrepare.push(result);
    	    input = regex.matchedRight(); 
    	}				
    	
    	var regex = ~/precacheImage\('(\S+)'/g;
    	while (regex.match(input)) {
    	    var result = regex.matched(1); 
    	    imagesToPrepare.push(result);
    	    input = regex.matchedRight();
    	}				
	}
	
	static var unspawnNotes:Array<Note> = [];
	static var pushNotes:Array<Array<Note>> = [];
    static var noteTypes:Array<String> = [];
	public static var songSpeed:Float = 1;
	public static var songSpeedType:String = "multiplicative";	
	public static function setSpeed()
	{
	    songSpeed = PlayState.SONG.speed;
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype');
		switch(songSpeedType)
		{
			case "multiplicative":
				songSpeed = PlayState.SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed');
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed');
		}		
	}
	static var lineUse:Int = ClientPrefs.data.loadLine;
	static function preloadChart()
	{	
	    Thread.create(() -> {
			mutex.acquire();
			
    	    unspawnNotes = [];    	        	    
    	    noteTypes = [];
    	    
    	    var noteData:Array<SwagSection> =  PlayState.SONG.notes;            
            var chartPlist:Array<Int> = [];
            
            if (lineUse > noteData.length) lineUse = noteData.length;
            var plist = Std.int(noteData.length / lineUse);
            for (realSection in 0...lineUse + 1)
            {
                if (realSection != lineUse) chartPlist.push(plist * realSection);  
                else chartPlist.push(noteData.length);                     
            }
            
            for (line in 0...lineUse){
                Thread.create(() -> {
                    var mutex:Mutex = new Mutex();
                    mutex.acquire();
                    var sectionNotes:Array<Note> = [];
            		for (num in chartPlist[line]...chartPlist[line + 1])
            		{
            		    var section = noteData[num];
            			for (songNotes in section.sectionNotes)
            			{
            				var daStrumTime:Float = songNotes[0];
                    		var daNoteData:Int = Std.int(songNotes[1] % 4);
                    		var gottaHitNote:Bool = section.mustHitSection;
                    		
                    		if (ClientPrefs.data.filpChart) {
                    		    if (daNoteData == 0) {
                    		        daNoteData = 3;
                    		    }    
                    		    else if (daNoteData == 1) {
                    		        daNoteData = 2;
                    		    }    
                    		    else if (daNoteData == 2) {
                    		        daNoteData = 1;
                    		    }   
                    		    else if (daNoteData == 3) {
                    		        daNoteData = 0;
                    		    } 
                    		}
                    
                    		if (songNotes[1] > 3)
                    		{
                    			gottaHitNote = !section.mustHitSection;
                    		}
                    
                    		var oldNote:Note;
                    		if (unspawnNotes.length > 0)
                    			oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
                    		else
                    			oldNote = null;
                    
                    		var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, LoadingState.instance);
                    		swagNote.mustPress = gottaHitNote;
                    		swagNote.sustainLength = songNotes[2];
                    		swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
                    		swagNote.noteType = songNotes[3];
                    		if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts
                    
                    		swagNote.scrollFactor.set();
                    
                    		sectionNotes.push(swagNote);
                    
                    		final susLength:Float = swagNote.sustainLength / Conductor.stepCrochet;
                    		final floorSus:Int = Math.floor(susLength) - ClientPrefs.data.fixLNL;
                    
                    		if(floorSus > 0) {
                    			for (susNote in 0...floorSus + 1)
                    			{
                    				oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
                    
                    				var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote), daNoteData, oldNote, true, LoadingState.instance);
                    				sustainNote.mustPress = gottaHitNote;
                    				sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
                    				sustainNote.noteType = swagNote.noteType;
                    				sustainNote.scrollFactor.set();
                    				sustainNote.parent = swagNote;
                    				sustainNote.hitMultUpdate(susNote, floorSus + 1);
                    				sectionNotes.push(sustainNote);
                    				swagNote.tail.push(sustainNote);
                    
                    				sustainNote.correctionOffset = swagNote.height / 2;
                    				if(!PlayState.isPixelStage)
                    				{
                    					if(oldNote.isSustainNote)
                    					{
                    						oldNote.scale.y *= Note.SUSTAIN_SIZE / oldNote.frameHeight;
                    						oldNote.scale.y /= ClientPrefs.getGameplaySetting('songspeed');
                    						oldNote.updateHitbox();
                    					}
                    
                    					if(ClientPrefs.data.downScroll)
                    						sustainNote.correctionOffset = 0;
                    				}
                    				else if(oldNote.isSustainNote)
                    				{
                    					oldNote.scale.y /= ClientPrefs.getGameplaySetting('songspeed');
                    					oldNote.updateHitbox();
                    				}
                    
                    				if (sustainNote.mustPress) sustainNote.x += FlxG.width / 2; // general offset
                    				else if(ClientPrefs.data.middleScroll)
                    				{
                    					sustainNote.x += 310;
                    					if(daNoteData > 1) //Up and Right
                    						sustainNote.x += FlxG.width / 2 + 25;
                    				}
                    			}
                    		}
                    
                    		if (swagNote.mustPress)
                    		{
                    			swagNote.x += FlxG.width / 2; // general offset
                    		}
                    		else if(ClientPrefs.data.middleScroll)
                    		{
                    			swagNote.x += 310;
                    			if(daNoteData > 1) //Up and Right
                    			{
                    				swagNote.x += FlxG.width / 2 + 25;
                    			}
                    		}
                    
                    		if(!noteTypes.contains(swagNote.noteType)) {
                    			noteTypes.push(swagNote.noteType);
                    		}	
            			}
            			
            			loaded++;
            		}
            		pushNotes.push(sectionNotes);
            		mutex.release();		   
    	        });
    		}
    		/*
    		for (event in songData.events) //Event Notes
    			for (i in 0...event[1].length)
    				makeEvent(event, i);*/
      		
    		mutex.release();
    	});
	}

	// called only once per different event (Used for precaching)
	/*
	function eventPushed(event:EventNote) {
		eventPushedUnique(event);
		if(eventsPushed.contains(event.event)) {
			return;
		}

		stagesFunc(function(stage:BaseStage) stage.eventPushed(event));
		eventsPushed.push(event.event);
	}
	*/
	
	static function sortNotes()
	{
	    Thread.create(() -> {
			mutex.acquire();
    	    for (array in 0...pushNotes.length)
    	    {	
    	        for (note in 0...pushNotes[array].length)
    	        unspawnNotes.push(pushNotes[array][note]);
    	    }
    	    unspawnNotes.sort(PlayState.sortByTime);
    	    mutex.release();
    	    loaded++;
	    });
	}
}
