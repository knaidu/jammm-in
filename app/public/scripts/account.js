var Account = {Messages: {}, SoundCloud: {}};

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
}.bind(Account.SoundCloud.importFromSoundCloud);

Account.SoundCloud.importFromSoundCloud.waitForConnection = function() {
	updateEl(this.getContentPanel()[0], "/connect/soundcloud/choose_tracks");
}.bind(Account.SoundCloud.importFromSoundCloud);
