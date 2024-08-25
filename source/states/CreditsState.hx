package states;

import objects.AttachedSprite;
import objects.ShapeEX;
import objects.CreditsShape;
import substates.CreditsSubState;
import substates.PsychCreditsSubState;

class CreditsState extends MusicBeatState
{
	private static var curSelected:Int = -1;
	private static var curSelectedFloat:Float;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var UnUcreditsStuff:Array<String> = [
		"NF Team", 
		"psych Team", 
		#if mobile
		"andriod team",
		#end
		"funkin Team"
	];

	private var NucreditsStuff:Array<Array<Array<String>>> = [
		[
		['NovaFlare Engine Team'],
		['Beihu',		'beihu',	'<Main Programmer>',	'Main Programmer and Head of NovaFlare Engine',						'https://b23.tv/Etk6gY9',	'FFC0CB'],
		['TieGuo',		'tieguo',	'<Coder>',	'Ex-Programmer',				'https://b23.tv/7OVWzAO',	'FF6600'],
		['Chiny',		'chiny',	'<Coder>',	'Touhou Player',				'https://space.bilibili.com/3493288327777064',	'3399FF'],
		['Careful_Scarf_487', 'Careful_Scarf_487', '<Artist>',	'Main Artist', 'https://b23.tv/DQ1a0jO',  '990000'],
		['mengqi',       'mengqi',       '<Artist>',	'Artist',                               'https://space.bilibili.com/2130239542',    '9b5a67'],
		['als',            'als',       '<Animation>',	    'Open screen animation support',     'https://b23.tv/mNNX8R8',                'ff0000'],
		['ddd',           'ddd',         '<Sounds Support>',	     'Sounds support',                     'https://space.bilibili.com/401733211',      '5123A0']
		],
		[
		['Psych Engine Team'],
		['Shadow Mario',		'shadowmario',		'Main Programmer and Head of Psych Engine',					 'https://ko-fi.com/shadowmario',		'444444'],
		['Riveren',				'riveren',			'Main Artist/Animator of Psych Engine',						 'https://twitter.com/riverennn',		'14967B'],
		['bb-panzu',			'bb',				'Ex-Programmer of Psych Engine',							 'https://twitter.com/bbsub3',			'3E813A'],
		['shubs',				'',					"Ex-Programmer of Psych Engine\nI don\'t support them.",	 '',									'A1A1A1'],
		['CrowPlexus',			'crowplexus',		'Input System v3, Major Help and Other PRs',				 'https://twitter.com/crowplexus',		'A1A1A1'],
		['Keoiki',				'keoiki',			'Note Splash Animations and Latin Alphabet',				 'https://twitter.com/Keoiki_',			'D2D2D2'],
		['SqirraRNG',			'sqirra',			"Crash Handler and Base code for\nChart Editor\'s Waveform", 'https://twitter.com/gedehari',		'E1843A'],
		['EliteMasterEric',		'mastereric',		'Runtime Shaders support',									 'https://twitter.com/EliteMasterEric',	'FFBD40'],
		['PolybiusProxy',		'proxy',			'.MP4 Video Loader Library (hxCodec)',						 'https://twitter.com/polybiusproxy',	'DCD294'],
		['Tahir',				'tahir',			'Implementing & Maintaining SScript and Other PRs',			 'https://twitter.com/tahirk618',		'A04397'],
		['iFlicky',				'flicky',			'Composer of Psync and Tea Time\nMade the Dialogue Sounds',	 'https://twitter.com/flicky_i',		'9E29CF'],
		['KadeDev',				'kade',				'Fixed some issues on Chart Editor and Other PRs',			 'https://twitter.com/kade0912',		'64A250'],
		['superpowers04',		'superpowers04',	'LUA JIT Fork',												 'https://twitter.com/superpowers04',	'B957ED'],
		['CheemsAndFriends',	'face',	'Creator of FlxAnimate\n(Icon will be added later, merry christmas!)',	 'https://twitter.com/CheemsnFriendos',	'A1A1A1'],
		],
		#if mobile
		[
		['Mobile Porting Team'],
		['mcagabe19',		                'lily',		                'Head Porter of Psych Engine Mobile',							'https://www.youtube.com/@mcagabe19',           'FFE7C0'],
		['Karim Akra',				'karim',			'Assistant Porter/Helper #1 of Psych Engine Mobile',						'https://youtube.com/@Karim0690',		'FFB4F0'],
		['MemeHoovy',				'hoovy',			'Helper #2 of Psych Engine Mobile',							'https://twitter.com/meme_hoovy',               'F592C4'],
		['MAJigsaw77',				'jigsaw',			'Author of Mobile Controls, New FlxRuntimeShader and Storage Stuff',							'https://github.com/MAJigsaw77',               '898989'],
		['FutureDorito',				'dorito',			'iOS Helper/Implement',							'https://www.youtube.com/@Futuredorito',               'E69138']
		],
		#end
		[
		["Funkin' Crew"],
		['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",						 'https://twitter.com/ninja_muffin99',	'CF2D2D'],
		['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",							 'https://twitter.com/PhantomArcade3K',	'FADC45'],
		['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",							 'https://twitter.com/evilsk8r',		'5ABD4B'],
		['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",							 'https://twitter.com/kawaisprite',		'378FC7']
		]
	];

	private var UncreditsStuff:Array<String> = [];
	private var creditsStuff:Array<Array<String>> = [];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:FlxColor;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;

	var modList:ModsButtonRect;
	var ModListArray:Array<ModsButtonRect> = [];

	var camSong:FlxCamera;

	var psych:Bool = true;
	var noscreen:Bool = false;

	private static var position:Float = 100 - 45;
	private static var lerpPosition:Float = 100 - 45;

	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);
		bg.screenCenter();

		for (psych in UnUcreditsStuff) {
			UncreditsStuff.push(psych);
		}

		#if MODS_ALLOWED
		for (mod in Mods.parseList().enabled) {
			UncreditsStuff.push(mod);
		}
		#end
	
		for (i in 0...UncreditsStuff.length)
		{
			modList = new ModsButtonRect(0, i * 120 + 100, 600, 90, 25, 25, UncreditsStuff[i], 0, FlxColor.BLACK);
			//modList.list = pushModCreditsToList(UncreditsStuff[i]);
			modList.screenCenter(X);
			add(modList);
			ModListArray.push(modList);
		}

		addVirtualPad(UP_DOWN, A_B_C);

		super.create();

		curSelectedFloat = curSelected;
		changeSelection(0);

		//camSong.scroll.x = FlxMath.lerp(-(curSelected) * 20 * 0.75, camSong.scroll.x, 0);
		//camSong.scroll.y = FlxMath.lerp((curSelected) * 75 * 0.75, camSong.scroll.y, 0);

		songsRectPosUpdate(false);
	}

	var quitting:Bool = false;
	var holdTime:Float = 0;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if(!quitting)
		{
			if(creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if(FlxG.keys.pressed.SHIFT || virtualPad.buttonC.pressed) shiftMult = 3;

				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-1);
					curSelectedFloat = curSelected;
				}
				if (downP)
				{
					changeSelection(1);
					curSelectedFloat = curSelected;
				}

				//camSong.scroll.x = FlxMath.lerp(-(curSelectedFloat) * 20 * 0.75, camSong.scroll.x, FlxMath.bound(1 - (elapsed * 9), 0, 1));
				//camSong.scroll.y = FlxMath.lerp((curSelectedFloat) * 75 * 0.75, camSong.scroll.y, FlxMath.bound(1 - (elapsed * 9), 0, 1));

				if(controls.UI_DOWN || controls.UI_UP)
				{

				}
			}

			if(controls.ACCEPT) {
				//CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				if(colorTween != null) {
					colorTween.cancel();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
				quitting = true;
			}
		}
		
