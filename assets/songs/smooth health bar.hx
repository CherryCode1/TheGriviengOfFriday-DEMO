public var wrapper = {
    smoothedHealth: 1
};

function postCreate() {
    healthBar.parent = wrapper;
    healthBar.parentVariable = "smoothedHealth";
    healthBar.numDivisions = Std.int(healthBar.width / 2);
}

function postUpdate(elapsed) {
    wrapper.smoothedHealth = FlxMath.lerp(wrapper.smoothedHealth, health, elapsed * 9);
}