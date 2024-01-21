package mobile.flixel;

import flixel.graphics.frames.FlxTileFrames;
import mobile.flixel.input.FlxMobileInputManager;
import mobile.flixel.FlxButton;
import flixel.math.FlxPoint;

/**
 * A gamepad.
 * It's easy to customize the layout.
 *
 * @original author Ka Wing Chin & Mihai Alexandru
 * @modification's author: Karim Akra & Lily (mcagabe19)
 */
class FlxVirtualPad extends FlxMobileInputManager
{
	public var buttonLeft:FlxButton = new FlxButton(0, 0);
	public var buttonUp:FlxButton = new FlxButton(0, 0);
	public var buttonRight:FlxButton = new FlxButton(0, 0);
	public var buttonDown:FlxButton = new FlxButton(0, 0);
	public var buttonLeft2:FlxButton = new FlxButton(0, 0);
	public var buttonUp2:FlxButton = new FlxButton(0, 0);
	public var buttonRight2:FlxButton = new FlxButton(0, 0);
	public var buttonDown2:FlxButton = new FlxButton(0, 0);
	public var buttonA:FlxButton = new FlxButton(0, 0);
	public var buttonB:FlxButton = new FlxButton(0, 0);
	public var buttonC:FlxButton = new FlxButton(0, 0);
	public var buttonD:FlxButton = new FlxButton(0, 0);
	public var buttonE:FlxButton = new FlxButton(0, 0);
    public var buttonF:FlxButton = new FlxButton(0, 0);
    public var buttonG:FlxButton = new FlxButton(0, 0);
    public var buttonS:FlxButton = new FlxButton(0, 0);
	public var buttonV:FlxButton = new FlxButton(0, 0);
	public var buttonX:FlxButton = new FlxButton(0, 0);
	public var buttonY:FlxButton = new FlxButton(0, 0);
	public var buttonZ:FlxButton = new FlxButton(0, 0);
	public var buttonP:FlxButton = new FlxButton(0, 0);