		position += FlxG.mouse.wheel * 70;
		if (FlxG.mouse.pressed) 
		{
			position += moveData;
			lerpPosition = position;
			songsRectPosUpdate(true);
		}
		for (i in 0...ModListArray.length)
		{
			if (FlxG.mouse.overlaps(ModListArray[i]))
			{
				if (FlxG.mouse.justReleased)
				{
					position += avgSpeed * (0.0166 / elapsed) * Math.pow(1.1, Math.abs(avgSpeed * 0.8));
					if (Math.abs(avgSpeed * (0.0166 / elapsed)) < 3) {
						creditsStuff = [];

						if (UncreditsStuff[i] == UnUcreditsStuff[i]) {
							for (eg in NucreditsStuff[i]) {
								if (eg[5] != null) {
									psych = false;
									if (eg[1] != null) {
										creditsStuff.push(eg);
									}
								}
								else {
									psych = true;
									creditsStuff.push(eg);
								}
							}
						}
						else {
							pushModCreditsToList(UncreditsStuff[i]);
						}

						trace(creditsStuff);

						if (!noscreen) 
						{
							if (!psych) {
								if (creditsStuff != null) {
									CreditsSubState.creditsStuff = creditsStuff;
									persistentUpdate = false;
									openSubState(new CreditsSubState());
									trace("false");
								}
							}
							else if (psych) {
								if (creditsStuff != null) {
									PsychCreditsSubState.creditsStuff = creditsStuff;
									persistentUpdate = false;
									openSubState(new PsychCreditsSubState());
									trace("true");
								}
							}
						}
						else if (noscreen) {
							FlxG.sound.play(Paths.sound('cancelMenu'));
						}
					}
				}
			}
		}

