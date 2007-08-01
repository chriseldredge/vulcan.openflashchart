﻿class BarStyle extends Style
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
		
			mc.onRollOver = _root.FadeIn;
			mc.onRollOut = _root.FadeOut;
			
			//mc.onRollOver = ChartUtil.glowIn;
			
			// this is used in FadeIn and FadeOut
			mc.tool_tip_title = labels[i];
			
			// add the MovieClip to our array:
			this.bar_mcs[i] = mc;
		}
			
	}
	

	public function valPos( b:Box, tickY:Number, min:Number, bar_count:Number, bar:Number )
	{
		this.ExPoints=Array();
		
		var item_width:Number = b.width_() / values.length;
		
		// the bar(s) have gaps between them:
		var bar_set_width:Number = item_width*0.8;
		// get the margin between sets of bars:
		var bar_left:Number = b.left_()+((item_width-bar_set_width)/2);
		// 1 bar == 100% wide, 2 bars = 50% wide each
		var bar_width:Number = bar_set_width/bar_count;
		
		for( var i:Number=0; i < this.values.length; i++)
		{

			var left2:Number = bar_left+(i*item_width);
			left2 += bar_width*bar;
			
			this.ExPoints.push(
				new ExPoint(
					left2,					// x position of value
					0,						// center (not applicable for a bar)
					b.getY( values[i] ),
					bar_width,
					// min=-100 and max=100, use b.zero
					// min = 10 and max = 20, use b.bottom
					Math.min(b.zero,b.bottom),
					Number(values[i])
					)
				);
		}
	}
	
	public function draw()
	{
		for( var i:Number=0; i < this.ExPoints.length; i++ )
			this.draw_bar( this.ExPoints[i], i );
	}
	
	public function draw_bar( val:ExPoint, i:Number )
	{
		var mc:MovieClip = this.bar_mcs[i];
		
		mc.clear();
		mc.beginFill( this.colour, 100 );
    	mc.moveTo( val.left, val.y );
    	mc.lineTo( val.left+val.bar_width, val.y );
    	mc.lineTo( val.left+val.bar_width, val.bar_bottom );
    	mc.lineTo( val.left, val.bar_bottom );
		mc.lineTo( val.left, val.y );
    	mc.endFill();
	
		mc._alpha = this.alpha;
		mc._alpha_original = this.alpha;	// <-- remember our original alpha while tweening
		
		// this is used in _root.FadeIn and _root.FadeOut
		mc.val = val;
		
		// we return this MovieClip to FilledBarStyle
		return mc;
	}
}