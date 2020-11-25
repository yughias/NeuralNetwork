class Graph{
  int x, y, w, h;
  int[] value;
  
  
  Graph(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    value = new int[w];
    for(int i = 0; i < value.length; i++) value[i] = h;
  }
  
  void update(int v){
    for(int i = 0; i < value.length-1; i++){
      value[i] = value[i+1];
    }
    value[value.length-1] = v;
  }
  
  void draw(){
    for(int i = 1; i < w; i++){
      line(x+(i-1), constrain(y+h-value[i-1], y, y+h), x+i, constrain(y+h-value[i], y, y+h)); 
    }
  }
  
}
