({
	init: function(component, event, helper) {
        setTimeout($A.getCallback(function() {
            $A.get("e.c:getCallbackExampleEvt").fire();
        }),1000);
    },
    updateView: function(component, event, helper) {
        component.set("v.text", "Hello World");
    }
})