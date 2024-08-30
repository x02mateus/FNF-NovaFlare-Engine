package objects.shape;

class CreditsNote extends FlxSprite
{
    public var sprTracker:FlxSprite;
    var char:String = '';
    var link:String = '';

    public function new(char:String, link:String, ?allowGPU:Bool = true)
    {
        super();

        this.char = char;
        this.link = link;

        alpha = 0.8;

        changeIcon(char, allowGPU);
    }

	override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (CoolUtil.mouseOverlaps(this))
        {
            alpha = 1;
            if (FlxG.mouse.justReleased)
            {
                CoolUtil.browserLoad(link);
            }
        }
        else {
            alpha = 0.8;
        }
    }

    private var iconOffsets:Array<Float> = [0, 0];
	public function changeIcon(char:String, ?allowGPU:Bool = true) {
        var name:String = 'menuExtend/CreditsState/linkButton';
        
        var graphic = Paths.image(name, allowGPU);
        var delimiter:Int = 150;
        loadGraphic(graphic, true, delimiter, graphic.height);
        updateHitbox();

        animation.add(char, [for (i in 0...numFrames) i], 0, false);
        animation.play(char);
        animation.curAnim.curFrame = 0;

        if (char == "github") animation.curAnim.curFrame = 0;
        else if (char == "youtube") animation.curAnim.curFrame = 1;
        else if (char == "x" || char == "twitter") animation.curAnim.curFrame = 2;
        else if (char == "discord") animation.curAnim.curFrame = 3;
        else if (char == "bilibili" || char == "b23.tv") animation.curAnim.curFrame = 4;
        else if (char == "douyin") animation.curAnim.curFrame = 5;
        else if (char == "kuaishou") animation.curAnim.curFrame = 6;
        else animation.curAnim.curFrame = 7;
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}
}