/**
 * Created by chris.baldock on 22/4/17.
 */
({

    onInit : function(cmp, event){
        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = cmp.get("c.getDefaultContactDetails");
        action.setParams({
            objectName : cmp.get("v.sObjectName"),
            recordId : cmp.get("v.recordId")
        });

         // Create a callback that is executed after
         // the server-side action returns
         action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var responseData = response.getReturnValue();
                cmp.set('v.contactName', responseData.name);
                cmp.set('v.mobileNumber', responseData.phone);
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
         });

         // $A.enqueueAction adds the server-side action to the queue.
         $A.enqueueAction(action);
    },

    sendSMS : function(cmp, event){

        // create a one-time use instance of the serverEcho action
        // in the server-side controller
        var action = cmp.get("c.addSMS");
        action.setParams({
            recordId : cmp.get("v.recordId"),
            objectName : cmp.get("v.sObjectName"),
            contactName : cmp.get("v.contactName"),
            mobileNumber : cmp.get("v.mobileNumber"),
            SMSText : cmp.get("v.SMSText"),
        });

        // Create a callback that is executed after
        // the server-side action returns
        action.setCallback(this, function(response) {
            var state = response.getState();

            if (state === "SUCCESS") {
                var newActivityEvent = $A.get("e.c:PPR_NewActivityEvent");
                newActivityEvent.setParams({
                    "activityType" : "SMS"
                });
                newActivityEvent.fire();

                cmp.set("v.SMSText", "");

            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });

        // $A.enqueueAction adds the server-side action to the queue.
        $A.enqueueAction(action);
    }
})