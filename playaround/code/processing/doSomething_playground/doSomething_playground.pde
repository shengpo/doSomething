/*****************************************
 Performance Name: playground 樂園
 Performer: doSomething() a.k.a shengpo
 For Audio-Visual Performance : Good Vibration 好抖 on 2013.7.6
 
 Author: Shen, Sheng-Po (http://shengpo.github.io)
 Development environment: Ubuntu 13.04 + i3 WM
 License: CC BY-SA 3.0
 
 
 操作：
 - for EZCam
    . SHIFT + 滑鼠上下 : zoom in/out
    . CONTROL + 滑鼠 : rotate
    . ALT + 滑鼠 : pan
    . dot (.) : reset zoom/rotate/pan
 - for background
    . 空白鍵 : 背景顏色切換 黑/白
    . / : 是否刷新背景
 - for mode
     . 1 : 啟動/關閉 cube mode 
     . 2 : 啟動/關閉 wave line circle mode
     . 3 : 啟動/關閉 box fluid mode
     . 4 : 啟動/關閉 pin shadow effect
     . 5 : 啟動/關閉 fade-out effect
 - trigger
    . t : trigger CubeMode/WaveLineCircleMode/BoxFluidMode
 - for CubeMode
    . c : 改變cube數量 (1~7) 
 - for WaveLineCircle
    . m : 改變顯示模式 line <-> circle 
    . z : 顯示/隱藏 tunnel模式 + 滑鼠橫向移動改變tunnel形狀
 - for BoxFluid
    . w : 顯示/隱藏 wireframe
    . p : 顯示particle or 顯示volume
    . k : 清除所有的particle

 說明：
 以上操作，除了EZCam的部份之外，都可以透過OSC呼叫 
 OSC message如下：
 /switchBackground
 /toggleBackground
 /fadeoutBackground
 /changeMode i
 /trigger
 /changeCubeCount i
 /changeWaveLineCircleMode
 /toggleTunnel
 /toggleWireframe
 /toggleParticle
 /clearParticles
 
 
 注意：
 - 不可以用滑鼠動態調整視窗大小，會error and then crash!! (Processing 2.0的bug)
 
 *****************************************/

import ddf.minim.*;
//import toxi.color.*;
import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.math.*;
import toxi.volume.*;
import oscP5.*;
import netP5.*;


//for app
boolean isResized = false;

//for garbage collector
GarbageCollector gc = null;
float gcPeriodMinute = 3;    //設定幾分鐘做一次gc

//for EZCam
EZCam ezCam = null;
boolean isZoom = false;
boolean isRotate = false;
boolean isPan = false;

//for audio analyzer
AudioAnalyzer audioAnalyzer = null;

//for BackgroundManager
BackgroundManager bkManager = null;

//for CubeManager
CubeManager cubeManager = null;
boolean isCubeMode = false;

//for WaveLineCircle
WaveLineCircle waveLineCircle = null;
boolean isWaveLineMode = false;

//for BoxFluid
BoxFluid boxFluid = null;
boolean isBoxFluidMode = false;

//for pin shadow effect
PinManager pinManager = null;
int cols = 80;
int rows = 45;
boolean isUsePinEffect = false;

//for OSC
OscP5 oscP5 = null;




//set frame undecorated to emulate full screen
public void init() {
    frame.dispose();  
    frame.setUndecorated(true);  
    super.init();
}


