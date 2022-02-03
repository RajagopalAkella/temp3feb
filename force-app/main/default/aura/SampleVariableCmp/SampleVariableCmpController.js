({
    
	doInit : function(component, event, helper) {
        var action = component.get("c.initClass");
        action.setParams({
            TempVal: "Rajagopal"
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.objSampleVariable', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);	
    }
    
})