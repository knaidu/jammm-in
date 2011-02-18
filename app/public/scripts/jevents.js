
JEvent.runAll = function(){
	$H(JEvent.list).keys().each(function(e){
		JEvent.list[e]();
	});
}.bind(JEvent);

JEvent.list.addOnHoverRowSelect = function() {
	$j(".highlight-row").live("mouseover", function(){
		$j(this).addClass("onhover");
	});
	
	$j(".highlight-row").live("mouseout", function(){
		$j(this).removeClass("onhover");
	});
}.bind(JEvent.list);

JEvent.list.addOnHoverContextMenuItem = function() {
	$j(".context-menu .highlight").live("mouseover", function(){
		$j(this).addClass("onhover");
	});
	
	$j(".context-menu .highlight").live("mouseout", function(){
		$j(this).removeClass("onhover");
	});
}.bind(JEvent.list);


JEvent.list.toogleDocItemClass = function(){
	$j(".player .item").live("mouseover", function(){
		$j(this).addClass("item-onhover");
//		$j(".player .item .image").css({opacity: 1});
	});
	
	$j(".player .item").live("mouseout", function(){
		$j(this).removeClass("item-onhover");
//		$j(".player .item .image").css({opacity: 0.8});
	});
}.bind(JEvent.list)

JEvent.list.smartFormFields = function() {
	$j("[onedit=blur]").live('blur', function(){
		General.saveSmartFieldValue(this);
	});
	
	$j("[onedit=change]").live('change', function(){
		General.saveSmartFieldValue(this);
	});
	
}.bind(JEvent.list);

JEvent.list.higlightJamOnSelect = function() {
	$j(".song-manage-page.jams .jam INPUT[type=checkbox]").live('change', function(){
		var fn = $(this).checked ? "addClassName" : "removeClassName";
		$j(this).parents()[1][fn]("selected");
		var img = this.parentNode.parentNode.findDescendantsByClassName("waveform-image")[0];
		waveformUrl = $(this).checked ? img.getAttribute("waveform2") : img.getAttribute("waveform");
		img.src = waveformUrl;
	})
}.bind(JEvent.list);

JEvent.list.highlightLinks = function() {
	$j(".link").live('mouseover', function(){
		$j(this).addClass("red important");
	})
	
	$j(".link").live('mouseout', function(){
		$j(this).removeClass("red");
	})
}.bind(JEvent.list);

JEvent.list.mouseDownOnButton = function() {
	$j(".button").live('mousedown', function() {
		$j(this).addClass("down");
	});
	
	$j(".button").live('mouseup', function() {
		$j(this).removeClass("down");
	});

	$j(".button").live('mouseout', function() {
		$j(this).removeClass("down");
	});

}.bind(JEvent.list);

JEvent.list.onClickPlay = function() {
	$j("[play]").live('click', function(){Flash.startOperations(this)})
}.bind(JEvent.list);


JEvent.list.sizeWaveform = function() {
	var resize = function() {
		var parent = $j(this).parents()[1];
		var width = parent.getWidth();
		var height = parent.getHeight();
		$j(this).css({width: width, height: height});
		$j(parent).css({width: width, height: height});
	};
	$j(".seek .waveform-image").livequery(resize);
}.bind(JEvent.list);


JEvent.list.onClickMore = function() {
	$j(".more").live('click', function() {
		General.onClickMore(this);
	});
}.bind(JEvent.list);

JEvent.list.highlightNavigationItem = function() {
	$j(".navigation-bar").hover(function() {
		$j(".navigation-bar .images .image:first-child").addClass("highlight");
	}, function() {
		$j(".navigation-bar .images .image:first-child").removeClass("highlight")
	});
}.bind(JEvent.list);


JEvent.list.onhoverFeedShowHiddenItems = function() {
	$j(".feeds .feed").live('mouseover', function(){
		$j("[onhovershow=true]", this).show();
	})
	
	$j(".feeds .feed").live('mouseout', function(){
		$j("[onhovershow=true]", this).hide();
	})
}.bind(JEvent.list);