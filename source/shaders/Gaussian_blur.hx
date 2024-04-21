package shaders;

import flixel.system.FlxAssets.FlxShader;

class Gaussian_blur extends FlxShader
{
	@:glFragmentSource('
		#pragma header
        // 16x acceleration of https://www.shadertoy.com/view/4tSyzy
        // by applying gaussian at intermediate MIPmap level.
        
        #define texture texture2D
        #define iR openfl_TextureSize
        
        #define quality 1
        
        #define SIZE 5
       
        int samples=2;
        
        int LOD;
        int sLOD;
        float sigma;
        
        float gaussian(vec2 i)
        {
        	return exp(-.5*dot(i/=sigma,i))/(6.28318530718*sigma*sigma);
        }
        
        vec4 blur(sampler2D sp,vec2 U,vec2 scale)
        {
        	vec4 O=vec4(0.);
        	vec2 d;
        	int s=samples/sLOD;
        
        	for (int i=0;i<s*s;i++)
        	{
        		d=vec2(i-s*(i/s),i/s)*float(sLOD)-float(samples)/2.;
        		O+=gaussian(d)*texture(sp,U+scale*d,float(LOD));
        	}
        
        	return O/O.a;
        }
        
        void main()
        {
        vec2 uv=openfl_TextureCoordv*SIZE;
        if(uv.x<0. || uv.x>1. || uv.y<0. || uv.y>1.)
        {
        gl_FragColor = vec4(0.);
        } else {
        	LOD=samples;
        	sLOD=samples/(samples/quality);
        	if (sLOD<1)
        		sLOD=1;
        
        	sigma=float(samples)*.25;
        	gl_FragColor=blur(bitmap,uv,1./iR);
        }
        }
        ')
	public function new()
	{
		super();
	}
}