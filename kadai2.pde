// 引っ張っているときに出てくる円
ArrayList<LittleCircle> lc = new ArrayList<LittleCircle>();
// カーソル
CursorCircle cursorcirc;
// 円の座標、直径、加速度
float x, y;
float r = 40;
float dx = 0;
float dy = 0;
// 引っ張り始めの位置
float sx = 0;
float sy = 0;
// 引っ張ったときにマウスに円がついていくスピード
float easing = 0.1;
// マウス座標（値がキャンバスより大きくなったときの処理用）
float mx, my;
// ドラッグ中か否か
boolean isDrag = false;
// エフェクト表示タイミング、エフェクト円の直径
int time;
float nofillcircsize = 1000;
// 円の色
int circc = 50;

void setup() {
  size( 600, 400 );
  noCursor();
  PFont font = loadFont( "Arial-Black-48.vlw" );
  textFont( font );
  textSize( 20 );
  textAlign( CENTER, CENTER );
  x = width / 2; 
  y = height / 2;
  cursorcirc = new CursorCircle( x, y, r );
}

void draw() {
  fill( 255, 130 );
  rect( 0, 0, width, height );

  // 加速度が３以下ならカーソルをリセット
  if ( abs( dx ) < 3 && abs( dy ) < 3 ) {
    cursorcirc.setting(x, y);
  }

  // 減速
  dx *= 0.99;
  dy *= 0.99;

  x += dx;
  y += dy;



  if ( isDrag ) {
    /*/ =====================================
     // ドラッグしているとき
     ====================================== /**/

    // 円の色
    stroke( circc );
    if ( circc > 100 ) {
      circc -= 40;
    }
    // ========================================
    // 円を引っ張る
    float easx = mouseX - x;
    if (abs(easx) > 0) { 
      x += easx * easing;
    }
    float easy = mouseY - y;
    if (abs(easy) > 1) {
      y += easy * easing;
    }
    // 画面外に出ないように
    if ( x < r / 2 ) {
      x = r / 2;
    }
    if ( x > width - r / 2 ) {
      x = width - r / 2;
    }
    if ( y < r / 2 ) {
      y = r / 2;
    }
    if ( y > height - r / 2 ) {
      y = height - r / 2;
    }
    // ===========================================
    // マウスを画面外まで引っ張ると
    // 円を振動させる
    if ( mouseX < 0 || mouseX > width || mouseY < 0 || mouseY > height ) {
      if ( frameCount / 3 % 2 == 0 ) {
        r *= 1.05;
      } else {
        r /= 1.05;
      }
    }
    // ===========================================
    // マウス座標が画面外±100になったら
    // time起動
    int over = 100;
    if ( mouseX < -over || mouseX > width + over || mouseY < -over || mouseY > height + over ) {
      time++;
    } else {
      time = 0;
    }
    // ------------------------------------
    // timeが７０以上になったらエフェクト起動
    if ( time > 70 ) {
      lc.add( new LittleCircle() );
      // 円を濃く小さく
      if ( r > 20 ) {
        r -= 0.1;
      }
      if ( circc > 0 ) {
        circc -= 5;
      }
      // エフェクト二つ目
      noFill();
      strokeWeight( 5 );
      stroke( 100 );
      ellipse( x, y, nofillcircsize, nofillcircsize );
      if ( nofillcircsize > 0 ) {
        nofillcircsize -= dist( x, y, mouseX, mouseY ) * 0.05;
      } else {
        nofillcircsize = 1000;
      }
    }
    // --------------------------------------
    // 円ドラッグ中は小さくする
    if ( dist( mouseX, mouseY, x, y ) < r * 1.5 ) {
      if ( r > 40 ) {
        r -= 5;
      } else {
        r = 40;
      }
    }
    /*/ =====================================================
     ==================================================== /**/
  } else {
    /*/ ==========================================
     // ドラッグしてないとき
     ========================================= /**/
    /*/ -----------------------------------
    ------------------------------------ /**/
    // 加速度３以下かつマウスオーバー時
    // dragと表示、円を大きく白く
    if ( abs( dx ) < 3 && abs( dy ) < 3 && dist( mouseX, mouseY, x, y ) < 45 * 1.5 ) {
      fill( 50 );
     // text( "Drag", x, y + 3 );
      if ( r < 100 ) {
        r += 5;
      }
      if ( circc < 255 ) {
        circc += 20;
      }
      // ----------------------------------
    } else {
      // ------------------------------------
      // 円が動いているとき or マウスオーバーじゃないとき
      // 円の大きさ、色調整
      if ( r > 40 ) {
        r -= 3;
      } else {
        r = 40;
      }
      if ( circc > 50 ) {
        circc -= 40;
      }
    }
    /*/ ---------------------------------
     ----------------------------------- /**/
    if ( abs( dx ) < 3 && abs( dy ) < 3 ) {
      // 加速度３以下のとき
      // カーソル表示
      cursorcirc.update();
    }
    // 動いているときの円の色は５０
    if (circc < 50 ) {
      circc += 5;
    }
  }
  /*/ =====================================================
   // if( isDrag ) {} else {} の処理終了
   ===================================================== /**/

  // エフェクト表示、削除
  for ( int i = 0; i < lc.size(); i++ ) {
    lc.get(i).update();
    if ( lc.get(i).cac < 0 || !isDrag ) {
      lc.remove(i);
    }
  }
  // ========================================
  // 跳ね返り
  // はみ出さないのを最優先にするためvoid draw()の一番下へ
  if ( x < r / 2 || x > width - r / 2 ) {
    dx *= -1;
  }
  if ( y < r / 2 || y > height - r / 2 ) {
    dy *= -1;
  }
  // =========================================
  // 円表示
  strokeWeight( 7 );
  stroke( 50 );
  fill( circc );
  ellipse( x, y, r, r );

  // println( x, y );
}

void mousePressed() {
  // 円の内側でクリックしたとき
  // 引っ張り開始位置リセット、ドラッグ中にする
  if ( dist( mouseX, mouseY, x, y ) < r / 2 ) {
    sx = mouseX;
    sy = mouseY;
    isDrag = true;
  }
}
void mouseReleased() {
  // マウスを話したとき
  // ドラッグ中だったら
  if ( isDrag ) {
    // マウスが画面外±100になったらそれ以上は加速度に影響しないようにする
    float dm = 100;
    mx = mouseX;
    my = mouseY;
    if ( mx < -dm ) {
      mx = -dm;
    }
    if ( mx > width + dm ) {
      mx = width + dm;
    }
    if ( my < -dm ) {
      my = -dm;
    }
    if ( my > height + dm ) {
      my = height + dm;
    }
    // 加速度設定
    dx = ( sx - mouseX ) * 0.1;
    dy = ( sy - mouseY ) * 0.1;
    // ドラッグ終了
    isDrag = false;
  }
}
