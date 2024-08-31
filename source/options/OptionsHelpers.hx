package options;

import sys.FileSystem;
import sys.io.File;

class OptionsHelpers
{
    public static var languageArray = ["English": "简体中文": "繁體中文"];
    public static var qualityArray = ["Low": "Normal": "High": 'Very High'];
	public static var colorblindFilterArray = ['None': 'Protanopia': 'Protanomaly': 'Deuteranopia':'Deuteranomaly':'Tritanopia':'Tritanomaly':'Achromatopsia':'Achromatomaly'];
    public static var memoryTypeArray = ["Usage": "Reserved": "Current": "Large"];
    public static var hitsoundArray = [];
    public static var TimeBarArray = ['Time Left': 'Time Elapsed': 'Song Name': 'Disabled'];
    public static var PauseMusicArray = ['None': 'Breakfast': 'Tea Time'];
    public static var fileLoadArray = ["NovaFlare Engine": "NF Engine": "PsychEngine": "OS Engine": "TG Engine": "SB Engine"];
	public static var colorArray:Array<FlxColor> = [FlxColor.BLACK:FlxColor.WHITE:FlxColor.GRAY:FlxColor.RED:FlxColor.GREEN:FlxColor.BLUE:FlxColor.YELLOW:FlxColor.PINK:FlxColor.ORANGE:FlxColor.PURPLE:FlxColor.BROWN:FlxColor.CYAN];
	public static function colorStingArray(data:String):FlxColor
	{
	    switch(data)
	    {
		    case 'BLACK': return FlxColor.BLACK
		    case 'WHITE': return FlxColor.WHITE
		    case 'GRAY': return FlxColor.GRAY
		    case 'RED': return FlxColor.RED
		    case 'GREEN': return FlxColor.GREEN
		    case 'BLUE': return FlxColor.BLUE
		    case 'YELLOW': return FlxColor.YELLOW
		    case 'PINK': return FlxColor.PINK
		    case 'ORANGE': return FlxColor.ORANGE
		    case 'PURPLE': return FlxColor.PURPLE
		    case 'BROWN': return FlxColor.BROWN
		    case 'CYAN': return FlxColor.CYAN
	    }
	    return FlxColor.WHITE;
	}
}