
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
	}
	return {
		shuffle: shuffle
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
		var img = "<img src='/images/icons/loading.gif' height=16>";
		this.messageDivEl.innerHTML = img + "&nbsp; &nbsp;" + message;
	},
	stop: function(){this._completed = true}
});

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

