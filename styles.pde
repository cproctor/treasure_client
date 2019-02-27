/* 
 * It can be helpful to cluster styling together into functions, so that you don't 
 * have to repeat them in different parts of your program, and so you can 
 * change them in one place. 
 */

void wireframe() {
 noFill();
 stroke(0);
 strokeWeight(1);
}

void yellowFill() {
 fill(200, 200, 0);
 stroke(0);
 strokeWeight(2);
}

void brightYellowFill() {
 fill(255, 255, 0);
 stroke(0);
 strokeWeight(2);
}

void treasureFill() {
 fill(200, 200, 255);
 stroke(50, 50, 200);
 strokeWeight(4);
}


void greenFill() {
 fill(0, 200, 0);
 stroke(0);
 strokeWeight(2);
}

void darkGreyFill() {
 fill(50);
 stroke(0);
 strokeWeight(2);
}

void hugeBlueText() {
 textSize(64);
 fill(50, 50, 200);
}

void bigBlackText() {
 textSize(32);
 fill(0);
}

void bigGreyText() {
 textSize(32);
 fill(128);
}

void mediumGreyText() {
 textSize(18);
 fill(128);
}
