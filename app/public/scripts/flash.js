var Flash = {currentData: {}, playing: false};
function getFlashMovie(movieName) {
  var isIE = navigator.appName.indexOf("Microsoft") != -1;
  return (isIE) ? window[movieName] : document[movieName];  
}  

function flashStop() {
   var retVal = getFlashMovie("jammminPlayer").stopFileFromJavaScript();
}

function flashPlay(url) {
	flashStop();
	getFlashMovie("jammminPlayer").playFileFromJavaScript(url);
}

function flashPause() {
  getFlashMovie("jammminPlayer").pauseFileFromJavaScript();
}
function flashContinue(url) {
  getFlashMovie("jammminPlayer").continueFileFromJavaScript();
}
function flashGetStatus(url) {
 var ret = getFlashMovie("jammminPlayer").getStatusFromJavaScript();
flashGotStatus(ret);
}  

function flashSetVolume(){
	var vol = arguments[0] || 100;
//	console.log('setting volume to: ' + vol);
}

function flashGotStatus(str) {
//	console.log("status: " + str);
	var arr = $A(str.split(","));
	var played = arr.pop();
	var buffered = (parseInt(arr[0]) / parseInt(arr[1])) * 100; 
	Flash.gotStatus(buffered, parseInt(played));
}

/* API */
Flash.startOperations = function(el) {
	var path = $(el).getAttribute('play');
	// Checks if the a song is already playing, but is play event is of another song, it plays the new song.
	// in the scope of a jam/song
	var samePlayClicked = (el.getAttribute('playtype') == 'doc' || this.currentData.playId == el.getAttribute('playid'));
	if(this.isPlaying() && samePlayClicked){
		this.pause();
		return;
	}else if (this.isPaused() && samePlayClicked){
		this.continuePlaying();
	}else{
		this.saveCurrentData(el);
		this.play(path);
	}
}.bind(Flash);

Flash.play = function(path) {
	this.playing = true;
	this.paused = false;
	flashPlay(path);
	this.displayMusicInDoc();
	this.startGettingStatus();
	if(this.currentData.playType == 'mini'){
		this.makeMiniLinkPersistent();
	}
}.bind(Flash);

Flash.setVolume = function() {
	var vol = arguments[0] || 100;
	flashSetVolume(vol);
}.bind(Flash);


Flash.makeMiniLinkPersistent = function() {
	$A($j("[onhovershow=false]")).each(function(e) {
		e.setAttribute("onhovershow", true);
		$j(e).hide();
	})
	this.currentData.playEl.setAttribute("onhovershow", false);
}.bind(Flash);


Flash.pause = function() {
	flashPause();
	this.paused = true;
	this.playing = false;
	this.stopSeekRepositioning();
	this.setImageStates();
}.bind(Flash);

Flash.isPaused = function() {
	return this.paused;
}.bind(Flash);

Flash.continuePlaying = function() {
	flashContinue();
	this.paused = false;
	this.playing = true;
	this.setImageStates();
	this.startGettingStatus();
}.bind(Flash);

Flash.saveCurrentData = function(el) {
	aaa = el;
	var seekEl = false, bufferEl = false; 
	var waveformEl = $(el.getAttribute('waveformid'));
	if(waveformEl){
		seekEl = waveformEl.findDescendantsByClassName("seek");
		bufferEl = waveformEl.findDescendantsByClassName("buffer");
	}
	var length = el.getAttribute("length") ? (parseInt($(el).getAttribute('length')) * 1000) : false;
	var sliderEl = $j("#" + el.getAttribute("sliderid"));
	this.currentData = {
		playEl: el,
		waveformEl: waveformEl,
		length: length,
		seekEl: seekEl,
		bufferEl: bufferEl,
		musicname: el.getAttribute("musicname"),
		playId: el.getAttribute("playid"),
		playType: el.getAttribute("playtype"),
		sliderEl: sliderEl 
	}
}.bind(Flash);

Flash.startGettingStatus = function() {
	if(this.statusTimer) this.statusTimer.stop();
	this.statusTimer = new PeriodicalExecuter(this.getStatus, 0.4);
}.bind(Flash);

Flash.getStatus = function() {
	flashGetStatus();
}.bind(Flash);

Flash.gotStatus = function(buffered, played) {
	var length = this.currentData.length;
	var playedPercent = ((played / length) * 100) + "%";
	var bufferedPercent = buffered + "%";
	$j(this.currentData.seekEl).width(playedPercent);
	$j(this.currentData.bufferEl).width(bufferedPercent);
	
	$j(".player .buffer").width(bufferedPercent);
	$j(".player .seek").width(playedPercent);
	
	if(playedPercent == "100%")	this.songDone();
}.bind(Flash);

Flash.songDone = function() {
	this.playing = false;
	this.paused = false;
	this.currentData = false;
	this.stopSeekRepositioning();
}.bind(Flash);

Flash.stopSeekRepositioning = function() {
	if(this.statusTimer) this.statusTimer.stop();
}.bind(Flash);

Flash.displayMusicInDoc = function() {
	Doc.Player.show();
	if(this.currentData.musicname)
		$j(".player .text").html(this.currentData.musicname);
	this.setImageStates();
}.bind(Flash);

Flash.isPlaying = function() {
	return this.playing;
}.bind(Flash);

Flash.setImageStates = function() {
	this.isPlaying() ? this.setImagesToPause() : this.setImagesToPlay();
}.bind(Flash);

Flash.setImagesToPause = function() {
	// Doc Image
	var docEl = $j("[playtype=doc]")[0];
	if(docEl){
		var img = docEl.getElementsByTagName("img")[0];
		img.style.marginLeft = "-192px";
	}
	
	// waveform image
	var playEl = this.currentData.playEl;
	if(playEl && playEl.getAttribute("playtype") == 'waveform'){
		var img = playEl.getElementsByTagName("img")[0];
		img.style.marginLeft = "-126px";
	}else if(playEl && playEl.getAttribute("playtype") == 'mini'){
		var img = playEl.getElementsByTagName("img")[0];
		img.style.marginLeft = "-648px";
		$j(".text", playEl).html("Pause");
	}

}.bind(Flash);

Flash.setImagesToPlay = function() {
	// Doc Image
	var docEl = $j("[playtype=doc]")[0];
	if(docEl){
		var img = docEl.getElementsByTagName("img")[0];
		img.style.marginLeft = "-168px";
	}
	
	// waveform image
	var playEl = this.currentData.playEl;
	if(playEl && playEl.getAttribute("playtype") == 'waveform'){
		var img = playEl.getElementsByTagName("img")[0];
		img.style.marginLeft = "-84px";
	}else if(playEl && playEl.getAttribute("playtype") == 'mini'){
		var img = playEl.getElementsByTagName("img")[0];
		img.style.marginLeft = "-624px";
		$j(".text", playEl).html("Play");
	}
}.bind(Flash);