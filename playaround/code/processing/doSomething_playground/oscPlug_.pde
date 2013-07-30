void switchBackground(){
    bkManager.switchBackgroundColor();
}


void toggleBackground(){
    bkManager.toggleBackground();
}


void fadeoutBackground(){
    bkManager.toggleFadeOut();
}


void changeMode(int mode){
    switch(mode){
        case 1 :
                isCubeMode = !isCubeMode;
                break;
        case 2 :
                isWaveLineMode = !isWaveLineMode;
                break;
        case 3 :
                isBoxFluidMode = !isBoxFluidMode;
                break;
        case 4 :
                isUsePinEffect = !isUsePinEffect;
                break;
        default :
                break;
    }
}


void trigger(){
    if(isCubeMode)    cubeManager.trigger();
    if(isWaveLineMode)    waveLineCircle.trigger();
    if(isBoxFluidMode)    boxFluid.createParticle();
}


void changeCubeCount(int count){
    if(count <= 0){
        cubeManager.changeCubeCount((int)random(1, 7));
    }else{
        cubeManager.changeCubeCount(count);
    }
}


void changeWaveLineCircleMode(){
    if(isWaveLineMode)    waveLineCircle.changeRandomMode();
}


void toggleTunnel(){
    if(isWaveLineMode){
        waveLineCircle.toggoleTunnel();
        isZoom = false;
        isRotate = false;
        isPan = false;
    }
}


void toggleWireframe(){
    boxFluid.toggleWireframe();
}


void toggleParticle(){
    boxFluid.toggleParticles();
}

void clearParticles(){
    boxFluid.clearParticles();
}
