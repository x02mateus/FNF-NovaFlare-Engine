package options;

typedef Keybind = {
	keyboard:String,
	gamepad:String
}

enum OptionType {
	BOOL;
	INT;
	FLOAT;
	PERCENT;
	STRING;
	KEYBIND;
	STATE;
	TEXT;
}

class Option extends FlxSpriteGroup
{
	private var variable:String = null; //Variable from ClientPrefs.hx
	public var defaultValue:Dynamic = null;
	public var description:String = '';

	public var options:Array<String> = null;
	public var curOption:Int = 0;

	public var minValue:Float = 0;
	public var maxValue:Float = 0;

	public var defaultKeys:Keybind = null; //Only used in keybind type
	public var keys:Keybind = null; //Only used in keybind type

	public var onChange:Void->Void = null; //Pressed enter (on Bool type options) or pressed/held left/right (on other types)
	public var type:OptionType = BOOL;

	public var saveHeight:Float = 0;

	public function new(description:String = '', variable:String = '', type:OptionType = BOOL, ?minValue:Float = 0, ?maxValue:Float = 0, ?options:Array<String> = null)
	{
		super();

		this.options = options;
		this.description = description;
		this.type = type;

		if(this.type != KEYBIND && variable != '') this.defaultValue = Reflect.getProperty(ClientPrefs.defaultData, variable);

		switch(type)
		{
			case BOOL:
				if(defaultValue == null) defaultValue = false;
			case INT, FLOAT:
				if(defaultValue == null) defaultValue = 0;
			case PERCENT:
				if(defaultValue == null) defaultValue = 1;
			case STRING:
				if(options.length > 0)
					defaultValue = options[0];
				if(defaultValue == null)
					defaultValue = '';
			case KEYBIND:
				defaultValue = '';
				defaultKeys = {gamepad: 'NONE', keyboard: 'NONE'};
				keys = {gamepad: 'NONE', keyboard: 'NONE'};
			default:
		}

		if(getValue() == null)
			setValue(defaultValue);

		switch(type)
		{
			case STRING:
				var num:Int = options.indexOf(getValue());
				if(num > -1) curOption = num;
			default:
		}

		switch(type)
		{
			case BOOL:
				addBool();
			case INT, FLOAT, PERCENT:
				addData();
			case STRING:
				addString();
			case TEXT:
				addText();
			default:
		}
	}

	function addBool() {
		saveHeight = 30;

		var text = new FlxText(40, 0, 0, description, 20);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        text.y += saveHeight / 2 - text.height / 2;
        add(text);

		var rect = new BoolRect(0, 0, 1030, saveHeight, this);
		add(rect);
	}

	var valueText:FlxText;
	function addData() {
		saveHeight = 50;

		var text = new FlxText(40, 0, 0, description, 20);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        text.y += saveHeight / 2 - text.height / 2;
        add(text);

		valueText = new FlxText(40, 0, 0, defaultValue, 20);
		valueText.font = Paths.font('montserrat.ttf'); 	
        valueText.antialiasing = ClientPrefs.data.antialiasing;	
        valueText.y += saveHeight / 2 - text.height / 2;
        add(valueText);

		var rect = new FloatRect(0, 0, minValue, maxValue, this);
		add(rect);
	}

	function addString() {
		saveHeight = 50;

		var text = new FlxText(40, 0, 0, description, 20);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        text.y += saveHeight / 2 - text.height / 2;
        add(text);

		var rect = new StringRect(0, 0, this);
		add(rect);
	}

	function addText() {
		saveHeight = 40;

		var text = new FlxText(40, 0, 0, description, 30);
		text.font = Paths.font('montserrat.ttf'); 	
        text.antialiasing = ClientPrefs.data.antialiasing;	
        text.y += saveHeight / 2 - text.height / 2;
        add(text);
	}

	public function change()
	{
		if(onChange != null)
			onChange();
	}

	dynamic public function getValue():Dynamic
	{
		var value = Reflect.getProperty(ClientPrefs.data, variable);
		if(type == KEYBIND) return !Controls.instance.controllerMode ? value.keyboard : value.gamepad;
		return value;
	}

	dynamic public function setValue(value:Dynamic)
	{
		if(type == KEYBIND)
		{
			var keys = Reflect.getProperty(ClientPrefs.data, variable);
			if(!Controls.instance.controllerMode) keys.keyboard = value;
			else keys.gamepad = value;
			return value;
		}
		return Reflect.setProperty(ClientPrefs.data, variable, value);
	}
}