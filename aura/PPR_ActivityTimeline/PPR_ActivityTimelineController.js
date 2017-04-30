/**
 * Created by chris.baldock on 22/4/17.
 */
({
    getHistory: function(component,event){

        //var spinner = component.find("mySpinner");
        //$A.util.toggleClass(spinner, "slds-hide");

       console.log('Entered getHistory');

       //alert('recordId: '+component.get("v.recordId")+'. objectId: '+component.get("v.sObjectName"));

       //component.set("v.timeLineItems", '');

        //retrieve server method
        var action = component.get("c.getActivityTimeline");
        //set method parameters
        action.setParams({
            recordId : component.get("v.recordId"),
            objectName : component.get("v.sObjectName")
        });

        // set call back instructions
        action.setCallback(this, function(response){
            var state = response.getState();

            if (state === "SUCCESS") {
                // You would typically fire a event here to trigger
                // client-side notification that the server-side
                // action is complete

               // assign server retrieved items to component variable
               component.set("v.timeLineItems", response.getReturnValue());
               //$A.util.toggleClass(spinner, "slds-hide");

            }
            else if (state === "INCOMPLETE") {
                // do something
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

        // queue action on the server
        $A.enqueueAction(action);


    }
})