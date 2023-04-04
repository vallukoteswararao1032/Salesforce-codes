({
    doInit: function (component) {
        console.log('doINit order field mapper helper');
        var action = component.get("c.getAllMappingData");
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS") {
                if (result.getReturnValue().length > 0) {
                    console.log('result first', result.getReturnValue());
                    component.set('v.orderFieldMapperList', result.getReturnValue());
                }
            } else if (state == "ERROR") {
                alert("Error in calling server side action");
            }
        });
        $A.enqueueAction(action);
    },
    saveOrderMapping: function (component) {
        var action = component.get("c.saveMappingData");
        action.setParams({
            updateList: component.get('v.orderFieldMapperList'),
            deleteList: component.get('v.orderFieldMapperDeleteList')
        });
        action.setCallback(this, function (result) {
            var state = result.getState();
            if (component.isValid() && state === "SUCCESS") {
                $A.get('e.force:refreshView').fire();
                this.showSuccessToast(component);
            } else if (state == "ERROR") {
                this.showErrorToast(component);
            }
        });
        $A.enqueueAction(action);
    },
    showSuccessToast: function (component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "type": "success",
            "message": "The record has been saved successfully."
        });
        toastEvent.fire();
    },
    showErrorToast: function (component) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Error!",
            "type": "error",
            "message": "There was error saving record. Please retry."
        });
        toastEvent.fire();
    },
})