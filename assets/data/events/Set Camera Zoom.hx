var CameraEventInfo:T = {
	ogCamZoom: 1,
	setCameraZoom: function(newZoom:Float, isAddon:Bool = false, duration:Float = 0.7) {
		if(isAddon) newZoom = camGame.zoom + newZoom;
		else if(newZoom == -1) newZoom = CameraEventInfo.ogCamZoom;

		if(duration == 0) {
			camGame.zoom = defaultCamZoom = newZoom;
		} else {
			FlxTween.tween(camGame, {zoom: newZoom}, duration, {ease: FlxEase.sineOut, 
				onUpdate: function(twn:FlxTween) {
					defaultCamZoom = camGame.zoom;
				},
				onComplete: function(twn:FlxTween) {
					defaultCamZoom = camGame.zoom;
				}
			});
		}
	}
};

function postCreate() {
	CameraEventInfo.ogCamZoom = defaultCamZoom;
	trace(CameraEventInfo.ogCamZoom);
	trace(defaultCamZoom);
}

function onEvent(event:EventGameEvent) {
	if(event.event.name == "Set Camera Zoom") {
		CameraEventInfo.setCameraZoom((event.event.params[0] ?? -1), (event.event.params[1] ?? false), (event.event.params[2] ?? 0.7));
	}
}