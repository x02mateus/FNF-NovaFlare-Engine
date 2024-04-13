package objects;

/*
    it optimized better than just use a FlxText to display
*/

class JudgementCounter extends FlxSpriteGroup
{
    var game = PlayState.instance;
    var isExtend:Bool = ClientPrefs.data.marvelousRating;
	public var mainText:FlxText;
    public var judgeTeam:Array<FlxText>;
    
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
		
		var runTime:Int = isExtend ? 5 : 4;		
		for (num in 0...runTime + 1){		 		   
    		var numText = new FlxText(0, 0, 0, "0", 20);
    		numText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    		numText.scrollFactor.set();    		
    		add(numText);		
    		judgeTeam.push(numText);
    		
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
	            judgeTeam[0].text = Std.string(game.ratingsData[4].hits);
	        case 'sick' :
	            judgeTeam[0 + dataFix].text = Std.string(game.ratingsData[0].hits);
	        case 'good' :
	            judgeTeam[1 + dataFix].text = Std.string(game.ratingsData[1].hits);
	        case 'bad' :
	            judgeTeam[2 + dataFix].text = Std.string(game.ratingsData[2].hits);
	        case 'shit' :
	            judgeTeam[3 + dataFix].text = Std.string(game.ratingsData[3].hits);
	    }			
	}
}