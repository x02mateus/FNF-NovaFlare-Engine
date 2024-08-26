package substates;

import objects.AttachedSprite;
import objects.shape.ShapeEX;
import objects.shape.CreditsShape;
import objects.shape.CreditsNote;
#if hxvlc
import hxvlc.flixel.FlxVideoSprite;
#end

class CreditsSubState extends MusicBeatSubstate
{
    public static var creditsStuff:Array<Array<String>> = [];

    var curSelected:Int = -1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	var iconArray:Array<AttachedSprite> = [];
	var iconTextArray:Array<FlxText> = [];
	var iconBGArray:Array<Rect> = [];
	var linkSpriteArray:Array<CreditsNote> = [];
	var iconNameArray:Array<String> = [];

	var linkArray:Array<String> = [];

	var bg:FlxSprite;
	var leftdescText:FlxText;
	var rightdescText:FlxText;
	var descBox:Rect;
	var descSprite:FlxSprite;
	var descSpriteText:FlxText;
	var intendedColor:FlxColor;
	var colorTween:FlxTween;
	var descBoxArray:Array<Rect> = [];

	var backShape:CreditsButton;

	var offsetThing:Float = -75;

    var camIcons:FlxCamera;
	var camHUD:FlxCamera;

	var iconVideo:FlxVideoSprite;

	var font = Paths.font('montserrat.ttf');

	private static var position:Float = 100 - 45;
	private static var lerpPosition:Float = 100 - 45;

    public function new()
    {     
        super();
    }

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
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		var bgwidth = 230;

        camIcons = new FlxCamera(0, 0, bgwidth, FlxG.height - 120);
		camIcons.bgColor = 0x00;

		camHUD = new FlxCamera();
		camHUD.bgColor = 0x00;

