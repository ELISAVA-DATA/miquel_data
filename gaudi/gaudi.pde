float x1 ;
float y1 ;
float x2;
float x3;
float y2;
float y3 ;
float inc = 20;
void setup() {
  size(600, 600);
  translate(width/2, height/2);
  iniciar();
}

void draw() {
  if (y1<height/2) {
    stroke(0, 20);
    line(width/2, y1, x2, height/2);
    line(width/2, y1, x3, height/2);
    line(width/2, y3, x3, height/2);
    line(width/2, y3, x2, height/2);
    x2 = x2+inc;
    x3 = x3-inc;
    y1 = y1 + inc;
y3 = y3-inc;
    //  line(x1, width/2, height/2, y2);
    x1=x1+inc;
    y2=y2-inc;
  } else
  {

    println("llega al final");
    iniciar();
  }
}
void iniciar() {
  inc = random (1, 5);
  background(#DBC364);
  x1 = width / 2;
  x3 = width/2;
  y3 = height;
  y1 = 0;
  x2 = width/2;
  y2 = height/2;
}
