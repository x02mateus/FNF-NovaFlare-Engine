package audio.dsp;

import audio.dsp.Signal;
import Math;
import Lambda;

class Signal {
	public function new() {
	}

	static public function smooth(y, n) {
		if (n <= 0) {
			return null;
		} else if (n == 1) {
			return y.slice();
		} else {
			var smoothed = [];
			smoothed.length = y.length;
			var _g = 0;
			var _g1 = y.length;
			while (_g < _g1) {
				var i = _g++;
				var m = i + 1 < n ? i : n - 1;
				smoothed[i] = Signal.sum(y.slice(i - m, i + 1));
			}
			return smoothed;
		}
	}

	static public function findPeaks(y, threshold, minHeight) {
		threshold = threshold == null ? 0.0 : Math.abs(threshold);
		if (minHeight == null) {
			minHeight = Signal.min(y);
		}
		var peaks = [];
		var _g = [];
		var _g1 = 1;
		var _g2 = y.length;
		while (_g1 < _g2) {
			var i = _g1++;
			_g.push(y[i] - y[i - 1]);
		}
		var dy = _g;
		var _g = 1;
		var _g1 = dy.length;
		while (_g < _g1) {
			var i = _g++;
			if (dy[i - 1] > threshold && dy[i] < -threshold && y[i] > minHeight) {
				peaks.push(i);
			}
		}
		return peaks;
	}

	static public function sum(array) {
		var sum = 0.0;
		var c = 0.0;
		var _g = 0;
		while (_g < array.length) {
			var v = array[_g];
			++_g;
			var t = sum + v;
			c += Math.abs(sum) >= Math.abs(v) ? sum - t + v : v - t + sum;
			sum = t;
		}
		return sum + c;
	}

	static public function mean(y) {
		return Signal.sum(y) / y.length;
	}

	static public function max(y) {
		return Lambda.fold(y, Math.max, y[0]);
	}

	static public function maxi(y) {
		return Lambda.foldi(y, function(yi, m, i) {
			if (yi > y[m]) {
				return i;
			} else {
				return m;
			}
		}, 0);
	}

	static public function min(y) {
		return Lambda.fold(y, Math.min, y[0]);
	}

	static public function mini(y) {
		return Lambda.foldi(y, function(yi, m, i) {
			if (yi < y[m]) {
				return i;
			} else {
				return m;
			}
		}, 0);
	}
}
