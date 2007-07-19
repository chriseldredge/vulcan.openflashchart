﻿/**
 * @author Hugo
 */
class ChartUtil {

static function get_colour( col:String ) :Number
{
	if( col.substr(0,2) == '0x' )
		return Number(col);
		
	if( col.substr(0,1) == '#' )
		return Number( '0x'+col.substr(1,col.length) );
		
	if( col.length=6 )
		return Number( '0x'+col );
		
	// not recognised as a valid colour, so?
	return Number( col );
		
}
	
	
	static function FadeIn(mc :MovieClip, tooltip_follow:Boolean) : Void
	{
		mc.onEnterFrame = function () {
			_root.show_tip(
				mc,
				mc.val.left,
				((mc.val.bar_bottom<mc.val.y)?mc.val.bar_bottom:mc.val.y)-20,
				mc.tool_tip_title,
				mc.tool_tip_value
				);
			
			if(tooltip_follow) {
				_root.tooltip._x = _root._xmouse+5;
				_root.tooltip._y = _root._ymouse-_root.tooltip._height-20;
			}
			if( mc._alpha < 100 )
			{
				mc._alpha += 10;
			}
			else
			{
				mc._alpha = 100;
				//
				// we delete mc.onEnterFrame later,
				// so the tool tip keeps following the mouse
				//
			}
		};
	}

	static function FadeOut(mc:MovieClip) : Void {
	mc.onEnterFrame = function ()
    {
			
        if( (mc._alpha-5) > mc._alpha_original )
        {
            mc._alpha -= 5;
        }
        else
        {
			mc._alpha = mc._alpha_original;
			_root.hide_tip( mc );
            delete mc.onEnterFrame;
        }
    };
}

/*

static function hide_tip( owner:Object ) : Void {
	if( _root.tooltip._owner == owner )
		removeMovieClip("tooltip");
}

static function show_tip( owner:Object, x:Number, y:Number, tip_text:String ) : Void
{
	if( ( _root.tooltip != undefined ) )
	{
		if(_root.tooltip._owner==owner)
			return;	// <-- it's our tooltip and it is showing
		else
			removeMovieClip("tooltip");	// <-- it is someone elses tootlip - remove it
	}
		
	var tooltip:MovieClip = _root.createEmptyMovieClip( "tooltip", _root.getNextHighestDepth() );
		
	// let the tooltip know who owns it, else we get weird race conditions where one
	// bar has onRollOver fired, then another has onRollOut and deletes the tooltip
	tooltip._owner = owner;
		
	var cstroke:Object = {width:2, color:0x808080, alpha:100};
	var ccolor:Object = {color:0xf0f0f0, alpha:100};

	tooltip.createTextField( "txt", _root.getNextHighestDepth(), 5, 5, 100, 100);
	tooltip.txt.text = tip_text;
	
	var fmt:TextFormat = new TextFormat();
	fmt.color = 0x000000;
	fmt.font = "Verdana";
	fmt.size = 12;
	fmt.align = "right";
	tooltip.txt.setTextFormat(fmt);
	tooltip.txt.autoSize="left";
	
	rrectangle(tooltip,
		tooltip.txt._width+10,
		tooltip.txt._height+10,
		6,
		((x+tooltip._width+10) > Stage.width ) ? (Stage.width-tooltip._width-10) : x,
		y - tooltip.txt._height,
		cstroke,
		ccolor);
	
	// NetVicious, June, 2007
	// create shadow filter
	var dropShadow:Object = new flash.filters.DropShadowFilter();
	dropShadow.blurX = 4;
	dropShadow.blurY = 4;
	dropShadow.distance = 4;
	dropShadow.angle = 45;
	dropShadow.quality = 2;
	dropShadow.alpha = 0.5;
	// apply shadow filter
	tooltip.filters = [dropShadow];

}

// JG - I copied this from :
//   http://www.actionscript.org/showMovie.php?id=1183
//
// Rounded rectangle made only with actionscript.
// Code taken and modified from http://www.actionscript-toolbox.com
// w = rectangle width
// h = rectangle height
// rad = rounded corner radius
// x = x  start point for rectangle
// y = y  start point for rectangle
// 
// 
// If you have any questions about this script mail me: janiss@cc.lv
// 
static function rrectangle(tooltip:MovieClip, w:Number, h:Number, rad:Number, x:Number, y:Number, stroke:Object, fill:Object) : Void {
	// added by JG on 30th May 07
	x = Math.round(x);
	y = Math.round(y);
	w = Math.round(w);
	h = Math.round(h);
	//
	tooltip.lineStyle(stroke.width, stroke.color, stroke.alpha);
	tooltip.beginFill(fill.color, fill.alpha);
	tooltip.moveTo(0+rad, 0);
	tooltip.lineTo(w-rad, 0);
	tooltip.curveTo(w, 0, w, rad);
	tooltip.lineTo(w, h-rad);
	tooltip.curveTo(w, h, w-rad, h);
	tooltip.lineTo(0+rad, h);
	tooltip.curveTo(0, h, 0, h-rad);
	tooltip.lineTo(0, 0+rad);
	tooltip.curveTo(0, 0, 0+rad, 0);
	tooltip.endFill();
	tooltip._x = x;
	tooltip._y = y;
}

static function format( i:Number ) : String {
	var s:String = '';
	if( i<0 )
		var num:Array = String(-i).split('.');
	else
		var num:Array = String(i).split('.');
	
	var x:String = num[0];
	var pos:Number=0;
	for(var c:Number = x.length-1;c>-1;c--)
	{
		if( pos%3==0 && s.length>0 )
		{
			s=','+s;
			pos=0;
		}
		pos++;
			
		s=x.substr(c,1)+s;
	}
	if( num[1] != undefined )
		s += '.'+ num[1].substr(0,2);
		
	if( i<0 )
		s = '-'+s;
		
	return s;
}
*/
}