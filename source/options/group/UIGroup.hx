package options.group;

class UIGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'Game UI',
            TITLE
        );
        follow.addOption(option);

        var reset:ResetRect = new ResetRect(450, 20, follow);
        follow.add(reset);

        ///////////////////////////////

        var option:Option = new Option(
            'Visble',
            TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Shows hud',
            'hideHud',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Combo sprite appearance',
            'showComboNum',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Rating sprite appearance',
            'showRating',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Shows opponent strums on screen',
            'opponentStrums',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            "Show your judgements",
            'judgementCounter',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            "Feedback the key you pressed",
            'keyboardDisplay',
            BOOL
        );
        follow.addOption(option);

        ///////////////////////////////

        var option:Option = new Option(
            'TimeBar',
            TEXT
        );
        follow.addOption(option);

        var TimeBarArray:Array<String> = ['Time Left', 'Time Elapsed', 'Song Name', 'Disabled'];
        var option:Option = new Option(
            'Display type',
            'timeBarType',
            STRING,
            TimeBarArray
        );
        follow.addOption(option);

        ///////////////////////////////

        var option:Option = new Option(
            'HealthBar',
            TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Alpha',
            'healthBarAlpha',
            FLOAT,
            0,
            1,
            1
        );
        follow.addOption(option);

        var option:Option = new Option(
        'Reduced version to psych 0.63h',
        'oldHealthBarVersion',
        BOOL
        );
        follow.addOption(option);

        ///////////////////////////////

        var option:Option = new Option(
            'Combo',
            TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Allow to get and use rating color',
            'comboColor',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Fix position offset',
            'comboOffsetFix',
            BOOL
        );
        follow.addOption(option);

        ///////////////////////////////

        var option:Option = new Option(
        'KeyBoard',
        TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Alpha',
            'keyboardAlpha',
            FLOAT,
            0,
            1,
            1
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Display sustain',
            'keyboardTime',
            INT,
            0,
            1000,
            0,
            'MS'
        );
        follow.addOption(option);

        var colorStingArray = ['BLACK', 'WHITE', 'GRAY', 'RED', 'GREEN', 'BLUE', 'YELLOW', 'PINK', 'ORANGE', 'PURPLE', 'BROWN', 'CYAN'];
        var option:Option = new Option(
            'BG color',
            'keyboardBGColor',
            STRING,
            colorStingArray
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Text color',
            'keyboardTextColor',
            STRING,
            colorStingArray
        );
        follow.addOption(option);

        ///////////////////////////////

        var option:Option = new Option(
        'Camera',
        TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Toggle the camera zoom in-game',
            'camZooms',
            BOOL
        );
        follow.addOption(option);

        var option:Option = new Option(
        "Score beat when you hit note",
        'scoreZoom',
        BOOL
        );
        follow.addOption(option);
    }
}