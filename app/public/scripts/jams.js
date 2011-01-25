var Jam = {Create: {}, Manage: {}};

Jam.create = function(){
	Modal.load("/jam/create", {height: "300px"})
}.bind(Jam);

Jam.Create.showSpinner = function(el){
	$j(el).hide();
	$j(".ajax-loader").show();
}.bind(Jam.Create);

Jam.Create.done = function(id){
	Modal.cmp.close();
	Jam.Manage.load(id);
}.bind(Jam.Create);

Jam.Manage.load = function(id){
	Navigate.loadContent("/jam/" + id + "/manage");
}.bind(Jam.Manage);