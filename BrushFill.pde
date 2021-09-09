class BrushFill extends Brush{ //This Class has been mutated for the purpose of the BIOF350 Project. Any changes will be noted with a comment, containing this tag (James)
  int undoFrames=0;
  color target;
    public BrushFill(color col,EMImage image,int s){
      super(col,image,s);
      shape=loadImage("ui/bucket.png");//load up the bucket encase of flood fill
      shape.resize(128,128);
    }
  ArrayList<Pixel> floodFillBackup=new ArrayList<Pixel>();//used to store pixels for processes taking more than 1 frame
  ArrayList<Pixel> pixelRange = new ArrayList<Pixel>(); // Array used to lessen the Scope of the FloodFill (James)
  public Brush draw(){//this draws the shape of the brush to the screen, generally should not update overlay unless there is a multi-frame process
    //this should be called every frame
    float zoom=this.img.getZoom();
    Pixel pixel = brushPosition();
    image(shape,mouseX-shape.width+9,mouseY-shape.height+13); 
    floodFillUpdate();  
    if(erase){//clears ongoing flood fill in case of overflow
      floodFillBackup=new ArrayList<Pixel>();
    }
    return this; 
  }
  public ArrayList<Pixel> getPixelRange(Pixel start){ //Used to Set up pixelRange (James)
    mouseX = start.x; //Re-defined for consistancy (James)
    mouseY = start.y; //Re-defined for consistancy (James)
    int HalfNum = 50; //The Width and height of pixelRange * 2 + 1. Default is 50, meaning the box will be 101 * 101 Pixels (James)
    int xWayL= HalfNum, xWayR= HalfNum, yWayU= HalfNum, yWayD = HalfNum;//Left, Right, Up and Down boundries, respectivly (James)
    ArrayList<Pixel> myPackage = new ArrayList<Pixel>();
    if(mouseX % width < HalfNum){//Define Boundries in the Picture (James)
      xWayL = mouseX % width;
    }if(mouseX % width > width - HalfNum){
      xWayR = mouseX % width;
    }if(mouseY % height < HalfNum){
      yWayU = mouseY % height;
    }if(mouseY % height > height - HalfNum){
     yWayD = mouseY % height; 
    }
    for(int y = mouseY - yWayU; y <= mouseY + yWayD; y++){
     for(int x = mouseX - xWayL; x <=  mouseX + xWayR; x++){
       myPackage.add(new Pixel(x, y, get(x,y))); //Add all Pixels within Range to Package (James)
     }
    }
    return myPackage;
  }
  public ArrayList<Pixel> findCircles(ArrayList<Pixel> sample){ //Returns list of Pixels that are part of a circle (James)
    ArrayList<Pixel> darkPixels = new ArrayList<Pixel>();
    ArrayList<Pixel> lightPixels = new ArrayList<Pixel>();
    ArrayList<Pixel> checked = new ArrayList<Pixel>();
    ArrayList<Pixel> circle = new ArrayList<Pixel>();
    ArrayList<Pixel> myPackage = new ArrayList<Pixel>();
    int wallColorBorder = 120; //Color of border
    int xMax = 0, yMax = 0, xMin = width, yMin = height, xExt, yExt;
    float d, area, unround;
    for(int i = 0; i < sample.size(); i++){
      if(red(sample.get(i).c) < wallColorBorder){
        darkPixels.add(sample.get(i));
      } else {
        lightPixels.add(sample.get(i));
      }
    }
    for(int i=0; i < lightPixels.size(); i++){
      if(!checked.contains(lightPixels.get(i))){
        circle.add(lightPixels.get(i));
        checked.add(lightPixels.get(i));
      }
      for(int j = 0; j < circle.size(); j++){
        if(!darkPixels.contains(new Pixel(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1),circle.get(j).y, get(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1),circle.get(j).y))) & !checked.contains(new Pixel(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1),circle.get(j).y, get(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1),circle.get(j).y))) & sample.contains(new Pixel(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1),circle.get(j).y, get(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1),circle.get(j).y)))){
          //^Check if pixel to the right isn't in darkPixels, checked, and is in sample^ (James) 
           circle.add(new Pixel(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1),circle.get(j).y, get(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1),circle.get(j).y)));
           checked.add(new Pixel(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1),circle.get(j).y, get(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1),circle.get(j).y)));
           if(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1) > xMax){
             xMax = circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1);
           }else if(circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1) < xMin){
             xMin = circle.get(j).x+1*int(circle.get(j).x<this.img.overlay.width-1);
           }
        }
        if(!darkPixels.contains(new Pixel(circle.get(j).x-1*int(circle.get(j).x>0),circle.get(j).y,get(circle.get(j).x-1*int(circle.get(j).x>0),circle.get(j).y))) & !checked.contains(new Pixel(circle.get(j).x-1*int(circle.get(j).x>0),circle.get(j).y,get(circle.get(j).x-1*int(circle.get(j).x>0),circle.get(j).y))) & sample.contains(new Pixel(circle.get(j).x-1*int(circle.get(j).x>0),circle.get(j).y,get(circle.get(j).x-1*int(circle.get(j).x>0),circle.get(j).y)))){
         //Same as before, but for the Left (James) 
           circle.add(new Pixel(circle.get(j).x-1*int(circle.get(j).x>0),circle.get(j).y,get(circle.get(j).x-1*int(circle.get(j).x>0),circle.get(j).y)));
           checked.add(new Pixel(circle.get(j).x-1*int(circle.get(j).x>0),circle.get(j).y,get(circle.get(j).x-1*int(circle.get(j).x>0),circle.get(j).y)));
           if(circle.get(j).x-1*int(circle.get(j).x>0) > xMax){
             xMax = circle.get(j).x-1*int(circle.get(j).x>0);
           }else if( circle.get(j).x-1*int(circle.get(j).x>0) < xMin){
             xMin = circle.get(j).x-1*int(circle.get(j).x>0);
           }
        }
        if(!darkPixels.contains(new Pixel(circle.get(j).x,circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1),get(circle.get(j).x,circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1)))) & !checked.contains(new Pixel(circle.get(j).x,circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1),get(circle.get(j).x,circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1)))) & sample.contains(new Pixel(circle.get(j).x,circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1),get(circle.get(j).x,circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1))))){
          //Same as before, but above (James)
           circle.add(new Pixel(circle.get(j).x,circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1),get(circle.get(j).x,circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1))));
           checked.add(new Pixel(circle.get(j).x,circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1),get(circle.get(j).x,circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1))));
           if(circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1) > yMax){
             yMax = circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1);
           }else if(circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1) < yMin){
             yMin = circle.get(j).y+1*int(circle.get(j).y<this.img.overlay.height-1);
           }
        }
        if(!darkPixels.contains(new Pixel(circle.get(j).x,circle.get(j).y-1*int(circle.get(j).y>0),get(circle.get(j).x,circle.get(j).y-1*int(circle.get(j).y>0)))) & !checked.contains(new Pixel(circle.get(j).x,circle.get(j).y-1*int(circle.get(j).y>0),get(circle.get(j).x,circle.get(j).y-1*int(circle.get(j).y>0)))) & sample.contains(new Pixel(circle.get(j).x,circle.get(j).y-1*int(circle.get(j).y>0),get(circle.get(j).x,circle.get(j).y-1*int(circle.get(j).y>0))))){
          circle.add(new Pixel(circle.get(j).x,circle.get(j).y-1*int(circle.get(j).y>0),get(circle.get(j).x,circle.get(j).y-1*int(circle.get(j).y>0))));
          checked.add(new Pixel(circle.get(j).x,circle.get(j).y-1*int(circle.get(j).y>0),get(circle.get(j).x,circle.get(j).y-1*int(circle.get(j).y>0))));
          if(circle.get(j).y-1*int(circle.get(j).y>0) > yMax){
           yMax = circle.get(j).y-1*int(circle.get(j).y>0); 
          }else if(circle.get(j).y-1*int(circle.get(j).y>0) < yMin){
            yMin = circle.get(j).y-1*int(circle.get(j).y>0);
          }
        }
      }
      yExt = yMax - yMin;
      xExt = xMax - xMin;
      d = (yExt + xExt) / 2;
      area = PI * sq(d/2);
      unround = abs(area - circle.size()) / circle.size();
      if(unround  <= 0.6){
        for(int j = 0; j <= circle.size();){
          myPackage.add(circle.get(j));
          circle.remove(j);
        }
      }
      xMax = 0;
      yMax = 0;
      xMin = width;
      yMin = height;
      
    }
    return myPackage;
  }
  public Pixel findClosest(ArrayList<Pixel> source, Pixel point){
    Pixel closest = point;
    float dist = 10000;
    for(int i = 0; i < source.size(); i++){
     if(dist > sqrt(sq(point.x - source.get(i).x) + sq(point.y - source.get(i).y))){
       closest = source.get(i);
       dist = sqrt(sq(point.x - source.get(i).x) + sq(point.y - source.get(i).y));
    }  
  }
  return closest;
  }
  public Pixel findCenter(ArrayList<Pixel> pixelList){ //Returns pixel approxamatly in the middle regarding the Picture 
    int sumX = 0;
    int sumY = 0;
    for(int i = 0; i < pixelList.size(); i++){
      sumX += pixelList.get(i).x;
      sumY += pixelList.get(i).y;
    }
    return new Pixel(int(sumX/pixelList.size()), int(sumY/pixelList.size()), get(int(sumX/pixelList.size()), int(sumY/pixelList.size())));
  }
  public BrushFill paint(EMImage img){//this causes the brush to lay down "ink" on the overlay and generally should only be called on mouse press or mouse drag
    this.img=img;
    float zoom=this.img.getZoom();
    Pixel pixel= this.img.getPixel(int(mouseX-zoom/2),int(mouseY-zoom/2));//not sure why I am doing this instead of just passing pixel in, will test when not documenting
    pixelRange = getPixelRange(pixel); //Sets Inital Pixel Range (James)
    //pixel is the top left corner, I want the pixel under the mouse, so I did this apparently
    
    //target=this.img.overlay.get(this.img.layer,pixel.x,pixel.y);//this is not multi click safe
    //floodFillBackup=new ArrayList<Pixel>();//you might need this line, it will make this multi click safe
    //oh yah, you very much need that line, with out that line the program will enter a valid flood fill of a color (lets say 0), it will go through the if and enter the loop, then on the next mouse event, the color is set to what
    //is under the mouse (now c, we just flood filled there) and this new flood fill fails to start because of the if, buuuuuuuuuut 1 flood is still going... now with c as its color... you see the problem?
    //unfortunatly that line actually causes the flood fill to insta clear and set target to c, so it does not lock up, but at the same time it does not flood fill either, use these lines
    if(floodFillBackup.size()==0){//there, we only change colors if there is not a flood fill in progress, a better solution would be a FloodArea class that keeps track of c and target, then you could just make 2 FloodArea objects
    //that would allow the multi point flood fill that this does not
      target= this.img.overlay.get(this.img.layer,pixel.x,pixel.y);
    }
    if(target!=c){//without this line, if you click on an area the same color as the brush color it will infinitly fill its self over and over and over
      floodFill(pixel);
    }
    return this;
  }

  public BrushFill floodFill(Pixel pixel){//add initial flood fill pixel
    floodFillBackup.add(pixel);
    return this;
  }

  public BrushFill floodFillUpdate(){//expand the flood fill

    if(target==c){//I have had so many problems with this that I am saying "Screw it" if we ever enter this condition for any reason, drop the entire flood fill emediatly
      floodFillBackup=new ArrayList<Pixel>();
    }//I should also probiably dump on color change in general, but this is just so fun to use, so I am going to leave it
    ArrayList<Pixel> pixels=floodFillBackup;
    ArrayList<Pixel> filledRegion = new ArrayList<Pixel>(); //Used for other methods later on (James)
    ArrayList<Pixel> circles = new ArrayList<Pixel>();
    if(!pixels.isEmpty()){
       undoFrames++;
       if(undoFrames>100){
         img.snap(); 
         undoFrames=0;
       }
    }
    int ittr=0;
    int startNum=pixels.size();
    while(!pixels.isEmpty() & ittr<startNum){//flood fill ends when there are no non c colored pixels to spread to
      Pixel p=pixels.get(0);
      filledRegion.add(pixels.get(0));
      pixels.remove(0);

      if (this.img.overlay.get(this.img.layer,p.x,p.y)==target & pixelRange.contains(this.img.overlay.get(this.img.layer, p.x,p.y))){//check if pixle is transparrent for flood fill, for future, !=c checks for same color // Also added a check to see if the pixel in in pixelRange (James)
        
        this.img.overlay.set(this.img.layer,p.x,p.y,c);
        
        pixels.add(new Pixel(p.x+1*int(p.x<this.img.overlay.width-1),p.y,c));//don’t worry, pixel is never checked for color anyway so we can get away with this short cut
        pixels.add(new Pixel(p.x-1*int(p.x>0),p.y,c));
        pixels.add(new Pixel(p.x,p.y+1*int(p.y<this.img.overlay.height-1),c));
        pixels.add(new Pixel(p.x,p.y-1*int(p.y>0),c));
        ittr++;
      }
    }
    floodFillBackup=pixels;//I don’t know why I don’t edit floodFillBackup directly, but for some reason I implemented this way sooooo
    if(ittr > 20){ //Check to see if item is considered big enough to continue to the next layer (James)
      Pixel center = findCenter(filledRegion);//center of filled area (James)
      this.img.changeLayer(1);
      pixelRange = getPixelRange(center); //Redefine pixelRange(James)
      circles = findCircles(pixelRange); //Finds Circles(James)
      floodFill(findClosest(circles, center)); //Starts floodFill for the Closest Circle, which should be a part of the vesticle! (James)  
    }
    return this;
  }

  public BrushFill update(){//updates the shape of the brush, this should only be called when there is a reasonable certainty that the brush has changed in some way
    //as it can be a computationally complex operation

    return this;
  }
       public Brush eStop(){//clear the list in an emergency
          floodFillBackup=new ArrayList<Pixel>();
          img.snap();//commit changes to undo record
          return this; 
        }
}
