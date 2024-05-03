package audio;

import backend.Paths;
import Lambda;
import Math;
import flixel.group.FlxTypedSpriteGroup;

class ABotVis extends FlxTypedSpriteGroup {
	public var visTimeMax;
	public var visTimer;
	public var volumes;
	public var snd;
	public var analyzer;

	public function initAnalyzer() {
		this.analyzer = new SpectralAnalyzer(7, new LimeAudioClip(this.snd._channel.__source), 0.01, 30);
		this.analyzer.set_maxDb(-35);
	}

	public function update(elapsed) {
		super.update(elapsed);
	}

	public function draw() {
		if (this.analyzer != null) {
			this.drawFFT();
		}
		super.draw();
	}

	public function drawFFT() {
		var levels = this.analyzer.getLevels(false);
		var _g = 0;
		var x = this.group.members.length;
		var y = levels.length;
		var _g1 = x > y ? y : x;
		while (_g < _g1) {
			var i = _g++;
			var animFrame = Math.round(levels[i].value * 5);
			animFrame = Math.floor(Math.min(5, animFrame));
			animFrame = Math.floor(Math.max(0, animFrame));
			animFrame = Math.abs(animFrame - 5) | 0;
			this.group.members[i].animation._curAnim.set_curFrame(animFrame);
		}
	}

	public function new(snd) {
		this.visTimeMax = 0.033333333333333333;
		this.visTimer = -1;
		this.volumes = [];
		super();
		this.snd = snd;
		var visFrms = Paths.getSparrowAtlas("aBotViz");
		var positionX = [0, 59, 56, 66, 54, 52, 51];
		var positionY = [0, -8, -3.5, -0.4, 0.5, 4.7, 7];
		var _g = 1;
		while (_g < 8) {
			var lol = _g++;
			this.volumes.push(0.0);
			var sum = function(num, total) {
				total += num;
				return total;
			};
			var posX = Lambda.fold(positionX.slice(0, lol), sum, 0);
			var posY = Lambda.fold(positionY.slice(0, lol), sum, 0);
			var viz = new FlxSprite(posX, posY);
			viz.set_frames(visFrms);
			this.add(viz);
			var visStr = "viz";
			viz.animation.addByPrefix("VIZ", visStr + lol, 0);
			viz.animation.play("VIZ", false, false, 6);
		}
	}

	static public function min(x, y) {
		if (x > y) {
			return y;
		} else {
			return x;
		}
	}
}
