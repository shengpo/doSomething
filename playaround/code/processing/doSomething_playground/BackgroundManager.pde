public class BackgroundManager {
    private int colour = 0;
    private boolean isDrawBackground = true;
    
    private boolean isFadeOut = false;
    
    
    public BackgroundManager(int initColour){
        colour = initColour;
    }
    
    public void show(){
//        if(isDrawBackground){
//            background(colour);
//        }
        if(isDrawBackground){
            if(isFadeOut){
                noStroke();
                fill(0, 50);
                rect(0, 0, width, height);
            }else{
                background(colour);
            }
        }
    }
    
    public void switchBackgroundColor(){
        if(colour == 0){
            colour = 255;
        }else if(colour == 255){
            colour = 0;
        }
    }
    
    
    public void toggleBackground(){
        isDrawBackground = !isDrawBackground;
    }
    
    
    public void toggleFadeOut(){
        isFadeOut = !isFadeOut;
    }
}
