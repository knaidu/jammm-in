var Admin = {PromotionCode: {}};

Admin.PromotionCode.create = function() {
	var invites = $j("#pc-invites").val();
	if(!confirm("Are you sure you want to create a promotion code with size " + invites + " ?")) return;
	var url = "/admin/promotion_codes/create";
	var params = {invites_remaining: invites};
	var onFailure = function(t) {alert(t.responseText)};
	call(url, {method: 'post', parameters: params, onSuccess: reload, onFailure: onFailure});
}.bind(Admin.PromotionCode);