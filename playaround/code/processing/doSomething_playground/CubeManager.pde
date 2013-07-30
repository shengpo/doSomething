public class CubeManager {
    private ArrayList<Cube> cubeList = null;
    private int cubeCount = 0;
    private boolean isRender = false;
    
    
    public CubeManager(){
        cubeList = new ArrayList<Cube>();
    }
    
    
    public void update(){
        isRender = true;
        for(Cube c : cubeList){
            c.update();
        }
        
        reArrangeLocationAndSize();
    }
    
    
    public void show(){
        for(Cube c : cubeList){
            c.show();
        }
        isRender = false;
    }
    
 
    public void trigger(){
        for(Cube c : cubeList){
            c.trigger();
        }
    }
 
    
    public void changeCubeCount(int count){
        if(isRender) return;    //update()跟show()還沒做完的話，不做這個function
        
        if(cubeCount < count){
            //add cube
            for(int i=0; i<count-cubeCount; i++){
                cubeList.add(new Cube(150));
            }
        }else if(cubeCount > count){
            //remove cubes randomly
            for(int i=0; i<cubeCount-count; i++){
                cubeList.remove((int)random(cubeList.size()));
            }
        }
        
        //reset cube count
        cubeCount = count;
    }
    

    //for resizeable window    
    private void reArrangeLocationAndSize(){
        float span = width/(cubeCount+1f);
        float size = span*0.4;
        
        for(int i=0; i<cubeList.size(); i++){
            cubeList.get(i).setLocation(new float[]{(i+1)*span, height/2, 0});
            cubeList.get(i).setSize(size);
        }
    }
}
