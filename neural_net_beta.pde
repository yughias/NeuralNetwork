NeuralNetwork brain;

//binario -> decimale

int random;
Graph cost_graph;

void setup(){
  size(500, 500);
  
  int[] hidden = {2, 2, 2};
  
  brain = new NeuralNetwork(4, hidden, 1);
  brain.learning_rate = 0.001;
  brain.Xavier();
  cost_graph = new Graph(0, 0, 500, 500);
  
  size(500, 500);
}

void draw(){
  background(255);
  stroke(0);
  
  Epoch(1000);
  
  cost_graph.draw();
  
  float[] in = new float[4];
  for(int j = 0; j < in.length; j++) in[j] = int(random(0, 2)); 
  float[] answ = new float[1];
  for(int i = 0; i < in.length; i++){
    answ[0] += int(in[i])*pow(2, i);
  }
  println("N: " + answ[0] + " AI: " + brain.feedForward(in)[0]);
} 

void Epoch(int epoch){
  float cost = 0;
  
  for(int i = 0; i < epoch; i++){
    float[] in = new float[4];
    for(int j = 0; j < in.length; j++) in[j] = int(random(0, 2));
    float[] answ = new float[1];
    for(int j = 0; j < in.length; j++){
      answ[0] += int(in[j])*pow(2, j);
    }
    cost += brain.train(in, answ);
  }
  println(cost);
  cost = map(cost, 0, 0.1, 0, height);
  cost_graph.update(int(cost));
}
