({
    getcallbk : function(component, event, helper){
        window.setInterval(
         //   $A.getCallback(
                function() { 
                helper.increment(component,helper);
            	}
         //   )
        , 5000); 
    },
     getAccount : function(component, event, helper) {
        var action = component.get("c.getAccountName");
        action.setParams({"AccId" : "00161000004hkQEAAY"});
        var accountPromise = helper.executeAction(component, action);
        accountPromise.then((result) => {
            alert('Result: ' + result);
        },(error) => {
            alert('An error occurred getting the account : ' + error.message);
        }
     );
    },
    getAccount2 : function(component, event, helper) {
        var action = component.get("c.getAccountName");
        action.setParams({"AccId" : "00161000004hkQEAAY"});
        var accountPromise = helper.executeAction(component, action);
        accountPromise.then(
        $A.getCallback(function(result){
            alert('Result: ' + result);
        }),
        $A.getCallback(function(error){
            alert('An error occurred getting the account : ' + error.message);
        })
     );
    },
    promiseExecution : function(component, event, helper) {
        var exeAction = component.get("c.executeMethod1");
        exeAction.setParams( {"message": 'Promise are cool way to handle callback'});
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                component.set("v.status" ,res ) ; 
            }
        ).catch(
            function(error) {
                component.set("v.status" ,error ) ; 
                console.log(error);
            }
        );
    },
    
    promiseOrchestration : function(component, event, helper) {
        var exeAction1 = component.get("c.executeMethod1");
        var exeAction2 = component.get("c.executeMethod2");
        var exeAction3 = component.get("c.executeMethod3");
        var exeAction4 = component.get("c.executeMethod4");
        var exeAction5 = component.get("c.executeMethod5");
        exeAction1.setParams( {"message": 'Promise are cool way to handle callback executeMethod1'});
        exeAction2.setParams( {"message": 'Promise are cool way to handle callback executeMethod2'});
        exeAction3.setParams( {"message": 'Promise are cool way to handle callback executeMethod3'});
        exeAction4.setParams( {"message": 'Promise are cool way to handle callback executeMethod4'});
        exeAction5.setParams( {"message": 'Promise are cool way to handle callback executeMethod5'});
        Promise.all([
            helper.serverSideCall(component,exeAction1),
            helper.serverSideCall(component,exeAction2) ,
            helper.serverSideCall(component,exeAction3) ,
            helper.serverSideCall(component,exeAction4) ,
            helper.serverSideCall(component,exeAction5) 
            
        ]).then(
            function(response) {
                console.log(response);
                //component.set("v.status" ,"Success" ) ;                 
                //component.set("v.statusArray" ,JSON.stringify(response[0])); 
                component.set("v.status" ,response[1]); 
            }
        ).catch(
            function(error) {
                component.set("v.status" ,error ) ; 
                console.log(error);
            }
        );
    },
    
    promiseChaining : function(component, event, helper) {
        var exeAction = component.get("c.executeMethod1");
        exeAction.setParams( {"message": 'Promise are cool way to handle callback'});
        helper.serverSideCall(component,exeAction).then(
            function(res) {
                var exeAction2 = component.get("c.executeMethod2");
                exeAction2.setParams( {"message": 'Promise are cool way to handle callback'});
                
                return helper.serverSideCall(component,exeAction2) ;
                
            }
        ).then(
            function(res) {
                var exeAction3 = component.get("c.executeMethod3");
                exeAction3.setParams( {"message": 'Promise are cool way to handle callback'});
                component.set("v.status" ,res);
                return helper.serverSideCall(component,exeAction3) ;
            }
        )
        .catch(
            function(error) {
                component.set("v.status" ,error ) ; 
                console.log(error);
            }
        );
    },
    
    promiseRace : function(component, event, helper) {
        var exeAction1 = component.get("c.executeMethod1");
        var exeAction2 = component.get("c.executeMethod2");        
        exeAction1.setParams( {"message": 'Promise are cool way to handle callback executeMethod1'});
        exeAction2.setParams( {"message": 'Promise are cool way to handle callback executeMethod2'});
        let var1 = helper.serverSideCall(component,exeAction1);
        let var2 = helper.serverSideCall(component,exeAction2);        
        Promise.race([var1, var1]).then(
            function(res) {
                var exeAction3 = component.get("c.executeMethod3");
                exeAction3.setParams( {"message": 'Promise are cool way to handle callback'});
                return helper.serverSideCall(component,exeAction3) ;
            }
        )
        .catch(
            function(error) {
                component.set("v.status" ,error ) ; 
                console.log(error);
            }
        ); 
    },
    
    promiseError : function(component, event, helper) {
        var exeAction = component.get("c.executeMethod1");
        helper.serverSideCall(component,exeAction).then(
            function(res) {
            }
        ).catch(
            function(error) {
                component.set("v.status" ,error ) ; 
                console.log(error);
            }
        );
    }
    
})