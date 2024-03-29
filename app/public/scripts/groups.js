var Group = {Manage: {}}

Group.Manage.filter = function(searchStr) {
	var users = $j(".user");
	General.List.filter(users, searchStr)
}.bind(Group.Manage);

Group.Manage.updatePicture = function(id) {
	Modal.load("/groups/" + id + "/manage/update_picture", {minHeight: "170px"});
}.bind(Group.Manage);

Group.Manage.updatePicture.showSpinner = function() {
	$j("form").hide();
	$j(".waiting-message").show();
}.bind(Group.Manage.updatePicture);

Group.Manage.updatePicture.done = function() {
	Modal.close();
	Navigate.reload();
	Modal.slowAlert("Your schools profile picture has been successfully changed.");
}.bind(Group.Manage.updatePicture);

Group.Manage.removeUser = function(divId) {
	var el = $(divId);
	var groupHandle = el.getAttribute("grouphandle");
	var userId = el.getAttribute("userid");
	var url = formatUrl('/groups/' + groupHandle + "/manage/remove_user", {user_id: userId});
	var onSuccess = function() {
		Modal.alert("Successfully removed user from your school.");
		el.remove();
	};
	General.WaitingDialog.show();
	call(url, {onSuccess: onSuccess, method: 'post'});
}.bind(Group.Manage);