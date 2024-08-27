package options;

import states.MainMenuState;
import states.FreeplayState;

class OptionsState extends MusicBeatState
{
	public static var instance:OptionsState;

	private static var position:Float = 0;
	private static var lerpPosition:Float = 0;

	var optionName:Array<String> = ['General', 'Gameplay', 'Game Backend', 'Game UI', 'Skin', 'Input', 'User Interface', 'Watermark'];
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
		}
		
		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	
	}

	var pressCheck:Bool = false;
	function backMenu() {
		if (!pressCheck){
			pressCheck = true;
			MusicBeatState.switchState(new MainMenuState());
		}
	}
}