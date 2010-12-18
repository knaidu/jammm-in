var Layout = {};
var Navigate = {states: []};

Layout.onReady = function(){
	this.showStructure();
	
}.bind(Layout);

$j(document).ready(Layout.onReady);

Layout.showStructure = function(){
	var c = this.getMiddleBar();
	var height = this.getWindowSize().height - this.getTopBar().height();
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

Navigate.saveHomeState = function(){
	this.saveState({name: "Home", description: "Desc is here", url: "/home"})
}.bind(Navigate);

Navigate.loadContent = function(url){
	updateEl("content-panel", url, {onSuccess: function(){window.setTimeout(Navigate.storeState, 500)}});
}.bind(Navigate);

Navigate.storeState = function(){
	this.saveState({
		name: $j(".content-panel .state .name"),
		description: $j(".content-panel .state .name"),
		url: $j(".content-panel .state .url")
	})
}.bind(Navigate);

Navigate.saveState = function(state){
	this.states.push(state);
}.bind(Navigate);