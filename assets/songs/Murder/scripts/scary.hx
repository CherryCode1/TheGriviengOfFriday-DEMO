introLength = 0;

function onCountdown(e) e.cancel();

function stepHit()
{
    switch(curStep)
    {
        case 382:
            scary = true;
            angleVar = 5;
        case 640:
            scary = false;
            angleVar = 2;
        case 1152:
            scary = true;
            angleVar = 5;
        case 1408:
            scary = false;
            angleVar = 2;
    }
}