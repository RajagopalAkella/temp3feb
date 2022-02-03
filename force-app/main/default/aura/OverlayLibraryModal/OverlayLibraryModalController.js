({
    handleCloseModal: function(component, event, helper) {
        //Close the Modal Window
        component.find("overlayLib").notifyClose();
    }
})