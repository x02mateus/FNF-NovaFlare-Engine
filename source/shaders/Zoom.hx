package shaders;

import flixel.system.FlxAssets.FlxShader;

class Zoom extends FlxShader
{
	@:glFragmentSource('
		#pragma header

        #define uv openfl_TextureCoordv
        
        #define SIZE 5
        
        void main()
        {
        gl_FragColor=texture2D(bitmap,uv/SIZE);
        }
        ')
	public function new()
	{
		super();
	}
}