//this class is modified from toxiclibs' example: BoxFluidDemo

public class BoxFluid {
    //box2大小為particle移動的範圍
    private int DIMX=200;    //200, 200, 200 為目前最適大小
    private int DIMY=200;
    private int DIMZ=200;

    //在box中移動的particle, particle的位置決定最後的mesh形狀
    private ArrayList<Particle> particleList = null;
    
    //mesh的grid數量大小 (數量越大, mesh運算量越大)
    private int GRID=18;
    private Vec3D SCALE=new Vec3D(DIMX, DIMY, DIMZ).scale(2);
    private float isoThreshold=3;    //可作為變數控制(建議值1~5, 以浮點數作為增減值)

    //用來製造mesh的物件
    private VolumetricSpaceArray volume;
    private IsoSurface surface;
    
    //存放最後產生的mesh
    private TriangleMesh mesh=new TriangleMesh("fluid");
    
    //用來決定點、線、面的顏色基礎
    Vec3D colAmp=new Vec3D(400, 200, 200);
    
    //顯示模式    
    private boolean showParticles=true;    //是否秀出 particles
    private boolean isWireFrame=false;    //是否秀出mesh網格
    private boolean isClosed=true;        //是否將mesh做close處理

    //整個BoxFluid在3D中的位移
    private int translateX = 0;
    private int translateY = 0;
    private int translateZ = 0;
    
    
    public BoxFluid(){
        particleList = new ArrayList<Particle>();
    
        volume=new VolumetricSpaceArray(SCALE, GRID, GRID, GRID);
        surface=new ArrayIsoSurface(volume);
    }
    
        
    public void update(){
        //update particles
        for(int i=0; i<particleList.size(); i++){
            particleList.get(i).update();
        }
        
        computeVolume();
    }
    
    
    public void show(int translateX, int translateY, int translateZ){
        pushMatrix();
//        translate(width/2, height/2);
        translate(translateX, translateY, translateZ);
        
//        noFill();
//        stroke(255, 192);
        strokeWeight(1);
//        box(DIMX*2, DIMY*2, DIMZ*2);
    
        if(showParticles){
//            strokeWeight(4);
//            stroke(0);
//            
//            for(int i=0; i<particleList.size(); i++){
//                Particle p = particleList.get(i);
//
//                //依particle的位置決定顏色
//                Vec3D rawcol = new Vec3D(p.getX(), p.getY(), p.getZ());
//                Vec3D col=rawcol.add(colAmp).scaleSelf(0.5);
//                stroke(col.x, col.y, col.z);
//
//                point(p.getX(), p.getY(), p.getZ());
//            }

            for(int i=0; i<particleList.size(); i++){
                particleList.get(i).show();
            }
        }else{
            //打燈
            ambientLight(216, 216, 216);
            directionalLight(255, 255, 255, 0, 1, 0);
            directionalLight(96, 96, 96, 1, 1, -1);

            if(isWireFrame){
                stroke(255);
                noFill();
            }else {
                noStroke();
                fill(224, 0, 51);
            }

            beginShape(TRIANGLES);
            if (!isWireFrame) {
                drawFilledMesh();
            } 
            else {
                drawWireMesh();
            }
            endShape();
        }
        
        popMatrix();
    }


    private void computeVolume() {
        float cellSize=(float)DIMX*2/GRID;
        Vec3D pos=new Vec3D();
        Vec3D offset=new Vec3D(-DIMX*2, -DIMY*2, -DIMZ*2);
            
        float[] volumeData=volume.getData();

        int index = 0;
        for(int z=0; z<GRID; z++){
            for(int y=0; y<GRID; y++){
                for(int x=0; x<GRID; x++){
                    pos.x = x*cellSize + offset.x;
                    pos.y = y*cellSize + offset.y;
                    pos.z = z*cellSize + offset.z;

                    float val=0;
                    for(int i=0; i<particleList.size(); i++){
                        Particle p = particleList.get(i);
//                        Vec3D pv=new Vec3D(p.getX(), p.getY(), p.getZ());
                        Vec3D pv=new Vec3D(p.getX()-DIMX, p.getY()-DIMY, p.getZ()-DIMZ);
                        float mag=pos.distanceToSquared(pv)+0.00001;
                        val+=1/mag;
                    }
                    volumeData[index++]=val;
                }
            }
        }

        if(isClosed){
            volume.closeSides();
        }

        surface.reset();
        surface.computeSurfaceMesh(mesh, isoThreshold*0.001);
    }

    private void drawFilledMesh() {
        int num=mesh.getNumFaces();
        mesh.computeVertexNormals();

        for(int i=0; i<num; i++){
            Face f=mesh.faces.get(i);

            Vec3D col=f.a.add(colAmp).scaleSelf(0.5);
            fill(col.x, col.y, col.z);
            _normal(f.a.normal);
            _vertex(f.a);

            col=f.b.add(colAmp).scaleSelf(0.5);
            fill(col.x, col.y, col.z);
            _normal(f.b.normal);
            _vertex(f.b);

            col=f.c.add(colAmp).scaleSelf(0.5);
            fill(col.x, col.y, col.z);
            _normal(f.c.normal);
            _vertex(f.c);
        }
    }

    private void drawWireMesh() {
        noFill();
        int num=mesh.getNumFaces();

        for(int i=0; i<num; i++){
            Face f=mesh.faces.get(i);

            Vec3D col=f.a.add(colAmp).scaleSelf(0.5);
            stroke(col.x, col.y, col.z);
            _vertex(f.a);

            col=f.b.add(colAmp).scaleSelf(0.5);
            stroke(col.x, col.y, col.z);
            _vertex(f.b);

            col=f.c.add(colAmp).scaleSelf(0.5);
            stroke(col.x, col.y, col.z);
            _vertex(f.c);
        }
    }

    private void _normal(Vec3D v) {
        normal(v.x, v.y, v.z);
    }
    
    private void _vertex(Vec3D v) {
        vertex(v.x, v.y, v.z);
    }

    
    
    public void createParticle(){
        if(particleList.size() < 100){    //最多約200個效果較好
            Particle p = new Particle(random(-DIMX, DIMX), random(-DIMY, DIMY), random(-DIMZ, DIMZ), DIMX, DIMY, DIMZ);
            particleList.add(p);
        }
    }
    
    
    public void removeParticle(){
        //...
    }

    public void clearParticles(){
        particleList.clear();
    }

    public void setIsoThreshold(float isoThreshold){
        if(isoThreshold < 1){
            this.isoThreshold = 1;
        }else if(isoThreshold > 5){
            this.isoThreshold = 5;
        }else{
            this.isoThreshold = isoThreshold;
        }
    }
    
    public void increaseIsoThreshold(){
        isoThreshold = isoThreshold + 0.01;
    }
    
    public void decreaseIsoThreshold(){
        isoThreshold = isoThreshold - 0.01;
    }

    public void toggleWireframe(){
        isWireFrame = !isWireFrame;
    }

    public void toggleParticles(){
        showParticles = !showParticles;
    }

    public void toggleClosed(){
        isClosed = !isClosed;
    }
}
