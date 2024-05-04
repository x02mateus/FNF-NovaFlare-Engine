package audio.flash.apps;

import flash.Lib;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import audio.fft.FFTFilter;
import audio.flash.widgets.Plotter;
import lime.media.AudioBuffer;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.media.Sound;
@:access(openfl.media.Sound.__buffer)

class SpectrumViewer extends Sprite {
    // Data
    var statusMessage: String = ""; // Message (useful for debugging and other things)
    
    // UI & child elements
    var plotter: Plotter;
    var statusText: TextField;
    var musicBuffer: AudioBuffer;
    var fftFilter: FFTFilter;
    
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
        
        // Load music file
        var music:FlxSound = FlxG.sound.music;               
        fftFilter = new FFTFilter(music._sound.__buffer, SAMPLE_RATE*1000);
        
        // Start polling
        var timer = new Timer(UPDATE_PERIOD);
        timer.addEventListener(TimerEvent.TIMER, update);
        timer.start();
    }
    
    public function update(event) {
        if (FlxG.sound.music == null || !FlxG.sound.music.playing) return;      
        fftFilter.update();        
        plotter.plot(fftFilter.freqs, fftFilter.mag);               
    }
    
}