package shaders;

import flixel.system.FlxAssets.FlxShader;

class Gaussian_blur extends FlxShader
{
	@:glFragmentSource('
		#pragma header
        precision lowp float;
        
        #define SIZE 0.5;
        
        #define pi 6.28318530718
        
        #define Quality_Angle 0.5
        #define Quality_Depth 0.5
        
        #define uv openfl_TextureCoordv
        
        
        float d;
        float i;
        
        vec2 SR;
        
        vec2 CosSin;
        vec4 accColor;
        
        float DIRECTIONS;
        float QUALITY;
        
        float stepQ;
        float dimDir;
        float PD;
        
        float roundf(float n) {return floor(n+.5);}
        
        void main(void) {
        DIRECTIONS=roundf(SIZE*(pi/2.)*Quality_Angle);
        QUALITY=roundf(SIZE*Quality_Depth);
        
        stepQ=1./QUALITY;
        dimDir=QUALITY*DIRECTIONS/2.;
        PD=pi/DIRECTIONS;
        
        SR=SIZE/openfl_TextureSize;
        
        accColor=vec4(0.);
        
        for (d=0.;d<pi;d+=PD) {
            CosSin=vec2(cos(d)*SR.x,sin(d)*SR.y);
            for (i=stepQ;i<=1.;i+=stepQ) {
                accColor+=texture2D(bitmap,uv+CosSin*i)*(1.-i);
            }
        }
        gl_FragColor=accColor/dimDir;
        }'
        )
	public function new()
	{
		super();
	}
}