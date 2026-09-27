// エフェクト
class LittleCircle {
  float cx, cy, cr;
  float cdx, cdy;
  int cc;
  int cac, cdac;
  int CircToMouse;
  float startx, starty;
  float eas;

  LittleCircle() {
    startx = random( x - 300, x + 300 );
    starty = random( y - 300, y + 300 );
    eas = random( 0.01, 0.1 );
    cx = x;
    cy = y;
    cr = random( 5, 30 );
    cdx = random( -5, 5 );
    cdy = random( -5, 5 );
    cc = (int)random( 0, 200 );
    cac = (int)random( 150, 255 );
    cdac = (int)random( 5, 15 );
  }

  void display() {
    noStroke();
    fill( cc, cac );
    ellipse( startx, starty, cr, cr );
  }

  void move() {
    float sdx = x - startx;
    startx += sdx * eas;
    float sdy = y - starty;
    starty += sdy * eas;
   // cx += cdx;
   // cy += cdy;
    if ( cac > 0 ) {
      cac -= cdac;
    }
  }

  void update() {
    move();
    display();
  }
}
