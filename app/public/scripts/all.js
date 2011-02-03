var Layout = {ContextMenu: {}, RightPanel: {}};
var Navigate = {states: []};
var Modal = {};
var Doc = {Player: {}, Playlist: {}, Notifications: {}, Messages: {}};
var JEvent = {list: {}}; // 'list' is treated as an array. In the sense, on load all keys in 'list' are itereated over and run.
var General = {Comment: {}};

Layout.onReady = function(){
	if($("content-panel")){
		this.showStructure();
		Navigate.saveHomeState();
		Modal.setup();
	}
	JEvent.runAll();
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
	this.attachScrollJEvent();
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

Layout.attachScrollJEvent = function() {
	$("content-panel").addEventListener('DOMMouseScroll', this.manageScrollJEvent, false);
	$("content-panel").addEventListener('mousewheel', this.manageScrollJEvent, false);
}.bind(Layout);

Layout.manageScrollJEvent = function(e){
	var detail = e.wheelDelta ? -(e.wheelDelta / 60) : e.detail; 
	var moveBy = -(30 * detail);
	var content = this.contentPanel.children()[0];
	var top = parseInt(content.style.top.replace("px", "")) + moveBy;
	if (top > 0) top = 0;
	content.style.top = top + "px";
}.bind(Layout);

Layout.ContextMenu.get = function() {
	return $j("#context-menu");
}.bind(Layout.ContextMenu);

Layout.ContextMenu.load = function(url) {
	updateEl(this.get()[0], url);
}.bind(Layout.ContextMenu);

Layout.ContextMenu.insertLoadingText = function() {
	var html = "<img style='padding-left: 10px; padding-right: 10px; padding-top: 5px;' src='/new-ui/loading.gif'> <font color='#aaa'>Loading ...</font>";
	this.insertHTML(html);
}.bind(Layout.ContextMenu);

Layout.ContextMenu.insertHTML = function(html) {
	this.get().html(html);
}.bind(Layout.ContextMenu);

Layout.RightPanel.get = function() {
	return $j("#right-panel");
}.bind(Layout.RightPanel);

Layout.RightPanel.load = function(url) {
	updateEl(this.get()[0], url);
}.bind(Layout.RightPanel);

Layout.RightPanel.insertLoadingText = function() {
	var html = "<img style='padding-left: 10px; padding-right: 10px; padding-top: 5px;' src='/new-ui/loading.gif'> <font color='#aaa'>Loading ...</font>";
	this.insertHTML(html);
}.bind(Layout.RightPanel);

Layout.RightPanel.insertHTML = function(html) {
	this.get().html(html);
}.bind(Layout.RightPanel);

/* Navigate */

var State = Class.create({
	initialize: function(attrs){
		var me = this;
		$H(attrs).keys().each(function(k){
			me[k] = attrs[k];
		});
	}
});

Navigate.saveHomeState = function(){
	var state = new State({name: "jamMm.in Home", description: "", url: "/home"}); 
	this.setCurrentState(state);
}.bind(Navigate);

Navigate.loadContent = function(url){
	var options = arguments[1] || {direction: "left"};
	var children = $j(".content-panel").children();
	var callback = function(e){
		if(children.size())
			$(children[0]).remove();
		var div = new Element("div", {style: "position: relative; padding-left: 10px; padding-top: 0px;"});
		$("content-panel").insert(div, "bottom");
//		div.absolutize();
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
	
	if(this.currentState.context_menu){
		Layout.ContextMenu.insertLoadingText();
		Layout.ContextMenu.load(this.currentState.context_menu);
	}
	
	if(this.currentState.right_panel){
		Layout.RightPanel.load(this.currentState.right_panel);		
	}
}.bind(Navigate)

Navigate.storeState = function(){
	if(!$j(".content-panel .state").size()) // return if there is no state available in the page
		return;
	
	var state = {};
	var children = $j(".content-panel .state").children();
	$A(children).each(function(i){
		state[i.className] = i.innerHTML;
	});
	
	if(state.url == this.currentState.url) // return if the new page is same as present page.
		return;

	if(this.currentState)
		this.saveState(this.currentState);
	this.setBackButton();		
		
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

Navigate.reload = function() {
	this.loadContent(this.currentState.url);
}.bind(Navigate);

/* Modal */
Modal.get = function(){
	return $j("#basic-modal-content");
}.bind(Modal);

Modal.getDataContainer = function() {
	return $j("#simplemodal-container .simplemodal-data");
};

Modal.setup = function(){
}.bind(Modal)

Modal.show = function(){
	var config = arguments[0] || {};
	var d = this.get();
//	d.center();
	this.cmp = d.modal(config);
}.bind(Modal)

Modal.load = function(url){
	var defaultConfig = {minHeight: 300, minWidth: 450};
	var config = arguments[1] || {}
	config = mergeHash(defaultConfig, config);
	this.show(config);
	var d = this.get();
	updateEl($j("#simplemodal-container .simplemodal-data")[0], url);
}.bind(Modal);


Modal.close = function(){
	if(this.cmp)
		this.cmp.close();
}.bind(Modal)

Modal.center = function(){
	this.get().center();
}.bind(Modal);

Modal.showWaitingText = function() {
	var msg = arguments[0] || "Please wait ...";
	var d = new Element("div", {class: "modal-text"});
	d.innerHTML = msg;
	var di = new Element("div", {style: "margin-top: 10px"});
	di.innerHTML = "<img src='/new-ui/ajax-loader.gif'>";
	this.show({minHeight: "80px", minWidth: "350px"});
	var dataContainer = this.getDataContainer();
	dataContainer.append(d);
	dataContainer.append(di);
}.bind(Modal);

Modal.alert = function(msg) {
	var d = new Element("div", {class: "modal-text"});
	d.innerHTML = msg;
	this.show({minHeight: "80px", minWidth: "250px"});
	var dataContainer = this.getDataContainer();
	dataContainer.append(d);
}.bind(Modal);

Modal.slowAlert = function(msg) {
	var fn = function(){Modal.alert(msg)}
	window.setTimeout(fn, 1000);
}.bind(Modal);

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


/* General */
General.saveSmartFieldValue = function(el){
	var onSuccess = function() {
		var left = $j(el).offset().left + $(el).getWidth() + 20;
		var top = $j(el).offset().top;
		var div = new Element("div", {style: 'position: fixed;'});
		var jd = $j(div);
		div.innerHTML = "<img src='/new-ui/tick.png' height='16px'>";
		jd.insertAfter($j(document.body));
		jd.show();
		jd.css({left: left, top: top});
		window.setTimeout(function() {
			$j(div).hide('slow');
		}, 1000)
	};
	var url = el.getAttribute("run");
	call(url, {method: 'post', onSuccess: onSuccess, parameters: {
		value: $(el).getValue()
	}});
}.bind(General);


/* INSTRUMENTS */
function reload_manage_instruments(container_div, for_type, for_type_id){
	var url = formatUrl("/partial/common/manage_instruments", {for_type: for_type, for_type_id: for_type_id});
	updateEl(container_div, url);
}

function add_instrument(select_div_id, container_div, for_type, for_type_id){
	var select = $(select_div_id);
	url = formatUrl("/instrument/add", {for_type: for_type, for_type_id: for_type_id, instrument_id: select.getValue()});
	var onComplete = function() {
		reload_manage_instruments(container_div, for_type, for_type_id)
	}
	call(url, {onComplete: onComplete});
}

function remove_instrument(id, container_div, for_type, for_type_id){
	var url = formatUrl("/instrument/remove", {contains_instrument_id: id});
	var onComplete = function() {
		reload_manage_instruments(container_div, for_type, for_type_id)
	};
	call(url, {onComplete: onComplete});
}

/* COMMENTS */
General.Comment.add = function() {
	var url = formatUrl('/comments/add', {
		for_type: $j("[name=for_type]").val(),
		for_type_id: $j("[name=for_type_id]").val(),
		comment: $j("[name=comment]").val()
	});
	
	var onSuccess = function(t) {
		$j(".comments").append(t.responseText);
		$j("[name=comment]").val('');
	};
	
	call(url, {method: 'post', onSuccess: onSuccess})
}.bind(General.Comment);