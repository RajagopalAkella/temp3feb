({
    handleShowModal: function(component) {
        var fName = component.get("v.FirstName");
        var lName = component.get("v.LastName");
        
        $A.createComponent("c:OverlayLibraryModal",
                           {
                               "FirstName" : fName,
                               "LastName" : lName
                           },
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   var modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: "Custom header",
                                       body: modalBody, 
                                       showCloseButton: true,
                                       closeCallback: function(ovl) {
                                           console.log('Overlay is closing');
                                       }
                                   }).then(function(overlay){
                                       console.log("Overlay is made");
                                       $A.get("e.force:closeQuickAction").fire();
                                   });
                               }
                           });
    },
    
    handleShowModalFooter : function (component, event, helper) {
        var modalBody;
        var modalFooter;
        $A.createComponents([
            ["c:OverlayLibraryBody",{}],
            ["c:OverlayLibraryFooter",{}]
        ],
                            function(components, status){
                                if (status === "SUCCESS") {
                                    modalBody = components[0];
                                    modalFooter = components[1];
                                    component.find('overlayLib').showCustomModal({
                                        header: "Application Confirmation",
                                        body: modalBody,
                                        footer: modalFooter,
                                        showCloseButton: true,
                                        cssClass: "my-modal,my-custom-class,my-other-class",
                                        closeCallback: function() {
                                            alert('You closed the alert!');
                                        }
                                    }).then(function (overlay) {
                                        //closes the modal immediately
                                        //overlay.close();
                                    });
                                }
                            }
                           );
    }
})