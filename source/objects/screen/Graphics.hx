package objects.screen;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Shape;

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
    public function new(width:Float = 140, height:Float = 50, Alpha:Float = 0.3, color:FlxColor = FlxColor.fromRGB(124, 118, 146, 255)){

        super();             				
		
		var shape:Shape = new Shape();
        shape.graphics.beginFill();
        shape.graphics.drawRoundRect(0, 0, width, height, 10, 10);     
        shape.graphics.endFill();
        
        var BitmapData:BitmapData = new BitmapData(width, height, 0x00FFFFFF);
        BitmapData.draw(shape);   
                
        this.bitmapData = BitmapData;
        this.alpha = Alpha;
    }  //说真的，haxe怎么写个贴图在flxgame层这么麻烦
}