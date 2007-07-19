class XLegend extends Title
{

	// override the MovieClip name:
	private var name:String = 'x_legend';
	
	function XLegend( lv:LoadVars )
	{
		if( lv.x_legend == undefined )
			return;
			
		var tmp:Array = lv.x_legend.split(',');
		
		var text:String = tmp[0];
		this.size = Number( tmp[1] );
		this.colour = _root.get_colour( tmp[2] );
		
		// call our parent (Title) constructor:
		super.build( text );
	}
	
	function move()
	{
		// this will center it in the X
		super.move();
		// this will align bottom:
		this.mc._y = Stage.height - this.mc._height;
	}
}