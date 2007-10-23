class LineHollow extends LineStyle
{
	public var bgColour:Number=0;
	public var name:String;
	public var mcs:Array;
	
	public function LineHollow( val:String, bgColour:Number, name:String )
	{
		this.mcs=[];
		this.values = [];
		
		this.bgColour = bgColour;
		this.name = name;
		
		var vals:Array = val.split(",");
		this.line_width = Number( vals[0] );
		this.colour = _root.get_colour( vals[1] );
		
		if( vals.length > 2 )
			this.key = vals[2];
			
		if( vals.length > 3 )
			this.font_size = Number( vals[3] );
		
		if( length( vals ) > 4 )
			this.circle_size = Number( vals[4] );
			
		this.mc2 = _root.createEmptyMovieClip( name+'_hightlight', _root.getNextHighestDepth());
		this.mc2.lineStyle( 0, 0, 0);
		this.mc2.fillCircle( 0, 0, this.circle_size+2, 15, this.colour );
		this.mc2.fillCircle( 0, 0, this.circle_size-this.line_width+2, 15, this.bgColour);
		this.mc2._visible = false;
	}
/*
	function set_values___( v:Array, labels:Array )
	{
		for( var i:Number=0; i < v.length; i++ )
			this.add( String( v[i] ), labels[i] );
	}
	
	public function add( val:String, tool_tip:String )
	{
		super.add( val );
		
		return;
		
		if( this.circle_size > 0 )
		{
			if( val != 'null' )
			{
				var mc:MovieClip = _root.createEmptyMovieClip(this.name+'_dot_'+this.mcs.length, _root.getNextHighestDepth());
				var tooltip = {x_label:tool_tip, value:_root.format(val), key:this.key};
				this.make_dot( mc, this.bgColour, this.colour, tooltip );
				this.mcs.push(mc);
			}
			else
				this.mcs.push(null);
		}
	}
*/
	
	public function draw()
	{
		super.draw();
		
		if( this.circle_size == 0 )
			return;
		
		//this.mc.blendMode = 2;
		//this.mc3.blendMode = 8;
		
		for( var i:Number=0; i < this.ExPoints.length; i++ )
		{
			var val:Point = this.ExPoints[i];
			this.mc.lineStyle( 0, 0, 0);
			this.mc.fillCircle( val.x, val.y, this.circle_size, 15, this.colour );
			this.mc.fillCircle( val.x, val.y, this.circle_size-this.line_width, 15, this.bgColour );
		}
		
		return;
		
		for( var i:Number=0; i < this.ExPoints.length; i++ )
			super.move_dot( this.ExPoints[i], this.mcs[i] )
	}
}