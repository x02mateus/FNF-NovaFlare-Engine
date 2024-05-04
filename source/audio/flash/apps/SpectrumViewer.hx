package audio.flash.apps;

import flash.Lib;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import audio.fft.FFTFilter;
import audio.flash.widgets.Plotter;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.media.Sound;
@:access(openfl.media.Sound.__buffer)

class MusicAnalyzer extends Sprite {
    // Data
    var statusMessage: String = ""; // Message (useful for debugging and other things)
    
    // UI & child elements
    var plotter: Plotter;
    var statusText: TextField;
    var musicBuffer: MusicBuffer;
    var fftFilter: FFTFilter;
    var stopwatch: Stopwatch;
    
    // Config
    static inline var LOG_N = 11; // Log2 (FFT length);
    static inline var UPDATE_PERIOD = 50;
    static inline var SAMPLE_RATE = 5; // in K's.
    
    public function new() {
        super();
        plotter = new Plotter(500, 300);
        plotter.xaxis("Frequency (Hz)", 0, SAMPLE_RATE*1000/2, 500, "%0.0f");
        plotter.yaxis("dB", -60, 0, 10, "%0.0f");
        addChild(plotter);
        
        statusText = new TextField();
        statusText.x = 20;
        statusText.y = 400;
        statusText.text = "";
        statusText.autoSize = TextFieldAutoSize.LEFT;
        addChild(statusText);
        
        // Load music file
        var music:FlxSound = FlxG.sound.music;               
        fftFilter = new FFTFilter(music._sound.__buffer, SAMPLE_RATE*1000);
        stopwatch = new Stopwatch();
        
        // Start polling
        var timer = new Timer(UPDATE_PERIOD);
        timer.addEventListener(TimerEvent.TIMER, update);
        timer.start();
    }
    
    public function update(event) {
        stopwatch.tic();
        fftFilter.update();
        stopwatch.toc();
        
        plotter.plot(fftFilter.freqs, fftFilter.mag);
        if (stopwatch.averageTime >= 0)
            statusText.text = 'Average time per FFT:' + Std.string(stopwatch.averageTime*1000) + 'ms';
    }
    
    public static function main() {
        Lib.current.addChild(new MusicAnalyzer());
    }    
}