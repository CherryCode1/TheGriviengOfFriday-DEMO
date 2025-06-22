function postCreate() {
	camGame.alpha = 0;
}

var ogNotePos:Array<Float> = [];
function onSongStart() {
	FlxTween.tween(camGame, {alpha: 1}, 5);
	for(note in cpuStrums) ogNotePos.push(note.x);
	for(note in playerStrums) ogNotePos.push(note.x);
}

function updatePost(_) {
	iconP2.alpha = iconP1.alpha;
}

function stepHit(curStep:Int) {
	switch(curStep) {
		case 128:
			camGame.flash(FlxColor.WHITE, 0.5);
		case 380:
			for (grpStrum in [cpuStrums, playerStrums]) {
				var i = -1;
				for(strum in grpStrum) {
					i++;
					FlxTween.tween(strum, {x: strum.x - (grpStrum == cpuStrums ? 600 : 324)}, 0.5, {startDelay: i / 18, ease: FlxEase.expoInOut});
				}
			}
		case 503:
			for(strum in cpuStrums) {
				var i = cpuStrums.members.indexOf(strum);
				FlxTween.tween(strum, {x: strum.x + 600, alpha: 0.5}, 0.5, {startDelay: i / 30, ease: FlxEase.expoInOut});
			}
			for(strum in playerStrums) {
				var i = playerStrums.members.indexOf(strum);
				FlxTween.tween(strum, {x: strum.x + (324 / 2)}, 0.5, {ease: FlxEase.sineOut});
			}
		case 672:
			for(strum in playerStrums) {
				var i = playerStrums.members.indexOf(strum);
				FlxTween.tween(strum, {x: strum.x + (324 / 2)}, 1, {startDelay: (i / 30), ease: FlxEase.backOut});
			}
			for(strum in cpuStrums) FlxTween.tween(strum, {alpha: 1}, 0.5, {ease: FlxEase.expoInOut});
		case 640:
			camGame.alpha = camHUD.alpha = 0;
		case 670:
			FlxTween.tween(camGame, {alpha: 0.3}, 3, {ease: FlxEase.sineOut});
			FlxTween.tween(camHUD, {alpha: 1}, 2);
		case 692:
			FlxTween.cancelTweensOf(camGame);
			camGame.alpha = 1;
			
			camGame.zoom = defaultCamZoom = 0.9;
		case 704:
			camGame.zoom = defaultCamZoom = 0.7;
			camGame.flash(FlxColor.WHITE, 1);
		case 832 | 924:
			for (grpStrum in [cpuStrums, playerStrums]) {
				for(strum in grpStrum) {
					FlxTween.tween(strum, {x: strum.x + (grpStrum == cpuStrums ? 50 : -50)}, 0.5, {ease: FlxEase.expoOut});
				}
			}
		case 908 | 960:
			for (grpStrum in [cpuStrums, playerStrums]) {
				for(strum in grpStrum) {
					FlxTween.tween(strum, {x: strum.x - (grpStrum == cpuStrums ? 50 : -50)}, 0.5, {ease: FlxEase.expoOut});
				}
			}
		case 1450:
			FlxTween.tween(camGame, {alpha: 0, zoom: 1.3}, 2, {ease: FlxEase.sineIn});
	}
}