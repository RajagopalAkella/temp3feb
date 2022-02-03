({
	changeVal : function(component, event, helper) {
		this.changeVal1(component, event, helper);
        this.changeVal2(component, event, helper);
	},
    changeVal1 : function(component, event, helper){
        var tempVal = component.get("v.tempVal");
		window.setInterval(
            $A.getCallback(function() { 
                component.set("v.tempVal", "changeVal1");
            }), 5000);         
    },
    changeVal2 :function(component, event, helper){
        var tempVal = component.get("v.tempVal");
		window.setInterval(
            $A.getCallback(function() { 
                component.set("v.tempVal", "changeVal2");
            }), 3000);        
    },
    
    modifyVal : function(component, event, helper){
        var tempVal = component.get("v.tempVal");
        var promval1 = this.modifyVal1(component, event, helper);
        promval1.then(
        $A.getCallback(function(result){
            component.set("v.tempVal", result);
        }) );
    },
    modifyVal1 : function(component, event, helper){
        return new Promise(function(resolve, reject) {  
            window.setInterval(() => {resolve("modifyVal1");}, 5000);
        });
    },
    modifyVal2 : function(component, event, helper){
        
    },
	getcallbkImpH : function(component, event, helper){
    	alert('Hello from callback: ' + component.get("v.tempVal")) ;                                      
	}
   
})