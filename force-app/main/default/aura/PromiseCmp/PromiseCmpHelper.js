({
    serverSideCall : function(component,action) {
        return new Promise(function(resolve, reject) { 
            action.setCallback(this, 
                               function(response) {
                                   var state = response.getState();
                                   if (state === "SUCCESS") {
                                       resolve(response.getReturnValue());
                                   } else {
                                       reject(new Error(response.getError()));
                                   }
                               }); 
            $A.enqueueAction(action);
        });
    },
    
    executeAction: function(cmp, action, callback) {
    return new Promise(function(resolve, reject) {
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var retVal=response.getReturnValue();
                resolve(retVal);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        reject(Error("Error message: " + errors[0].message));
                    }
                }
                else {
                    reject(Error("Unknown error"));
                }
            }
        });
    $A.enqueueAction(action);
    });
},
    
    increment : function(component, event) {
  var i = component.get("v.count");
        component.set("v.count", i+1);
 }
})