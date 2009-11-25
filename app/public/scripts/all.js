
var GLOBAL = {playerType: "large"};

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

// Redirects to a particular song page
function loadJam(id){
  if(!id) return;
  loadUrl("/jam/" + id);
}

function formatController(){
	return ("/" + $A(arguments).map(function(arg){return arg}).join("/"));
}


/* Messages */

function sendMessage(formId){
	var form = $(formId);
	if(!form) return;
	form.request({onSuccess: loadAccountMessages})
}

function deleteMessages() {
	var els = document.getElementsByName('message-checkbox');
	var ids = $A(els).map(function(id){
		var el = $(id);
		return el.checked ? el.getValue() : null
	}).compact().join(',');
	var url = formatUrl('/account/messages/delete', {ids: ids});
	call(url, {onSuccess: reload});
};

function loadMessage(id, message, className){
	var el = $(id);
	if(!el) return;
	var div = new Element('div');
	el.addClassName('text-center');
	div.insert(message);
	div.addClassName(className);
	var items = ["<center>", "<br>", div, "<br>", "</center>"];	
	el.innerHTML = '';
	$A(items).each(function(item){el.insert(item)});
	window.setTimeout(function(){el.innerHTML = ''}, 2000); // empties the window after 2 seconds
}

function loadSuccessMessage(id, message){
	loadMessage(id, message, "success-message");
}

function loadFailureMessage(id, message){
	loadMessage(id, message, "failure-message");
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
	var options = mergeHash({method: 'get'}, (arguments[2] || {}));
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
function saveSongInformation(){
	var formId = 'song-information';
	var responseId = 'save-information-response';
	submitForm(formId, responseId);
}

function loadSongManageJams(songId) {
	var url = formatController('song', songId, 'manage', 'jams');
	new Ajax.Updater('song-manage-jams', url, {method: 'get'});
};

function addJamToSong(songId) {
	var combo = $('song-manage-my-jams'); 
	if(!combo || !combo.getValue()) return;
	var jamId = combo.getValue();
	var url = $A(["/song", songId, 'manage', 'add_jam']).join('/');
	url = formatUrl(url, {jam_id: jamId});
	var onSuccess = function(){
		loadSongManageJams(songId);
		loadSongManageArtists(songId)
	};
	call(url, {onSuccess: onSuccess});
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
	form.request({method: 'get', onSuccess: function() {loadSongManageArtists(songId)}});
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

function publishSong(songId){
	var songJams = document.getElementsByName('song-publish-form-song-jam');
	var checkedJamIds = $A(songJams).map(function(el){
		return el.checked ? el.value : null 
	}).compact();
	
	var callback = function(response){
		var config = {
			url: "/process_info/" + response.responseText,
			onSuccess: reload
		};
		var poll = new Poll(config);
		poll.start();
	}
	
	var url = formatController('song', songId, 'manage', 'publish');
	url = formatUrl(url, {jam_ids: $A(checkedJamIds).join(",")});
	call(url, {onSuccess: callback});
}

function unpublishSong(songId) {
	var url = formatController('song', songId, 'manage', 'unpublish');
	call(url, {onSuccess: reload});
};

function deleteSong(songId) {
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
	form.request({async: 'true', method: 'get', onSuccess: function() {loadJamManageArtists(jamId)}});
}

function untagArtistInJam(jamId, artistId){
	var url = formatUrl('/jam/' + jamId + '/manage/untag_artist', {artist_id: artistId});
	call(url, {async: 'true', method: 'get', onSuccess: function() {loadJamManageArtists(jamId)}});
}

function publishJam(jamId){
	var url = formatController('jam', jamId, 'manage', 'publish');
	call(url, {onSuccess: reload});
}


function unpublishJam(jamId){
	var url = formatController('jam', jamId, 'manage', 'unpublish');
	call(url, {onSuccess: reload});
}


function deleteJam(jamId){
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
	var progressId = getNewXProgressId();
	var iframeId = 'upload-jam-iframe';
	var iframe = $('upload-jam-iframe-id');
	iframe.hide();
	window.frames[iframeId].$('upload-jam-form').action += ('?' + progressId);
	var progressBar = new ProgressBar({width: '400px'});
	progressBar.render('upload-progress');
	window.setTimeout(function(){showUploadProgress(progressId, progressBar, jamId)}, 1000);
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


/* Player */
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
			swfobject.embedSWF("/swf/player.swf", "playerdiv", "380", "70", "7.0.0", false, flashvars, params, attributes);
		else
			swfobject.embedSWF("/swf/player-small.swf", "playerdiv", "200", "70", "7.0.0", false, flashvars, params, attributes);
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
			swfobject.embedSWF("/swf/player.swf", "playerdiv", "380", "70", "7.0.0", false, flashvars, params, attributes);
		else
			swfobject.embedSWF("/swf/player-small.swf", "playerdiv", "200", "70", "7.0.0", false, flashvars, params, attributes);
}

function play(filehandle){
	var filepath = $A([window.location.protocol, "//", window.location.host, "/file/", filehandle]).join('');
	log(filepath);
	playerinit(GLOBAL.playerType);
	playSong("file", filepath, "large");
}