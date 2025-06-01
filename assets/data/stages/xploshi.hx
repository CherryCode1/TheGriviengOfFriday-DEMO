function postCreate() {
    madfamily.visible = false;
}

function stepHit(step) {

    switch (step) {
        case 1296: 
            madfamily.visible = true;
            family.visible = false;
            strumLines.members[1].characters[0].scale.set(1.21,1.21);
            strumLines.members[1].characters[0].y += 0;

        case 2352: 
            madfamily.visible = false;
            bg.visible = false;
            strumLines.members[1].characters[0].visible = false;
    }
}