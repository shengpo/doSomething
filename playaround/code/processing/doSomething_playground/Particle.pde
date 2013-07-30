public class Particle {
    private float x = 0;
    private float y = 0;
    private float z = 0;
    
    private float tx = 0;
    private float ty = 0;
    private float tz = 0;
    
    private float boxDIMX = 200;
    private float boxDIMY = 200;
    private float boxDIMZ = 200;
    
    private int step = 30;
    
    //用來決定點、線、面的顏色基礎
    private Vec3D colAmp=new Vec3D(400, 200, 200);
    
    
    public Particle(float x, float y, float z, float boxDIMX, float boxDIMY, float boxDIMZ){
        this.x = x;
        this.y = y;
        this.z = z;
        this.boxDIMX = boxDIMX;
        this.boxDIMY = boxDIMY;
        this.boxDIMZ = boxDIMZ;
        
        tx = random(-boxDIMX, boxDIMX);
        ty = random(-boxDIMY, boxDIMY);
        tz = random(-boxDIMZ, boxDIMZ);
        step = (int)random(3, 90);
    }
    
    public void update(){
        x = x + (tx-x)/step;
        y = y + (ty-y)/step;
        z = z + (tz-z)/step;
        
        if(dist(x, y, z, tx, ty, tz) < 1){
            tx = random(-boxDIMX, boxDIMX);
            ty = random(-boxDIMY, boxDIMY);
            tz = random(-boxDIMZ, boxDIMZ);
        }
    }
    
    
    public void show(){
        //依particle的位置決定顏色
        Vec3D rawcol = new Vec3D(x, y, z);
        Vec3D col=rawcol.add(colAmp).scaleSelf(0.5);
        strokeWeight(4);
        stroke(col.x, col.y, col.z);

        point(x, y, z);
    }
    
    
    public void setX(float x){
        this.x = x;
    }
    
    public void setY(float y){
        this.y = y;
    }
    
    public void setZ(float z){
        this.z = z;
    }

    public float getX(){
        return x;
    }
    
    public float getY(){
        return y;
    }
    
    public float getZ(){
        return z;
    }
}
