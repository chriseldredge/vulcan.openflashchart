class MinMax
{
	public var y_min:Number=0;
	public var y_max:Number=0;
	
	function MinMax( lv:LoadVars )
	{
		if( lv.y_max == undefined )
			this.y_max = 10;
		else
			this.y_max = Number(lv.y_max)
			
		if( lv.y_min == undefined )
			this.y_min = 0;
		else
			this.y_min = Number(lv.y_min)
	}
}