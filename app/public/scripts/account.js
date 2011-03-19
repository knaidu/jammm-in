var Account = {Messages: {}, SoundCloud: {}};

Account.welcome = function() {
	Modal.load("/account/welcome", {minHeight: "400px"});	
}.bind(Account);

Account.welcome.load = function(str) {
	var fn = function(){};
	switch(str){
		case "create-jam":
			fn = Jam.create; break;
		case "import":
			fn = Account.SoundCloud.importFromSoundCloud; break;
		case "collaborate":
			fn = Jam.showSample; break;
		default:;
	}
	Modal.close();
	General.WaitingDialog.show();
	window.setTimeout(fn, 1500);
}.bind(Account.welcome);

Account.updatePicture = function(id) {
	Modal.load("/account/aboutme/update_picture", {minHeight: "200px"});
}.bind(Account);

Account.updatePicture.showSpinner = function() {
	$j("form").hide();
	$j(".waiting-message").show();
}.bind(Account.updatePicture);

Account.updatePicture.done = function() {
	Modal.close();
	Navigate.reload();
	Modal.slowAlert("Your profile picture has been successfully updated.");
}.bind(Account.updatePicture);

Account.changePassword = function() {
	var response = $j(".password-response");
	var onSuccess = function() {
		response.html("Your password has been successfully changed.");
		$j("[type=password]").val("");
	};
	var onFailure = function(t) {
		response.html(General.getErrorText(t.responseText));
	};
	var params = {
		current_password: $j("[name=current-password]").val(),
		password: $j("[name=password]").val(), 
		confirm_password: $j("[name=confirm-password]").val()
	};
	call('/account/aboutme/change_password', {method: 'post', parameters: params, onSuccess: onSuccess, onFailure: onFailure})
}.bind(Account);

Account.Messages.filter = function(searchStr) {
	var messageStreams = $j(".message-stream");
	General.List.filter(messageStreams, searchStr)
}.bind(Account.Messages);


// SOUNDCLOUD CONNECT

Account.SoundCloud.connect = function() {
	window.open("http://jammm.in/connect/soundcloud/connect", "");
}.bind(Account.SoundCloud);

Account.SoundCloud.importFromSoundCloud = function() {
	Modal.load("/connect/soundcloud/connect/intro", {minHeight: "300px"});
}.bind(Account.SoundCloud);

Account.SoundCloud.importFromSoundCloud.getContentPanel = function() {
	return $j("#import-soundcloud-div");
}.bind(Account.SoundCloud.importFromSoundCloud);

Account.SoundCloud.importFromSoundCloud.connect = function() {
	Account.SoundCloud.connect();
	this.getContentPanel().html(General.getAjaxLoader("Please wait while your accounts are being connected ..."));
	this.waitForConnection();
}.bind(Account.SoundCloud.importFromSoundCloud);

Account.SoundCloud.importFromSoundCloud.waitForConnection = function() {
	var onSuccess = function(t) {
		var res = t.evalJSON();
		if(res)
			this.chooseTracks();
		else
			window.setTimeout(this.waitForConnection, 2000);
	}.bind(this);
	call("/connect/soundcloud/is_connection_alive", {onSuccess: onSuccess});
}.bind(Account.SoundCloud.importFromSoundCloud);

Account.SoundCloud.importFromSoundCloud.chooseTracks = function() {
	this.getContentPanel().html("Loading ...");
	updateEl(this.getContentPanel()[0], "/connect/soundcloud/choose_tracks");
}.bind(Account.SoundCloud.importFromSoundCloud);

Account.SoundCloud.importFromSoundCloud.trackClicked = function(el) {
	var cb = $j("INPUT[type=checkbox]", el)[0];
	cb.checked ? el.addClassName("selected") : el.removeClassName("selected");
}.bind(Account.SoundCloud.importFromSoundCloud);


Account.SoundCloud.importFromSoundCloud.importTracks = function() {

	var responseEl = $j("#soundcloud-tracks-response-el");
	var tracks = $j(".soundcloud-tracks .soundcloud-track.selected");
	var info = $A(tracks).map(function(track) {
		return track.getAttribute("trackid");
	});
	
	if(tracks.size() < 1){
		responseEl.html(General.getErrorText("Please select atleast one track to import."));
		return;
	}
 	
	var button = $j("#import-button");
	var callback = function(response){
		responseEl.html("Please wait while your tracks are being imported ...");
		var config = {
			url: "/process_info/" + response.responseText,
			messageDiv: responseEl[0],
			onSuccess: function() {
				Modal.close();
				Modal.slowAlert("Your tracks have been successfully imported. <br><br>Note: The instrument and genre for the jams have not been added, please update them");
				Navigate.loadContent("/account/jams");
			}
		};
		var poll = new Poll(config);
		poll.start();
	}
 	var onFailure = function(t) {
		button.show();
		responseEl.html(General.getErrorText(t.responseText));
	};
	responseEl.html("Please wait ...");
	button.hide();
	var url = formatUrl('/connect/soundcloud/import_tracks', {tracks: info.join(",")});
  call(url, {onSuccess: callback, onFailure: onFailure});
	
}.bind(Account.SoundCloud.importFromSoundCloud);

// Reloads the doc every 25 secs
Account.refreshDocAfterInterval = function() {
	if(this.docRefreshTimer){
		window.clearTimeout(this.docRefreshTimer);
	}
	this.docRefreshTimer = window.setTimeout(Doc.reload, 25000);
}.bind(Account);

Account.stopDocRefreshTimer = function() {
	if(this.docRefreshTimer)
		window.setTimeout(this.docRefreshTimer);
	this.docRefreshTimer = false;
}.bind(Account);