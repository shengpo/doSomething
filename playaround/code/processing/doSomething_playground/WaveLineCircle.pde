//this class is modified from toxiclibs' example: PolarUnravel

public class WaveLineCircle {
    private float transition, transTarget;    // keepers of transition state & target
    private InterpolateStrategy is=new SigmoidInterpolation(3);    // use a S-Curve to achieve an ease in/out effect

    private Vec2D normUp = null;
    
    private float[] audioBuffer = null;
    
    private int mode = 1;    //目前共3種mode: 0表示line-mode, 1表示box-mode, 2表示sphere-mode
    private boolean isOpenTunnel = false;


    public WaveLineCircle() {
        normUp = new Vec2D(0, -1);    //line的方向
        transition = 1;
        transTarget = 1;
    }


    public void update(float[] audioBuffer) {
        // update transition
        transition = transition + (transTarget-transition)*0.01;

        this.audioBuffer = audioBuffer;
    }


    public void show() {
        float w2=width * 0.5;
        float h2=height * 0.5;
        
        pushMatrix();
        translate(w2, h2);

        //以270度處為開口
        for (int i=270; i<360+270; i=i+2) {
            float theta = radians(i);
            // create a polar coordinate
            Vec2D polar = new Vec2D(200, theta);    //圓形半徑(極座標長度)為200
            // also use theta to manipulate line length
            float len = audioBuffer[(int)map(i, 270, 360+270, 0, audioBuffer.length)]*100;
            // convert polar coord into cartesian space (to obtain position on a circle)
            Vec2D circ = polar.copy().toCartesian();
            // create another coord splicing the circle at the top and using theta difference as position on a line
            Vec2D linear = new Vec2D((MathUtils.THREE_HALVES_PI - polar.y) * w2 / PI + w2, 100);
            // interprete circular position as normal/direction vector 
            Vec2D dir = circ.getNormalized();
            // interpolate both position & normal based on current transition state
            circ.interpolateToSelf(linear, transition, is);
            dir.interpolateToSelf(normUp, transition, is).normalizeTo(len);

            switch(mode){
                case 0:    //line-mode
                        showLineMode(circ.x, circ.y, dir.x, dir.y);
                        break;
                case 1:    //box-mode
                        showBoxMode(circ.x, circ.y, dir.x, dir.y);
                        break;
                case 2:    //sphere-mode
                        showSphereMode(circ.x, circ.y, dir.x, dir.y);
                        break;
                default:
                        break;
            }
            
            //open tunnel
            if(isOpenTunnel){
                showTunnel(i, circ.x, circ.y, dir.x, dir.y);
            }
        }
        popMatrix();
    }

    public void trigger() {
        // toggle transition target state
        transTarget=(++transTarget % 2);
    }
    
    
    public void changeMode(int mode){
        if(mode<0 || mode>2){
            changeRandomMode();
        }else{
            this.mode = mode;
        }
    }
    
    public void changeRandomMode(){
        mode = (int)random(3);
    }
    
    
    public void toggoleTunnel(){
        isOpenTunnel = !isOpenTunnel;
    }
    
    public void showLineMode(float x, float y, float dirX, float dirY){
        stroke(255);
        strokeWeight(1);
        line(x, y, x+dirX*4, y+dirY*4);
    }
    
    
    public void showBoxMode(float x, float y, float dirX, float dirY){
            pushMatrix();
            translate(x, y);
            noStroke();
            fill(255, 150);
            box(abs(dirX+dirY)*2);
            popMatrix();
    }
    
    
    public void showSphereMode(float x, float y, float dirX, float dirY){
            pushMatrix();
            translate(x, y);
            noStroke();
            fill(255, 180);
            sphereDetail(5);
            sphere(abs(dirX+dirY)*6);
            popMatrix();
    }
    
    
    public void showTunnel(int i, float x, float y, float dirX, float dirY){
        pushMatrix();
        translate(0, 100);
        rotateX(radians(i*map(mouseX, 0, width, 1, 100)));
        stroke(255, 200);
        strokeWeight(abs(dirX+dirY)*1.2);
        point(x, y);
        popMatrix();
    }    
}

