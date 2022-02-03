({
	pollApex : function(component, event, helper) {
		helper.callApexMethod(component,helper);
        window.setInterval(
            $A.getCallback(function() { helper.callApexMethod(component,helper); }), 5000 );
    },
        
    callApexMethod : function (component,helper){
        var recID = component.get("v.recordId");
        var action = component.get("c.getAccountOrders");
        action.setParams({
            ExternalAccId: recID
        });
        action.setCallback(this, function(response){
            var data = response.getReturnValue();
            component.set("v.OrderList", data);
        });
        $A.enqueueAction(action);
    }	
})