var Layout = {ContextMenu: {}, RightPanel: {}};
var Navigate = {states: []};
var Modal = {};
var Doc = {Player: {}, Playlist: {}, Notifications: {}, Messages: {}, Login: {}};
var JEvent = {list: {}}; // 'list' is treated as an array. In the sense, on load all keys in 'list' are itereated over and run.
var General = {Comment: {}, Tabs: {}, List: {}, Overview: {}, User: {}};
var Playlist = {list: [], position: false};

Layout.onReady = function(){
	if($("content-panel")){
		this.showStructure();
		this.load();
//		Navigate.saveHomeState();
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

Layout.load = function() {
	var hash = window.location.hash;
	if(hash.blank())
		this.loadOverview();
}.bind(Layout);

Layout.loadOverview = function() {
	Navigate.loadContent("/partial/homepage/overview")
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

Layout.ContextMenu.empty = function() {
	this.get().html("");
}.bind(Layout.ContextMenu);

Layout.ContextMenu.load = function(url) {
	var onSuccess = function() {
		window.setTimeout(this.drawTree, 400)
	}.bind(this);
	updateEl(this.get()[0], url, {onSuccess: onSuccess});
}.bind(Layout.ContextMenu);

Layout.ContextMenu.reload = function() {
	this.load(Navigate.currentState.context_menu);
}.bind(Layout.ContextMenu);

Layout.ContextMenu.insertLoadingText = function() {
	var html = "<img style='padding-left: 10px; padding-right: 10px; padding-top: 5px;' src='/new-ui/loading.gif'> <font color='#aaa'>Loading ...</font>";
	this.insertHTML(html);
}.bind(Layout.ContextMenu);

Layout.ContextMenu.insertHTML = function(html) {
	this.get().html(html);
}.bind(Layout.ContextMenu);

Layout.ContextMenu.drawTree = function() {
	var draw = function(el) {
		var subs = $(el).getElementsBySelector(".sub");
		var parents = $A(subs).map(function(i){return i.parentNode}).uniq();
		$A(parents).each(function(p) {
			var subs = $(p).getElementsBySelector(".sub");
			var count = $A(subs).size();
			var height = (count * 31) - 13;
			var vline = new Element('div');
			$j(vline).css({position: 'absolute', borderLeft: '1px dotted #aaa', top: 34, left: 22, height: height});
			$j(p).append(vline);

			$A(subs).each(function(sub) {
				var hline = new Element('div');
				$j(hline).css({position: "absolute", width: 17, borderBottom: '1px dotted #aaa', top: 15, left: 22});
				$j(sub).append(hline);
			});
		});
	};
	$A($j(".context-menu .item")).each(function(el) {draw(el)});
}.bind(Layout.ContextMenu);


Layout.RightPanel.get = function() {
	return $j("#right-panel");
}.bind(Layout.RightPanel);

Layout.RightPanel.load = function(url) {
	var d = new Element('div', {style: "padding: 0px 20px"});
	var l = Layout.RightPanel.get();
	l.html("");
	l.append(d);
	$j(d).html(General.loadingText());
 	url != "false" ? updateEl(d, url) : true;
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
		$j(div).html(General.loadingText());
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
	
	if(this.currentState.context_menu == 'false'){
		Layout.ContextMenu.empty();
	}
	else if(this.currentState.context_menu){
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
	
	if(this.currentState && state.url == this.currentState.url) // return if the new page is same as present page.
		return;

	if(this.currentState)
		this.saveState(this.currentState);
	this.setBackButton();		
		
	this.setCurrentState(new State(state));

	// Used to either hide or show the navigation bar. Navigation bar is only shown when there are items in the stack
	var bar = $j(".navigation-bar");
	(this.states.size() > 0) ? bar.show('slow') : bar.hide('slow');

}.bind(Navigate);

Navigate.saveState = function(state){
	this.states.push(state);
}.bind(Navigate);

Navigate.setBackButton = function(){
	var state = $A(this.states).last();
	if(!state) return;
	var states = $A(this.states).slice(-3).reverse();
	var opacity = 1.0;
	var right = 0;
	var images = $j(".navigation-bar .images");
	images.html("");
	$A(states).each(function(state) {
		var d = new Element('div');
		$j(d).css({right: right, opacity: opacity, top: top});
		d.addClassName("image");
		
		var img = new Element('img');
		img.src = state.img;
		d.appendChild(img);
		
		$j(".navigation-bar .images")[0].appendChild(d);
		opacity -= 0.3; right += 60;
	})
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
	var d = new Element("div");
	d.addClassName("modal-text");
	d.innerHTML = msg;
	var di = new Element("div", {style: "margin-top: 10px"});
	di.innerHTML = "<img src='/new-ui/ajax-loader.gif'>";
	this.show({minHeight: "80px", minWidth: "350px"});
	var dataContainer = this.getDataContainer();
	dataContainer.append(d);
	dataContainer.append(di);
}.bind(Modal);

Modal.alert = function(msg) {
	var d = new Element("div");
	d.addClassName("modal-text");
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
	return $j(".player-container");
}.bind(Doc.Player);

Doc.Player.expand = function(){
	Doc.Player.show();
	var url = arguments[0] || false;
	var callback = function(){
		if(url){
			var el = this.get()[0];
			$j(el).html("<div class='s11' style='padding: 10px'>Loading...</div>");
			updateEl(el, url);
		}
	}.bind(this);
	this.get().animate({height: 300}, "slow", callback);
}.bind(Doc.Player);

Doc.Player.collapse = function(){
	this.get().animate({height: 20}, "slow", function() {
		updateEl(Doc.Player.get()[0], "/partial/body/actions_doc");
		if(!Flash.isPlaying()) Doc.Player.hide();
	});
}.bind(Doc.Player);

Doc.Player.show = function() {
	this.get().show();
}.bind(Doc.Player);

Doc.Player.hide = function() {
	this.get().fadeOut();
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

Doc.reload = function() {
	var el = $j(".actions-doc")[0];
	updateEl(el, "/partial/body/doc_icons");
}.bind(Doc);


Doc.Login.show = function() {
	Doc.Player.expand("/signin");
}.bind(Doc.Login);


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

General.onClickMore = function(el) {
	aaa = el;
	var id = $(el).getAttribute("moreref");
	var container = $(id);
	$j(el).hide();
	var prevHeight = container.getHeight();
	container.style.height = '';
	var newHeight = container.getHeight();
	container.style.height = prevHeight + "px";
	$j(container).animate({height: newHeight}, 500);
}.bind(General);

/* TABS */
General.Tabs.setup = function(container) {
	var el = $j("#" + container);
	var children = $A(el.children());
	
	var rightTab = $A(el.children()).pop();
	var tabs = $j("#" + container + " .tab");
	children.pop();
	var widths = $A(children).map(function(i) {return i.getWidth()}).sum();
	var width = el.width() - widths - 10;
	$j(rightTab).width(width);
	tabs.click('click', function() {
		General.Tabs.loadTab(this);
	});
	this.loadTab(tabs[0]); // Loads the First Tab
}.bind(General.Tabs);

General.Tabs.loadTab = function(el) {
	parent = $j(el).parent();
	var contentDivId = $j(el).parent()[0].getAttribute('contentdivid');
	updateEl(contentDivId, el.getAttribute('url'));
	var tabs = $j("#" + parent[0].id + " .tab");
	tabs.removeClass("selected");
	$j(el).addClass("selected");
}.bind(General.Tabs);

/* SEARCH LIST FILTER */
General.List.filter = function(list, searchStr) {
	var toshow = [];
	var tohide = [];
	$A(list).each(function(u) {
		var fields = u.findDescendantsByClassName('search-field');
		var show = $A(fields).any(function(el) {return el.innerHTML.toLowerCase().include(searchStr)});
		show ? toshow.push(u) : tohide.push(u)
	});
	$j(tohide).hide();
	$j(toshow).show();
}.bind(General.List);

General.List.filter.monitor = function(el) {
	el = $(el);
	var onkeyup = function() {
		if(el.keyuptimer) clearTimeout(el.keyuptimer);
		var fn = eval(el.getAttribute("filterfn"));
		el.keyuptimer = window.setTimeout(function() {fn(el.value)}, 300);
	};
	$j(el).keyup(onkeyup)
}.bind(General.List.filter);

General.resizeWaveforms = function() {
	var resize = function(el) {
		var parent = $j(el).parents()[1];
		var width = parent.getWidth();
		var height = parent.getHeight();
		$j(el).css({width: width, height: height});
		$j(parent).css({width: width, height: height});
		el.setAttribute("resized", true)
	};
	var imgs = $j(".waveform-image[resized!=true]");
	$A(imgs).each(function(i){resize(i)});
}.bind(General);

General.download = function(fileHandle) {
	window.location = "/file/" + fileHandle;
}.bind(General);

General.login = function() {
	var onSuccess = function() {	
		Doc.reload();
		Doc.Player.collapse();
		Navigate.loadContent("/account");
	};
	
	var onFailure = function(t) {
		$j(".error-response").html(t.responseText);
	};
	var params = {
		username: $j("[name=username]").val(),
		password: $j("[name=password]").val()
	};
	$j(".player .error-response").html("<img src='/new-ui/loading.gif'");
	call('/signin/process', {parameters: params, method: 'post', onSuccess: onSuccess, onFailure: onFailure});
}.bind(General);

General.logout = function() {
	Navigate.loadContent("/account/logout");
}.bind(General);

/* Playlist */
Playlist.get = function() {
	var onSuccess = function(t) {
		this.list = t.evalJSON();
	}.bind(this);
	call("/playlist", {onSuccess: onSuccess});
}.bind(Playlist);


/* GENERAL */

General.loadingText = function() {
	return "<img style='padding-left: 10px; padding-right: 10px; padding-top: 5px;' src='/new-ui/loading.gif'> <font color='#aaa'>Loading ...</font>";
}.bind(General);

General.Overview.animateItems = function() {
	$j(".overview .item").hover(function() {
		$j(this).animate({paddingLeft: 130})
	}, function() {
		$j(this).animate({paddingLeft: 15})
	})
}.bind(General.Overview);


General.Overview.getOverlay = function() {
	return $j("#overview-overlay");
}.bind(General.Overview);

General.Overview.setup = function() {
	this.show(this.showWhat);
;}.bind(General.Overview);

General.Overview.show = function() {
	var callback = arguments[0] || function() {};
	this.getOverlay().center().fadeIn(callback);
;}.bind(General.Overview);


General.Overview.close = function() {
	this.getOverlay().fadeOut();
;}.bind(General.Overview);


General.Overview.showWhat = function() {
	var el = this.getOverlay();
	var fn = function() {
		updateEl(el[0], "/partial/homepage/overview_what");
	}.bind(this);
	el[0].visible() ? fn() : this.show(fn)
}.bind(General.Overview);


General.Overview.showWhy = function() {
	var el = this.getOverlay();
	var fn = function() {
		updateEl(el[0], "/partial/homepage/overview_why");
	}.bind(this);
	el[0].visible() ? fn() : this.show(fn)
}.bind(General.Overview);

/* FOLLOW UN FOLLOW */
General.User.follow = function(username) {
	var onSuccess = function() {
		Modal.alert("You are now following " + username);
		Layout.ContextMenu.reload();
	};
	call("/" + username + "/follow", {method: 'post', onSuccess: onSuccess})
}.bind(General.User);

General.User.unfollow = function(username) {
	call("/" + username + "/unfollow", {method: 'post', onSuccess: Layout.ContextMenu.reload})
}.bind(General.User);


General.User.sendMessage = function(username) {
	var url = "/" + username + "/send_message";
	Modal.load(url, {minHeight: 215, minWidth: 380})
}.bind(General.User);


General.User.sendMessage.submit = function(id1, id2) {
	var body = $j("[name=message-textarea]").val();
	$j("[name=send-message-status] .waiting-message").show();
	General.addMessageStreamPost(id1, id2, body, Modal.close)
}.bind(General.User.sendMessage);

General.User.postViaMessageStream = function(id1, id2) {
	var body = $j("[name=post-message-text-area]").val();
	var onSuccess = function(t) {
		var id = t.evalJSON().id;
		this.updatePostInList(id)
	}.bind(this);
	General.addMessageStreamPost(id1, id2, body, onSuccess);
}.bind(General.User);

General.User.updatePostInList = function(id) {
	var onSuccess = function(t) {
		$j(".user-messages").append(t.responseText)
	};
	var url = formatUrl('/message_stream/message', {id: id})
	call(url, {onSuccess: onSuccess});
}.bind(General.User);

/* Account */
General.User.loadHome = function() {
	Navigate.loadContent('/account');
}.bind(General.User);


/* GENERAL SEND MESSAGE FUNCTION */
General.addMessageStreamPost = function(id1, id2, body) {
	var callback = arguments[3] || function() {};
	var onFailure = arguments[4] || function() {};
	var url = formatUrl("/message_stream/new_post");
	call(url, {method: 'post', onSuccess: callback, onFailure: onFailure, parameters: {user_ids: id1+","+id2, body: body}})
}.bind(General);
