var Flash = {currentData: {}};
function getFlashMovie(movieName) {
  var isIE = navigator.appName.indexOf("Microsoft") != -1;
  return (isIE) ? window[movieName] : document[movieName];  
}  

function flashPlay(url) {
   getFlashMovie("jammminPlayer").playFileFromJavaScript(url);
}
function flashPause() {
   getFlashMovie("jammminPlayer").pauseFileFromJavaScript();
}
function flashContinue(url) {
   getFlashMovie("jammminPlayer").continueFileFromJavaScript();
}
function flashGetStatus(url) {
   getFlashMovie("jammminPlayer").getStatusFromJavaScript();
}  

function flashPlayed(str) {
	Flash.startGettingStatus();
}
 
function flashPaused(str) {
// alert("flash paused"+str);  
}

function flashContinued(str) {
// alert("flash continued"+str);  
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
	this.saveCurrentData(el);
	this.play(path);
}.bind(Flash);

Flash.play = function(path) {
	flashPlay(path);
	this.displayMusicInDoc();
}.bind(Flash);

Flash.saveCurrentData = function(el) {
	var waveformEl = $(el.getAttribute('waveformid'));
	var seekEl = waveformEl.findDescendantsByClassName("seek");
	var bufferEl = waveformEl.findDescendantsByClassName("buffer");
	this.currentData = {
		playEl: el,
		waveformEl: waveformEl,
		length: parseInt($(el).getAttribute('length')) * 1000,
		seekEl: seekEl,
		bufferEl: bufferEl,
		musicname: el.getAttribute("musicname")
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
	
	if(playerPercent >= length) this.stopSeekRepositioning();
}.bind(Flash);

Flash.stopSeekRepositioning = function() {
	if(this.statusTimer) this.statusTimer.stop();
}.bind(Flash);

Flash.displayMusicInDoc = function() {
	$j(".player .text").html(this.currentData.musicname);
}.bind(Flash);