package options.group;

class InputGroup
{
    static public function add(follow:OptionBG) {
        var option:Option = new Option(
            'Input',
            TITLE
        );
        follow.addOption(option);

        var reset:ResetRect = new ResetRect(450, 20, follow);
        follow.add(reset);

        ///////////////////////////////

        var option:Option = new Option(
            'Controls setup',
            'ControlsSubState',
            STATE,
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Touch-Main',
            TEXT
        );
        follow.addOption(option);
        
        #if desktop
        var option:Option = new Option(
            'Touch control support',
            'needMobileControl',
            BOOL
        );
        follow.addOption(option);
        #end

        var option:Option = new Option(
            'Control alpha',
            'controlsAlpha',
            FLOAT,
            0,
            1,
            1
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Touch-Game',
            TEXT
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Controls type',
            'MobileControlSelectSubState',
            STATE,
        );
        follow.addOption(option);

        var option:Option = new Option(
            'dynamicColors',
            'dynamicColors',
            BOOL
        );
        follow.addOption(option);

        var hitboxLocationArray:Array<String> = ['Bottom', 'Top'];
        var option:Option = new Option(
            'Hitbox extra key location',
            'hitboxLocation',
            STRING,
            hitboxLocationArray
        );
        follow.addOption(option);

        var option:Option = new Option(
            'Control alpha',
            'playControlsAlpha',
            FLOAT,
            0,
            1,
            1
        );
        follow.addOption(option);

        var option:Option = new Option(
            'ExtraKey for special key',
            'extraKey',
            INT,
            0,
            4
        );
        follow.addOption(option);

        var option:Option = new Option(
            'ExtraKey setup',
            'MobileExtraControl',
            STATE,
        );
        follow.addOption(option);
    }
}