﻿class XAxis
{
	private var tick:Number;
	private var grid_colour:Number;
	private var axis_colour:Number;
	//private var label_count:Number;
	private var grid_count:Number;
	private var mc:MovieClip;
	private var x_steps:Number;
	private var alt_axis_colour:Number;
	private var alt_axis_step:Number;
	
	function XAxis( tick:Number, lv:LoadVars, label_count:Number, steps:Number )
	{
		this.tick = tick;
		
		if( lv.x_grid_colour != undefined )
			this.grid_colour = _root.get_colour( lv.x_grid_colour );
		else
			this.grid_colour = 0xF5E1AA;
		
		if( lv.x_axis_colour != undefined )
			this.axis_colour = _root.get_colour( lv.x_axis_colour );
		else
			this.axis_colour = 0x784016;

		// Path from Will Henry
		var style:Array = lv.x_label_style.split(',');
		if( style.length > 4 )
		{
			this.alt_axis_step = style[3];
			this.alt_axis_colour = _root.get_colour(style[4]);
		}
		
		//this.label_count = label_count;
		this.grid_count = label_count;
		if( steps == undefined )
			this.x_steps = 1;
		else
			this.x_steps = steps;

		this.mc = _root.createEmptyMovieClip( "x_axis", _root.getNextHighestDepth() );
		
	}
	
	function set_grid_count( val:Number )
	{
		this.grid_count = val;
	}
	
	function move( box:Box )
	{
		this.mc.clear();
		
		//
		// Grid lines
		//var item_width:Number = box.width / this.grid_count;
		//var left:Number = box.left+(item_width/2);
		//

		for( var i:Number=0; i < this.grid_count; i+=this.x_steps )
		{
			if( ( this.alt_axis_step > 1 ) && ( i % this.alt_axis_step == 0 ) )
			{
				this.mc.lineStyle(1,this.alt_axis_colour,100);
			}
			else
			{
				this.mc.lineStyle(1,this.grid_colour,100);
			}
			
			var x:Number = box.get_x_pos(i);
			this.mc.moveTo( x, box.bottom);
			this.mc.lineTo( x, box.top);
			
			this.mc.moveTo( x, box.bottom);
			this.mc.lineTo( x, box.top);
		}
		
		// for 3D
		var h:Number = 5;
		var offset:Number = 12;
		var x_axis_height:Number = h+offset;
		var three_d:Boolean = true;
		
		//
		// ticks
		var item_width:Number = box.width / this.grid_count;
		//var left:Number = box.left+(item_width/2);
		
		if( three_d )
		{
			box.tick_offset = offset;
		}
		//
	

		this.mc.lineStyle(1, this.axis_colour, 100);
		var w:Number = 1;
		for( var i:Number=0; i < this.grid_count; i+=this.x_steps )
		{
			//
			// uncommenting beginFill and endFill causes big bugs??!
			//
			//this.mc.beginFill(this.axis_colour,100);
			var pos:Number = box.get_x_tick_pos(i);
			
			this.mc.moveTo( pos, box.bottom+x_axis_height);
			this.mc.lineTo( pos+w, box.bottom+x_axis_height);
			this.mc.lineTo( pos+w, box.bottom+x_axis_height+this.tick);
			this.mc.lineTo( pos, box.bottom+x_axis_height+this.tick);
			this.mc.lineTo( pos, box.bottom+x_axis_height);
			//this.mc.endFill();
		}

		// Axis line:
		//this.mc.lineStyle(undefined, 0, 0);
		this.mc.beginFill(this.axis_colour,100);
		this.mc.moveTo(box.left,box.bottom);
		this.mc.lineTo(box.right,box.bottom);
		this.mc.lineTo(box.right-offset,box.bottom+offset);
		this.mc.lineTo(box.left-offset,box.bottom+offset);
		this.mc.endFill();
	
		//this.mc.beginFill(this.axis_colour,100);
		this.mc.beginFill(0xFF0000,100);
		this.mc.moveTo(box.left-offset,box.bottom+offset);
		this.mc.lineTo(box.right-offset,box.bottom+offset);
		this.mc.lineTo(box.right-offset,box.bottom+offset+h);
		this.mc.lineTo(box.left-offset,box.bottom+offset+h);
		this.mc.endFill();
		
		this.mc.beginFill(0xFF00F0,100);
		this.mc.moveTo(box.right,box.bottom);
		this.mc.lineTo(box.right,box.bottom+h);
		this.mc.lineTo(box.right-offset,box.bottom+offset+h);
		this.mc.lineTo(box.right-offset,box.bottom+offset);
		this.mc.endFill();
		
	}
	
	// 2D:
	function move_( box:Box )
	{
		this.mc.clear();
		
		//var width = (box.right-box.left);
		
		//
		// Grid lines
		var item_width:Number = box.width / this.grid_count;
		var left:Number = box.left+(item_width/2);
		//
//
// JG removed for merge
//
//		this.mc.lineStyle(1,this.grid_colour,100);
//
		for( var i:Number=0; i < this.grid_count; i+=this.x_steps )
		{
			if( ( this.alt_axis_step > 1 ) && ( i % this.alt_axis_step == 0 ) )
			{
				this.mc.lineStyle(1,this.alt_axis_colour,100);
			}
			else
			{
				this.mc.lineStyle(1,this.grid_colour,100);
			}
			
			this.mc.moveTo(left + (i*item_width),box.bottom);
			this.mc.lineTo(left + (i*item_width),box.top);
			
			this.mc.moveTo(left + (i*item_width),box.bottom);
			this.mc.lineTo(left + (i*item_width),box.top);
		}
		
		//
		// ticks
		var item_width:Number = box.width / this.grid_count;
		var left:Number = box.left+(item_width/2);
		//
		this.mc.lineStyle(2,this.axis_colour,100);
		for( var i:Number=0; i < this.grid_count; i+=this.x_steps )
		{
			this.mc.moveTo(left + (i*item_width),box.bottom);
			this.mc.lineTo(left + (i*item_width),box.bottom+this.tick);
		}
		
		// Axis line:
		this.mc.lineStyle(2,this.axis_colour,100);
		this.mc.moveTo(box.left,box.bottom);
		this.mc.lineTo(box.right,box.bottom);
			
	}
	
	function height_()
	{
		return 2 + this.tick;
	}
	
	function height()
	{
		return 24 + this.tick;
	}
	
}