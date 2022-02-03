({
	init : function(component, event, helper) {
		var spstr = component.get("v.spString");
        spstr = spstr.replace(/,/g,'<br/>');
        component.set("v.spString", spstr);
	}
})