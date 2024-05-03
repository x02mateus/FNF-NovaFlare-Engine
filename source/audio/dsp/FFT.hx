package audio.dsp;

import audio.dsp.FFT;
import Math;
import audio.dsp.Signal;
import haxe.Log;
import Std;

class FFT {
	public function new() {
	}

	static public function fft(input) {
		return FFT.do_fft(input, false);
	}

	static public function rfft(input) {
		var f = funkin_audio_visualize_dsp_Complex.fromReal;
		var result = new Array(input.length);
		var _g = 0;
		var _g1 = input.length;
		while (_g < _g1) {
			var i = _g++;
			result[i] = f(input[i]);
		}
		var s = FFT.fft(result);
		return s.slice(0, (s.length / 2 | 0) + 1);
	}

	static public function ifft(input) {
		return FFT.do_fft(input, true);
	}

	static public function do_fft(input, inverse) {
		var n = FFT.nextPow2(input.length);
		var _g = [];
		var _g1 = 0;
		var _g2 = n;
		while (_g1 < _g2) {
			var i = _g1++;
			if (i < input.length) {
				_g.push(input[i]);
			} else {
				_g.push(funkin_audio_visualize_dsp_Complex.zero);
			}
		}
		var ts = _g;
		var _g = [];
		var _g1 = 0;
		var _g2 = n;
		while (_g1 < _g2) {
			var _ = _g1++;
			_g.push(funkin_audio_visualize_dsp_Complex.zero);
		}
		var fs = _g;
		FFT.ditfft2(ts, 0, fs, 0, n, 1, inverse);
		if (inverse) {
			var result = new Array(fs.length);
			var _g = 0;
			var _g1 = fs.length;
			while (_g < _g1) {
				var i = _g++;
				var z = fs[i];
				var k = 1 / n;
				result[i] = {
					real: z.real * k,
					imag: z.imag * k
				};
			}
			return result;
		} else {
			return fs;
		}
	}

	static public function ditfft2(time, t, freq, f, n, step, inverse) {
		if (n == 1) {
			var this1 = time[t];
			freq[f] = {
				real: this1.real,
				imag: this1.imag
			};
		} else {
			var halfLen = n / 2 | 0;
			FFT.ditfft2(time, t, freq, f, halfLen, step * 2, inverse);
			FFT.ditfft2(time, t + step, freq, f + halfLen, halfLen, step * 2, inverse);
			var _g = 0;
			var _g1 = halfLen;
			while (_g < _g1) {
				var k = _g++;
				var w = (inverse ? 1 : -1) * 2 * Math.PI * k / n;
				var twiddle_real = Math.cos(w);
				var twiddle_imag = Math.sin(w);
				var this1 = freq[f + k];
				var even_real = this1.real;
				var even_imag = this1.imag;
				var this2 = freq[f + k + halfLen];
				var odd_real = this2.real;
				var odd_imag = this2.imag;
				var rhs_real = twiddle_real * odd_real - twiddle_imag * odd_imag;
				var rhs_imag = twiddle_real * odd_imag + twiddle_imag * odd_real;
				freq[f + k] = {
					real: even_real + rhs_real,
					imag: even_imag + rhs_imag
				};
				var rhs_real1 = twiddle_real * odd_real - twiddle_imag * odd_imag;
				var rhs_imag1 = twiddle_real * odd_imag + twiddle_imag * odd_real;
				freq[f + k + halfLen] = {
					real: even_real - rhs_real1,
					imag: even_imag - rhs_imag1
				};
			}
		}
	}

	static public function dft(ts, inverse) {
		if (inverse == null) {
			inverse = false;
		}
		var n = ts.length;
		var fs = [];
		fs.length = n;
		var _g = 0;
		var _g1 = n;
		while (_g < _g1) {
			var f = _g++;
			var sum = funkin_audio_visualize_dsp_Complex.zero;
			var _g2 = 0;
			var _g3 = n;
			while (_g2 < _g3) {
				var t = _g2++;
				var this1 = ts[t];
				var w = (inverse ? 1 : -1) * 2 * Math.PI * f * t / n;
				var rhs_real = Math.cos(w);
				var rhs_imag = Math.sin(w);
				var rhs_real1 = this1.real * rhs_real - this1.imag * rhs_imag;
				var rhs_imag1 = this1.real * rhs_imag + this1.imag * rhs_real;
				sum = {
					real: sum.real + rhs_real1,
					imag: sum.imag + rhs_imag1
				};
			}
			var tmp;
			if (inverse) {
				var k = 1 / n;
				tmp = {
					real: sum.real * k,
					imag: sum.imag * k
				};
			} else {
				tmp = sum;
			}
			fs[f] = tmp;
		}
		return fs;
	}

	static public function nextPow2(x) {
		if (x < 2) {
			return 1;
		} else if ((x & x - 1) == 0) {
			return x;
		}
		var pow = 2;
		--x;
		while ((x >>= 1) != 0) pow <<= 1;
		return pow;
	}

