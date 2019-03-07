class AComplex {
  AGuiAddState guiAddState;
  ArrayList<AEdge> edgeList=new ArrayList<AEdge>();
  ABar[] bars=new ABar[4];
  AModel model=null, inverseModel=null;

  AComplex() {
    guiAddState=new AGuiAddOff(this);
    for (int i=0; i<4; i++) {
      bars[i]=new ABar(i);
    }
  }

  void display() {
    for (ABar bar : bars) {
      bar.display();
    }

    for (AEdge edge : edgeList) {
      edge.display();
    }

    guiAddState=guiAddState.display();
  }


  void mousePressed() {
    guiAddState=guiAddState.mousePressed();
  }

  //---

  void solve() {
    ARunner[] runners=new ARunner[4];
    for (int i=0; i<4; i++) {
      runners[i]=new ARunner(i);
      runners[i].run();
    }

    int[] ans={runners[0].id, runners[1].id, runners[2].id, runners[3].id};
    Permutation p=new Permutation(ans);
    int[] biases={runners[0].bias, runners[1].bias, runners[2].bias, runners[3].bias};
    model=new AModel(p, biases);

    int[] minusBiases={-runners[0].bias, -runners[1].bias, -runners[2].bias, -runners[3].bias};
    inverseModel=new AModel(p.inverse(), p.applyLabel(minusBiases));
  }

  //---

  void addAEdge(int aId, int aPos, int bId, int bPos) {
    APoint a=new APoint(aId, aPos), b=new APoint(bId, bPos);
    edgeList.add(new AEdge(a, b));
  }

  //そのid、posにedgeが既にあるか existはcomplexが実装したほうがすっきりした
  boolean exist(int id, int pos) {
    for (AEdge edge : edgeList) {
      if (edge.a.id==id) {
        if (edge.a.pos==pos) return true;
      }
      if (edge.b.id==id) {
        if (edge.b.pos==pos) return true;
      }
    }
    return false;
  }

  //片方がそのidに繋がっているedgeの一覧
  ArrayList<AEdge> getAEdgeListOnId(int id) {
    ArrayList<AEdge> result=new ArrayList<AEdge>();
    for (AEdge edge : edgeList) {
      if (edge.a.id==id) result.add(edge);
      if (edge.b.id==id) result.add(edge);
    }

    return result;
  }

  //二つのid間にあるedgeの一覧
  ArrayList<AEdge> getAEdgeListOnIds(int aId, int bId) {
    ArrayList<AEdge> result=new ArrayList<AEdge>();
    for (AEdge edge : edgeList) {
      if (edge.a.id==aId && edge.b.id==bId) result.add(edge);
      if (edge.a.id==bId && edge.b.id==aId) result.add(edge);
    }

    return result;
  }

  //-------------------------------------------------------------------------------------------------------------------
  //横線
  class AEdge {
    APoint a, b;
    float dispX, dispY;
    int bias;

    AEdge(APoint _a, APoint _b) {
      a=_a;
      b=_b;
      dispX=150+(a.id+b.id)*0.5*100;
      dispY=150+(a.pos+b.pos)*0.5;
      bias=1;
    }

    APoint getConcerned(int id) {
      if (a.id==id) return a;
      if (b.id==id) return b;
      return null;
    }

    APoint getAlternative(int id) {
      if (a.id==id) return b;
      if (b.id==id) return a;
      return null;
    }

    void display() {
      stroke(0);
      strokeWeight(1);
      line(150+a.id*100, 150+a.pos, 150+b.id*100, 150+b.pos);

      fill(255);
      ellipse(dispX, dispY, 10, 10);
      fill(0);
      textSize(10);
      textAlign(CENTER);
      text("+"+bias, dispX, dispY-10);

      //ナビゲーター
      if (mouseIsOn()) {
        stroke(0, 100);
        strokeWeight(2);
        noFill();
        ellipse(dispX, dispY, 10, 10);
      }
    }

    boolean mouseIsOn() {
      if (dist(mouseX, mouseY, dispX, dispY)<10) return true;

      return false;
    }
  }

  //縦線
  //ほぼ描画してるだけ、mouseIsOnだけ機能としてある
  class ABar {
    int id;
    int dispX, dispY, l;

    ABar(int _id) {
      id=_id;
      dispX=150+id*100;
      dispY=150;
      l=300;
    }

    void display() {
      stroke(0);
      strokeWeight(1);
      line(dispX, dispY, dispX, dispY+l);

      //ナビゲーター
      if (mouseIsOn()) {
        stroke(0, 100);
        strokeWeight(2);
        line(150+id*100, 150, 150+id*100, 450);
      }
    }

    boolean mouseIsOn() {
      return (mouseX>dispX-20 && mouseX<dispX+20);
    }
  }

  //置換をつくるときに走査するやつ
  class ARunner {
    int pos, id, bias;

    ARunner(int _id) {
      id=_id;
      pos=0;
      bias=0;
    }

    void run() {
      while (pos<300) {
        for (AEdge edge : complex.getAEdgeListOnId(id)) {
          if (edge.getConcerned(id).pos==pos) {
            pos=edge.getAlternative(id).pos;
            id=edge.getAlternative(id).id;
            bias+=edge.bias;
            break;
          }
        }
        pos++;
      }
    }
  }

  //id,posによる点表現
  class APoint {
    int id, pos;

    APoint(int _id, int _pos) {
      id=_id;
      pos=_pos;
    }
  }

  //--------------------------------------------------------------------
  //Off
  class AGuiAddOff implements AGuiAddState {
    AComplex complex;

    AGuiAddOff(AComplex _complex) {
      complex=_complex;
    }

    AGuiAddState display() {
      return this;
    }

    AGuiAddState mousePressed() {
      if (mouseButton==RIGHT) {
        for (int i=complex.edgeList.size()-1; i>=0; i--) {
          AEdge edge=complex.edgeList.get(i);
          if (edge.mouseIsOn()) {
            complex.edgeList.remove(edge);
            complex.solve();
          }
        }
      } else {
        for (int i=complex.edgeList.size()-1; i>=0; i--) {
          AEdge edge=complex.edgeList.get(i);
          if (edge.mouseIsOn()) {
            edge.bias++;
            if (edge.bias>=10) edge.bias=1;
            complex.solve();
          }
        }

        for (ABar bar : complex.bars) {
          //既にedgeがあるposはだめ
          if (bar.mouseIsOn() && !complex.exist(bar.id, mouseY-150)) return new AGuiAddOn(complex, new APoint(bar.id, mouseY-150));
        }
      }

      return this;
    }
  }

  //On
  class AGuiAddOn implements AGuiAddState {
    AComplex complex;
    APoint a;

    AGuiAddOn(AComplex _complex, APoint _a) {
      complex=_complex;
      a=_a;
    }

    AGuiAddState display() {
      fill(255, 0, 0);
      ellipse(150+a.id*100, 150+a.pos, 10, 10);

      stroke(0);
      strokeWeight(1);
      line(150+a.id*100, 150+a.pos, mouseX, mouseY);
      return this;
    }

    AGuiAddState mousePressed() {
      int bId=-1;
      for (int i=-1; i<=1; i+=2) {
        if (a.id+i>=0 && a.id+i<4) {
          ABar bBar=complex.bars[a.id+i];
          if (bBar.mouseIsOn()) bId=a.id+i;
        }
      }
      //bIdがa.idの隣でないとだめ
      if (bId==-1) return new AGuiAddOff(complex);
      //既にedgeがあるposはだめ
      if (complex.exist(bId, mouseY-150)) return new AGuiAddOff(complex);

      //edge交差はだめ
      for (AEdge edge : complex.getAEdgeListOnIds(a.id, bId)) {
        if (edge.a.id==a.id) {
          if ((edge.a.pos>a.pos && edge.b.pos<mouseY-150) || (edge.a.pos<a.pos && edge.b.pos>mouseY-150)) return new AGuiAddOff(complex);
        } else {
          if ((edge.b.pos>a.pos && edge.a.pos<mouseY-150) || (edge.b.pos<a.pos && edge.a.pos>mouseY-150)) return new AGuiAddOff(complex);
        }
      }

      complex.addAEdge(a.id, a.pos, bId, mouseY-150);
      complex.solve();

      return new AGuiAddOff(complex);
    }
  }
}

//---------------------------------------------------------------

interface AGuiAddState {
  AGuiAddState display();
  AGuiAddState mousePressed();
}
