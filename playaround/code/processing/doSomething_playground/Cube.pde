public class Cube {
    private PShape cube = null;
    
    private float cubeSize = 20;
    private float[] location = new float[3];
    private float[] degree = new float[3];
    private float[] tdegree = new float[3];
    
    private int colour = 0;
    
    private int step = 30;
    
    
    public Cube(float cubeSize){
        this.cubeSize = cubeSize;
        
        cube = createShape(BOX, cubeSize);
        
        //default degrees
        for(int i=0; i<degree.length; i++){
            tdegree[i] = degree[i] = 0;
        }
        
        //default color
        colour = color(255);
        
        //random step
        step = (int)random(3, 10);
    }
    
    
    public void update(){
        float sum = 0;
        
        for(int i=0; i<degree.length; i++){
            degree[i] = degree[i] + (tdegree[i]-degree[i])/step;
            
            sum = sum + abs(tdegree[i]-degree[i]);
        }
        
        if(sum < 10) colour = color(255);
        cube.setFill(colour);
    }
    
    
    public void show(){
        pushMatrix();
        translate(location[0], location[1], location[2]);
        rotateX(radians(degree[0]));
        rotateY(radians(degree[1]));
        rotateZ(radians(degree[2]));
        shape(cube, 0, 0);
        popMatrix();
    }
    
    
    public void trigger(){
        //set current color to red
        colour = color(255, 0, 0);
        
        float r = random(3);
        if(r < 1){
            degree[0] = degree[0] + (random(2)<1 ? 90 : -90);
        }else if(r < 2){
            degree[1] = degree[1] + (random(2)<1 ? 90 : -90);
        }else{
            degree[2] = degree[2] + (random(2)<1 ? 90 : -90);
        }
    }
    
    
    public void setLocation(float[] location){
        this.location = location;
    }
    
    
    public void setSize(float cubeSize){
        cube.scale(cubeSize/this.cubeSize, cubeSize/this.cubeSize, cubeSize/this.cubeSize);
        this.cubeSize = cubeSize;
    }
}
