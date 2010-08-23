
var GLOBAL = {playerType: "large", selectedMenuItem: false, Slider: {}};

/* INIT */

// This is executed after the page has been loaded

window.onload = function(){

  window.setTimeout(expandContentPanel, 200);
	window.setTimeout(styleMenuItems, 10);
}

/* Layout */

function expandContentPanel(){
  var el = $('content-panel');
	if(!el) return;
  var height = el.ancestors()[0].getHeight();
  el.style.minHeight = (height + "px");
}

/* MENU */

function styleMenuItems(){
	/*
	var menuItemsSections = document.getElementsByClassName('menu-items');
	if($A(menuItemsSections).size() == 0) 
		return;
	$A(menuItemsSections).each(function(menuItemsSections){
		var menuItemsSection = menuItemsSections.getElementsByClassName('menu-item');
		$A(menuItemsSection).each(styleMenuItem);
	});
	*/
	if(GLOBAL.selectedMenuItem)
		styleSelectedMenuItem(GLOBAL.selectedMenuItem);
}

// The below functions are kept, if IE fixes are needed
function styleMenuItem(item){
	return;
	var item = $(item);
	var textItem = item.getElementsByClassName("text")[0];
	
	$(item).observe('mouseover', function(){
		if (!$A(item.classNames()).include('menu-item-hover')){
			item.addClassName("menu-item-hover") 
		}
	});
	
	$(item).observe('mouseout', function(){
		if ($A(item.classNames()).include('menu-item-hover'))
			item.removeClassName("menu-item-hover") 
	});
}

function styleSelectedMenuItem(itemId){
	var item = $(itemId);
	if(!item) return;
	var prevSelectedItems = $A(document.getElementsByClassName('menu-item-selected'));
	$A(prevSelectedItems).each(function(pItem){
		pItem.removeClassName('menu-item-selected');
	})
	item.addClassName('menu-item-selected');
}

function setSelectedMenuItem(id){
	GLOBAL.selectedMenuItem = id;
}



/* Debug */

function log(message){
	try{
		if(console && console.log) console.log(message)	
	}catch(e){}
}

function loadUrl(url){
  window.location = url;
}

function reload(){
	window.location = window.location.href;
}

function mergeHash(hash1, hash2){
	return $H(hash1).update(hash2).toObject();
}

function loadAccountMessages(){
	loadUrl("/account/messages")
}

// Redirects to a particular song page
function loadSong(id){
  if(!id) return;
  loadUrl("/song/" + id);
}

function loadSongManage(id){
  if(!id) return;
  loadUrl("/song/" + id + "/manage");
}

// Redirects to a particular song page
function loadJam(id){
  if(!id) return;
  loadUrl("/jam/" + id);
}

function loadJamManage(id){
  if(!id) return;
  loadUrl("/jam/" + id + "/manage");
}

function formatController(){
	return ("/" + $A(arguments).map(function(arg){return arg}).join("/"));
}

/* General */

function showLoadingMessage(id){
	var el = $(id);
	if(!el) return;
	var message = "<span class='text'>" + (arguments[1] || "Please wait...") + "</span>";
	var loadingImgPath = "/images/icons/loading.gif";
	el.innerHTML = "<img src='"+ loadingImgPath +"' height=16> " + message;
}

/* Messages */

function addMessage(formId){
  var form = $(formId);
  if(!form) return;
  var users = form.findElementByName('user_ids').value;
  var divId = form.findElementByName('div_id').value;
  var responseDivId = form.findElementByName('response_div_id').value;
	var full = form.findElementByName('full')
	if(full) full = full.value;
  form.request({
    onSuccess: function(){loadMessageStream(users, divId, full)},
    onFailure: loadResponseFn(responseDivId)
  });
}

function loadMessage(id, message, className){
  var el = $(id);
  if(!el) return;
  var div = new Element('div');
  el.addClassName('text-center text');
  div.insert(message);
  div.addClassName(className);
  var items = ["<center>", "<br>", div, "<br>", "</center>"];     
  el.innerHTML = '';
  $A(items).each(function(item){el.insert(item)});
  window.setTimeout(function(){el.innerHTML = ''}, 4000); // empties the window after 2 seconds
}

