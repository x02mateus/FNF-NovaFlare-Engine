package objects.shape;

import objects.shape.ShapeEX;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import flash.geom.Point;
import flash.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Shape;
import flixel.util.FlxSpriteUtil;

class ModsButtonRect extends FlxSpriteGroup //play/back button
{
    var background:Rect;
    var text:FlxText;
    var box:FlxSprite;

    var saveColor:FlxColor;

    public var list:Array<Array<String>> = [];
    public var onClick:Void->Void = null;
    public var folder:String = 'unknownMod';

	public function new(X:Float, Y:Float, width:Float = 0, height:Float = 0, roundWidth:Float = 0, roundHeight:Float = 0, texts:String = '', textOffset:Float = 0, color:FlxColor = FlxColor.WHITE, onClick:Void->Void = null)
    {
        super(X, Y);

        box = new FlxSprite();

        this.folder = texts;

        var bmp = Paths.cacheBitmap(Paths.mods('$folder/pack.png'));
		if(bmp == null)
		{
			bmp = Paths.cacheBitmap(Paths.mods('$folder/pack-pixel.png'));
			//isPixel = true;
		}

        if(bmp != null)
        {
            box.loadGraphic(bmp, true, 150, 150);
        }

        else box.loadGraphic(Paths.image('unknownMod'), true, 150, 150);
        box.scale.set(0.5, 0.5);
        box.updateHitbox();
		
        text = new FlxText(0, 0, 0, texts, 22);
        text.color = FlxColor.WHITE;
        text.font = Paths.font('montserrat.ttf');
        text.antialiasing = ClientPrefs.data.antialiasing;

        background = new Rect(0, 0, width, height, roundWidth, roundHeight, color);
        background.color = color;
        background.alpha = 0.6;
        background.antialiasing = ClientPrefs.data.antialiasing;
        add(background);
        add(text);
        add(box);

        text.x += background.width / 2 - text.width / 2;
        text.y += background.height / 2 - text.height / 2;

        box.x += background.width / 32 - box.width / 32;
        box.y += (background.height / 2 - box.height / 2) - 1;

        box.updateHitbox();
        text.updateHitbox();

        this.onClick = onClick;
        this.saveColor = color;
	}

    public var focusChangeCallback:Bool->Void = null;
	public var onFocus:Bool = false;
	public var ignoreCheck:Bool = false;
	var needFocusCheck:Bool = false;
    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if(!ignoreCheck && !Controls.instance.controllerMode)
            onFocus = FlxG.mouse.overlaps(this);

        if(onFocus && onClick != null && FlxG.mouse.justReleased)
            //click();

        if (onFocus)
        {
            background.alpha = 1;
            needFocusCheck = true;
        } else {
            if (needFocusCheck)
            {
                background.alpha = 0.6;
                needFocusCheck = false;
            }
        }
    }
}