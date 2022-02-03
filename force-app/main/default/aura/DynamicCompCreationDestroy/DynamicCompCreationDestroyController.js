({
    handleComponent : function(component, event, helper) {
        $A.createComponent(
            "ui:inputText",
            {
                "aura:id": "inpId",
                "labelClass":"slds-form-element__label",
                "placeholder":"Enter Some Text",
                "label": "Enter some text",
                "class": "slds-input"
            },
            function(newInp, status, errorMessage){
                if (status === "SUCCESS") {
                    var body = component.get("v.body");
                    body.push(newInp);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                }
                    else if (status === "ERROR") {
                        console.log("Error: " + errorMessage);
                    }
            }
        );
    },
    handleDestroy : function(component,event,helper){
        if(component.find("inpId")!=null || component.find("inpId")!='undefined'){
            component.find("inpId").destroy();
        }else{
            alert(' Component is already Destroyed ');
        }
        
    },
    handleDestroywithfacet : function(component,event,helper){
        var body = component.get("v.body");
        body.shift();
        component.set("v.body", body);
        
    }
})