void setup() {
    size(400, 300, P3D);         //default size, but not final size.
    frame.setResizable(true);    //because this app is set to resizable

    //OSC
    oscP5 = new OscP5(this, 12000);
    oscP5.plug(this, "switchBackground", "/switchBackground");
    oscP5.plug(this, "toggleBackground", "/toggleBackground");
    oscP5.plug(this, "fadeoutBackground", "/fadeoutBackground");
    oscP5.plug(this, "changeMode", "/changeMode");
    oscP5.plug(this, "trigger", "/trigger");
    oscP5.plug(this, "changeCubeCount", "/changeCubeCount");
    oscP5.plug(this, "changeWaveLineCircleMode", "/changeWaveLineCircleMode");
    oscP5.plug(this, "toggleTunnel", "/toggleTunnel");
    oscP5.plug(this, "toggleWireframe", "/toggleWireframe");
    oscP5.plug(this, "toggleParticle", "/toggleParticle");
    oscP5.plug(this, "clearParticles", "/clearParticles");

    //initializations
    ezCam = new EZCam();
    audioAnalyzer = new AudioAnalyzer(this);
    bkManager = new BackgroundManager(0);
    cubeManager = new CubeManager();
    waveLineCircle = new WaveLineCircle();
    boxFluid = new BoxFluid();
    pinManager = new PinManager(cols, rows);


    //garbage collector
    gc = new GarbageCollector(gcPeriodMinute);
    gc.start();
}


void draw() {
    noCursor();
    makeResizeWorkable();    //only run once
    bkManager.show();

    ezCam.beginCam();

    if(isBoxFluidMode){
        boxFluid.update();
        boxFluid.show(width/2, height/2, 0);
    }

    if(isCubeMode){
        cubeManager.update();
        cubeManager.show();
    }

    if(isWaveLineMode){
        waveLineCircle.update(audioAnalyzer.getAudioInMixBuffer());
        waveLineCircle.show();
    }

    ezCam.endCam();

    if(isUsePinEffect){
        PImage tmp = get();
        background(0);
        pinManager.update(tmp);
        pinManager.show();
    }
}


void makeResizeWorkable() {
    if (!isResized) {
        frame.setSize(displayWidth, displayHeight/2);
        isResized = true;
        
        mouseX = width/2;
        mouseY = height/2;
    }
}


void keyPressed() {
    //for EZCam
    if(key == CODED){
        if(keyCode == SHIFT){
            isZoom = true;
            isRotate = false;
            isPan = false;
            println("EZCam zoom mode ...");
        }
        if(keyCode == CONTROL){
            isZoom = false;
            isRotate = true;
            isPan = false;
            println("EZCam rotate mode ...");
        }
        if(keyCode == ALT){
            isZoom = false;
            isRotate = false;
            isPan = true;
            println("EZCam pan mode ...");
        }
    }
    
    if(key == '.'){
        ezCam.resetZoom();
        ezCam.resetRotate();
        ezCam.resetPan();
        isZoom = false;
        isRotate = false;
        isPan = false;
    }

    //background
    if (key == ' ') {
        bkManager.switchBackgroundColor();
    }
    
    if(key == '/'){
        bkManager.toggleBackground();
    }

    //trigger
    if (key == 't') {
        if(isCubeMode)    cubeManager.trigger();
        if(isWaveLineMode)    waveLineCircle.trigger();
        if(isBoxFluidMode)    boxFluid.createParticle();
    }

    //change Cube count
    if (key == 'c') {
        cubeManager.changeCubeCount((int)random(1, 7));
    }
    
    //for WaveLineCircle
    if(key == 'm'){
        if(isWaveLineMode)    waveLineCircle.changeRandomMode();
    }
    
    if(key == 'z'){
        if(isWaveLineMode){
            waveLineCircle.toggoleTunnel();
            isZoom = false;
            isRotate = false;
            isPan = false;
        }
    }
    
    //for BoxFluid
    if (key=='w') {
        boxFluid.toggleWireframe();
    }
    
    if (key=='p') {
        boxFluid.toggleParticles();
    }
    
    if (key=='k') {
        boxFluid.clearParticles();
    }
    
    //select mode
    if(key == '1'){
        isCubeMode = !isCubeMode;
    }

    if(key == '2'){
        isWaveLineMode = !isWaveLineMode;
    }

    if(key == '3'){
        isBoxFluidMode = !isBoxFluidMode;
    }
    
    if(key == '4'){
        isUsePinEffect = !isUsePinEffect;
    }
    
    if(key == '5'){
        bkManager.toggleFadeOut();
    }
}

