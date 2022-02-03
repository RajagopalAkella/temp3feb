({
	getcallbk : function(component, event, helper){
        helper.changeVal(component, event, helper);
	},
    getModifyBk : function(component, event, helper){
        helper.modifyVal(component, event, helper);
    },
    getcallbkImp : function(component, event, helper){
        window.setTimeout(
          //  $A.getCallback(
          function() { 
              helper.getcallbkImpH(component, event, helper);
           }
          // )
        , 5000); 
    }
})