        FlxG.cameras.add(camIcons, false);
		FlxG.cameras.add(camHUD, false);
	
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);

			if(isSelectable) {
				if(creditsStuff[i][5] != null)
				{
					Mods.currentModDirectory = creditsStuff[i][5];
				}

				var str:String = 'credits/missing_icon';
				if(creditsStuff[i][1] != null && creditsStuff[i][1].length > 0)
				{
					var fileName = 'credits/' + creditsStuff[i][1];
					if (Paths.fileExists('images/$fileName.png', IMAGE)) str = fileName;
					else if (Paths.fileExists('images/$fileName-pixel.png', IMAGE)) str = fileName + '-pixel';
				}
				iconNameArray.push(str);

				var icon:AttachedSprite = new AttachedSprite(str);
                icon.scale.set(0.3, 0.3);
				icon.updateHitbox();
                iconArray.push(icon);

				var iconBG:Rect = new Rect(0, 0, bgwidth, 120, 0, 0, FlxColor.GRAY, 0.7);
				iconBGArray.push(iconBG);

				var iconText:FlxText = new FlxText(0, 0, 0, creditsStuff[i][0], 22);
				iconText.setFormat(font, 22, FlxColor.BLACK, LEFT);

				if (iconText.width > 140) iconText.scale.x = 140 / iconText.width;
				iconText.offset.x = iconText.width * (1 -iconText.scale.x) / 2;

				iconText.updateHitbox();
                iconTextArray.push(iconText);

				add(iconBG);
				add(icon);
				add(iconText);

				icon.cameras = [camIcons];
				iconBG.cameras = [camIcons];
				iconText.cameras = [camIcons];

				Mods.currentModDirectory = '';

				if(curSelected == -1) curSelected = i;
			}
		}

        for (i in 0...iconArray.length)
        {
			RectPos(i);
        }

		var BG:Rect = new Rect(0, FlxG.height - 120, bgwidth, 5, 0, 0, FlxColor.BLACK, 1);
		BG.cameras = [camHUD];
		add(BG);

		var BG:Rect = new Rect(bgwidth, 0, 5, FlxG.height, 0, 0, FlxColor.BLACK, 1);
		BG.cameras = [camHUD];
		add(BG);

		var BG:Rect = new Rect(bgwidth + 5, FlxG.height - 150, FlxG.width - bgwidth + 5, 5, 0, 0, FlxColor.BLACK, 1);
		BG.cameras = [camHUD];
		add(BG);

		var BG:Rect = new Rect(bgwidth + 5, FlxG.height * 0.1, FlxG.width - bgwidth + 5, 5, 0, 0, FlxColor.BLACK, 1);
		BG.cameras = [camHUD];
		add(BG);

		leftdescText = new FlxText(170, 5, Std.int(FlxG.width / 2), "");
		leftdescText.setFormat(font, 45, FlxColor.BLACK, CENTER);
		leftdescText.updateHitbox();

		rightdescText = new FlxText(700, 5, Std.int(FlxG.width / 2), "");
		rightdescText.setFormat(font, 45, FlxColor.BLACK, CENTER);
		rightdescText.updateHitbox();
		
		var dbwidth:Int = 470;

		var descBox:Rect = new Rect(265, 5, dbwidth, 60, 25, 25, FlxColor.WHITE, 0.7);
		add(descBox);

		var copydescBox:Rect = new Rect(785, 5, dbwidth, 60, 25, 25, FlxColor.WHITE, 0.7);
		add(copydescBox);

		var leftdescBox:Rect = new Rect(265, 115, dbwidth, 420, 25, 25, FlxColor.WHITE, 0.7);
		add(leftdescBox);

		var rightdescBox:Rect = new Rect(785, 115, dbwidth, 420, 25, 25, FlxColor.WHITE, 0.7);
		add(rightdescBox);

		add(leftdescText);
		add(rightdescText);

		descBoxArray.push(descBox);
		descBoxArray.push(copydescBox);
		descBoxArray.push(leftdescBox);
		descBoxArray.push(rightdescBox);

		descSprite = new FlxSprite();
		descSprite.loadGraphic(Paths.image(mainIconExists(creditsStuff[curSelected + 1][1])));
		descSprite.scale.set(1, 1);
		descSprite.updateHitbox();
		descSprite.visible = false;
		add(descSprite);

		iconVideo = new FlxVideoSprite(295, 115);
		iconVideo.bitmap.onFormatSetup.add(function():Void
		{
			if (iconVideo.bitmap != null && iconVideo.bitmap.bitmapData != null)
			{
				final scale:Float = Math.min(dbwidth / iconVideo.bitmap.bitmapData.width, 420 / iconVideo.bitmap.bitmapData.height);
		
				iconVideo.setGraphicSize(iconVideo.bitmap.bitmapData.width * scale, iconVideo.bitmap.bitmapData.height * scale);
				iconVideo.updateHitbox();
			}
		});
		add(iconVideo);
		
		if (FileSystem.exists(mainIconVideoExists(creditsStuff[curSelected + 1][1]))) {
			iconVideo.load(mainIconVideoExists(creditsStuff[curSelected + 1][1]), ['input-repeat=65545']);
			iconVideo.play();
			iconVideo.visible = true;
		}
		else {
			iconVideo.visible = false;
			descSprite.visible = true;
		}

		descSpriteText = new FlxText(785, 115, dbwidth, "");
		descSpriteText.setFormat(font, 45, FlxColor.BLACK, LEFT);
		descSpriteText.updateHitbox();

		add(descSpriteText);

		backShape = new CreditsButton(180, 660, 50, 50, "BACK", FlxColor.BLACK, close);
		add(backShape);

		bg.color = CoolUtil.colorFromString(creditsStuff[curSelected][4]);
		intendedColor = bg.color;
		changeSelection();

		addVirtualPad(UP_DOWN, A_B_C);

		RectPosUpdate(false);

		super.create();
	}

	function descPosUpdate()
	{
		leftdescText.text = iconTextArray[curSelected].text;
		if (leftdescText.width > 470) leftdescText.scale.x = 470 / leftdescText.width;
		leftdescText.updateHitbox();

		leftdescText.x = 200;
		leftdescText.x += (leftdescText.width * (1 - leftdescText.scale.x) / 2);

		rightdescText.text = creditsStuff[curSelected + 1][2];
		if (rightdescText.width > 470) rightdescText.scale.x = 470 / rightdescText.width;
		rightdescText.updateHitbox();

		rightdescText.x = 720;
		rightdescText.x += (rightdescText.width * (1 - rightdescText.scale.x) / 2);
		
		if (mainIconVideoExists(creditsStuff[curSelected + 1][1]) != null) {
			descSprite.visible = false;
			iconVideo.load(mainIconVideoExists(creditsStuff[curSelected + 1][1]), ['input-repeat=65545']);
			iconVideo.play();

			iconVideo.visible = true;

			trace(mainIconVideoExists(creditsStuff[curSelected + 1][1]));
		}
		else {
			iconVideo.visible = false;
			descSprite.visible = true;
			
			descSprite.loadGraphic(Paths.image(mainIconExists(creditsStuff[curSelected + 1][1])));
			descSprite.updateHitbox();

			trace(mainIconExists(creditsStuff[curSelected + 1][1]));
		}

		descSprite.x = 265 + descBoxArray[2].width / 2 - descSprite.width / 2;
		descSprite.y = 115 + descBoxArray[2].height / 2 - descSprite.height / 2;

		descSpriteText.text = creditsStuff[curSelected + 1][3];
		descSpriteText.updateHitbox();

		Recognizelink();
	}

	function mainIconVideoExists(file):String
	{
		var filepath:String = Paths.video("credits/" + file);

		if (FileSystem.exists(filepath)) return filepath;
		else return null;
	}

	function mainIconExists(file):String
	{
		var str:String = 'credits/missing_icon';
		var fileName = 'credits/mainIcon/' + file;
		if (Paths.fileExists('images/$fileName.png', IMAGE)) str = fileName;

		return str;
	}

	var firstarray:Array<String> = [];

	function Recognizelink()
	{
		if (creditsStuff[curSelected + 1][4] != null)
		{
			firstarray = [];
			linkArray = [];

			for (i in 0...linkSpriteArray.length)
			{
				linkSpriteArray[i].destroy();
			}

			for (i in 4...creditsStuff[curSelected + 1].length - 2) {
				firstarray.push(creditsStuff[curSelected + 1][i]);
			}

			Recognize();

			for(i in 0...linkArray.length)
			{
				var link:CreditsNote = new CreditsNote(linkArray[i], firstarray[i]);
				link.x = 400 + 150 * i;
				link.y = 575;

				link.antialiasing = true;

				link.scale.set(0.7, 0.7);
				link.updateHitbox();
				add(link);
				linkSpriteArray.push(link);
			}
		}
	}

	var linkay:Array<String> = ["github", "youtube", "x", "twitter", "discord", "bilibili", "douyin", "kuaishou"];

	var unlinkArray:Array<String> = [];
	var pushBool:Bool = false;

	function Recognize()
	{
		for(i in firstarray)
		{
			unlinkArray = linkArray;
			pushBool = false;
			for (a in 0...linkay.length)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split(linkay[a] + ".com");
				if (arr.length != 1) {
					linkArray.push(linkay[a]);
					pushBool = true;
				}
			}

			if (!pushBool)
			{
				linkArray.push("Missing");
			}
		}
	}

	function RectPosUpdate(forceUpdate:Bool = false) 
	{
		if (!forceUpdate && lerpPosition == position) return; //优化
		for (i in 0...iconBGArray.length){
			RectPos(i);
		}
	}

	function RectPos(i)
	{
		iconArray[i].x = 20;
		iconArray[i].y = lerpPosition + i * 120;
		iconArray[i].y = iconArray[i].y + iconBGArray[0].height / 2 - iconBGArray[0].height / 2;

		iconBGArray[i].x = 0;
		iconBGArray[i].y = lerpPosition + i * 120 - 30;

		//iconTextArray[i].x = -150; = center
		iconTextArray[i].x = 90;
		iconTextArray[i].y = lerpPosition + i * 120 + 12;
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

				if(controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

					if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}

			position += FlxG.mouse.wheel * 70;
			if (FlxG.mouse.pressed) 
			{
				position += moveData;
				lerpPosition = position;
				RectPosUpdate(true);
			}

			for (i in 0...iconBGArray.length)
			{
				if (iconBGArray[i].color != FlxColor.GRAY) {
					iconBGArray[i].color = FlxColor.GRAY;
					iconBGArray[i].alpha = 0.7;
				}

				if (iconBGArray[curSelected].color != FlxColor.WHITE) {
					iconBGArray[curSelected].color = FlxColor.WHITE;
					iconBGArray[curSelected].alpha = 0.7;
				}

				if (CoolUtil.mouseOverlaps(iconBGArray[i], camIcons))
				{
					if (FlxG.mouse.justReleased && i != curSelected)
					{
						position += avgSpeed * (0.0166 / elapsed) * Math.pow(1.1, Math.abs(avgSpeed * 0.8));
						if (Math.abs(avgSpeed * (0.0166 / elapsed)) < 3) {
							changeSelection(i);
						}
					}
				}
			}
	
			if (position > 360 - 330) position = FlxMath.lerp(360 - 330, position, Math.exp(-elapsed * 15));
			if (position < 360 - 45 - 87 * (iconBGArray.length - 1)) position = FlxMath.lerp(360 - 45 - 87 * (iconBGArray.length - 1), position, Math.exp(-elapsed * 15));
	
			if (Math.abs(lerpPosition - position) < 1) lerpPosition = position;
			else lerpPosition = FlxMath.lerp(position, lerpPosition, Math.exp(-elapsed * 15));

			if (controls.BACK)
			{
                close();
			}
		}

		RectPosUpdate(false);

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

	var moveTween:FlxTween = null;
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		curSelected = change;

		var newColor:FlxColor = CoolUtil.colorFromString(creditsStuff[curSelected + 1][4]);
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		trace(creditsStuff[curSelected + 1]);
		

		descPosUpdate();
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}