function loadMessageStream(users, divId, full){
  var url = formatUrl('/message_stream/show', {user_ids: users, full: full});
	updateEl(divId, url)
}

function markMessageStreamAsRead(users, divId, full){
	if(full == 'false') full = false;
  var url = formatUrl("/message_stream/mark_as_read", {user_ids: users});
  call(url, {onSuccess: function(){loadMessageStream(users, divId, full)}})
}

function loadSuccessMessage(id, message){  
	loadMessage(id, message, "success-message");
}

function loadFailureMessage(id, message){
	loadMessage(id, message, "failure-message");
}

function loadResponseFn(id){
	return function(response){loadResponseMessage(response, id)};
}

function loadResponseMessage(response, id){
  var messageType = response.transport.status == 200 ? "success-message" : "failure-message";
  loadMessage(id, getResponseText(response.transport), messageType);
}

/* Comments */

function displayComments(for_type, for_type_id, comments_div_id){
	var params = {for_type: for_type, for_type_id: for_type_id, comments_div_id: comments_div_id};
	var url = formatUrl('/comments/fetch', params);
	updateEl(comments_div_id, url);
}

function addComment(formId){
	var form = $(formId);
	if(!form) return;
	var getValueOf = function(name){
		var el = $A(form.getElements()).find(function(i){return i.name == name});
		if(el) return el.getValue();
	}
	var comments_div_id = arguments[1] || false;
	var for_type = getValueOf('for_type');
	var for_type_id = getValueOf('for_type_id');
	form.request({onSuccess: function() {displayComments(for_type, for_type_id, comments_div_id)}});
}

function deleteComment(id, commentsDivId, formId){
	var form = $(formId);
	if(!form) return;
	var getValueOf = function(name){
		var el = $A(form.getElements()).find(function(i){return i.name == name});
		if(el) return el.getValue();
	}
	var comments_div_id = arguments[1] || false;
	var for_type = getValueOf('for_type');
	var for_type_id = getValueOf('for_type_id');
	var url = formatUrl('/comments/delete', {id: id});
	call(url, {onSuccess: function() {displayComments(for_type, for_type_id, comments_div_id)}})
}

/* FORM */
function submitForm(formId){
	var form = $(formId);
	var responseId = arguments[1] || false;
	var responseIdEl = $(responseId);
	var success = function(response){
		if(!responseIdEl) return;
		loadSuccessMessage(responseId, getResponseText(response.transport))
	};
	var failure = function(response){
		if(!responseIdEl) return;
		loadFailureMessage(responseId, getResponseText(response.transport))
	};
	form.request({onSuccess: success, onFailure: failure});
}

/* AJAX */
function call(url){
	var defaultOptions = {method: 'get'};
	var options = $H(defaultOptions).update(arguments[1] || {}).toObject();
	new Ajax.Request(url, options);
}

function updateEl(el, url){
	var options = mergeHash({method: 'get', evalScripts: true}, (arguments[2] || {}));
	new Ajax.Updater(el, url, options);
}

function formatUrl(url){
	var params = arguments[1] || false;
	if(!params) return url;
	return url + '?' + $H(params).toQueryString();
}

function getResponseText(transport){
	return transport.responseText;
}

/* SONGS */

function createSong(){
  var form = $('create-song-form');
  showLoadingMessage("create-response", "Please wait your song is being created...");
  form.request({
    onSuccess: function(response){
      loadSongManage(getResponseText(response.transport));
    },
    onFailure: loadResponseFn('create-response')
  })
}

function saveSongInformation(){
	var formId = 'song-information';
	var responseId = 'save-information-response';
	submitForm(formId, responseId);
}

function loadSongManageJams(songId) {
	var url = formatController('song', songId, 'manage', 'jams');
	updateEl('song-manage-jams', url);
};

function addJamToSong(songId) {
	var combo = $('song-manage-my-jams'); 
	if(!combo || !combo.getValue()) return;
	var jamId = combo.getValue();
	var url = $A(["/song", songId, 'manage', 'add_jam']).join('/');
	url = formatUrl(url, {jam_id: jamId});
	var onSuccess = function(){
		loadSongManageJams(songId);
		loadSongManageArtists(songId);
		reloadTags(); // File function is found in /views/common/manage_tags.erb
	};
	call(url, {
	  onSuccess: onSuccess,
	  onFailure: function(response){loadResponseMessage(response, 'flatten-response')}
	});
};