	/**
	 * Create a gamepad.
	 *
	 * @param   DPadMode     The D-Pad mode. `LEFT_FULL` for example.
	 * @param   ActionMode   The action buttons mode. `A_B_C` for example.
	 */
	public function new(DPad:FlxDPadMode, Action:FlxActionMode)
	{
		super();

		var buttonLeftColor:Array<FlxColor>;
		var buttonDownColor:Array<FlxColor>;
		var buttonUpColor:Array<FlxColor>;
		var buttonRightColor:Array<FlxColor>;

		buttonLeftColor = ClientPrefs.defaultData.arrowRGB[0];
		buttonDownColor = ClientPrefs.defaultData.arrowRGB[1];
		buttonUpColor = ClientPrefs.defaultData.arrowRGB[2];
		buttonRightColor = ClientPrefs.defaultData.arrowRGB[3];

		scrollFactor.set();

		switch (DPad)
		{
			case UP_DOWN:
				add(buttonUp = createButton(0, FlxG.height - 255, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP, FlxMobileInputID.noteUP]));
				add(buttonDown = createButton(0, FlxG.height - 135, 132, 127, 'down', buttonDownColor[0], [FlxMobileInputID.DOWN, FlxMobileInputID.noteDOWN]));
			case LEFT_RIGHT:
				add(buttonLeft = createButton(0, FlxG.height - 135, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT, FlxMobileInputID.noteLEFT]));
				add(buttonRight = createButton(127, FlxG.height - 135, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT, FlxMobileInputID.noteRIGHT]));
			case UP_LEFT_RIGHT:
				add(buttonUp = createButton(105, FlxG.height - 243, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP, FlxMobileInputID.noteUP]));
				add(buttonLeft = createButton(0, FlxG.height - 135, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT, FlxMobileInputID.noteLEFT]));
				add(buttonRight = createButton(207, FlxG.height - 135, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT, FlxMobileInputID.noteRIGHT]));
			case LEFT_FULL:
				add(buttonUp = createButton(105, FlxG.height - 345, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP, FlxMobileInputID.noteUP]));
				add(buttonLeft = createButton(0, FlxG.height - 243, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT, FlxMobileInputID.noteLEFT]));
				add(buttonRight = createButton(207, FlxG.height - 243, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT, FlxMobileInputID.noteRIGHT]));
				add(buttonDown = createButton(105, FlxG.height - 135, 132, 127, 'down', buttonDownColor[0], [FlxMobileInputID.DOWN, FlxMobileInputID.noteDOWN]));
			case RIGHT_FULL:
				add(buttonUp = createButton(FlxG.width - 258, FlxG.height - 408, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP, FlxMobileInputID.noteUP]));
				add(buttonLeft = createButton(FlxG.width - 384, FlxG.height - 309, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT, FlxMobileInputID.noteLEFT]));
				add(buttonRight = createButton(FlxG.width - 132, FlxG.height - 309, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT, FlxMobileInputID.noteRIGHT]));
				add(buttonDown = createButton(FlxG.width - 258, FlxG.height - 201, 132, 127, 'down', buttonDownColor[0], [FlxMobileInputID.DOWN, FlxMobileInputID.noteDOWN]));
			case BOTH:
				add(buttonUp = createButton(105, FlxG.height - 345, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP, FlxMobileInputID.noteUP]));
				add(buttonLeft = createButton(0, FlxG.height - 243, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT, FlxMobileInputID.noteLEFT]));
				add(buttonRight = createButton(207, FlxG.height - 243, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT, FlxMobileInputID.noteRIGHT]));
				add(buttonDown = createButton(105, FlxG.height - 135, 132, 127, 'down', buttonDownColor[0], [FlxMobileInputID.DOWN, FlxMobileInputID.noteDOWN]));
				add(buttonUp2 = createButton(FlxG.width - 258, FlxG.height - 408, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP2, FlxMobileInputID.noteUP]));
				add(buttonLeft2 = createButton(FlxG.width - 384, FlxG.height - 309, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT2, FlxMobileInputID.noteLEFT]));
				add(buttonRight2 = createButton(FlxG.width - 132, FlxG.height - 309, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT2, FlxMobileInputID.noteRIGHT]));
				add(buttonDown2 = createButton(FlxG.width - 258, FlxG.height - 201, 132, 127, 'down', buttonDownColor[0], [FlxMobileInputID.DOWN2, FlxMobileInputID.noteDOWN]));
			// PSYCH RELEATED BUTTONS
			case DIALOGUE_PORTRAIT:
				add(buttonUp = createButton(105, FlxG.height - 345, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP]));
				add(buttonLeft = createButton(0, FlxG.height - 243, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT]));
				add(buttonRight = createButton(207, FlxG.height - 243, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT]));
				add(buttonDown = createButton(105, FlxG.height - 135, 132, 127, 'down', buttonDownColor[0], [FlxMobileInputID.DOWN]));
				add(buttonUp2 = createButton(105, 0, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP2]));
				add(buttonLeft2 = createButton(0, 82, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT2]));
				add(buttonRight2 = createButton(207, 82, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT2]));
				add(buttonDown2 = createButton(105, 190, 132, 127, 'down', buttonDownColor[0], [FlxMobileInputID.LEFT2]));
			case MENU_CHARACTER:
				add(buttonUp = createButton(105, 0, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP]));
				add(buttonLeft = createButton(0, 82, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT]));
				add(buttonRight = createButton(207, 82, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT]));
				add(buttonDown = createButton(105, 190, 132, 127, 'down', buttonDownColor[0], [FlxMobileInputID.DOWN]));
			case NOTE_SPLASH_DEBUG:
				add(buttonUp = createButton(0, 125, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP]));
				add(buttonLeft = createButton(0, 0, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT]));
				add(buttonRight = createButton(127, 0, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT]));
				add(buttonDown = createButton(127, 125, 132, 127, 'down', buttonDownColor[0], [FlxMobileInputID.DOWN]));
				add(buttonUp2 = createButton(127, 393, 132, 127, 'up', buttonUpColor[0], [FlxMobileInputID.UP2]));
				add(buttonLeft2 = createButton(0, 393, 132, 127, 'left', buttonLeftColor[0], [FlxMobileInputID.LEFT2]));
				add(buttonRight2 = createButton(1145, 393, 132, 127, 'right', buttonRightColor[0], [FlxMobileInputID.RIGHT2]));
				add(buttonDown2 = createButton(1015, 393, 132, 127, 'down', buttonDownColor[0], [FlxMobileInputID.DOWN2]));
			case NONE: // do nothing
		}

		switch (Action)
		{
			case A:
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			case B:
				add(buttonB = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
			case B_X:
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonX = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'x', 0x99062D, [FlxMobileInputID.X]));
			case A_B:
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			case A_B_C:
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00, [FlxMobileInputID.C]));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			case A_B_E:
				add(buttonE = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'e', 0xFF7D00, [FlxMobileInputID.E]));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			case A_B_X_Y:
				add(buttonX = createButton(FlxG.width - 510, FlxG.height - 135, 132, 127, 'x', 0x99062D, [FlxMobileInputID.X]));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonY = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'y', 0x4A35B9, [FlxMobileInputID.Y]));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			case A_B_C_X_Y:
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00, [FlxMobileInputID.C]));
				add(buttonX = createButton(FlxG.width - 258, FlxG.height - 255, 132, 127, 'x', 0x99062D, [FlxMobileInputID.X]));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonY = createButton(FlxG.width - 132, FlxG.height - 255, 132, 127, 'y', 0x4A35B9, [FlxMobileInputID.Y]));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			case A_B_C_X_Y_Z:
				add(buttonX = createButton(FlxG.width - 384, FlxG.height - 255, 132, 127, 'x', 0x99062D, [FlxMobileInputID.X]));
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00, [FlxMobileInputID.C]));
				add(buttonY = createButton(FlxG.width - 258, FlxG.height - 255, 132, 127, 'y', 0x4A35B9, [FlxMobileInputID.Y]));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonZ = createButton(FlxG.width - 132, FlxG.height - 255, 132, 127, 'z', 0xCCB98E, [FlxMobileInputID.Z]));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			case A_B_C_D_V_X_Y_Z:
				add(buttonV = createButton(FlxG.width - 510, FlxG.height - 255, 132, 127, 'v', 0x49A9B2, [FlxMobileInputID.V]));
				add(buttonD = createButton(FlxG.width - 510, FlxG.height - 135, 132, 127, 'd', 0x0078FF, [FlxMobileInputID.D]));
				add(buttonX = createButton(FlxG.width - 384, FlxG.height - 255, 132, 127, 'x', 0x99062D, [FlxMobileInputID.X]));
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00, [FlxMobileInputID.C]));
				add(buttonY = createButton(FlxG.width - 258, FlxG.height - 255, 132, 127, 'y', 0x4A35B9, [FlxMobileInputID.Y]));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonZ = createButton(FlxG.width - 132, FlxG.height - 255, 132, 127, 'z', 0xCCB98E, [FlxMobileInputID.Z]));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			// PSYCH RELEATED BUTTONS
			case CHARACTER_EDITOR:
				add(buttonV = createButton(FlxG.width - 510, FlxG.height - 255, 132, 127, 'v', 0x49A9B2, [FlxMobileInputID.V]));
				add(buttonD = createButton(FlxG.width - 510, FlxG.height - 135, 132, 127, 'd', 0x0078FF, [FlxMobileInputID.D]));
				add(buttonX = createButton(FlxG.width - 384, FlxG.height - 255, 132, 127, 'x', 0x99062D, [FlxMobileInputID.X]));
				add(buttonC = createButton(FlxG.width - 384, FlxG.height - 135, 132, 127, 'c', 0x44FF00, [FlxMobileInputID.C]));
				add(buttonS = createButton(FlxG.width - 636, FlxG.height - 135, 132, 127, 's', 0xEA00FF, [FlxMobileInputID.S]));
				add(buttonF = createButton(FlxG.width - 410, 0, 132, 127, 'f', 0xFF009D, [FlxMobileInputID.F]));
				add(buttonY = createButton(FlxG.width - 258, FlxG.height - 255, 132, 127, 'y', 0x4A35B9, [FlxMobileInputID.Y]));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonZ = createButton(FlxG.width - 132, FlxG.height - 255, 132, 127, 'z', 0xCCB98E, [FlxMobileInputID.Z]));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			case DIALOGUE_PORTRAIT:
				add(buttonX = createButton(FlxG.width - 384, 0, 132, 127, 'x', 0x99062D, [FlxMobileInputID.X]));
				add(buttonC = createButton(FlxG.width - 384, 125, 132, 127, 'c', 0x44FF00, [FlxMobileInputID.C]));
				add(buttonY = createButton(FlxG.width - 258, 0, 132, 127, 'y', 0x4A35B9, [FlxMobileInputID.Y]));
				add(buttonB = createButton(FlxG.width - 258, 125, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonZ = createButton(FlxG.width - 132, 0, 132, 127, 'z', 0xCCB98E, [FlxMobileInputID.Z]));
				add(buttonA = createButton(FlxG.width - 132, 125, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			case MENU_CHARACTER:
				add(buttonC = createButton(FlxG.width - 384, 0, 132, 127, 'c', 0x44FF00, [FlxMobileInputID.C]));
				add(buttonB = createButton(FlxG.width - 258, 0, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonA = createButton(FlxG.width - 132, 0, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
			case NOTE_SPLASH_DEBUG:
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
				add(buttonE = createButton(FlxG.width - 132, 0, 132, 127, 'e', 0xFF7D00, [FlxMobileInputID.E]));
				add(buttonX = createButton(FlxG.width - 258, 0, 132, 127, 'x', 0x99062D, [FlxMobileInputID.X]));
				add(buttonY = createButton(FlxG.width - 132, 250, 132, 127, 'y', 0x4A35B9, [FlxMobileInputID.Y]));
				add(buttonZ = createButton(FlxG.width - 258, 250, 132, 127, 'z', 0xCCB98E, [FlxMobileInputID.Z]));
				add(buttonA = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'a', 0xFF0000, [FlxMobileInputID.A]));
				add(buttonC = createButton(FlxG.width - 132, 125, 132, 127, 'c', 0x44FF00, [FlxMobileInputID.C]));
				add(buttonV = createButton(FlxG.width - 258, 125, 132, 127, 'v', 0x49A9B2, [FlxMobileInputID.V]));
			case P:
				add(buttonP = createButton(FlxG.width - 132, 0, 132, 127, 'x', 0x99062D, [FlxMobileInputID.P]));
			case B_C:
				add(buttonC = createButton(FlxG.width - 132, FlxG.height - 135, 132, 127, 'c', 0x44FF00, [FlxMobileInputID.C]));
				add(buttonB = createButton(FlxG.width - 258, FlxG.height - 135, 132, 127, 'b', 0xFFCB00, [FlxMobileInputID.B]));
			case NONE: // do nothing
		}
		updateTrackedButtons();
	}

	/*
	 * Clean up memory.
	 */
	override public function destroy():Void
	{
		super.destroy();

		buttonLeft = FlxDestroyUtil.destroy(buttonLeft);
		buttonUp = FlxDestroyUtil.destroy(buttonUp);
		buttonDown = FlxDestroyUtil.destroy(buttonDown);
		buttonRight = FlxDestroyUtil.destroy(buttonRight);
		buttonLeft2 = FlxDestroyUtil.destroy(buttonLeft2);
		buttonUp2 = FlxDestroyUtil.destroy(buttonUp2);
		buttonDown2 = FlxDestroyUtil.destroy(buttonDown2);
		buttonRight2 = FlxDestroyUtil.destroy(buttonRight2);
		buttonA = FlxDestroyUtil.destroy(buttonA);
		buttonB = FlxDestroyUtil.destroy(buttonB);
		buttonC = FlxDestroyUtil.destroy(buttonC);
		buttonD = FlxDestroyUtil.destroy(buttonD);
		buttonE = FlxDestroyUtil.destroy(buttonE);
        buttonF = FlxDestroyUtil.destroy(buttonF);
        buttonG = FlxDestroyUtil.destroy(buttonG);
        buttonS = FlxDestroyUtil.destroy(buttonS);
		buttonV = FlxDestroyUtil.destroy(buttonV);
		buttonX = FlxDestroyUtil.destroy(buttonX);
		buttonY = FlxDestroyUtil.destroy(buttonY);
		buttonZ = FlxDestroyUtil.destroy(buttonZ);
		buttonP = FlxDestroyUtil.destroy(buttonP);
	}

	private function createButton(X:Float, Y:Float, Width:Int, Height:Int, Graphic:String, ?Color:Int = 0xFFFFFF, IDs:Array<FlxMobileInputID>):FlxButton
	{
		var button:FlxButton = new FlxButton(X, Y, IDs);
		button.frames = FlxTileFrames.fromFrame(Paths.getSparrowAtlas('virtualpad').getByName(Graphic), FlxPoint.get(Width, Height));
		button.resetSizeFromFrame();
		button.solid = false;
		button.immovable = true;
		button.moves = false;
		button.scrollFactor.set();
		button.color = Color;
		button.antialiasing = ClientPrefs.data.antialiasing;
		button.tag = Graphic.toUpperCase();
		#if FLX_DEBUG
		button.ignoreDrawDebug = true;
		#end
		return button;
	}
}

enum FlxDPadMode
{
	UP_DOWN;
	LEFT_RIGHT;
	UP_LEFT_RIGHT;
	LEFT_FULL;
	RIGHT_FULL;
	BOTH;
	DIALOGUE_PORTRAIT;
	MENU_CHARACTER;
	NOTE_SPLASH_DEBUG;
	NONE;
}

enum FlxActionMode
{
	A;
	B;
	B_X;
	A_B;
	A_B_C;
	A_B_E;
	A_B_X_Y;
	A_B_C_X_Y;
	A_B_C_X_Y_Z;
	A_B_C_D_V_X_Y_Z;
	CHARACTER_EDITOR;
	DIALOGUE_PORTRAIT;
	MENU_CHARACTER;
	NOTE_SPLASH_DEBUG;
	P;
	B_C;
	NONE;
}
