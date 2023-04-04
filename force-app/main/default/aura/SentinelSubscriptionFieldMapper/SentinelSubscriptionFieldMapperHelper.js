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
        
         // for isSync from User setting 24 Nov 2020
         var actionIsCheck = component.get('c.checkEnabled');
		
		console.log('++++1 '+actionIsCheck); 
        actionIsCheck.setCallback(this, function(response){
			
            var state = response.getState();
			console.log('++++2 '+state); 
			
            if(state === 'SUCCESS' && component.isValid()){
                /* set the value to the attribute of the component */
                var responseValue = response.getReturnValue();
                console.log('++++3 '+responseValue); 
				var mainDivId = document.getElementById("mainDiv");
                var showMsgNoAccessDiv = document.getElementById("showMsgNoAccessDiv");
                
                //console.log('++++31 '+mainDivId); 
                //console.log('++++32 '+responseValue.includes('Subscription')); 
				 if (responseValue.includes('Subscription') ) {
                    mainDivId.style.display = "block"; // show main div
                     showMsgNoAccessDiv.style.display = "none"; // hide no access msg
                    } 
                else {
                    mainDivId.style.display = "none";// main div hide
                    showMsgNoAccessDiv.style.display = "block"; // show no access msg
                    }
				
                
            }else{
                var errors = response.getError();
                $A.log(errors);
                if(errors || errors[0].message){
                    console(errors[0].message);
                }
            }
        });
        $A.enqueueAction(actionIsCheck);
        
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