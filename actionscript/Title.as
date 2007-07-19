class Title
{
	public var mc:TextField;
	public var title:String = '';
	public var colour:Number;
	public var size:Number;
	private var top_padding:Number = 0;
	
	private var style:Css;
	
	function Title( lv:LoadVars )
	{
		if( lv.title == undefined )
			return;
			
		var tmp:Array = lv.title.split(',');
		
		this.style = new Css( tmp[1] );
		this.build( tmp[0] );
		return;
		
		
		if( tmp.length < 3 )
		{
			trace( 'Title error' );
			return;		// <-- should report an error
		}
		
		this.size = Number( tmp[1] );
		this.colour = _root.get_colour( tmp[2] );
		
		if( tmp.length == 4 )
			this.top_padding = Number( tmp[3] );
	}
	
	function build( text:String )
	{
		this.title = text;
		
		if( this.mc == undefined )
			this.mc = _root.createTextField( 'title', _root.getNextHighestDepth(), 0, 0, 200, 200 );
			
		this.mc.text = this.title;
		
		var fmt:TextFormat = new TextFormat();
		fmt.color = this.style.get( 'color' );
		fmt.font = "Verdana";
		fmt.size = this.style.get( 'font-size' );
		
		fmt.align = "center";
	
		this.mc.setTextFormat(fmt);
		this.mc.autoSize = "left";
	}
	
	function move()
	{
		if( this.mc != undefined )
		{
			//
			// is the title aligned (text-align: xxx)?
			//
			var tmp:String = this.style.get( 'text-align' );
			switch( tmp )
			{
				case 'left':
					this.mc._x = this.style.get( 'margin-left' );
					break;
					
				case 'right':
					this.mc._x = Stage.width - ( this.mc._width + this.style.get( 'margin-right' ) );
					break;
					
				case 'center':
				default:
					this.mc._x = (Stage.width/2) - (this.mc._width/2);
					break;
			}
			
			this.mc._y = this.style.get( 'margin-top' );
		}
	}
	
	function height()
	{
		// the title may be turned off:
		if( this.mc == undefined )
			return 0;
		else
			return this.mc._height+this.style.get( 'margin-top' )+this.style.get( 'margin-bottom' );
	}
}