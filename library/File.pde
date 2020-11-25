void saveMatrix(Matrix m, String s){
  String[] file = new String[m.rows];
  for (int i = 0; i < m.rows; i++) {
    file[i] = "";
    for (int j = 0; j < m.cols; j++) {
      file[i] += m.matrix[i][j];
      if(j != m.cols-1) file[i] += ", ";
    }
  }
  saveStrings(s, file);
}

Matrix loadMatrix(String s){
  String[] file = loadStrings(s);
  Matrix m;
  String row = file[0];
  String[] raw_values = split(row, ", ");
  m = new Matrix(file.length, raw_values.length);
  for(int i = 0; i < file.length; i++){
    row = file[i];
    raw_values = split(row, ", ");
    for(int j = 0; j < raw_values.length; j++){
      m.matrix[i][j] = Float.parseFloat(raw_values[j]);
    }
  }
  return m;
}
