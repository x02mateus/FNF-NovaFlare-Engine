package audio.visualize;

import flixel.FlxG;
import flixel.math.FlxMath;
import audio.visualize.VisShit;
import flixel.math.FlxBasePoint;
import Math;
import backend.Conductor;
import flixel.group.FlxTypedSpriteGroup;

enum VISTYPE {
	STATIC;
	UPDATED;
	FREQUENCIES;
}

class SpectogramSprite extends FlxTypedSpriteGroup {
	public var curTime = 0;
	public var frameCounter = 0;
	public var doAnim = false;
	public var wavOptimiz = 10;
	public var numSamples = 0;
	public var setBuffer = false;
	public var daHeight = FlxG.height;
	public var col = -1;
	public var visType:VISTYPE = UPDATED;
	public var lengthOfShit = 500;
	public var vis;
	public var audioData;
	public var sampleRate;

	public function regenLineShit() {
		for(i in 0...lengthOfShit) {
			var lineShit = new FlxSprite(100, i / lengthOfShit * daHeight).makeGraphic(1, 1, col);
			lineShit.active = false;
			lineShit.ID = i;
			add(lineShit);
		}
	}

	public function update(elapsed) {
		switch (visType) {
			case STATIC:
			case UPDATED: updateVisulizer();
			case FREQUENCIES: updateFFT();
		}
		group.forEach(function(spr) {
			spr.visible = spr.ID % wavOptimiz == 0;
		}, false);
		super.update(elapsed);
	}

	public function generateSection(start=0, seconds=1) {
		this.checkAndSetBuffer();
		if (this.setBuffer) {
			var samplesToGen = Std.int(this.sampleRate * seconds);
			var startingSample = Std.int(FlxMath.remapToRange(start, 0, this.vis.snd._length, 0, this.numSamples));
			var prevLine = new FlxPoint(0, 0);
			for(i in 0...group.members.length) {
				var member = group.members[i];
				var sampleApprox:Int = Std.int(FlxMath.remapToRange(i, 0, group.members.length, startingSample, startingSample + samplesToGen));
				var curAud = VisShit.getCurAud(audioData, sampleApprox);
				var swagheight = 200;
				member.setPosition(prevLine.x, prevLine.y);
				prevLine.x = curAud.balanced * swagheight / 2 + swagheight / 2 + x;
				prevLine.y = i / group.members.length * daHeight + y;
				var line = FlxPoint.get(
					prevLine.x - member.x,
					prevLine.y - member.y
				);
				member.setGraphicSize(Math.max(line.length, 1) | 0, 1);
				member.angle = line.degrees;
			}
			wavOptimiz = 1;
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

	public function updateFFT() {
		if (this.vis.snd != null) {
			var remappedShit = 0;
			this.checkAndSetBuffer();
			if (!this.doAnim) {
				this.frameCounter++;
				if (this.frameCounter >= 0) {
					this.frameCounter = 0;
					this.doAnim = true;
				}
			}
			if (this.setBuffer && this.doAnim) {
				this.doAnim = false;
				if (this.vis.snd._channel != null) {
					remappedShit = FlxMath.remapToRange(this.vis.snd._time, 0, this.vis.snd._length, 0, this.numSamples) | 0;
				} else {
					remappedShit = FlxMath.remapToRange(Conductor.instance.songPosition, 0, this.vis.snd._length, 0, this.numSamples) | 0;
				}
				var fftSamples = [];
				var i = remappedShit;
				var _g = remappedShit;
				var _g1 = remappedShit + 306;
				while (_g < _g1) {
					var sample = _g++;
					var curAud = VisShit.getCurAud(this.audioData, i);
					i += 2;
					fftSamples.push(curAud.balanced);
				}
				var freqShit = this.vis.funnyFFT(fftSamples);
				var prevLine = new FlxBasePoint(0, 0);
				var swagheight = 200;
				var _g = 0;
				var _g1 = this.group.members.length;
				while (_g < _g1) {
					var i = _g++;
					var powedShit = FlxMath.remapToRange(i, 0, this.group.members.length, 0, 4);
					var hzPicker = Math.pow(10, powedShit);
					var remappedFreq = FlxMath.remapToRange(hzPicker, 0, 10000, 0, freqShit[0].length - 1) | 0;
					this.group.members[i].set_x(prevLine.x);
					this.group.members[i].set_y(prevLine.y);
					var freqPower = 0;
					var _g2 = 0;
					var _g3 = freqShit.length;
					while (_g2 < _g3) {
						var pow = _g2++;
						freqPower += freqShit[pow][remappedFreq];
					}
					freqPower /= freqShit.length;
					var freqIDK = FlxMath.remapToRange(freqPower, 0, 0.000005, 0, 50);
					prevLine.set_x(freqIDK * swagheight / 2 + swagheight / 2 + this.x);
					prevLine.set_y(i / this.group.members.length * this.daHeight + this.y);
					var x = prevLine.x - this.group.members[i].x;
					var y = prevLine.y - this.group.members[i].y;

					var line = FlxPoint.get(x, y);
					// DESKTOP ONLY CODE
				}
			}
		}
	}

	public function updateVisulizer() {
		if (this.vis.snd != null) {
			var remappedShit = 0;
			this.checkAndSetBuffer();
			if (this.setBuffer) {
				if (this.vis.snd._channel != null) {
					remappedShit = FlxMath.remapToRange(this.vis.snd._time, 0, this.vis.snd._length, 0, this.numSamples) | 0;
				} else {
					if (this.curTime == Conductor.instance.songPosition) {
						this.wavOptimiz = 3;
						return;
					}
					this.curTime = Conductor.instance.songPosition;
					remappedShit = FlxMath.remapToRange(Conductor.instance.songPosition, 0, this.vis.snd._length, 0, this.numSamples) | 0;
				}
				this.wavOptimiz = 8;
				var i = remappedShit;
				var prevLine = new FlxBasePoint(0, 0);
				var swagheight = 200;
				var _g = remappedShit;
				var _g1 = remappedShit + this.lengthOfShit;
				while (_g < _g1) {
					var sample = _g++;
					var curAud = VisShit.getCurAud(this.audioData, i);
					i += 2;
					var remappedSample = FlxMath.remapToRange(sample, remappedShit, remappedShit + this.lengthOfShit, 0, this.lengthOfShit - 1);
					this.group.members[remappedSample | 0].set_x(prevLine.x);
					this.group.members[remappedSample | 0].set_y(prevLine.y);
					prevLine.set_x(curAud.balanced * swagheight / 2 + swagheight / 2 + this.x);
					prevLine.set_y((remappedSample | 0) / this.lengthOfShit * this.daHeight + this.y);
					var x = prevLine.x - this.group.members[remappedSample | 0].x;
					var y = prevLine.y - this.group.members[remappedSample | 0].y;
					var point = FlxBasePoint.pool.get().set(x, y);
					point._inPool = false;
					var line = point;
					this.group.members[remappedSample | 0].setGraphicSize(Math.max(Math.sqrt(line.x * line.x + line.y * line.y), 1) | 0, 1);
					this.group.members[remappedSample | 0].set_angle(flixel_math_FlxPoint.get_radians(line) * (180 / Math.PI));
				}
			}
		}
	}

	public function new(daSound, col, height, amnt) {
		if (amnt == null) {
			amnt = 500;
		}
		if (height == null) {
			height = 720;
		}
		if (col == null) {
			col = -1;
		}
		
		super();
		this.vis = new VisShit(daSound);
		this.col = col;
		this.daHeight = height;
		this.lengthOfShit = amnt;
		this.regenLineShit();
	}
}
