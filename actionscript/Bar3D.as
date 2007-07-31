﻿class Bar3D extends BarStyle
{
	public var is_bar:Boolean = true;
	public var outline_colour:Number = 0x000000;

	public function Bar3D( val:String, name:String )
	{
		this.name = name;
		this.parse( val );
	}
	
	public function parse( val:String )
	{
		var vals:Array = val.split(",");
		
		this.alpha = Number( vals[0] );
		this.colour = _root.get_colour( vals[1] );
		//this.outline_colour = _root.get_colour( vals[2] );
		
		if( vals.length > 3 )
			this.key = vals[2];
			
		if( vals.length > 4 )
			this.font_size = Number( vals[2] );
		
	}
	

	private function top( mc:MovieClip, val:ExPoint )
	{
		//
		var w:Number = val.bar_width;
		//var rad:Number = 7;
		
//		mc.lineStyle(0, this.outline_colour, 100);
		mc.lineStyle(0, this.outline_colour, 0);
		//set gradient fill
		var colors:Array = [this.colour,0xFFFFFF];
		var alphas:Array = [100,100];
		var ratios:Array = [0,255];
		var matrix:Object = { matrixType:"box", x:0, y:0, w:w+12, h:12, r:0};//(180/180)*Math.PI };
		mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
		
		
		//mc.beginFill(this.colour, 100);
		mc.moveTo(0, 0);
		mc.lineTo(w, 0);
		mc.lineTo(w-12, 12);
		mc.lineTo(-12, 12);
		mc.endFill();
		mc._x = val.left;
		mc._y = val.y;
	}
	
	private function front( mc:MovieClip, val:ExPoint )
	{
		//
		var w:Number = val.bar_width;
		var h:Number = val.bar_bottom-val.y;
		var x:Number = val.left;
		var y:Number = val.y;
		var rad:Number = 7;
		
		//set gradient fill
		var colors:Array = [0xFFFFFF,this.colour];
		var alphas:Array = [100,100];
		var ratios:Array = [0,127];
		var matrix:Object = { matrixType:"box", x:-12, y:12, w:w-12, h:h+12, r:(180/360)*Math.PI };
		mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
		
		mc.moveTo(-12, 12);
		mc.lineTo(-12, h+12);
		mc.lineTo(w-12, h+12);
		mc.lineTo(w-12, 12);
		mc.endFill();
	}
	
	private function side( mc:MovieClip, val:ExPoint )
	{
		//
		var w:Number = val.bar_width;
		var h:Number = val.bar_bottom-val.y;
		var x:Number = val.left;
		var y:Number = val.y;
		var rad:Number = 7;
		
		mc.lineStyle(0, this.outline_colour, 0);
		mc.beginFill(this.colour, 100);
		mc.moveTo(w, 0);
		mc.lineTo(w, h);
		mc.lineTo(w-12, h+12);
		mc.lineTo(w-12, 12);
		mc.endFill();
	};
	
	public function draw_bar( val:ExPoint, i:Number )
	{
		var mc:MovieClip = this.bar_mcs[i];
		
		mc.clear();
		this.top( mc, val );
		this.front( mc, val );
		this.side( mc, val );
		
		var dropShadow = new flash.filters.DropShadowFilter();
		dropShadow.blurX = 5;
		dropShadow.blurY = 5;
		dropShadow.distance = 3;
		dropShadow.angle = 45;
		dropShadow.quality = 2;
		dropShadow.alpha = 0.4;
		//mc.filters = [dropShadow];
		
		mc._alpha = this.alpha;
		mc._alpha_original = this.alpha;	// <-- remember our original alpha while tweening
		
		// this is used in _root.FadeIn and _root.FadeOut
		mc.val = val;
	}
}