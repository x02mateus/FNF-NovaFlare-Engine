package objects.screen;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;

import openfl.utils.Assets;

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


class FPSBG extends Sprite
{    
    public function new(x:Float = 0, y:Float = 0, Alpha:Float = 0.5){

        super();              

		this.x = x;
		this.y = y;
		graphics.alpha = Alpha;
		graphics.drawRoundRect(0, 0, 80, 30, 10, 10);      	      
    }
} 