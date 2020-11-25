import java.util.Random;

static class Matrix{
  int rows;
  int cols;
  float[][] matrix;

  Random rnd = new Random();

  Matrix(int r, int c){
    rows = r;
    cols = c;
    matrix = new float[r][c];
    
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        matrix[i][j] = 0;
      }
    }
  }
  
  void mutate(float x){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        if(Math.random() < x) matrix[i][j] += rGaussian(0, 0.1) ; 
      }
    }
  }
  
  void setAll(float n){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        matrix[i][j] = n;
      }
    }
  }
  
  void linear(){}
  
  static Matrix dlinear(Matrix m){
    Matrix result = new Matrix(m.rows, m.cols);
    for(int i = 0; i < result.rows; i++){
      for(int j = 0; j < result.cols; j++){
       result.matrix[i][j] = 1;
      }
    }
    return result;
  }
  
  void aTan(){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        matrix[i][j] = atan(matrix[i][j]);
      }
    }
  }
  
  static Matrix daTan(Matrix m){
    Matrix result = new Matrix(m.rows, m.cols);
    for(int i = 0; i < result.rows; i++){
      for(int j = 0; j < result.cols; j++){
        result.matrix[i][j] = 1/(m.matrix[i][j]*m.matrix[i][j]+1);
      }
    }
    return result;
  }
  
  void reLU(){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        if(matrix[i][j] < 0) matrix[i][j] = 0;
      }
    }
  }
  
  static Matrix dreLU(Matrix m){
    Matrix result = new Matrix(m.rows, m.cols);
    for(int i = 0; i < result.rows; i++){
      for(int j = 0; j < result.cols; j++){
        if(m.matrix[i][j] > 0) result.matrix[i][j] = 1;
          else result.matrix[i][j] = 0;
      }
    }
    return result;
  }
  
  void leakyReLU(){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        if(matrix[i][j] < 0) matrix[i][j] = 0.01*matrix[i][j];
      }
    }
  }
  
  static Matrix dleakyReLU(Matrix m){
    Matrix result = new Matrix(m.rows, m.cols);
    for(int i = 0; i < result.rows; i++){
      for(int j = 0; j < result.cols; j++){
        if(m.matrix[i][j] >= 0) result.matrix[i][j] = 1;
          else result.matrix[i][j] = 0.01;
      }
    }
    return result;
  }
  
  void sigmoid(){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        matrix[i][j] = (float) ( 1 / (1 + Math.exp(-matrix[i][j]) ) );
      }
    }
  }
 
  static Matrix dsigmoid(Matrix m){
    Matrix result = new Matrix(m.rows, m.cols);
    for(int i = 0; i < result.rows; i++){
      for(int j = 0; j < result.cols; j++){
        result.matrix[i][j] = m.matrix[i][j]*(1-m.matrix[i][j]);
      }
    }
    return result;
  }
  
  void randomize(){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        //valore random tra -1 e 1
        matrix[i][j] = ( (float)Math.random()*2 - 1 );
      }
    }
  }
  
  static Matrix substract(Matrix a, Matrix b){
    Matrix result = new Matrix(a.rows, a.cols);
    for(int i = 0; i < result.rows; i++){
      for(int j = 0; j < result.cols; j++){
        result.matrix[i][j] = a.matrix[i][j] - b.matrix[i][j];
      }
    }
    return result;
  }

  static Matrix transpose(Matrix m){
    Matrix result = new Matrix(m.cols, m.rows);
    for(int i = 0; i < m.rows; i++){
      for(int j = 0; j < m.cols; j++){
        result.matrix[j][i] = m.matrix[i][j];
      }
    }
    return result;
  }

  //prodotto scalare
  void multiply(float n){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        matrix[i][j] *= n;
      }
    }
  }
  
  //hadamard product
  void multiply(Matrix m){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        matrix[i][j] *= m.matrix[i][j];
      }
    }
  }
  
  
  float[] toArray(){
    int index = 0;
    float[] array = new float[rows*cols];
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        array[index] = matrix[i][j];
        index++;
      }
    }
    return array;
  }
  
  static Matrix fromArray(float[] array){
    Matrix result = new Matrix(array.length, 1);
    
    for(int i = 0; i < array.length; i++){
      result.matrix[i][0] = array[i];
    }
    return result;
  }
  
  
  //moltiplicazione di 2 matrici
  static Matrix multiply(Matrix a, Matrix b){
    if(a.cols != b.rows){
      println("MATRIX MULTIPLY ERROR");
      return a;
    }
    Matrix result = new Matrix(a.rows, b.cols);
    for(int i = 0; i < result.rows; i++){
      for(int j = 0; j < result.cols; j++){
        //dot product of values in col
        float sum = 0;
        for(int k = 0; k < a.cols; k++){
          sum += a.matrix[i][k] * b.matrix[k][j];
        }
        result.matrix[i][j] = sum;
      }
    }
    return result;
  }

  static Matrix multiply(float a, Matrix b){
    Matrix result = new Matrix(b.rows, b.cols);
    for(int i = 0; i < result.rows; i++){
      for(int j = 0; j < result.cols; j++){
        result.matrix[i][j] = a * b.matrix[i][j];
      }
    }
    return result;
  }

  void add(float n){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        matrix[i][j] += n;
      }
    }
  }
  
  void add(Matrix m){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        matrix[i][j] += m.matrix[i][j];
      }
    }
  }
  
  Matrix copy(){
    Matrix result = new Matrix(rows, cols);
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        result.matrix[i][j] = matrix[i][j];
      }
    }
    return result;
  }
  
  void display(){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        print(matrix[i][j] + " ");
      }
      println();
    }
  }
  
  void Gaussian(float m, float v){
    for(int i = 0; i < rows; i++){
      for(int j = 0; j < cols; j++){
        matrix[i][j] = rGaussian(m, v);
      }
    }
  }
  
  float rGaussian(float m, float v){
    return (float) ( rnd.nextGaussian() * v + m );
  }
  
}
