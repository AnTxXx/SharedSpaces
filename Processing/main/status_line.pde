import java.io.BufferedReader;
import java.io.FileReader;
import java.net.URL;

/**
* Shows a beautiful ASCII image line by line
*/
public class StatusLine {

  private String[] lines;
  private String filename;
  private int i=0;
  
  public StatusLine() {
    int f = (int) Math.round(Math.random()*6);
    filename = "data/ascii_"+f+".txt";
    lines = loadStrings(filename);
  }
  
  public void getLine() {
      if(++i<lines.length) {
        println(lines[i]);
      }
      else {
        i=0;
      }
  }
  
}
