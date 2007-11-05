class NumberUtils {


	public static function formatNumber (i:Number){
		var format:NumberFormat = NumberFormat.getInstance();
		return NumberUtils.format (i, 
			format.numDecimals, 
			format.isFixedNumDecimalsForced, 
			format.isDecimalSeparatorComma 
		);
	} 

	public static function format( 
		i:Number, 
		numDecimals:Number,
		isFixedNumDecimalsForced:Boolean, 
		isDecimalSeparatorComma:Boolean 
	) {
		if ( isNaN (numDecimals )) {
			numDecimals = 2;
		}
		
		var s:String = '';
		if( i<0 )
			var num:Array = String(-i).split('.');
		else
			var num:Array = String(i).split('.');
		
		//trace ("a: " + num[0] + ":" + num[1]);
		var x:String = num[0];
		var pos:Number=0;
		var c:Number=0;
		for(c:Number=x.length-1;c>-1;c--)
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
			if (isFixedNumDecimalsForced){
				num[1] += "0000000000";
			}
			s += '.'+ num[1].substr(0,numDecimals);
			
		if( i<0 )
			s = '-'+s;
		
		if (isDecimalSeparatorComma) {
			s = toDecimalSeperatorComma(s);
		}			
		return s;
	}
	
	public static function toDecimalSeperatorComma (value:String){
		return value
			.replace(".","|")
			.replace(",",".")
			.replace("|",",")
	}

}