
// カーソル
class CursorCircle {
  float _mx, _my, _mr, _mc;
  float mdx = 0, mdy = 0;
  float measing = 1;

  float fcx, fcy, fcr;
  float ButtonMouseDx, ButtonMouseDy;
  float ButtonMouseEasing = 0;
  boolean OnButton = false;
  boolean InButton = false;

  CursorCircle( float _fcx, float _fcy, float _fcr ) {
    _mx = mouseX;
    _my = mouseY;
    _mr = 30;
    _mc = 255;

    fcx = _fcx;
    fcy = _fcy;
    fcr = _fcr;
  }

  void setting(float x, float y) {
    fcx = x;
    fcy = y;
  }

  void display() {
    // マウスカーソル
    noStroke();
    fill( 255, 150, 150, _mc);
    ellipse( _mx, _my, _mr, _mr );
    if ( InButton ) {
      fill( 50 );
      text( "Drag", _mx, _my );
    }
  }

  void cursorsize() {
    if ( !OnButton ) {
      if ( _mr > 30 ) {
        _mr -= 10;
      }    
      if ( _mc < 255 ) {
        _mc += 20;
      }
    } else {
      if ( _mr < 90 ) {
        _mr += 5;
      } 
      if ( _mc > 200 ) {
         _mc -= 10;
      }
    }
  }
  void circbuttonmove() {
    if ( dist( mouseX, mouseY, fcx, fcy ) < fcr * 1.6 ) {
      // カーソルがボタンの中心に引き寄せられる
      ButtonMouseEasing = 0.15;
      _mx += ButtonMouseDx * ButtonMouseEasing;
      _my += ButtonMouseDy * ButtonMouseEasing;
      OnButton = true;
    }
    if ( abs( ButtonMouseDx ) < fcr / 2 && abs( ButtonMouseDy ) < fcr / 2 ) {
      InButton = true;
    }
  }

  void move() {
    mdx = mouseX - _mx;
    mdy = mouseY - _my;
    ButtonMouseDx = fcx - _mx;
    ButtonMouseDy = fcy - _my;
    if ( dist( mouseX, mouseY, fcx, fcy ) < fcr * 2 ) {
      circbuttonmove();
    } else {
      OnButton = false;
      // カーソルはマウスに追従する
      if ( measing < 1 ) {
        measing += 0.05;
      }
      _mx += mdx * measing;
      _my += mdy * measing;
      InButton = false;
    }
    if ( InButton ) {
      // マウスがボタン内にあるときは追従スピードを遅くする
      measing = 0.05;
      _mx += mdx * measing;
      _my += mdy * measing;
    }
  }

  void update() {
    cursorsize();
    display();
    move();
  }
}
