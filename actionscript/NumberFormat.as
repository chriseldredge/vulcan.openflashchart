class NumberFormat
{
	public var numDecimals:Number = 2;
	public var isFixedNumDecimalsForced:Boolean = false;
	public var isDecimalSeparatorComma:Boolean = false; 
	public var isThousandSeparatorDisabled:Boolean = false; 
	
	
	private function NumberFormat( numDecimals:Number, isFixedNumDecimalsForced:Boolean, isDecimalSeparatorComma:Boolean, isThousandSeparatorDisabled:Boolean )
	{
		if ( (numDecimals!=undefined) && !isNaN( numDecimals ) ){
			this.numDecimals = numDecimals;
		} else {
			this.numDecimals = 2;
		}
		
		if (isFixedNumDecimalsForced != undefined ){
			this.isFixedNumDecimalsForced = isFixedNumDecimalsForced;
		} else {
			this.isFixedNumDecimalsForced = false;
		}	

		
		if (isDecimalSeparatorComma != undefined ){
			this.isDecimalSeparatorComma = isDecimalSeparatorComma;
		} else {
			this.isDecimalSeparatorComma = false;
		}			
		
		if (isThousandSeparatorDisabled != undefined ){
			this.isThousandSeparatorDisabled = isThousandSeparatorDisabled;
		} else {
			this.isThousandSeparatorDisabled = false;
		}			
	}
	
	
	
	
	//singleton 
//	public static function getInstance (lv,c:Number):NumberFormat{
//		if (c==2){
//			return NumberFormat.getInstanceY2(lv);
//		} else {
//			return NumberFormat.getInstance(lv);
//		}
//	}

	private static var _instance:NumberFormat = null;
	
	public static function getInstance (lv):NumberFormat{
		if (_instance == null) {
			if (lv==undefined ||  lv == null){
				lv=_root.lv;
			}
			
			_instance = new NumberFormat ( 
				lv.num_decimals,
				lv.is_fixed_num_decimals_forced,
				lv.is_decimal_separator_comma,
				lv.is_thousand_separator_disabled
			 );
			 //trace ("getInstance NEW!!!!");
		} else {
			 //trace ("getInstance found");
		}
		return _instance;
	}

	private static var _instanceY2:NumberFormat = null;
	
	public static function getInstanceY2 (lv):NumberFormat{
		if (_instanceY2 == null) {
			if (lv==undefined ||  lv == null){
				lv=_root.lv;
			}
			
			_instanceY2 = new NumberFormat ( 
				lv.num_decimals_y2,
				lv.is_fixed_num_decimals_forced_y2,
				lv.is_decimal_separator_comma_y2,
				lv.is_thousand_separator_disabled_y2
			 );
			 //trace ("getInstanceY2 NEW!!!!");
		} else {
			 //trace ("getInstanceY2 found");
		}
		return _instanceY2;
	}	
}