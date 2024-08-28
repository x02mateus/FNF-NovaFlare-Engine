package options;

import states.MainMenuState;
import states.FreeplayState;

class OptionsState extends MusicBeatState
{
	public static var instance:OptionsState;

	private static var position:Float = 0;
	private static var lerpPosition:Float = 0;
	private static var maxPos:Float = 0;

	var optionName:Array<String> = ['General', 'Gameplay', 'Backend', 'Game UI', 'Skin', 'Input', 'User Interface', 'Watermark'];
	var cataArray:Array<OptionCata> = [];
	var bgArray:Array<OptionBG> = [];
    
	override function create()
	{     
		persistentUpdate = persistentDraw = true;

		instance = this;
		
		var bg = new Rect(0,0, FlxG.width, FlxG.height, 0, 0, 0x302E3A);
		add(bg);

		var bg = new Rect(0,0, 250, FlxG.height, 0, 0, 0x24232C);
		add(bg);

		for (i in 0...optionName.length)
		{
			var option = new OptionCata(0, 80.625 * i, optionName[i]);
			add(option);
			cataArray.push(option);
		}

		var back = new BackButton(0,0, 250, 75, 'back', 0x53b7ff, backMenu);
		back.y = FlxG.height - 75;
		add(back);

		for (i in 0...cataArray.length)
		{
			var bg:OptionBG = new OptionBG(250, 0);
			add(bg);
			bgArray.push(bg);
			switch (i)
			{
				case 0:
					GeneralGroup.add(bg);
				case 1:
					GameplayGroup.add(bg);
				case 2:
					BackendGroup.add(bg);
				case 3:
					UIGroup.add(bg);
				case 4:
					SkinGroup.add(bg);
				case 5:
					InputGroup.add(bg);
				case 6:
					InterfaceGroup.add(bg);
				case 7:
					WatermarkGroup.add(bg);
			}

			if (i != 0) bg.y = bgArray[bgArray.length - 1].y + bgArray[bgArray.length - 1].saveHeight;
			maxPos += bg.saveHeight;
		}
		
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		mouseMove();

		if (FlxG.mouse.x >= 250 && FlxG.mouse.x <= FlxG.width)
		{
			position -= FlxG.mouse.wheel * 70;
			if (FlxG.mouse.pressed) 
			{
				position -= moveData;
				lerpPosition = position;
			}
			if (FlxG.mouse.justReleased)
			{
				position -= avgSpeed * 1.5 * (0.0166 / elapsed) * Math.pow(1.1, Math.abs(avgSpeed * 0.8));
				if (Math.abs(avgSpeed * (0.0166 / elapsed)) < 3) {
			
				}
			}
		}

		if (position > maxPos) position = maxPos;
		if (position < 0) position = 0;
		if (lerpPosition > maxPos) lerpPosition = maxPos;
		if (lerpPosition < 0) lerpPosition = 0;

		if (Math.abs(lerpPosition - position) < 0.1) lerpPosition = position;
		else lerpPosition = FlxMath.lerp(position, lerpPosition, Math.exp(-elapsed * 15));

		for (num in 0...bgArray.length)
		{
			if (num == 0) bgArray[num].y = -lerpPosition;
			else bgArray[num].y = bgArray[num - 1].y + bgArray[num - 1].saveHeight;
		}
	}

	var saveMouseY:Int = 0;
	var moveData:Int = 0;
	var avgSpeed:Float = 0;
	function mouseMove()
	{
		if (FlxG.mouse.justPressed) saveMouseY = FlxG.mouse.y;
		moveData = FlxG.mouse.y - saveMouseY;
		saveMouseY = FlxG.mouse.y;
		avgSpeed = avgSpeed * 0.75 + moveData * 0.25;
	}

	var pressCheck:Bool = false;
	function backMenu() {
		if (!pressCheck){
			pressCheck = true;
			MusicBeatState.switchState(new MainMenuState());
		}
	}
}