function removeJamFromSong(songId, jamId) {
	var url = formatController('song', songId, 'manage', 'remove_jam');
	url = formatUrl(url, {jam_id: jamId});
	call(url, {onSuccess: function(){loadSongManageJams(songId)}})
};


function loadSongManageArtists(songId) {
	var url = formatController('song', songId, 'manage', 'artists');
	new Ajax.Updater('song-manage-artists-div', url, {method: 'get'});
};

function inviteArtistToSong(songId) {
	var form = $('song-manage-invite-artist-form');
	if(!form) return false;
	form.request({
	  method: 'get', 
	  onSuccess: function() {loadSongManageArtists(songId)},
	  onFailure: function(response){loadResponseMessage(response, 'invite-artists-response-div')}
	});
};

function removeArtistFromSong(songId, artistId){
	var url = formatController('song', songId, 'manage', 'remove_artist');
	url = formatUrl(url, {artist_id: artistId});
	var onSuccess = function() {
		loadSongManageArtists(songId);
		loadSongManageJams(songId);
	}
	call(url, {onSuccess: onSuccess});
}

function flattenSong(songId){
	var songJams = document.getElementsByName('song-publish-form-song-jam');
	var checkedJamIds = $A(songJams).map(function(el){
		var volume = GLOBAL.Slider["jam-" + el.value + "-volume-slider"].getValue();
		return el.checked ? (el.value + "," + (volume/25)) : null;
	}).compact();
	
	var callback = function(response){
		var config = {
			url: "/process_info/" + response.responseText,
			messageDiv: "flatten-response",
			onSuccess: reload
		};
		var poll = new Poll(config);
		poll.start();
	}
	
	var url = formatController('song', songId, 'manage', 'flatten');
	url = formatUrl(url, {jam_ids: $A(checkedJamIds).join(";")});
	call(url, {onSuccess: callback});
}

function publishSong(songId){
	var url = formatController('song', songId, 'manage', 'publish');
	call(url, {onSuccess: reload});
}

function unpublishSong(songId) {
	var url = formatController('song', songId, 'manage', 'unpublish');
	call(url, {onSuccess: reload});
};

function deleteSong(songId) {
	if(!confirm("Are you sure you want to delete this Song ?"))
		return;
	var url = formatController('song', songId, 'manage', 'delete_song');
	call(url, {onSuccess: function() {loadUrl("/account/songs")}});
};

function updateSongSections(songId, sections){
	$H(sections).each(function(kv){
		var url = formatController('song', songId, kv[1]);
		updateEl(kv[0], url)
	});
}

function likeSong(songId) {
	var url = formatController('song', songId, 'manage', 'like');
	var updateSections = {'basic-info': 'basic_info', 'song-likes': 'likes'}
	call(url, {onSuccess: function() {updateSongSections(songId, updateSections)}});
};

function unlikeSong(songId) {
	var url = formatController('song', songId, 'manage', 'unlike');
	var updateSections = {'basic-info': 'basic_info', 'song-likes': 'likes'}
	call(url, {onSuccess: function() {updateSongSections(songId, updateSections)}});
};


/* JAMS */
function saveJamInformation(){
	var formId = 'jam-information';
	var responseId = 'save-information-response';
	submitForm(formId, responseId);
}

function loadJamManageArtists(jamId){
	new Ajax.Updater('jam-artists', '/jam/' + jamId + '/manage/artists', {method: 'get'});
}

function tagArtistInJam(jamId){
	var form = $('tag-artist-form');
	form.request({
	  async: 'true', 
	  method: 'get', 
	  onSuccess: function() {loadJamManageArtists(jamId)},
	  onFailure: function(response){loadResponseMessage(response, 'tag-artists-div')}
	});
}

function untagArtistInJam(jamId, artistId){
	var url = formatUrl('/jam/' + jamId + '/manage/untag_artist', {artist_id: artistId});
	call(url, {async: 'true', method: 'get', onSuccess: function() {loadJamManageArtists(jamId)}});
}

