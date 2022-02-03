/* dynamicHandlerController.js */
({
    fireEvent : function(cmp, event) {
        // Get the component event by using the
        // name value from <aura:registerEvent> tag
        var compEvent = cmp.getEvent("compEvent");
        compEvent.fire();
        console.log("Fired a component event");
    },
    
    addEventHandler : function(cmp, event) {
        // First param matches name attribute in <aura:registerEvent> tag
        cmp.addEventHandler("compEvent", cmp.getReference("c.handleEvent"));
        console.log("Added handler for component event");
    },

    handleEvent : function(cmp, event) {
        alert("Handled the component event");
    },

    fireAppEvent : function(cmp, event) {
        var appEvent = $A.get("e.c:sampleAppEvent");
        appEvent.fire();
        console.log("Fired an application event");
    },
    
    addAppEventHandler : function(cmp, event) {
        // Can use cmp.getReference() or anonymous function for handler
        // First param is event descriptor, "c:appEvent", for application events
        cmp.addEventHandler("c:sampleAppEvent", cmp.getReference("c.handleAppEvent"));
        // Can alternatively use anonymous function for handler
        //cmp.addEventHandler("c:appEvent", function(auraEvent) {
            // console.log("Handled the application event in anonymous function");
        //});
        console.log("Added handler for application event");
    },

    handleAppEvent : function(cmp, event) {
        alert("Handled the application event");
    }         
})