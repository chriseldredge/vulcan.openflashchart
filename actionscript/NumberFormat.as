class NumberFormat
{
	public var numDecimals:Number = 2;
	public var isFixedNumDecimalsForced:Boolean = false;
	public var isDecimalSeparatorComma:Boolean = false; 

	
	private function NumberFormat( numDecimals:Number, isFixedNumDecimalsForced:Boolean, isDecimalSeparatorComma:Boolean )
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
	}
	
	//singleton 
	private static var _instance:NumberFormat = null;
	
	public static function getInstance ():NumberFormat{
		if (_instance == null) {
			_instance = new NumberFormat ( 
				_root.lv.numDecimals,
				_root.lv.isFixedNumDecimalsForced,
				_root.lv.isDecimalSeparatorComma
			 );
			 //trace ("getInstance NEW!!!!");
		} else {
			 //trace ("getInstance found");
		}
		return _instance;
	}
}