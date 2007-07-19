class YLegend
{
	public var mc:TextField = undefined;
	
	function YLegend( lv:LoadVars )
	{
		if( lv.y_legend == undefined )
			return;
		
		// parse the data file string:
		var tmp:Array = lv.y_legend.split(',');
		var text:String = tmp[0];
		var size:Number = Number( tmp[1] );
		var colour:Number = _root.get_colour( tmp[2] );
		 
		this.mc = _root.createTextField("y_legend", _root.getNextHighestDepth(), 0, 0, 200, 200);
		this.mc.text = text;
		// so we can rotate the text
		this.mc.embedFonts = true;
		
		var fmt:TextFormat = new TextFormat();
		fmt.color = colour;
		// our embedded font - so we can rotate it
		// library->new font, linkage
		fmt.font = "Verdana_embed";
		
		fmt.size = size;
		fmt.align = "center";
		
		this.mc.setTextFormat(fmt);
		this.mc.autoSize = "left";
		this.mc._rotation = 270;
		this.mc.autoSize = "left";
	}
	
	function move()
	{
		if( this.mc == undefined )
			return;
			
		this.mc._y = (Stage.height/2)+(this.mc._height/2);
		this.mc._x = 0;
	}
	
	function width()
	{
		if( this.mc == undefined )
			return 0;
		else
			return this.mc._width;
	}
}