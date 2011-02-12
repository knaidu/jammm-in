var Jam = {Create: {callback: false}, Manage: {}};

Jam.Manage.like = function(id) {
	call("/jam/" + id + "/manage/like", {onSuccess: Layout.ContextMenu.reload, method: 'post'});
}.bind(Jam.Manage);

Jam.Manage.unlike = function(id) {
	call("/jam/" + id + "/manage/unlike", {onSuccess: Layout.ContextMenu.reload, method: 'post'});
}.bind(Jam.Manage);

Jam.create = function(){
	var callback = arguments[0] || false;
	this.Create.callback = callback;
	Modal.load("/jam/create", {minHeight: 350});
}.bind(Jam);

Jam.Create.submit = function(el) {
	var names = ['name', 'file', 'instrument', 'genre'];
	var any  = $A(names).any(function(e) {
		var je = $j("[name="+e+"]");
		return (je.val().blank() || je.val() == 'false');
	});
	if(any){
		$j(".error-response").html("Please fill in all the details");
		return;
	}
	var f = $(document.getElementsByTagName("form")[0]);
	f.submit();
	this.showSpinner(el);
}.bind(Jam.Create);

Jam.Create.showSpinner = function(el){
	$j(el).parent().hide();
	$j(".ajax-loader").show();
}.bind(Jam.Create);

Jam.Create.done = function(id){
	Modal.cmp.close();
	this.callback = this.callback || function(){
		Jam.Manage.load(id);
		window.setTimeout(function() {Jam.Manage.publishPopup(id)}, 1000);
	}
	this.callback(id);
	this.callback = false;
}.bind(Jam.Create);

Jam.createAndToSong = function(id) {
	var fn = function(jamId){
		Song.Manage.uploadJam.add(id, jamId);
	}.bind(Jam.Create);
	Jam.create(fn);
}.bind(Jam);

Jam.Manage.load = function(id){
	Navigate.loadContent("/jam/" + id + "/manage");
}.bind(Jam.Manage);

Jam.Manage.updateAudioFile = function(id){
	Modal.load("/jam/" + id + "/manage/update_file", {minHeight: 150});
}.bind(Jam.Manage);

Jam.Manage.updateAudioFile.showSpinner = function(el) {
	$j("form").hide();
	$j(".waiting-message").show();
}.bind(Jam.Manage.updateAudioFile);

Jam.Manage.updateAudioFile.done = function(){
	Modal.close();
	Navigate.reload();
}.bind(Jam.Manage.updateAudioFile);

Jam.Manage.publish = function(id) {
	var url = formatUrl('/jam/' + id + "/manage/publish", {jam_id: id})
	var onSuccess = function() {
		Modal.alert("Your jam has been successfully published");
		Navigate.reload();
	};
	call(url, {onSuccess: onSuccess, method: 'post'});
}.bind(Jam.Manage);

Jam.Manage.unpublish = function(id) {
	var url = formatUrl('/jam/' + id + "/manage/unpublish")
	var onSuccess = function() {
		Modal.alert("Your jam has been successfully unpublished");
		Navigate.reload();
	};
	call(url, {onSuccess: onSuccess, method: 'post'});
}.bind(Jam.Manage);

Jam.Manage.publishPopup = function(id) {
	Modal.load("/jam/" + id + "/manage/publish_popup", {minHeight: 120, minWidth: 600});
}.bind(Jam.Manage);

Jam.Manage.publishPopup.publish = function(id) {
	Modal.close();
	Jam.Manage.publish(id);
}.bind(Jam.Manage);

Jam.Manage.publishPopup.publishLater = function(id) {
	Modal.close();
}.bind(Jam.Manage.publish);