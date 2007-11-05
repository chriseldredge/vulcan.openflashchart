class LineStyle extends Style
{
	private var mc:MovieClip;
	private var mc2:MovieClip;
	
	public function LineStyle( val:String, name:String )
	{
		var vals:Array = val.split(",");
		this.line_width = Number( vals[0] );
		this.colour = _root.get_colour( vals[1] );
		
		if( vals.length > 2 )
			this.key = vals[2];
			
		if( vals.length > 3 )
			this.font_size = Number( vals[3] );
		
		if( length( vals ) > 4 )
			this.circle_size = Number( vals[4] );
			
		this.mc = _root.createEmptyMovieClip(name, _root.getNextHighestDepth());
		this.mc2 = _root.createEmptyMovieClip(name, _root.getNextHighestDepth());
		this.mc2.fillCircle( 0, 0, 7, 15, 0xFFFFFF );
		this.mc2.fillCircle( 0, 0, 5, 15, this.colour );
		this.mc2._visible = false;
	}
	
	public function valPos( b:Box, right_axis:Boolean, min:Number )
	{
		this.ExPoints=Array();
		
		var x_legend:String = '';
		if( _root._x_legend != undefined )
			
					
		for( var i:Number=0; i < this.values.length; i++)
		{
			
			if( this.values[i] == 'null' )
			{
				this.ExPoints.push( null );
			}
			else
			{
				var tmp:Point = b.make_point( i, Number(this.values[i]), right_axis );
				
				tmp.make_tooltip(
					_root.get_tooltip_string(),
					this.key,
					Number(this.values[i]),
					_root.get_x_legend(),
					_root.get_x_axis_label(i)
					);
				
				this.ExPoints.push( tmp );
			}
		}
	}
	
	// Draw lines...
	public function draw()
	{
		this.mc.clear();
		this.mc.lineStyle( this.line_width, this.colour, 100); // <-- alpha 0 to 100
	
		var first:Boolean = true;
		
		for( var i:Number=0; i < this.ExPoints.length; i++ )
		{
			// skip null values
			if( this.ExPoints[i] != null )
			{
				if( first )
				{
					this.mc.moveTo(this.ExPoints[i].x,this.ExPoints[i].y);
					first = false;
				}
				else
					this.mc.lineTo(this.ExPoints[i].x,this.ExPoints[i].y);
				
			}
		}
	}
	
	public function highlight_value()
	{
		var found:Boolean = false;
		
		for( var i:Number=0; i < this.ExPoints.length; i++ )
		{
			if( this.ExPoints[i].is_tip )
			{
				this.mc2._x = this.ExPoints[i].x;
				this.mc2._y = this.ExPoints[i].y;
				this.mc2._visible = true;
				found = true;
				break;
			}
		}
		if( !found )
			this.mc2._visible = false;
	}
	
	private function rollOver()
	{}
	
	public function closest( x:Number, y:Number )
	{
		var shortest:Number = Number.MAX_VALUE;
		var point:Point = null;
		
		for( var i:Number=0; i < this.ExPoints.length; i++)
		{
			this.ExPoints[i].is_tip = false;
			
			var dx:Number = Math.abs( x - this.ExPoints[i].x );
		
			if( dx < shortest )
			{
				shortest = dx;
				point = this.ExPoints[i];
			}
		}
		var dy:Number = Math.abs( y - point.y );
		return { point:point, distance_x:0, distance_y:dy };
	}
	
	// called by AreaHollow, LineHollow
	public function make_dot( mc:MovieClip, col:Number, bg:Number, tool_tip_title:String, tool_tip_value:String )
	{
	
		if( tool_tip_title != undefined )
			mc.tool_tip_title = tool_tip_title;
		else
			mc.tool_tip_title = '';
			
		mc.tool_tip_value = tool_tip_value;
		
		//mc.onRollOver = _root.circleBig;
		
		//
		// extremely curious syntax, but it works.
		// add a roll over function to the MovieClip
		//
		var ref = mc;
		mc.onRollOver = function(){
			ref._width += 4;
			ref._height += 4;
			_root.show_tip( this, this._x, this._y-20, this.tool_tip_title, this.tool_tip_value );
		};

		// make the circle shrink and remove tooltip:
		mc.onRollOut = function(){
			_root.hide_tip( this );
			ref._width -= 4;
			ref._height -= 4;
		};

		mc.lineStyle( 0, bg, 100);
		mc.fillCircle( 0, 0, this.circle_size, 15, bg );
		mc.fillCircle( 0, 0, this.circle_size-1, 15, col);
	}
	
	public function move_dot( val:Point, mc:MovieClip )
	{
		//trace(val.center);
		// Move and fix the dots...
		mc._x = val.x;
		mc._y = val.y;
	}
	
	/*
	public function add( val:String )
	{
		this.values.push( val );
	
	}
	*/
}