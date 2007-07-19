class Box
{
	public var top:Number=0;
	public var left:Number=0;
	public var right:Number=0;
	public var bottom:Number=0;
	public var width:Number=0;
	public var height:Number=0;
	
	// position of the zero line
	public var zero:Number=0;
	public var steps:Number=0;
	
	public function Box( top:Number, left:Number, right:Number, bottom:Number,
						y_min:Number, y_max:Number,
						x_left_label_width:Number, x_right_label_width:Number,
						count:Number )
	{
		
		right = this.jiggle( left, right, x_right_label_width, count );
		var tmp_left:Number = this.shrink_left( left, right, x_left_label_width, count );
		
		this.top = top;
		this.left = Math.max(left,tmp_left);
		this.right = right;
		this.bottom = bottom;
		this.width = this.right-this.left;
		this.height = bottom-top;
		
		this.steps = this.height/(y_max-y_min);
		this.zero = bottom-(steps*(y_min*-1));
	}
	
	//
	// if the last X label is wider than the chart area, the last few letters will
	// be outside the drawing area. So we make the chart width smaller so the label
	// will fit into the screen.
	//
	function jiggle( left:Number, right:Number, x_label_width:Number, count:Number )
	{
		var r:Number = 0;
		
		if( x_label_width != 0 )
		{
			var item_width:Number = (right-left) / count;
			var r:Number = right-(item_width/2);
			var new_right:Number = right;
			
			// while the right most X label is off the edge of the
			// Stage, move the box.right - 1
			while( r+(x_label_width/2) > right )
			{
				new_right -= 1;
				// changing the right also changes the item_width:
				item_width = (new_right-left) / count;
				r = new_right-(item_width/2);
			}
			right = new_right;
		}
		
		return right;
		
	}
	
	// if the left label is truncated, shrink the box until
	// it fits onto the screen
	function shrink_left( left:Number, right:Number, x_label_width:Number, count:Number )
	{
		var pos:Number = 0;

		if( x_label_width != 0 )
		{
			var item_width:Number = (right-left) / count;
			var pos:Number = left+(item_width/2);
			var new_left:Number = left;
			
			// while the left most label is hanging off the Stage
			// move the box.left in one pixel:
			while( pos-(x_label_width/2) < 0 )
			{
				new_left += 1;
				// changing the left also changes the item_width:
				item_width = (right-new_left) / count;
				pos = new_left+(item_width/2);
			}
			left = new_left;
		}
		
		return left;
		
	}
	
	
	// takes a value and returns the screen Y location
	function getY( i:Number )
	{
		// start at zero:
		var y:Number = this.zero;
		// move up (-Y) to our point (don't forget that y_min will shift it down)
		y -= i*this.steps;
		return y;
	}
}