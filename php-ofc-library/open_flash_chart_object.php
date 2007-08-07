<?
function open_flash_chart_object( $width, $height, $url )
{
	$ie = strstr(getenv('HTTP_USER_AGENT'), 'MSIE');

	if ( $ie ) {
		// Using library for auto-enabling Flash object on IE, disabled-Javascript proof
		echo '<div id="flashcontent"></div>';
		echo '<script type="text/javascript" src="js/swfobject.js"></script>';
		echo '<script type="text/javascript">';
		echo 'var so = new SWFObject("open-flash-chart.swf", "ofc", "'. $width . '", "' . $height . '", "8", "#FFFFFF");';
		echo 'so.addVariable("width", "' . $width . '");';
		echo 'so.addVariable("height", "' . $height . '");';
		echo 'so.addVariable("data", "'. $url . '");';
		echo 'so.addParam("allowScriptAccess", "sameDomain");';
		echo 'so.write("flashcontent");';
		echo '</script>';
		echo '<noscript>';
	}

	echo '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="' . $width . '" height="' . $height . '" id="graph-2" align="middle">';
	echo '<param name="allowScriptAccess" value="sameDomain" />';
	echo '<param name="movie" value="open-flash-chart.swf?width='. $width .'&height='. $height . '&data='. $url .'" /><param name="quality" value="high" /><param name="bgcolor" value="#FFFFFF" />';
	echo '<embed src="open-flash-chart.swf?width='. $width .'&height='. $height . '&data=' . $url .'" quality="high" bgcolor="#FFFFFF" width="'. $width .'" height="'. $height .'" name="open-flash-chart" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />';
	echo '</object>';

	if ( $ie ) {
		echo '</noscript>';
	}
}
?>