Ajax.Response.addMethods({
  evalJSON: function() {
    return this.transport.responseText.evalJSON()
  }
});

Object.extend(Object, function(){
	function applyHash(object, hash){
		$H(hash).each(function(kv){object[kv[0]] = kv[1];});
	}
	return {
		applyHash: applyHash
	}
}());

Object.extend(Array.prototype, function(){
	function shuffle(){
		var o = this.clone();
		for(var j, x, i = o.length; i; j = parseInt(Math.round(Math.random() * 100) % i), x = o[--i], o[i] = o[j], o[j] = x);
		return o;
	};
	
	function sum(){
		for(var i=0,sum=0;i<this.length;sum+=this[i++]);
		return sum;
	};
	
	return {
		shuffle: shuffle,
		sum: sum
	}
}());


Element.addMethods({
	scrollBottom: function(element){
    element.scrollTop = element.scrollHeight;
  },
	findDescendantsByClassName: function(element, className){
		var decs = element.descendants();
		return decs.findAll(function(i){return i.hasClassName(className)}) 
	},
	findDescendantsByName: function(element, name){
		var decs = element.descendants();
		return decs.findAll(function(i){return i.getAttribute('name') == name}) 
	},
	getContentHeight: function(element) {
		var prevHeight = element.getHeight();
		element.style.height = 'auto';
		var newHeight = element.getHeight();
		element.style.height = prevHeight + "px";
		return newHeight;
	}
});

/* Progress Bar HTML el */

var ProgressBar = Class.create({
	initialize: function(config){
		this.id = Math.random();
		this.width = '100%';
		Object.applyHash(this, config);
		this.id += ''; //Converts ID to a string
		ProgressBar._constructHtml(this);
	},
	
	getEl: function(){return $(this.id)},
	update: function(value){
		var el = this.getEl();
		el.style.width = value;
	},
	
	render: function(id){
		var el = $(id);
		if(!el) return;
		el.update(this.html)
	}
});

ProgressBar._constructHtml = function(progressBar){
	progressBar.html = $A([
		"<div id='" + progressBar.id + "-container' class='progress-bar-container' style='width: "+ progressBar.width +"'>",
			"<div id='"+ progressBar.id  +"' class='progress-bar'>&nbsp</div>",
		"</div>"
	]).join('');
}


/* Poll */

var Poll = Class.create({
	initialize: function(config){
		
		this.onSuccess = function() {};
		this.onFailure = function() {};
		this.period = 5;
		this.url = false;
		this._completed = false;
		this.messageDiv = false;
		
		Object.applyHash(this, config);
		if(this.messageDiv)
			this.messageDivEl = $(this.messageDiv);
		this.period *= 1000
	},
	
	start: function(){return Poll.start(this)},
	loadMessage: function(message) {
		if(!this.messageDiv || !this.messageDivEl) return;
		this.messageDivEl.innerHTML = message;
	},
	stop: function(){this._completed = true}
});

jQuery.fn.center = function () {
	var duration = arguments[0] || 0;
	this.css("position","fixed");
	this.css({
		"top": ( $j(window).height() - this[0].getHeight() ) / 2+$j(window).scrollTop() + "px",
		"left": ( $j(window).width() - this[0].getWidth() ) / 2+$j(window).scrollLeft() + "px"
	}, 1000);
	return this;
}

Poll._processUrl = function(poll){
	if(poll._completed) return;
	
	var callback = function(response){
		var json = response.evalJSON();
		if(json.message)
			poll.loadMessage(json.message);
		if(json.failed){
			poll.onFailure(json);
			poll.stop();
		}
		if(json.done){
			poll.onSuccess(json);
			poll.stop();
		}
		window.setTimeout(function(){Poll._processUrl(poll)}, poll.period);
	}
	call(poll.url, {onSuccess: callback});
}.bind(Poll);

Poll.start = function(poll){
	this._completed = false;
	poll.loadMessage("Please wait...");
	this._processUrl(poll);
}.bind(Poll);

/* AJAX */
function call(url){
	var defaultOptions = {method: 'get'};
	var options = $H(defaultOptions).update(arguments[1] || {}).toObject();
	new Ajax.Request(url, options);
}

function updateEl(el, url){
	var randStr = "&randno=" + Math.random();
	url = url.include("?") ? (url + randStr) : (url + "?" + randStr);
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

function log(message){
	try{
		if(console && console.log) console.log(message)	
	}catch(e){}
}

function loadUrl(url){
  window.location = url;
}

function reload(){
	window.location = '';
}

function mergeHash(hash1, hash2){
	return $H(hash1).update(hash2).toObject();
}