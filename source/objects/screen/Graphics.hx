package objects.screen;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

class Watermark extends Bitmap
{
    public function new(x:Float = 10, y:Float = 10, Alpha:Float = 0.5){

        super();
        
        var image:String = Paths.modFolders('images/menuExtend/Others/watermark.png');
        
        bitmapData = BitmapData.fromFile(image);

		this.x = x;
		this.y = y;
        this.alpha = Alpha;        
    }
} 


class FPSBG extends Bitmap
{    
    public function new(x:Float = 0, y:Float = 0, Alpha:Float = 0.5){

        super();              

		this.x = x;
		this.y = y;
		
		var bgWidth = 80;
		var bgHeight = 30;
		
		var graphics:Graphics = new Graphics();
        graphics.beginFill(FlxColor.fromRGB(124, 118, 146, 205));
        graphics.drawRoundRect(0, 0, bgWidth, bgHeight, 10, 10);     
        graphics.endFill();
        
        var BitmapData:BitmapData = new BitmapData(bgWidth, bgHeight);
        BitmapData.draw(graphics);   
        
        this.bitmapData = BitmapData;
    }
}