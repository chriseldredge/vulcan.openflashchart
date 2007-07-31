class BarFade extends BarStyle
{
	public function BarFade( val:String, name:String )
	{
		super( val, name );
	}
	
	public function draw_bar( val:ExPoint, i:Number )
	{
		var mc:MovieClip = this.bar_mcs[i];
		mc.clear();
		
		//set gradient fill
		var colors:Array = [this.colour,0xFFFFFF];
		var alphas:Array = [100,0];
		var ratios:Array = [0,255];
		var matrix:Object = { matrixType:"box", x:val.left, y:val.y, w:val.bar_width, h:val.bar_bottom-val.y, r:(90/180)*Math.PI };
		mc.beginGradientFill("linear", colors, alphas, ratios, matrix);
		
		
		//mc.beginFill( this.colour, 100 );
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
