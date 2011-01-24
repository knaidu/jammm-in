var Layout = {};
var Navigate = {states: []};
var Dialog = {};
var Doc = {Player: {}, Playlist: {}, Notifications: {}, Messages: {}};
var Event = {};

Layout.onReady = function(){
	this.showStructure();
	Navigate.saveHomeState();
	Dialog.setup();
	Event.runAll();
}.bind(Layout);

$j(document).ready(Layout.onReady);

Layout.showStructure = function(){
	var c = this.getMiddleBar();
	var height = this.getWindowSize().height - this.getTopBar().height() - $j(".bottom-bar").height();
	var width = this.getWindowSize().width;
	c.height(height);
	c.children().height(height);
	c.width(width);
	c.fadeIn();
	Doc.Player.collapse();
	this.attachScrollEvent();
	this.contentPanel = this.getContentPanel();
}.bind(Layout);

Layout.getWindowSize = function(){
	return {height: $j(window).height(), width: $j(window).width()};
}.bind(Layout);

Layout.getMiddleBar = function(){
	return $j(".middle-bar");
}.bind(Layout);

Layout.getTopBar = function(){
	return $j(".top-bar");
}.bind(Layout);

Layout.getContentPanel = function(){
	return $j("#content-panel");
}.bind(Layout)

Layout.attachScrollEvent = function() {
	$("content-panel").addEventListener('DOMMouseScroll', this.manageScrollEvent, false);
	$("content-panel").addEventListener('mousewheel', this.manageScrollEvent, false);
}.bind(Layout);

Layout.manageScrollEvent = function(e){
	eee = e;
	var detail = e.wheelDelta ? -(e.wheelDelta / 60) : e.detail; 
	var moveBy = -(30 * detail);
	var content = this.contentPanel.children()[0];
	var top = parseInt(content.style.top.replace("px", "")) + moveBy;
	if (top > 0) top = 0;
	content.style.top = top + "px";
}.bind(Layout);

/* Navigate */

var State = Class.create({
	initialize: function(attrs){
		this.name = attrs.name;
		this.description = attrs.description;
		this.url = attrs.url;
	}
});

Navigate.saveHomeState = function(){
	this.setCurrentState(new State({name: "Back", description: "Go Back", url: "/home"}))
}.bind(Navigate);

Navigate.loadContent = function(url){
	var options = arguments[1] || {direction: "left"};
	var children = $j(".content-panel").children();
	var callback = function(e){
		if(children.size())
			$(children[0]).remove();
		var div = new Element("div", {style: "padding-left: 10px; padding-top: 11px"});
		$("content-panel").insert(div, "bottom");
		div.absolutize();
		div.style.top = "0px";
		updateEl(div, url, {onSuccess: function(){window.setTimeout(Navigate.storeState, 500)}});		
	}

	if(children.size()){
		children[0].absolutize();
		if(options.direction == 'left')
			children.animate({left: "-" + children.width() + "px"}, 200, callback);
		else
			children.fadeOut('slow', callback);
	}
	else
		callback();
}.bind(Navigate);

Navigate.setCurrentState = function(state){
	this.currentState = new State(state);
}.bind(Navigate)

Navigate.storeState = function(){
	if(!$j(".content-panel .state").size()) // return if there is no state available in the page
		return;
	if(this.currentState)
		this.saveState(this.currentState);
	this.setBackButton();
	var state = {
		name: $j(".content-panel .state .name").html(),
		description: $j(".content-panel .state .description").html(),
		url: $j(".content-panel .state .url").html()
	};
	if(state.url == this.currentState.url) // return if the new page is same as present page.
		return;
	this.setCurrentState(new State(state));
}.bind(Navigate);

Navigate.saveState = function(state){
	this.states.push(state);
}.bind(Navigate);

Navigate.setBackButton = function(){
	var state = $A(this.states).last();
	$j(".navigation-bar .content .name").html(state.name);
	$j(".navigation-bar .content .description").html(state.description);
	$j(".navigation-bar .content .url").html(state.url);
}.bind(Navigate);

Navigate.back = function(){
	var state = this.states.pop();
	this.currentState = false; // Made to false so that the current state does not get pushed to stack
	this.loadContent(state.url, {direction: "right"});
	this.setBackButton();
}.bind(Navigate);

/* Dialog */
Dialog.get = function(){
	return $j(".dialog");
}.bind(Dialog)

Dialog.setup = function(){
	var d = this.get();
	d.bind('resize', function(){d.center()});
	d.center();
}.bind(Dialog)

Dialog.show = function(){
	var d = this.get();
	d.show('slow', this.center);
}.bind(Dialog)

Dialog.load = function(url){
	this.show();
	var d = this.get();
	d.html("");
	updateEl(d[0], url, {onComplete: this.center});
}.bind(Dialog)

Dialog.hide = function(){
	var d = this.get();
	d.hide('slow');
}.bind(Dialog)

Dialog.center = function(){
	this.get().center();
}.bind(Dialog);

/* Doc Functions */

Doc.get = function(){
	return $j(".actions-docs");
}.bind(Doc);

Doc.Player.get = function(){
	return $j(".player");
}.bind(Doc.Player);

Doc.Player.expand = function(){
	var url = arguments[0] || false;
	var callback = function(){
		if(url)
			updateEl(this.get()[0], url);
	}.bind(this);
	this.get().animate({height: 300}, "slow", callback);
}.bind(Doc.Player);

Doc.Player.collapse = function(){
	this.get().animate({height: 15}, "slow");
}.bind(Doc.Player);

Doc.Playlist.show = function() {
	Doc.Player.expand("/dock/playlist");
}.bind(Doc.Playlist);

Doc.Notifications.show = function() {
	Doc.Player.expand("/dock/notifications");
}.bind(Doc.Notifications);

Doc.Messages.show = function() {
	Doc.Player.expand("/dock/messages");
}.bind(Doc.Messages);

Event.runAll = function(){
	this.addOnHoverRowSelect();
	this.setListRowsHeight();
	this.toogleDocItemClass();
}.bind(Event);

Event.addOnHoverRowSelect = function() {
	$j(".jams .jam").live("mouseover", function(){
		$j(this).addClass("onhover");
	});
	
	$j(".jams .jam").live("mouseout", function(){
		$j(this).removeClass("onhover");
	});
}.bind(Event);


Event.setListRowsHeight = function(){
	$j(".list .rows").livequery(function(){
		var height = $(Layout.getContentPanel()[0]).getHeight() - ($($j(".list .list-header")[0]).getHeight() + $j(".list .column-headers").height());
		$j(this).height(height);
	});
}.bind(Event);

Event.toogleDocItemClass = function(){
	$j(".player .item").live("mouseover", function(){
		$j(this).addClass("item-onhover");
//		$j(".player .item .image").css({opacity: 1});
	});
	
	$j(".player .item").live("mouseout", function(){
		$j(this).removeClass("item-onhover");
//		$j(".player .item .image").css({opacity: 0.8});
	});
}.bind(Event)