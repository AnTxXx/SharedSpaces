static color getColor(String col_name){
   color col = #daa1ff;
  if(col_name.equals("red")){
    col = #ff8d8d;
  }
  else if(col_name.equals("orange")){
    col = #ffd18f;
  }
  else if(col_name.equals("yellow")){
    col = #e7ff8f;
  }
  else if(col_name.equals("green")){
    col = #92ffc3;
  }
  //check  
  return col;
}
