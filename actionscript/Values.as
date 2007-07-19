﻿class Values
{
	public var styles:Array=Array();

	public function Values( lv:LoadVars, bgColour:Number, labels:Array )
	{
		var name:String = '';
		var c:Number=1;
		
		do
		{
			if( c>1 ) name = '_'+c;
			
			if( lv['values'+name ] != undefined )
			{
				this.styles[c-1] = this.make_style( lv, name, c, bgColour );
				this.styles[c-1].set_values( this.parseVal( lv['values'+name] ), labels );
			}
			else
				break;		// <-- stop loading data
				
			c++;
		}
		while( true );
	
	}
	
	private function make_style( lv:LoadVars, name:String, c:Number, bgColour:Number )
	{
		if( lv['line'+name] != undefined )
			return new LineStyle(lv['line'+name],'bar_'+c);
		if( lv['line_dot'+name] != undefined )
			return new LineDot(lv['line_dot'+name],bgColour,'bar_'+c);
		if( lv['line_hollow'+name] != undefined )
			return new LineHollow(lv['line_hollow'+name],bgColour,'bar_'+c);
		else if( lv['area_hollow'+name] != undefined )
			return new AreaHollow(lv['area_hollow'+name],bgColour,'bar_'+c);
		else if( lv['bar'+name] != undefined )
			return new BarStyle(lv['bar'+name],'bar_'+c);
		else if( lv['filled_bar'+name] != undefined )
			return new FilledBarStyle(lv['filled_bar'+name],'bar_'+c);
		else if( lv['pie'+name] != undefined )
			return new PieStyle(lv['pie'+name], lv.x_labels!=undefined ? lv['values'] : "", lv['links']);
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
	
	// get x, y co-ords of vals
	function move( b:Box, min:Number, max:Number )
	{
		var tickY:Number = b.height / (max-min);
		
		var bar_count:Number = this._count_bars();
		var bar:Number = 0;
		
		for( var c:Number=0; c<this.styles.length; c++ )
		{
			this.styles[c].valPos( b, tickY, min, bar_count, bar );
			if( this.styles[c].is_bar )
				bar++;
		}
		
		// draw the bars and dots ontop of the line
		for( var c:Number=0; c < this.styles.length; c++ )
		{
			this.styles[c].draw();
		}
	}
}