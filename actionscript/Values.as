﻿class Values
{
	public var styles:Array;

	public function Values( lv:LoadVars, bgColour:Number, labels:Array )
	{
		this.styles = [];
		var name:String = '';
		var c:Number=1;
		
		do
		{
			if( c>1 ) name = '_'+c;
			
			if( lv['values'+name ] != undefined )
			{
				this.styles[c-1] = this.make_style( lv, name, c, bgColour );
				
				//
				// UGH -- quick fix for candle charts. Need to fix all bar charts
				//
				if( lv['candle'+name] != undefined )
					this.styles[c-1].set_values( lv['values'+name], labels, lv['links'+name] );
				else if( lv['scatter'+name] != undefined )
					this.styles[c-1].set_values( lv['values'+name] );
				else
					this.styles[c-1].set_values( this.parseVal( lv['values'+name] ) );
			}
			else
				break;		// <-- stop loading data
				
			c++;
		}
		while( true );
	
	}
	
	private function make_style( lv:LoadVars, name:String, c:Number, bgColour:Number )
	{
		var style:Style = null;
		
		if( lv['line'+name] != undefined )
			style = new LineStyle(lv['line'+name],'bar_'+c);
		if( lv['line_dot'+name] != undefined )
			style = new LineDot(lv['line_dot'+name],bgColour,'bar_'+c);
		if( lv['line_hollow'+name] != undefined )
			style = new LineHollow(lv['line_hollow'+name],bgColour,'bar_'+c);
		else if( lv['area_hollow'+name] != undefined )
			style = new AreaHollow(lv['area_hollow'+name],bgColour,'bar_'+c);
		else if( lv['bar'+name] != undefined )
			style = new BarStyle(lv['bar'+name],'bar_'+c);
		else if( lv['filled_bar'+name] != undefined )
			style = new FilledBarStyle(lv['filled_bar'+name],'bar_'+c);
		else if( lv['bar_glass'+name] != undefined )
			style = new BarGlassStyle(lv['bar_glass'+name],'bar_'+c);
		else if( lv['bar_fade'+name] != undefined )
			style = new BarFade(lv['bar_fade'+name],'bar_'+c);
		else if( lv['bar_zebra'+name] != undefined )
			style = new BarZebra(lv['bar_zebra'+name],'bar_'+c);
		else if( lv['bar_arrow'+name] != undefined )
			style = new BarArrow(lv['bar_arrow'+name],'bar_'+c);
		else if( lv['bar_3d'+name] != undefined )
			style = new Bar3D(lv['bar_3d'+name],'bar_'+c);
		else if( lv['pie'+name] != undefined )
			style = new PieStyle(lv['pie'+name], lv.x_labels!=undefined ? lv['values'] : "", lv['links']);
		else if( lv['candle'+name] != undefined )
			style = new CandleStyle(lv['candle'+name],'bar_'+c);
		else if( lv['scatter'+name] != undefined )
			return new Scatter(lv['scatter'+name],bgColour,'bar_'+c);
		
		if (lv['tool_tips'+name] != undefined)
			style.tool_tips = lv['tool_tips'+name].split(",");
		
		if (lv['links'+name] != undefined)
			style.set_links(lv['links'+name].split(","));
			
		return style;
	}
	
	private function parseVal( val:String ):Array
	{
		var tmp:Array = Array();
		
		var vals:Array = val.split(",");
		for( var i:Number=0; i < vals.length; i++ )
		{
			tmp.push( vals[i] );
		}
		return tmp;
	}
	
	public function length()
	{
		var max:Number = -1;

		for(var i:Number=0; i<this.styles.length; i++ )
			max = Math.max( max, this.styles[i].values.length );

		return max;
	}
	
	function _count_bars()
	{
		// count how many sets of bars we have
		var bar_count:Number = 0;
		for( var i=0; i<this.styles.length; i++ )
			if( this.styles[i].is_bar )
				bar_count++;

		return bar_count;
	}
	
	// If the current line is to be drawn on y2 (defined in data values, y2_lines)
	private function is_right( y2lines:Array, line:Number )
	{
			//var y2lines:Array = _root.lv.y2_lines.split(",");
			var right:Boolean = false;
			for( var i:Number=0; i<y2lines.length; i++ )
			{
				if(y2lines[i] == line)
					right = true; 
			}
			
			return right;
	}
	
	function _do_it()
	{
		
	}
	
	// get x, y co-ords of vals
	function move( b:Box, min:Number, max:Number, min2:Number, max2:Number )
	{
		
		var bar_count:Number = this._count_bars();
		var bar:Number = 0;
		var y2:Boolean = false;
		var y2lines:Array;
			
		if( _root.lv.show_y2 != undefined )
			if( _root.lv.show_y2 != 'false' )
				if( _root.lv.y2_lines != undefined )
				{
					y2 = true;
					y2lines = _root.lv.y2_lines.split(",");
				}
			
		for( var c:Number=0; c<this.styles.length; c++ )
		{
			var right_axis:Boolean = false;
				
			// move values...
			if( y2 && is_right(y2lines,c+1) )
				right_axis = true;

			this.styles[c].valPos( b, right_axis, min, bar_count, bar );
			if( this.styles[c].is_bar )
				bar++;
		}
			
		// draw the bars and dots ontop of the line
		for( var c:Number=0; c < this.styles.length; c++ )
		{
			this.styles[c].draw();
		}
	}
	
	//
	// tell all out lines and bars that the mouse has moved and
	// some will need to Fade In and some Fade Out
	//
	public function mouse_move( x:Number, y:Number )
	{
		for( var i:Number=0; i < this.styles.length; i++)
		{
			if( this.styles[i].is_over( x, y ) )
				this.styles[i].fade_in();
		}
	}
}