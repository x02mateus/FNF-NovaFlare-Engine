package options.group;

class GameplayGroup
{
    static public function add() {
        var option:Option = new Option(
            'General',
            TEXT
        );
        follow.addOption(option);
    }
}