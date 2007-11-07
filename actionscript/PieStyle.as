import flash.external.ExternalInterface;
import mx.transitions.Tween;
import mx.transitions.easing.*;

class PieStyle extends Style
{
	var TO_RADIANS:Number = Math.PI/180;
	var labels:Array;
	var links:Array;
	var colours:Array;
	
	var text_colour:Number;
	
	public var values:Array;
	
	private var pie_mcs:Array;
	public var name:String;
	
	private var gradientFill:String = 'true'; //toggle gradients
	private var border_width:Number = 1;
	private var label_line:Number;
	private var easing:Function;
	
	public function PieStyle( lv:LoadVars, name:String )//, links:String )
	{
		this.labels = new Array();
		this.links = new Array();
		this.colours = new Array();
		
		this.name = name;
		
		this.parse( lv.pie );
		this.labels = lv.pie_labels.split(',');
		this.links = lv.links.split(',');
		
		var tmp:Array;
		if( lv.colours != undefined )
			tmp = lv.colours.split(',');
		
		// allow for both spellings fo colour.
		if( lv.colors != undefined )
			tmp = lv.colours.split(',');
			
			
		for( var i:Number=0; i<tmp.length; i++ )
			this.colours.push( _root.get_colour( tmp[i] ) );
		
		this.label_line = 10;
		this.easing = Elastic.easeOut;
		this.easing = Bounce.easeOut;
		this.easing = Strong.easeInOut;

		var tmp:Array = this.parseVals( lv.values );
		this.set_values( tmp );
	}
	
	public function parse( val:String ) : Void
	{
		var vals:Array = val.split(",");
		
		this.alpha = Number( vals[0] );
		this.colour = _root.get_colour( vals[1] );
		this.text_colour = _root.get_colour( vals[2] );
		
		if( vals.length > 3 )
			this.gradientFill = vals[3]; 
			
		if( vals.length > 4 )
			this.border_width = vals[4];
	}
	
	private function parseVals( val:String ):Array
	{
		var tmp:Array = Array();
		
		var vals:Array = val.split(",");
		for( var i:Number=0; i < vals.length; i++ )
		{
			tmp.push( vals[i] );
		}
		return tmp;
	}
	
	// override Style:set_values
	function set_values( v:Array )
	{
		super.set_values( v );
		
		// make an empty array to hold each bar MovieClip:
		this.pie_mcs = new Array( this.values.length );
		
		for( var i:Number=0; i < this.values.length; i++ )
		{
			var mc:MovieClip = _root.createEmptyMovieClip( this.name+'_'+i, _root.getNextHighestDepth() );

			mc.onRollOver = function() {ChartUtil.FadeIn(this, true); };
			mc.onRollOut = function() {ChartUtil.FadeOut(this); };
			
			if(this.links.length>i)
			{
				mc._ofc_link = this.links[i];
				mc.onRelease = function ():Void { trace(this._ofc_link); getURL(this._ofc_link); };
			}
			
			// this is used in FadeIn and FadeOut
			var tooltip:Object = {x_label:this.labels[i], value:this.values[i], key:'??'};
			mc.tooltip = tooltip;
			
			// add the MovieClip to our array:
			this.pie_mcs[i] = mc;
		}
		
		this.valPos();
	}
	
	private function valPos() : Void
	{
		this.ExPoints = new Array();
	
		var total:Number = 0;
		var slice_start:Number=0;
		for( var i:Number=0; i < this.values.length; i++)
		{
			total += Number(values[i]);
		}
		
		for( var i:Number=0; i < this.values.length; i++)
		{
			var slice_percent :Number = Number(this.values[i])*100/total; 
			
			if( slice_percent > 0 )
			{
				this.ExPoints.push(
					new ExPoint(
						slice_start,					// x position of value
						0,						// center (not applicable for a bar)
						Number(this.values[i]), //y
						slice_percent,//width
						// min=-100 and max=100, use b.zero
						// min = 10 and max = 20, use b.bottom
						slice_start, //bar bottom
						//ChartUtil.format(slice_percent)+"%"+"\n"+ChartUtil.format(values[i]), //tooltip
						//_root.format(slice_percent)+"%"+"\n"+_root.format(values[i])
						slice_percent
						//,"#" //link
						)
					);
			}
				
			slice_start += slice_percent;
		}
	}
	
