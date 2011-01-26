var Jam = {Create: {callback: false}, Manage: {}};

Jam.create = function(){
	Modal.load("/jam/create", {minHeight: 250});
}.bind(Jam);

Jam.Create.showSpinner = function(el){
	$j(el).hide();
	$j(".ajax-loader").show();
}.bind(Jam.Create);

Jam.Create.done = function(id){
	Modal.cmp.close();
	this.callback = this.callback || function(){
		Jam.Manage.load(id);	
	}
	this.callback(id);
	this.callback = false;
}.bind(Jam.Create);

Jam.createAndToSong = function(id) {
	Jam.Create.callback = function(jamId){
		Song.Manage.uploadJam.add(id, jamId);
	}.bind(Jam.Create);
	Jam.create();
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