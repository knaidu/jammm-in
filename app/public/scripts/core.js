Object.extend(Object, function(){
	function applyHash(object, hash){
		$H(hash).each(function(kv){object[kv[0]] = kv[1];});
	}
	return {
		applyHash: applyHash
	}
}());

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
