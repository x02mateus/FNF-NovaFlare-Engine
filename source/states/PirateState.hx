package states;

import flixel.FlxSubState;

import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import openfl.Lib;


class PirateState extends MusicBeatState
{
	public static var leftState:Bool = false;

	var warnText:FlxText;
	override function create()
	{
		super.create();
		Lib.application.window.title = "NovaFlare Engine - PirateState";


		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		var guh:String = "Hey, watch out!\n
		This is pirate version\n
		Press A to download official version\n		
		You can't enter the game until then!!!";

		controls.isInSubstate = false; // qhar I hate it
		warnText = new FlxText(0, 0, FlxG.width, guh, 32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.RED, CENTER);
		warnText.screenCenter(Y);
		add(warnText);

		addVirtualPad(NONE, A);
	}

	override function update(elapsed:Float)
	{		
		if (controls.ACCEPT) CoolUtil.browserLoad('https://github.com/NFteam-android/FNF-NF-Engine-newbase');
		
		super.update(elapsed);
	}
}
