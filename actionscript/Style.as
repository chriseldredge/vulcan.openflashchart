class Style
{
	public var key:String = '';
	public var font_size:Number = -1;
	public var colour:Number = 0x000000;
	public var line_width:Number = 1;
	public var circle_size:Number = 0;

	//
	public var is_bar:Boolean = false;
	public var alpha:Number = 50;		// <- transparancy
	
	public var values:Array;
	public var ExPoints:Array;
	public var tool_tips:Array;
	private var links:Array;
	
	public function Style()
	{
		links = new Array();
	}
	
	function set_values( v:Array )
	{
		this.values = v;
	}

	function set_links( links:Array )
	{
		this.links = links;
	}
	
	function get_tip_index()
	{
		for( var i:Number=0; i < this.ExPoints.length; i++ )
		{
			if( this.ExPoints[i].is_tip )
			{
				return i;
			}
		}
		return -1;
	}
	
	public function draw( val, mc )
	{}
	
	public function highlight_value()
	{}
	
	public function mouse_release()
	{
		if (this.links.length == 0)
		{
			return;
		}
		
		var i = get_tip_index();
		if (i<0 || i>=this.links.length)
		{
			return;
		}
		
		trace(this.links[i]);
		getURL(this.links[i]);
	}
	
	public function closest( x:Number, y:Number )
	{}

}