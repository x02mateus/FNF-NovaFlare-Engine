package options.group;

class InterfaceGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'User Interface',
            TITLE
        );
        follow.addOption(option);

        var reset:ResetRect = new ResetRect(450, 20, follow);
        follow.add(reset);

        var CustomFadeArray:Array<String> = ['Move', 'Alpha'];
        var option:Option = new Option(
            'Custom tade type',
            'CustomFade',
            STRING,
            CustomFadeArray
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Custom fade sound volume',
            'CustomFadeSound',
            FLOAT,
            0,
            1,
            1
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Custom fade text visible',
            'CustomFadeText',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Skip intro video',
            'skipTitleVideo',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Use psych freeplay',
            'freeplayOld',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Open Results Screen at end song',
            'resultsScreen',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Add a LoadingScreen for PlayState and load faster\nif have some problem please disable it',
            'loadingScreen',
            BOOL
        );
        follow.addOption(option);
    }
}