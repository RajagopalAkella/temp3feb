({
    helperMethod : function(component, event, helper) {  
        var vposts = component.get("v.posts");
        component.set("v.postsstr",JSON.stringify(vposts));
        //this.addTwo(component, event, helper);
        this.addThree(component, event, helper, this.addTwo);
    },
    addTwo : function(component, event, helper) {
        var vposts = component.get("v.posts");
        setTimeout(() => {
            vposts.push('2');
            component.set("v.posts","vposts");
            component.set("v.postsstr",JSON.stringify(vposts));
        },3000);
        },                    
    addThree : function(component, event, helper,callback) {
       var vposts = component.get("v.posts");
       setTimeout(() => {
           this.callback();
            vposts.push('3');
            component.set("v.posts","vposts");
            component.set("v.postsstr",JSON.stringify(vposts));
         },2000);
      }
})