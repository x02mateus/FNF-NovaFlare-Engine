package mobile.backend;
import haxe.ds.StringMap;
import mobile.flixel.FlxVirtualPad.FlxDPadMode;
import mobile.flixel.FlxVirtualPad.FlxActionMode;

class Data {
    public static var dpadMode:StringMap<FlxDPadMode> = new StringMap<FlxDPadMode>();
    public static var actionMode:StringMap<FlxActionMode> = new StringMap<FlxActionMode>();

    public static function setup() {
        for(data in FlxDPadMode.createAll()){
            dpadMode.set(data.getName(), data);
        }
        for(data in FlxActionMode.createAll()){
            actionMode.set(data.getName(), data);
        }
    }
}