var Layout = {};
var Navigate = {states: []};
var Dialog = {};

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
	c.children().first().height(height);
	c.width(width);
	c.fadeIn();
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
	this.setCurrentState(new State({name: "Home", description: "Desc is here", url: "/home"}))
}.bind(Navigate);

Navigate.loadContent = function(url){
	var options = arguments[1] || {direction: "left"};
	var child = $j(".content-panel").children();
	var callback = function(e){
		ttt= child;
		if(child.size())
			$(child[0]).remove();
		updateEl("content-panel", url, {onSuccess: function(){window.setTimeout(Navigate.storeState, 500)}});		
	}
	if(child.size()){
		child[0].absolutize();
		if(options.direction == 'left')
			child.animate({left: "-" + child.width() + "px"}, 1000, callback);
		else
			child.fadeOut('slow', callback);
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
		description: $j(".content-panel .state .name").html(),
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
};

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
}.bind(Dialog)