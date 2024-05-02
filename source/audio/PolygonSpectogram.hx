package audio.visualize;

import flixel.FlxG;
import Math;
import flixel.math.FlxMath;
import audio.visualize.VisShit;
import graphics.rendering.MeshRender;

class PolygonSpectogram extends MeshRender {
	public var curTime;
	public var waveAmplitude;
	public var thickness;
	public var detail;
	public var setBuffer;
	public var numSamples;
	public var realtimeStartOffset;
	public var realtimeVisLenght;
	public var daHeight;
	public var visType;
	public var vis;
	public var prevAudioData;
	public var audioData;
	public var sampleRate;

	public function setSound(daSound) {
		this.vis = new VisShit(daSound);
	}

	public function update(elapsed) {
		super.update(elapsed);
		if (this.visType._hx_index == 1) {
			this.realtimeVis();
		}
	}

	public function generateSection(start, seconds) {
		if (seconds == null) {
			seconds = 1;
		}
		if (start == null) {
			start = 0;
		}
		this.checkAndSetBuffer();
		if (this.setBuffer) {
			this.clear();
			start = Math.max(start, 0);
			var samplesToGen = this.sampleRate * seconds | 0;
			if (samplesToGen == 0) {
				return;
			}
			var startSample = FlxMath.remapToRange(start, 0, this.vis.snd._length, 0, this.numSamples) | 0;
			if (startSample < 0 || startSample >= this.numSamples) {
				return;
			}
			if (samplesToGen <= 0 || startSample + samplesToGen > this.numSamples) {
				samplesToGen = this.numSamples - startSample;
			}
			var prevPoint = new FlxBasePoint(0, 0);
			var funnyPixels = this.daHeight * this.detail | 0;
			if (this.prevAudioData == this.audioData.subarray(startSample, startSample + samplesToGen)) {
				return;
			}
			this.prevAudioData = this.audioData.subarray(startSample, samplesToGen);
			var _g = 0;
			var _g1 = funnyPixels;
			while (_g < _g1) {
				var i = _g++;
				var sampleApprox = FlxMath.remapToRange(i, 0, funnyPixels, startSample, startSample + samplesToGen) | 0;
				var curAud = VisShit.getCurAud(this.audioData, sampleApprox);
				var coolPoint = new FlxBasePoint(0, 0);
				coolPoint.set_x(curAud.balanced * this.waveAmplitude);
				coolPoint.set_y(i / funnyPixels * this.daHeight);
				this.build_quad(prevPoint.x, prevPoint.y, prevPoint.x
					+ this.thickness, prevPoint.y, coolPoint.x, coolPoint.y, coolPoint.x
					+ this.thickness, coolPoint.y
					+ this.thickness);
				prevPoint.set_x(coolPoint.x);
				prevPoint.set_y(coolPoint.y);
			}
		}
	}

	public function realtimeVis() {
		if (this.vis.snd != null) {
			if (this.curTime != this.vis.snd._time) {
				if (this.vis.snd._channel != null) {
					this.curTime = this.vis.snd._time;
				} else if (Math.abs(this.curTime - this.vis.snd._time) > 10) {
					var a = this.curTime;
					this.curTime = a + 0.5 * (this.vis.snd._time - a);
				}
				this.curTime = this.vis.snd._time;
				if (this.vis.snd._time < this.vis.snd._length - this.realtimeVisLenght) {
					this.generateSection(this.vis.snd._time + this.realtimeStartOffset, this.realtimeVisLenght);
				}
			}
		}
	}

	public function checkAndSetBuffer() {
		this.vis.checkAndSetBuffer();
		if (this.vis.setBuffer) {
			this.audioData = this.vis.audioData;
			this.sampleRate = this.vis.sampleRate;
			this.setBuffer = this.vis.setBuffer;
			this.numSamples = this.audioData.length / 2 | 0;
		}
	}

	public function new(daSound, col, height, detail) {
		if (detail == null) {
			detail = 1;
		}
		if (height == null) {
			height = 720;
		}
		if (col == null) {
			col = -1;
		}
		this.curTime = 0;
		this.waveAmplitude = 100;
		this.thickness = 2;
		this.detail = 1;
		this.setBuffer = false;
		this.numSamples = 0;
		this.realtimeStartOffset = 0;
		this.realtimeVisLenght = 0.2;
		this.daHeight = FlxG.height;
		this.visType = funkin_audio_visualize_VISTYPE.UPDATED;
		super(0, 0, col);
		if (daSound != null) {
			this.setSound(daSound);
		}
		if (height != null) {
			this.daHeight = height;
		}
		this.detail = detail;
	}
}
