var initialZoom:Float = 1;
var amountZoom:Float = 0.0;
var setInitialZoom:Bool = false;
function postCreate() {
    initialZoom = defaultCamZoom; 
}
function onEvent(event) {
    if (event.event.name == "set defaultCamZoom") {
      
       setInitialZoom = event.event.params[0];
       if (!setInitialZoom){
        amountZoom = event.event.params[1];
        defaultCamZoom = amountZoom;
       }else{
        amountZoom = initialZoom;
        defaultCamZoom = amountZoom;
       }
       
    }
}
