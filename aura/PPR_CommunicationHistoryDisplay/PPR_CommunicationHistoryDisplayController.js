/**
 * Created by chris.baldock on 22/4/17.
 */
({
    refreshChild : function(cmp, event){
        console.log('Entered Refresh Child');
        cmp.find("activityTimeline").refresh();
    }
})