function publishJam(jamId){
	var url = formatController('jam', jamId, 'manage', 'publish');
	call(url, {onSuccess: reload, onFailure: function(response){loadResponseMessage(response, 'jam-actions-response')}});
}


function unpublishJam(jamId){
	var url = formatController('jam', jamId, 'manage', 'unpublish');
	call(url, {onSuccess: reload});
}


function deleteJam(jamId){
	if(!confirm("Are you sure you want to delete this Jam ?"))
		return;
	var url = formatController('jam', jamId, 'manage', 'delete_jam');
	call(url, {onSuccess: function(){loadUrl("/account/jams")}});
}

function updateJamSections(jamId, sections){
	$H(sections).each(function(kv){
		var url = formatController('jam', jamId, kv[1]);
		updateEl(kv[0], url)
	});
}

function likeJam(jamId) {
	var url = formatController('jam', jamId, 'manage', 'like');
	var updateSections = {'basic-info': 'basic_info', 'jam-likes': 'likes'}
	call(url, {onSuccess: function() {updateJamSections(jamId, updateSections)}});
};

function unlikeJam(jamId) {
	var url = formatController('jam', jamId, 'manage', 'unlike');
	var updateSections = {'basic-info': 'basic_info', 'jam-likes': 'likes'}
	call(url, {onSuccess: function() {updateJamSections(jamId, updateSections)}});
};

function commentOnJam(jamId) {
	var comment = $('jam-comment-textarea');
	if(!comment) return;
	comment = comment.getValue();
	var url = formatController('jam', jamId, 'comment');
	call(url, {method: 'post', parameters: {comment: comment}, onSuccess: function() {loadJamComments(jamId)}});
};

function loadJamComments(jamId){
	var url = formatController('jam', jamId, 'comments');
	updateEl('jam-comments', url);
}

function setJamPolicy(select, jamId){
	var policy = select.value;
	var url = formatController("jam", jamId, "manage", "set_policy");
	call(url, {
		method: 'post', 
		onComplete: function(response){loadResponseMessage(response, 'policy-response')},
		parameters: {policy: policy}
	});	
}

/* USERS */

function followUser(username){
	call("/" + username + "/follow", {onSuccess: function(){loadUserProfileActions(username)}})
}

function unfollowUser(username){
	call("/" + username + "/unfollow", {onSuccess: function(){loadUserProfileActions(username)}})
}

function loadUserProfileActions(username){
	updateEl("profile-actions-div", "/" + username + "/actions")
}

/* SECTIONS */
function toogleSectionExpand(id){
	var el = $(id);
	if(!el) return;
	var toogleLink = arguments[1];
	el.visible() ? hideSection(id, toogleLink) : showSection(id, toogleLink);
}

function hideSection(id, toogleLinkId){
	var el = $(id);
	if(!el) return;
	var toogleLink = $(toogleLinkId);
	if(toogleLink) toogleLink.innerHTML = 'show';
	el.hide()
}

function showSection(id, toogleLinkId){
	var el = $(id);
	if(!el) return;
	var toogleLink = $(toogleLinkId);
	if(toogleLink) toogleLink.innerHTML = 'hide';
	el.show();
}



/* UPLOAD */
function getNewXProgressId(){
	var uuid = "";
	for (i = 0; i < 32; i++) {
		uuid += Math.floor(Math.random() * 16).toString(16);
	}	
	return uuid;
}

function loadJamManageFileActions(jamId){
	new Ajax.Updater('jam-file-actions', '/jam/' + jamId + '/manage/file_actions', {method: 'get'});
}

function uploadJam(jamId){

	var iframeId = 'upload-jam-iframe';
	var iframe = $('upload-jam-iframe-id');
	showLoadingMessage("upload-progress", "Please wait while the audio file is being uploaded and noramlized...");
	
//	var progressId = getNewXProgressId();	
//	iframe.hide();
//	window.frames[iframeId].$('upload-jam-form').action += ('?' + progressId);
//	var progressBar = new ProgressBar({width: '400px'});
//	progressBar.render('upload-progress');
//	window.setTimeout(function(){showUploadProgress(progressId, progressBar, jamId)}, 1000);
	return true;
}