	public function draw( top:Number ) : Void
	{
		this.clear_mcs( Stage.width/2, ((Stage.height-top)/2)+top );
		
		//radius for the pie
		var rad:Number = (Stage.width<(Stage.height-top)) ? Stage.width/2 : (Stage.height-top)/2;
		var labelLineSize:Number = rad+this.label_line;
		
		if( this.labels.length>0 )
		{
			this.init_labels();
			
			var tfs:Array = Array();
			
			// create the text field objects
			for( var i:Number=0; i < this.ExPoints.length; i++ )
				tfs.push( this.create_label( i, this.labels[i] ) );
				
			//
			// start off with the radius at 100%, then keep shrinking it untill
			// all the labels fit into the Stage.
			//
			var outside:Boolean = false;
			
			do
			{
				for( var i:Number=0; i < tfs.length; i++ )
				{
					var angle:Number = this.ExPoints[i].bar_bottom+this.ExPoints[i].bar_width/2;
					outside = outside || this.move_label( tfs[i], labelLineSize, this.pie_mcs[i]._x, this.pie_mcs[i]._y, angle );
				}
				
				if( !outside )
				{
					trace( 'break' );
					trace( rad );
					trace('--');
					break;
				}
				
				// LOOK, here we reduce the radius:
				rad--;
				labelLineSize = rad+this.label_line;
				outside = false;
				
			}while( true );
			
			
		}
		
		for( var i:Number=0; i < this.ExPoints.length; i++ )
		{
			//this.draw_bits( rad, this.ExPoints[i], this.pie_mcs[i], , this.labels[i], this.links[i], i );
			this.draw_slice( this.pie_mcs[i], rad, this.colours[i%this.colours.length], this.ExPoints[i].bar_width );
			// draw the line from the slice to the label
			if( this.labels.length>0 )
				this.draw_label_line( this.pie_mcs[i], rad, this.label_line, this.ExPoints[i].bar_width );
				
			//rotate slice to appropriate place in pie
			//pieSlice._rotation = 3.6*value.bar_bottom;
			var t:Tween = new Tween( this.pie_mcs[i], "_rotation", this.easing, 0, 3.6*this.ExPoints[i].bar_bottom, 120, false);
		}	
	}
	
	function clear_mcs( x:Number, y:Number )
	{
		for( var i:Number=0; i < this.ExPoints.length; i++ )
		{
			var mc:MovieClip = this.pie_mcs[i];
			//the slice to be drawn
			mc.clear();
			//move slice to center
			mc._x = x;
			mc._y = y;
		
			mc._alpha = this.alpha;
			mc._alpha_original = this.alpha;	// <-- remember our original alpha while tweening
		}
	}
	
	// draw the line from the pie slice to the label
	function draw_label_line( pieSlice:MovieClip, rad:Number, tick_size:Number, slice_angle:Number )
	{
		//draw line 
		pieSlice.lineStyle( 1, this.colour, 100 );
		//move to center of arc
		pieSlice.moveTo(rad*Math.cos(slice_angle/2*3.6*TO_RADIANS), rad*Math.sin(slice_angle/2*3.6*TO_RADIANS));

		//final line positions
		var lineEnd_x:Number = (rad+tick_size)*Math.cos(slice_angle/2*3.6*TO_RADIANS);
		var lineEnd_y:Number = (rad+tick_size)*Math.sin(slice_angle/2*3.6*TO_RADIANS);
		pieSlice.lineTo(lineEnd_x, lineEnd_y);
	}
	
