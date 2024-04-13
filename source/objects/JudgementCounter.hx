package objects;

/*
    it optimized better than just use a FlxText to display
*/

class JudgementCounter extends FlxSpriteGroup
{
    var game = PlayState.instance;
    var isExtend:Bool = ClientPrefs.data.marvelousRating;
	public var mainText:FlxText;
    public var judgeTeam:FlxTypedGroup<FlxText>;
    
	public function new(x:Float, y:Float)
	{
		super(x, y);
		
		var marvelousRate:String = isExtend ? 'Marvelous: 0\n' : '';
		mainText = new FlxText(0, 0, 0, "", 20);
		mainText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		mainText.scrollFactor.set();
		mainText.text = marvelousRate 
		+ 'Sicks: 0' + '\n'
		+ 'Goods: 0' + '\n'
		+ 'Bads: 0' + '\n'
		+ 'Shits: 0' + '\n';
		add(mainText);
		
		var judgeName:Array<String> = ['Sicks', 'Goods', 'Bads', 'Shits'];
		if (isExtend) judgeName.unshift('Marvelous');
		
		var fixText = new FlxText(0, 0, 0, "", 20);
		fixText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		fixText.scrollFactor.set();		
		add(fixText); //it will remove soon
		
		judgeTeam = new FlxTypedGroup<FlxText>();
		add(judgeTeam);
		
		var runTime:Int = isExtend ? 5 : 4;		
		for (num in 0...runTime + 1){		 		   
    		var numText = new FlxText(0, 0, 0, "0", 20);
    		numText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		numText.scrollFactor.set();    		    		
    		judgeTeam.add(numText);
    		
    		fixText.text = judgeName[num] + ': ';
    		numText.x = fixText.width;
    		numText.y = fixText.height * num;
		}
		
		fixText.destroy();
	}
	
	public function updateScore(name:String)
	{
	    var dataFix:Int = isExtend ? 1 : 0;
	    switch (name)
	    {
	        case 'marvelous' :
	            judgeTeam.members[0].text = Std.string(game.ratingsData[4].hits);
	        case 'sick' :
	            judgeTeam.members[0 + dataFix].text = Std.string(game.ratingsData[0].hits);
	        case 'good' :
	            judgeTeam.members[1 + dataFix].text = Std.string(game.ratingsData[1].hits);
	        case 'bad' :
	            judgeTeam.members[2 + dataFix].text = Std.string(game.ratingsData[2].hits);
	        case 'shit' :
	            judgeTeam.members[3 + dataFix].text = Std.string(game.ratingsData[3].hits);
	    }			
	}
}