var Layout = {};
var Navigate = {states: []};
var Dialog = {};
var Doc = {Player: {}};

Layout.onReady = function(){
	this.showStructure();
	Navigate.saveHomeState();
	Dialog.setup();
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
		var div = new Element("div", {style: "padding-top: 20px"});
		$("content-panel").insert(div, "bottom");
		updateEl(div, url, {onSuccess: function(){window.setTimeout(Navigate.storeState, 500)}});		
	}

	if(children.size()){
		children[0].absolutize();
		if(options.direction == 'left')
			children.animate({left: "-" + children.width() + "px"}, 1000, callback);
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
	this.get().animate({height: 300}, "slow");
}.bind(Doc.Player);

Doc.Player.collapse = function(){
	this.get().animate({height: 30}, "slow");
}.bind(Doc.Player);