	function init_labels()
	{
		//create legend text field
		for( var i:Number=0; i < this.ExPoints.length; i++ )
			if( _root["pie_text_"+i] != undefined )
				_root["pie_text_"+i].removeTextField();
	}
	
	function create_label( num:Number, label:String )
	{
		var tf:TextField = _root.createTextField("pie_text_"+num, _root.getNextHighestDepth(), 0, 0, 10, 10);
		
		tf.text = label;
		tf.autoSize = true;
		// legend_tf._rotation = 3.6*value.bar_bottom;
				
		var fmt:TextFormat = new TextFormat();
		fmt.color = this.text_colour;
		fmt.font = "Verdana";
		//fmt.size = this.size;
		fmt.align = "center";
		tf.setTextFormat(fmt);
		
		return tf;
	}
	
	function move_label( tf:TextField, rad:Number, x:Number, y:Number, ang:Number )
	{
		//text field position
		var legend_x:Number = x+rad*Math.cos((ang)*3.6*TO_RADIANS);
		var legend_y:Number = y+rad*Math.sin((ang)*3.6*TO_RADIANS);
		
		//if legend stands to the right side of the pie
		if(legend_x<x)
			legend_x -= tf._width;
				
		//if legend stands on upper half of the pie
		if(legend_y<y)
			legend_y -= tf._height;
		
		tf._x = legend_x;
		tf._y = legend_y;
		
		// is this label outside the stage?
		if( (tf._x>0) && (tf._y>0) && (tf._y+tf._height<Stage.height ) && (tf._x+tf._width<Stage.width) )
			return false;
		else
			return true;
	}
	
	function draw_slice( pieSlice:MovieClip, r1:Number, color:Number, slice_angle:Number )
	{
		//line from center to edge
		pieSlice.lineStyle( this.border_width, this.colour, 100 );

		//if the user selected the charts to be gradient filled do gradients
		if( this.gradientFill == 'true' )
		{
			//set gradient fill
			var colors:Array = [color, color];
			var alphas:Array = [100, 50];
			var ratios:Array = [100,255];
			var matrix:Object = {a:r1*2, b:0, c:50, d:0, e:r1*2, f:0, g:-3, h:3, i:1};
			pieSlice.beginGradientFill("radial", colors, alphas, ratios, matrix);
		}
		else
			pieSlice.beginFill(color, 100);
		
		pieSlice.moveTo(0, 0);
		pieSlice.lineTo(r1, 0);
	
		
		var angle:Number = 4;
		var a:Number = Math.tan((angle/2)*TO_RADIANS);
		
		var i:Number = 0;
		//draw curve segments spaced by angle 
		for( i=0; i+angle < slice_angle*3.6; i+=angle) {
			var endx:Number = r1*Math.cos((i+angle)*TO_RADIANS);
			var endy:Number = r1*Math.sin((i+angle)*TO_RADIANS);
			var ax:Number = endx+r1*a*Math.cos(((i+angle)-90)*TO_RADIANS);
			var ay:Number = endy+r1*a*Math.sin(((i+angle)-90)*TO_RADIANS);
			pieSlice.curveTo(ax, ay, endx, endy);	
		}
		
		//when aproaching end of slice, refine angle interval
		var angle:Number = 0.08;
		var a:Number = Math.tan((angle/2)*TO_RADIANS);
		 
		for ( ; i+angle < slice_angle*3.6; i+=angle) {
			var endx:Number = r1*Math.cos((i+angle)*TO_RADIANS);
			var endy:Number = r1*Math.sin((i+angle)*TO_RADIANS);
			var ax:Number = endx+r1*a*Math.cos(((i+angle)-90)*TO_RADIANS);
			var ay:Number = endy+r1*a*Math.sin(((i+angle)-90)*TO_RADIANS);
			pieSlice.curveTo(ax, ay, endx, endy);	
		}
		
		//close slice
		pieSlice.endFill();
		pieSlice.lineTo(0,0);
	}
}