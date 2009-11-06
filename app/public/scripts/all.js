/* Debug */

function log(message){
	if(console && console.log) console.log(message)
}

function loadUrl(url){
  window.location = url;
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


function allit(){
	alert('well');
	return false;
}

/* Messages */

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
}

function loadSuccessMessage(id, message){
	loadMessage(id, message, "success-message");
}

function loadFailureMessage(id, message){
	loadMessage(id, message, "failure-message");
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
	var options = arguments[1] || {};
	new Ajax.Request('/your/url', options);
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


/* JAMS */
function saveJamInformation(){
	var formId = 'song-information';
	var responseId = 'save-information-response';
	submitForm(formId, responseId);
}