import processing.awt.*;
import java.awt.*;
import javax.swing.*;

AComplex complex;
JTextField field;
String input;

void settings() {
  size(600, 700);
}

void setup() {
  complex=new AComplex();
  complex.solve();
  textFont(createFont("メイリオ", 16));

  Canvas canvas =(Canvas)surface.getNative();
  JLayeredPane pane =(JLayeredPane)canvas.getParent().getParent();
  field=new JTextField("酒");
  field.setBounds(250, 600, 100, 20);
  pane.add(field);

  input=field.getText().substring(0, 1);
}

void draw() {
  background(255);

  complex.display();
  if (field.getText().length()>0)input=field.getText().substring(0, 1);

  fill(0);
  textSize(12);
  textAlign(CENTER);
  for (int i=0; i<4; i++) {
    text(i, 150+i*100, 50);
  }
  textSize(32);
  for (int i=0; i<4; i++) {
    text(hex(convertToUnicodeNum(input)[i]).substring(7), 150+i*100, 100);
  }
  textSize(64);
  text(input, 300, 100);

  if (complex.inverseModel!=null) {
    textSize(12);
    for (int i=0; i<4; i++) {
      text(complex.inverseModel.p.get_value(i), 150+i*100, 550);
    }
    textSize(32);
    for (int i=0; i<4; i++) {
      text(complex.model.txtToResArr(input)[i], 150+i*100, 500);
    }
    textSize(64);
    text(complex.model.txtToResTxt(input), 300, 500);
  }
}

void mousePressed() {
  complex.mousePressed();
}
