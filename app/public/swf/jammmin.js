function playSong(songtitle,songhandle,type)
{
		var flashvars = {};
		flashvars.playfile = "1";
		flashvars.playurl = songhandle;
			
		// Flash parameters
		var params = {};
		params.allowfullscreen = "true";
		params.allowScriptAccess = "always";
		params.allowNetworking = "all";
		params.quality = "high";
		params.bgcolor = "000000";
		params.wmode = "transparent";
		params.menu = "true";

		// Attributes
		var attributes = {};

		// Call SWFobject
		if(type=="large")
			swfobject.embedSWF("player.swf", "playerdiv", "380", "70", "7.0.0", false, flashvars, params, attributes);
		else
			swfobject.embedSWF("player-small.swf", "playerdiv", "200", "70", "7.0.0", false, flashvars, params, attributes);
}

function playerinit(type)
{
		// Flash variables
		var flashvars = {};
		flashvars.playfile = "0";
		flashvars.playurl = "";
				
		// Flash parameters
		var params = {};
		params.allowfullscreen = "true";
		params.allowScriptAccess = "always";
		params.allowNetworking = "all";
		params.quality = "high";
		params.bgcolor = "000000";
		params.wmode = "transparent";
		params.menu = "true";

		// Attributes
		var attributes = {};

		// Call SWFobject
		if(type=="large")
			swfobject.embedSWF("player.swf", "playerdiv", "380", "70", "7.0.0", false, flashvars, params, attributes);
		else
			swfobject.embedSWF("player-small.swf", "playerdiv", "200", "70", "7.0.0", false, flashvars, params, attributes);
}