	static public function main() {
		var Fs = 44100.0;
		var N = 512;
		var halfN = N / 2 | 0;
		var freqs = [5919.911];
		var _g = [];
		var _g1 = 0;
		var _g2 = N;
		while (_g1 < _g2) {
			var n = _g1++;
			var result = new Array(freqs.length);
			var _g3 = 0;
			var _g4 = freqs.length;
			while (_g3 < _g4) {
				var i = _g3++;
				result[i] = Math.sin(2 * Math.PI * freqs[i] * n / Fs);
			}
			_g.push(Signal.sum(result));
		}
		var ts = _g;
		var fs_pos = FFT.rfft(ts);
		var _g = [];
		var _g1 = -(halfN - 1);
		var _g2 = 0;
		while (_g1 < _g2) {
			var k = _g1++;
			var this1 = fs_pos[-k];
			_g.push({
				real: this1.real,
				imag: -this1.imag
			});
		}
		var fs_fft_array = _g.concat(fs_pos);
		var fs_fft_offset = -(halfN - 1);
		var f = funkin_audio_visualize_dsp_Complex.fromReal;
		var result = new Array(ts.length);
		var _g = 0;
		var _g1 = ts.length;
		while (_g < _g1) {
			var i = _g++;
			result[i] = f(ts[i]);
		}
		var fs_dft_array = funkin_audio_visualize_dsp_OffsetArray.circShift(FFT.dft(result), halfN - 1);
		var fs_dft_offset = -(halfN - 1);
		var _g = [];
		var _g1 = -(halfN - 1);
		var _g2 = halfN;
		while (_g1 < _g2) {
			var k = _g1++;
			var this1 = fs_fft_array[k - fs_fft_offset];
			var rhs = fs_dft_array[k - fs_dft_offset];
			_g.push({
				real: this1.real - rhs.real,
				imag: this1.imag - rhs.imag
			});
		}
		var fs_err = _g;
		var result = new Array(fs_err.length);
		var _g = 0;
		var _g1 = fs_err.length;
		while (_g < _g1) {
			var i = _g++;
			var z = fs_err[i];
			result[i] = Math.sqrt(z.real * z.real + z.imag * z.imag);
		}
		var max_fs_err = Signal.max(result);
		if (max_fs_err > 1e-6) {
			Log.trace("FT Error: " + max_fs_err, null);
		}
		var _this = fs_fft_array;
		var result = new Array(_this.length);
		var _g = 0;
		var _g1 = _this.length;
		while (_g < _g1) {
			var i = _g++;
			var z = _this[i];
			result[i] = Math.sqrt(z.real * z.real + z.imag * z.imag);
		}
		var _this = Signal.findPeaks(result);
		var result = new Array(_this.length);
		var _g = 0;
		var _g1 = _this.length;
		while (_g < _g1) {
			var i = _g++;
			result[i] = (_this[i] - (halfN - 1)) * Fs / N;
		}
		var _g = [];
		var _g1 = 0;
		var _g2 = result;
		while (_g1 < _g2.length) {
			var v = _g2[_g1];
			++_g1;
			if (v >= 0) {
				_g.push(v);
			}
		}
		var freqis = _g;
		if (freqis.length != freqs.length) {
			Log.trace("Found frequencies: " + Std.string(freqis), {
				fileName: "source/funkin/audio/visualize/dsp/FFT.hx",
				lineNumber: 145,
				className: "funkin.audio.dsp.FFT",
				methodName: "main"
			});
		} else {
			var _g = [];
			var _g1 = 0;
			var _g2 = freqs.length;
			while (_g1 < _g2) {
				var i = _g1++;
				_g.push(freqis[i] - freqs[i]);
			}
			var freqs_err = _g;
			var f = Math.abs;
			var result = new Array(freqs_err.length);
			var _g = 0;
			var _g1 = freqs_err.length;
			while (_g < _g1) {
				var i = _g++;
				result[i] = f(freqs_err[i]);
			}
			var max_freqs_err = Signal.max(result);
			if (max_freqs_err > Fs / N) {
				Log.trace("Frequency Errors: " + Std.string(freqs_err), {
					fileName: "source/funkin/audio/visualize/dsp/FFT.hx",
					lineNumber: 151,
					className: "funkin.audio.dsp.FFT",
					methodName: "main"
				});
			}
		}
		var _this = funkin_audio_visualize_dsp_OffsetArray.circShift(fs_fft_array, -(halfN - 1));
		var result = new Array(_this.length);
		var _g = 0;
		var _g1 = _this.length;
		while (_g < _g1) {
			var i = _g++;
			var z = _this[i];
			var k = 1 / Fs;
			result[i] = {
				real: z.real * k,
				imag: z.imag * k
			};
		}
		var ts_ifft = FFT.ifft(result);
		var _g = [];
		var _g1 = 0;
		var _g2 = N;
		while (_g1 < _g2) {
			var n = _g1++;
			var this1 = ts_ifft[n];
			var this_real = this1.real * Fs;
			var this_imag = this1.imag * Fs;
			_g.push(this_real - ts[n]);
		}
		var ts_err = _g;
		var f = Math.abs;
		var result = new Array(ts_err.length);
		var _g = 0;
		var _g1 = ts_err.length;
		while (_g < _g1) {
			var i = _g++;
			result[i] = f(ts_err[i]);
		}
		var max_ts_err = Signal.max(result);
		if (max_ts_err > 1e-6) {
			Log.trace("IFT Error: " + max_ts_err, null);
		}
	}
}
