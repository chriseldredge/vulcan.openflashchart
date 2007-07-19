class FilledBarStyle extends BarStyle
{
	public var is_bar:Boolean = true;
	public var outline_colour:Number = 0x000000;
	
	public function FilledBarStyle( val:String, name:String )
	{
		this.name = name;
		this.parse( val );
	}
	
	public function parse( val:String )
	{
		var vals:Array = val.split(",");
		
		this.alpha = Number( vals[0] );
		this.colour = _root.get_colour( vals[1] );
		this.outline_colour = _root.get_colour( vals[2] );
		
		if( vals.length > 3 )
			this.key = vals[3];
			
		if( vals.length > 4 )
			this.font_size = Number( vals[4] );
		
	}
	
	public function draw_bar( val:ExPoint, i:Number )
	{
		var mc:MovieClip = super.draw_bar( val, i );
		
		mc.lineStyle(2,this.outline_colour,100);
		mc.moveTo( val.left, val.bar_bottom );
    	mc.lineTo( val.left, val.y );
    	mc.lineTo( val.left+val.bar_width, val.y );
    	mc.lineTo( val.left+val.bar_width, val.bar_bottom );

		mc._alpha = this.alpha;
		mc._alpha_original = this.alpha;	// <-- remember our original alpha while tweening
	}
}