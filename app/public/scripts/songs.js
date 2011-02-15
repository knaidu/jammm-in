var Song = {Manage: {}};

Song.Manage.like = function(id) {
	call("/song/" + id + "/manage/like", {onSuccess: Layout.ContextMenu.reload, method: 'post'});
}.bind(Song.Manage);

Song.Manage.unlike = function(id) {
	call("/song/" + id + "/manage/unlike", {onSuccess: Layout.ContextMenu.reload, method: 'post'});
}.bind(Song.Manage);


Song.create = function(musicType, musicId) {
	var url = formatUrl('/song/create', {music_type: musicType, music_id: musicId});
	Modal.load(url, {minHeight: "210px"});
}.bind(Song);


Song.create.submit = function() {
	$j(".error-response").show();
	var params = {
		name: $j(".simplemodal-data [name=name]").val(),
		music_type: $j(".simplemodal-data [name=music_type]").val(),
		music_id:  $j(".simplemodal-data [name=music_id]").val(),
		add: "add"
	};
	var onSuccess = function(t) {
		Modal.close();
		var id = t.responseText;
		Navigate.loadContent("/song/" + id + "/manage");
	};
	call("/song/create/submit", {method: "post", parameters: params, onSuccess: onSuccess});
}.bind(Song.create);


Song.Manage.generateSliders = function() {
	jams = $j(".song-manage-page.jams .jam[jamid]");
	jams = $A(jams).map(function(i){return {jamid: i.getAttribute("jamid"), volume: i.getAttribute("volume")}});
	sliders = $j(".jquery-slider");
	$A(sliders).each(function(s){
		var jam = $A(jams).find(function(j){return j.jamid == s.getAttribute("jamid")});
		$j(s).slider();
		$j(s).slider({
			max: 4, 
			value: jam.volume, 
			step: 0.04,
			change: function(e, ui){
				Song.Manage.monitorSlider(jam.jamid, e, ui)
			}
		});
	})
}.bind(Song.Manage);


Song.Manage.monitorSlider = function(id, e, ui) {
	var songjam = $j(".song-manage-page.jams .jam[jamid="+ id +"]");
	songjam[0].setAttribute("volume", ui.value);
}.bind(Song.Manage);

Song.Manage.uploadJam = function(id) {
	Jam.createAndToSong(id);
}.bind(Song.Manage);

Song.Manage.uploadJam.add = function(songId, jamId) {
	var onSuccess = function() {
		Navigate.reload();
	};
	var url = formatUrl('/song/' + songId + '/add_music', {add: "jam_" + jamId});
	call(url, {onSuccess: onSuccess});
}.bind(Song.Manage.uploadJam);


Song.Manage.flatten = function(id) {
	var jams = $j(".song-manage-page.jams .jam[jamid].selected");
	var info = $A(jams).map(function(jam) {
		return jam.getAttribute("jamid") + "," + jam.getAttribute('volume')
	});
	var url = formatUrl('/song/' + id + "/manage/flatten", {jam_ids: info.join(";")});
	
	var callback = function(response){
		Modal.showWaitingText("Flattening your jams...");
		var config = {
			url: "/process_info/" + response.responseText,
			messageDiv: $j(".modal-text")[0],
			onSuccess: function() {
				Modal.close();
				window.setTimeout(function() {Song.Manage.publishPopup(id)}, 1500);
			}
		};
		var poll = new Poll(config);
		poll.start();
	}
  
	var url = formatUrl('/song/' + id + "/manage/flatten", {jam_ids: info.join(";")})
  call(url, {onSuccess: callback});
	
}.bind(Song.Manage);

Song.Manage.publish = function(id) {
	var url = formatUrl('/song/' + id + "/manage/publish");
	call(url, {onSuccess: function() {
		Modal.alert("Your Collaboration has been successfully published.");
		Navigate.reload();
	}, method: 'post'})
}.bind(Song.Manage);

Song.Manage.unpublish = function(id) {
	var url = formatUrl('/song/' + id + "/manage/unpublish");
	call(url, {onSuccess: function() {
		Modal.alert("Your Collaboration has been unpublished.");
		Navigate.reload();		
	}, method: 'post'})
}.bind(Song.Manage);

Song.Manage.updatePicture = function(id) {
	Modal.load("/song/" + id + "/manage/update_picture", {minHeight: "170px"});
}.bind(Song.Manage);

Song.Manage.updatePicture.showSpinner = function() {
	$j("form").hide();
	$j(".waiting-message").show();
}.bind(Song.Manage.updatePicture);

Song.Manage.updatePicture.done = function() {
	Modal.close();
	Navigate.reload();
	Modal.slowAlert("The collaboration picture has been changed successfully.");
}.bind(Song.Manage.updatePicture);

Song.Manage.publishPopup = function(id) {
	Modal.load("/song/" + id + "/manage/publish_popup", {minHeight: 140, minWidth: 600});
}.bind(Song.Manage);

Song.Manage.publishPopup.publish = function(id) {
	Modal.close();
	Song.Manage.publish(id);
}.bind(Song.Manage);

Song.Manage.publishPopup.publishLater = function(id) {
	Modal.close();
}.bind(Song.Manage.publish);

Song.Manage.deleteSong = function(id) {
	var url = formatUrl('/partial/account/confirm_delete_song', {song_id: id});
	Modal.load(url, {minHeight: '100px', minWidth: '300px'});
}.bind(Song.Manage);

Song.Manage.deleteSong.submit = function(id) {
	Modal.close();
	var callback = function() {
		General.User.loadHome();
		window.setTimeout(function() {Modal.alert("Your collaboration has been successfully deleted.")}, 1000);
	};
	var url = "/song/"+ id +"/manage/delete_song";
	call(url, {method: 'post', onSuccess: callback});
}.bind(Song.Manage.deleteSong);