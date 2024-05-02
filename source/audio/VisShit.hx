package audio.visualize;

import Math;
import flixel.math.FlxMath;
import audio.visualize.dsp.FFT;
import flixel.FlxG;
import haxe.Log;

class VisShit {
	public var numSamples;
	public var sampleRate;
	public var setBuffer;
	public var snd;
	public var audioData;

	public function new(snd) {
		this.numSamples = 0;
		this.sampleRate = 44100;
		this.setBuffer = false;
		this.snd = snd;
	}

	static public function getCurAud(aud, index) {
		var left = aud[index] / 32767;
		var right = aud[index + 2] / 32767;
		var balanced = (left + right) / 2;
		var funny = {
			left: left,
			right: right,
			balanced: balanced
		};
		return funny;
	}
}
