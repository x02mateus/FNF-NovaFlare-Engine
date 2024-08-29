package options.group;

import shaders.ColorblindFilter;

class GeneralGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'General',
            TITLE
        );
        follow.addOption(option);
       

        var reset:ResetRect = new ResetRect(450, 20, follow);
        follow.add(reset);

        var option:Option = new Option(
            'Change your FPS cap',
            'framerate',
            INT,
            24,
            500,
            'FPS'
        );
        follow.addOption(option);
        option.onChange = onChangeFramerate;

        var colorblindFilterArray:Array<String> = ['None', 'Protanopia', 'Protanomaly', 'Deuteranopia','Deuteranomaly','Tritanopia','Tritanomaly','Achromatopsia','Achromatomaly'];
        var option:Option = new Option(
            'Colorblind filter more playable for colorblind people',
            'colorblindMode',
            STRING,
            colorblindFilterArray
        );
        follow.addOption(option);
        option.onChange = onChangeFilter;

        var option:Option = new Option(
            'Turn off some object on stages',
            'lowQuality',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Change game quality for screen',
            'gameQuality',
            INT,
            0,
            3
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Toggle antialiasing, improving graphics quality at a slight performance penalty',
            'antialiasing',
            BOOL
        );
        follow.addOption(option);
        
        var option:Option = new Option(
            'Toggle flashing lights that can cause epileptic seizures and strain',
            'flashing',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Shaders used for some visual effects',
            'shaders',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Allows the GPU to be used for caching textures, decreasing RAM usage',
            'cacheOnGPU',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Stops game, when its unfocused',
            'autoPause',
            BOOL
        );
        follow.addOption(option);
        option.onChange = onChangePause;
    }

    static function onChangeFramerate()
    {
        if(ClientPrefs.data.framerate > FlxG.drawFramerate)
        {
            FlxG.updateFramerate = ClientPrefs.data.framerate;
            FlxG.drawFramerate = ClientPrefs.data.framerate;
        }
        else
        {
            FlxG.drawFramerate = ClientPrefs.data.framerate;
            FlxG.updateFramerate = ClientPrefs.data.framerate;
        }
    }

    static function onChangeFilter()
    {
        ColorblindFilter.UpdateColors();
    }
    

    static function onChangePause()
    {
        FlxG.autoPause = ClientPrefs.data.autoPause;
    }
}


    