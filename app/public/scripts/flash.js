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
	var played = $A(str.split(",")).pop();
	Flash.gotStatus(parseInt(played));
}

/* API */
Flash.startOperations = function(el) {
	var path = $(el).getAttribute('play');
	this.saveCurrentData(el);
	this.play(path);
}.bind(Flash);

Flash.play = function(path) {
	flashPlay(path);
}.bind(Flash);

Flash.saveCurrentData = function(el) {
	it = el;
	this.currentData = {
		playEl: el,
		seekEl: $(el.getAttribute('seekid')),
		length: parseInt($(el).getAttribute('length')) * 1000
	}
}.bind(Flash);

Flash.startGettingStatus = function() {
	if(this.statusTimer) this.statusTimer.stop();
	this.statusTimer = new PeriodicalExecuter(this.getStatus, 0.4);
}.bind(Flash);

Flash.getStatus = function() {
	flashGetStatus();
}.bind(Flash);

Flash.gotStatus = function(played) {
	var length = this.currentData.length;
	var playedPercent = (played / length) * 100;
	$j(this.currentData.seekEl).width(playedPercent + "%");
	if(playerPercent >= length) this.stopSeekRepositioning();
}.bind(Flash);

Flash.stopSeekRepositioning = function() {
	if(this.statusTimer) this.statusTimer.stop();
}.bind(Flash);