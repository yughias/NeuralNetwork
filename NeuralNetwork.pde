class NeuralNetwork{
  int n_inputs;
  int[] n_hiddens;
  int n_outputs;


  Matrix[] weights;
  Matrix[] biases;
  float learning_rate;

  NeuralNetwork(int numI, int[] numH, int numO){
    n_inputs = numI;
    n_hiddens = new int[numH.length];
    for(int i = 0; i < numH.length; i++){
      n_hiddens[i] = numH[i];
    }
    n_outputs = numO;
    
    //inizializzo i pesi
    weights = new Matrix[n_hiddens.length+1];
    weights[0] = new Matrix(n_hiddens[0], n_inputs);
    for(int i = 1; i < n_hiddens.length; i++){
      weights[i] = new Matrix(n_hiddens[i], n_hiddens[i-1]);
    }
    weights[weights.length-1] = new Matrix(n_outputs, n_hiddens[n_hiddens.length-1]);
    
    //inizializzo i bias
    biases = new Matrix[n_hiddens.length+1];
    for(int i = 0; i < n_hiddens.length; i++){
      biases[i] = new Matrix(n_hiddens[i], 1);
    }
    biases[biases.length-1] = new Matrix(n_outputs, 1); 
    
    //randomizzo i weights
    for(int i = 0; i < weights.length; i++) weights[i].randomize();
    
    //randomizzo i bias
    for(int i = 0; i < biases.length; i++) biases[i].randomize();
    
    learning_rate = 0.1;
  }

  void setAll(float x){
    for(int i = 0; i < weights.length; i++){
      weights[i].setAll(x);
      biases[i].setAll(x);
    }
  }

  void Xavier(){
    for(int i = 0; i < biases.length; i++) biases[i].setAll(0);
    float value = 0;
    float fan_in = 0;
    float fan_out = 0;
    for(int i = 0; i < weights.length; i++){
      if(i == 0) fan_in = n_inputs;
        else fan_in = n_hiddens[i-1];
      if(i == weights.length-1) fan_out = n_outputs;
        else fan_out = n_hiddens[i];
      value = sqrt( 2/(fan_in+fan_out) );
      weights[i].Gaussian(0, value);
    }
  }

  float[] feedForward(float[] array){
    Matrix inputs = Matrix.fromArray(array);
    
    Matrix output = Matrix.multiply(weights[0], inputs);
    output.add(biases[0]);
    output.leakyReLU();
    
    for(int i = 1; i < weights.length; i++){
      output = Matrix.multiply(weights[i], output);
      output.add(biases[i]);
      output.leakyReLU();
    }
    
    return output.toArray();
  }
  
  float train(float[] in, float[] answers){
    Matrix inputs = Matrix.fromArray(in);
    
    Matrix output = Matrix.multiply(weights[0], inputs);
    Matrix[] layers = new Matrix[weights.length];
    output.add(biases[0]);
    output.leakyReLU();
    layers[0] = output.copy();
    
    for(int i = 1; i < weights.length; i++){
      output = Matrix.multiply(weights[i], output);
      output.add(biases[i]);
      output.leakyReLU();
      layers[i] = output.copy();
    }
    
    //INIZIO TRAIN
    
    Matrix targets = Matrix.fromArray(answers);
    
    //ERROR = TERGETS - OUTPUTS
    Matrix errors = Matrix.substract(output, targets);
    
    float cost = 0;
    for(int i = 0; i < errors.rows; i++){
      cost += (errors.matrix[i][0] * errors.matrix[i][0]);
    }
    
    for(int i = layers.length-1; i >= 0; i--){
      //calculate gradient
      Matrix gradients = Matrix.dleakyReLU(layers[i]);
      gradients.multiply(errors);
      
      //L2 TEST
      //gradients.add(Matrix.multiply(0.001, weights[i]));
      
      gradients.multiply(-learning_rate);
      
      //calculate deltas
      Matrix transpose;
      if(i > 0) transpose = Matrix.transpose(layers[i-1]);
        else transpose = Matrix.transpose(inputs);
      Matrix deltas = Matrix.multiply(gradients, transpose);
      
      
      //Adjust the weights by deltas
      weights[i].add(deltas);
      //Adjust the bias
      biases[i].add(gradients);
      
      //calcolo il nuovo errore
      Matrix error_t = Matrix.transpose(weights[i]);
      errors = Matrix.multiply(error_t, errors);
    }
    
    return cost;
  }
  
  void save(){
    String[] lr = {str(learning_rate)};
    saveStrings("data\\general\\learning_rate.txt", lr);
    
    String[] in = {str(n_inputs)};
    saveStrings("data\\general\\n_inputs.txt", in);
    
    String[] nodes = new String[n_hiddens.length];
    for(int i = 0; i < nodes.length; i++) nodes[i] = str(n_hiddens[i]);
    saveStrings("data\\general\\n_hiddens.txt", nodes);
    
    String[] out = {str(n_outputs)};
    saveStrings("data\\general\\n_outputs.txt", out);
    
    String s;
    //salvo i weights
    for(int i = 0; i < weights.length; i++){
      s = "\\data\\weights\\" + i + ".txt";
      saveMatrix(weights[i], s);
    }
    
    //salvo i biases
    for(int i = 0; i < biases.length; i++){
      s = "\\data\\biases\\" + i + ".txt";
      saveMatrix(biases[i], s);
    }
    
  }
  
  void load(){
    String[] lr = loadStrings("data\\general\\learning_rate.txt");
    learning_rate = Float.parseFloat(lr[0]);
    String[] in = loadStrings("data\\general\\n_inputs.txt");
    n_inputs = Integer.parseInt(in[0]);
    String[] hid = loadStrings("data\\general\\n_hiddens.txt");
    n_hiddens = new int[hid.length];
    for(int i = 0; i < hid.length; i++) n_hiddens[i] = Integer.parseInt(hid[i]);
    String[] out = loadStrings("data\\general\\n_outputs.txt");
    n_outputs = Integer.parseInt(out[0]);
    biases = new Matrix[n_hiddens.length+1];
    weights = new Matrix[n_hiddens.length+1];
    for(int i = 0; i < biases.length; i++) biases[i] = loadMatrix("data\\biases\\" + i + ".txt");
    for(int i = 0; i < weights.length; i++) weights[i] = loadMatrix("data\\weights\\" + i + ".txt");
  }
  
  NeuralNetwork copy(){
    NeuralNetwork cp = new NeuralNetwork(n_inputs, n_hiddens, n_outputs);
    cp.learning_rate = learning_rate;
    cp.weights = new Matrix[weights.length];
    for(int i = 0; i < weights.length; i++) cp.weights[i] = weights[i].copy();
    cp.biases = new Matrix[biases.length];
    for(int i = 0; i < biases.length; i++) cp.biases[i] = biases[i].copy();
    return cp;
  }
  
  void mutate(float x){
    for(int i = 0; i < weights.length; i++){
      biases[i].mutate(x);
      weights[i].mutate(x);
    }
  }
  
}
