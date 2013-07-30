public class AudioAnalyzer {
    private PApplet papplet = null;
    
    private Minim minim = null;
    private AudioInput in = null;


    public AudioAnalyzer(PApplet papplet) {
        this.papplet = papplet;
        minim = new Minim(papplet);
        in = minim.getLineIn();    //收麥克風的聲音

        //移除註解將聽到回音 (麥克風收音->喇叭放出來->麥克風收音->喇叭放出來->... 因此造成回音)
        //in.enableMonitoring();
    }
    
    
    public float[] getAudioInLeftBuffer(){
        return in.left.toArray();
    }
    
    public float[] getAudioInRightBuffer(){
        return in.right.toArray();
    }
    
    public float[] getAudioInMixBuffer(){
        return in.mix.toArray();
    }
}

