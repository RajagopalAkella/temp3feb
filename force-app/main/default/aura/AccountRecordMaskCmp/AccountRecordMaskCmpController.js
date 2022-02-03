({
    handleClick : function (cmp, event, helper) {
        //alert("You clicked: " + event.getSource().get("v.label"));
        alert("recordId is: " + cmp.get("v.recordId"));
        
        var navService = cmp.find("navService");
        var pageReference = {
            "type": "standard__recordPage",
            "attributes": {
                "recordId": cmp.get("v.recordId"),
                "objectApiName": "Account",
                "actionName": "view"
            },
            "state": {
                "nooverride": true
            }
        };
        //event.preventDefault();
        navService.navigate(pageReference);
        
    }
});