		if (position > 360 - 45) position = FlxMath.lerp(360 - 45, position, Math.exp(-elapsed * 15));
		if (position < 360 - 45 - 100 * (ModListArray.length - 1)) position = FlxMath.lerp(360 - 45 - 100 * (ModListArray.length - 1), position, Math.exp(-elapsed * 15));

		if (Math.abs(lerpPosition - position) < 1) lerpPosition = position;
		else lerpPosition = FlxMath.lerp(position, lerpPosition, Math.exp(-elapsed * 15));
		
		songsRectPosUpdate(false);

		super.update(elapsed);
	}

	var saveMouseY:Int = 0;
	var moveData:Int = 0;
	var avgSpeed:Float = 0;
	function mouseMove()
	{
		moveData = FlxG.mouse.y - saveMouseY;
		saveMouseY = FlxG.mouse.y;
		avgSpeed = avgSpeed * 0.75 + moveData * 0.25;
	}

	function songsRectPosUpdate(forceUpdate:Bool = false) 
	{
		if (!forceUpdate && lerpPosition == position) return; //优化
		for (i in 0...ModListArray.length){
			ModListArray[i].y = lerpPosition + i * 120;
		}
	}

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected += change;
		if (curSelected < 0)
			curSelected = creditsStuff.length - 1;
		if (curSelected >= creditsStuff.length)
			curSelected = 0;

	}

	#if MODS_ALLOWED
	function pushModCreditsToList(folder:String)
	{
		var creditsFile:String = null;
		if(folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');

		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for(i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split(";;");
				if (arr.length != 1) {
					if(arr.length >= 5) arr.push(folder);
					creditsStuff.push(arr);
					psych = false;
				}
				else {
					var arrr:Array<String> = i.replace('\\n', '\n').split("::");
					if(arrr.length >= 5) arrr.push(folder);
					creditsStuff.push(arrr);
					psych = true;
				}
				trace(arr.length);
			}
			creditsStuff.push(['']);
			noscreen = false;
		}
		else {
			noscreen = true;
		}
	}
	#end

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