function showUploadProgress(progressId, progressBar, jamId){
	var onSuccess = function(response){
		var status = eval(response.transport.responseText);
		if(status.state != 'done') {
			if(status.size && status.received){
				var percent = (status.received / status.size ) * 100;
				progressBar.update(percent + '%');
			}
			window.setTimeout(function(){showUploadProgress(progressId, progressBar, jamId)}, 1000);
		}
		else if(status.state == 'done') {
			$('upload-progress').innerHTML = 'Upload Complete<br><br>';
			loadJamManageFileActions(jamId);
		};
	};
	call('/progress', {
		onSuccess: onSuccess,
		method: 'get',
		requestHeaders: {"X-Progress-Id": progressId}
	});
}

/* Instruments */

function reload_manage_instruments(container_div, for_type, for_type_id){
	var url = formatUrl("/partial/common/manage_instruments", {for_type: for_type, for_type_id: for_type_id});
	updateEl(container_div, url);
}

function add_instrument(select_div_id, container_div, for_type, for_type_id){
	var select = $(select_div_id);
	var url = formatController("instrument", "add");
	url = formatUrl(url, {for_type: for_type, for_type_id: for_type_id, instrument_id: select.getValue()});
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


/* Blanket HOVER */
function onMouseOverBlanket(el){
	var hiddenEls = el.findDescendantsByClassName('hidden');
	$A(hiddenEls).each(function(hEl){
		hEl.addClassName('visible');
	});
}

function onMouseOutBlanket(el){
	var visibleEls = el.findDescendantsByClassName('visible');
	$A(visibleEls).each(function(vEl){
		vEl.removeClassName('visible');
	});
}

/* SCHOOLS */
function addUserToSchool(){}

/* Slider */

function sliderRegister(id){
  GLOBAL.Slider[id] = {
		id: id,
		getValue: function(){
			var value = $(id + "-container").findDescendantsByName('slider-value')[0].innerHTML;
			return parseInt(value);
		}
	};
	var slider = GLOBAL.Slider[id];
	Event.observe(id + '-container', 'mousedown', function(e){sliderOnMouseDown(slider, e)});
  Event.observe(id + '-container', 'mousemove', function(e){sliderOnMouseMove(slider, e)});
  Event.observe(id + '-container', 'mouseup', function(e){sliderOnMouseUp(slider, e)});
}

function sliderOnMouseDown(slider, e){
  slider.mousedown = true;
  sliderMove(slider, e, e.element());
}

function sliderOnMouseUp(slider, e){
  slider.mousedown = false;
  slider.mouseup = true;
}

function sliderOnMouseMove(slider, e){
  if(!slider.mousedown) return;
  sliderMove(slider, e, e.element());
}

function sliderMove(slider, e, element){
  var newValue = (e.clientX - element.cumulativeOffset()[0]);
  $(slider.id + '-head').style.paddingLeft = newValue + 'px';
	var sliderValueEl = $(slider.id + "-container").findDescendantsByName('slider-value')[0];
	sliderValueEl.innerHTML = newValue;
}

function submitSay(formId, containerId){
	var form = $(formId);
	var message = form.findDescendantsByName("message")[0];
	if(message.getValue().blank()) return;
	var onSuccess = function(){updateEl(containerId, "/partial/account/say")}
	form.request({method: 'post', onSuccess: onSuccess});
	return false;
}


/* SHARE */
function twitterShare(url){
  window.open("http://www.twitter.com/home?status=" + url);
}

function facebookShare(url, title){
  var shareUrl = "http://www.facebook.com/share.php?u=" + url + "&t=" + title;
  window.open(shareUrl, "Share", "height=400px,width=800px")
}

/* Player */

function playMusic(url,name){	
	if(window.jammminplayer){
		window.document["jammminplayer"].SetVariable("url", url);
		window.document["jammminplayer"].SetVariable("name", name);
		window.document["jammminplayer"].Rewind();
		window.document["jammminplayer"].Play();
	}
	if(document.jammminplayer){
		document.jammminplayer.SetVariable("url", url);	
		document.jammminplayer.SetVariable("name", name);
		document.jammminplayer.Rewind();
		document.jammminplayer.Play()
	}	
}

function loadSong(url, name){
	if(window.jammminplayer){
		window.document["jammminplayer"].SetVariable("url", url);
		window.document["jammminplayer"].SetVariable("name", name);
		window.document["jammminplayer"].Rewind();
	}
	if(document.jammminplayer){
		document.jammminplayer.SetVariable("url", url);	
		document.jammminplayer.SetVariable("name", name);
		document.jammminplayer.Rewind();
	}	
}


function startChatPings(){
	chatPing();
}

function chatSyncWindow(){
	var height = (
			$(document.body).getHeight() - 
			document.getElementsByClassName("top-bar")[0].getHeight() - 
			document.getElementsByClassName("footer")[0].getHeight() - 
			150) + "px";
	$('chat-window').style.maxHeight = height;
	$('chat-window').style.height = height;
}

function chatOpenNewWindow(){
	window.open("/chat");
}

function chatPing(){
	var onSuccess = function(r){
		var prevLastId = chatGetLastMessageId();
		var el = $('chat-messages');
		el.update(r.responseText);
		var newLastId = chatGetLastMessageId();
		if(prevLastId != newLastId)
			chatToggleWindowTitle();
		chatScrollWindowBottom();
	}
	new PeriodicalExecuter(function() {
		call("/chat/messages", {onSuccess: onSuccess});
	}, 5);
	
	return;
	
//	call("/chat/ping", {onComplete: chatPingOnComplete, onException: chatPingOnComplete})
}

function chatPingOnComplete(r){
	var data = r.evalJSON();
	if(data.new_messages)
		chatLoadNewMessages();	
	if(data.new_users)
		chatLoadUsers();
	chatPing();
}

function chatSay(){
	var form = $('chat-form');
	var onSuccess = function() {
		chatLoadNewMessages();
	};
	form.request({onSuccess: onSuccess});
	$('chat-input-text').value = "";
}

function chatLoadNewMessages(){
	var onSuccess = function(r){
		var el = $('chat-messages');
		el.insert({bottom: r.responseText})		
		chatScrollWindowBottom();
	}
	call("/chat/new_messages", {onSuccess: onSuccess});
}

function chatLoadUsers(){
	updateEl('chat-users', '/partial/chat/users');
}

function chatScrollWindowBottom(){
	var el = $('chat-window');
	el.scrollBottom();
}

function chatStartUsersRefresh(){
	new Ajax.PeriodicalUpdater('chat-users', '/partial/chat/users', {frequency: 10, method: 'get'})
}

function chatSignOut(){
	call("/chat/sign_out", {asynchronous: false});
}

function chatSignOutToHome(){
	var onSuccess = function(){
		loadUrl("/");
	}
	call("/chat/sign_out", {onSuccess: onSuccess});	
}

function chatToggleWindowTitle(){
	var titles = ["jamMm.in", "new message - jamMm.in"];
	if(GLOBAL.chatTitleTimer && GLOBAL.chatTitleTimer.timer)
		return;
	GLOBAL.chatTitleTimer = new PeriodicalExecuter(function(){
		titles = $A(titles).reverse();
		document.title = $A(titles).shift();
	}, 2);
}

function chatGetLastMessageId(){
	return $('chat-messages').childElements().pop().id;
}

function chatResetChatWindowTitle(){
	var chatTimer = GLOBAL.chatTitleTimer;
	if(chatTimer && chatTimer.timer)
	{
		chatTimer.stop();
		document.title = "jamMm.in";
	}	
}



/* School Admin */
function addSchoolUser(){
	var formId = 'school-admin-add';
	var responseId = 'add-school-user-response';
	submitForm(formId, responseId);
}
function addUpdateSchoolDetails(){
	var formId = 'school-admin-manage-school';
	var responseId = 'update-school-details-response';
	submitForm(formId, responseId);
}


/* REPOT MUSIC */
function reportMusic(musicType, musicId){
	var url = formatController('report', musicType, musicId);
	var ans = confirm("Would you like to report this peice of music?");
	var onSuccess = function(){
		alert('Your request has been registered, we will be looking through the music shortly.');
	}
	call(url, {onSuccess: onSuccess, method: 'post'});
}