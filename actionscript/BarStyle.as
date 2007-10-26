class BarStyle extends Style
{
	public var is_bar:Boolean = true;
	
	// MovieClip that holds each bar:
	private var bar_mcs:Array;
	public var name:String;
	
	public function BarStyle( val:String, name:String )
	{
		this.name = name;
		// this calls parent obj Style.Style first
		this.parse_bar( val );
	}
	
	public function parse_bar( val:String )
	{
		var vals:Array = val.split(",");
	
		this.alpha = Number( vals[0] );
		this.colour = _root.get_colour(vals[1]);
		
		if( vals.length > 2 )
			this.key = vals[2];
			
		if( vals.length > 3 )
			this.font_size = Number( vals[3] );
		
	}

	// override Style:set_values
	function set_values( v:Array, labels:Array )
	{
		super.set_values( v );
		
		// make an empty array to hold each bar MovieClip:
		this.bar_mcs = new Array(this.values.length);
		
		for( var i:Number=0; i < this.values.length; i++ )
		{
			var mc:MovieClip = _root.createEmptyMovieClip( this.name+'_'+i, _root.getNextHighestDepth() );
		
			mc.onRollOver = _root.FadeIn2;
			mc.onRollOut = _root.FadeOut;
			
			//mc.onRollOver = ChartUtil.glowIn;
			
			// this is used in FadeIn and FadeOut
			//mc.tool_tip_title = labels[i];
			//var tooltip:Object = {x_label:labels[i], value:this.values[i], key:this.key};
			//mc.tooltip = tooltip;
		
			// add the MovieClip to our array:
			this.bar_mcs[i] = mc;
		}
			
	}
	

	public function valPos( b:Box, right_axis:Boolean, min:Number, bar_count:Number, bar:Number )
	{
		this.ExPoints=Array();
		
		for( var i:Number=0; i < this.values.length; i++)
		{
			if( this.values[i] != 'null' )
			{
				var tmp:Point = b.make_point_bar( i, Number(this.values[i]), right_axis, bar, bar_count );
				
				tmp.make_tooltip(
					_root.get_tooltip_string(),
					this.key,
					Number(this.values[i]),
					_root.get_x_legend(),
					_root.get_x_axis_label(i)
					);
					
				this.ExPoints.push( tmp );
			}
			else
			{
				this.ExPoints.push( null );
			}
		}
	}
	
	public function draw()
	{
		for( var i:Number=0; i < this.ExPoints.length; i++ )
			this.draw_bar( this.ExPoints[i], i );
	}
	
	public function draw_bar( val:PointBar, i:Number )
	{
		var top:Number;
		var height:Number;
		
		if(val.bar_bottom<val.y)
		{
			top = val.bar_bottom;
			height = val.y-val.bar_bottom;
		}
		else
		{
			top = val.y
			height = val.bar_bottom-val.y;
		}
		
		var mc:MovieClip = this.bar_mcs[i];
		
		mc.clear();
		mc.beginFill( this.colour, 100 );
    	mc.moveTo( 0, 0 );
    	mc.lineTo( val.width, 0 );
    	mc.lineTo( val.width, height );
    	mc.lineTo( 0, height );
		mc.lineTo( 0, 0 );
    	mc.endFill();
		
		mc._x = val.x;
		mc._y = top;
	
		mc._alpha = this.alpha;
		mc._alpha_original = this.alpha;	// <-- remember our original alpha while tweening
		
		// this is used in _root.FadeIn and _root.FadeOut
		//mc.val = val;
		
		// we return this MovieClip to FilledBarStyle
		return mc;
	}
	
	/*  
	    ------O------
	          A
			  
	    +-----+
		|  B  |
		|     |   +-----+
		|     |   |  C  |
		|     |   |     |
	    +-----+---+-----+
		   1   2
		
	*/
	public function closest( x:Number, y:Number )
	{
		var shortest:Number = Number.MAX_VALUE;
		var ex:PointBar = null;
		
		for( var i:Number=0; i < this.ExPoints.length; i++)
		{
			this.ExPoints[i].is_tip = false;
			
			if( (x > this.ExPoints[i].x) && (x < this.ExPoints[i].x+this.ExPoints[i].width) )
			{
				// mouse is in position 1
				shortest = 0;
				ex = this.ExPoints[i];
			}
			else
			{
				// mouse is in position 2
				// get distance to left side and right side
				var d1:Number = Math.abs( x - this.ExPoints[i].x );
				var d2:Number = Math.abs( x - (this.ExPoints[i].x+this.ExPoints[i].width) );
				var min:Number = Math.min( d1, d2 );
				if( min < shortest )
				{
					shortest = min;
					ex = this.ExPoints[i];
				}
			}
		}
		var dy:Number = Math.abs( y - ex.y );
		
		return { point:ex, distance_x:shortest, distance_y:dy };
	}
}