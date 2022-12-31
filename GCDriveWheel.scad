$fn=360;
// Gugusse Compact's size rollers


// Choose a value between 8.0, 9.5, 16.0, 28.0 or 35.0
// depending on the width of the film.
filmWidth=35.0;

// Choose a tolerance for inserting a bearing
// that depends on your 3D printer resolution
// Anything between 0.03 (resin printer) to
// 0.15 (precise FDM 3D printer)
// or to 0.5 (imprecises ones)
tolerance=0.03;

// These other values shouldn't change
// but this is an open free world...
bearingDiam=22.0;
bearingHeight=7.0;
wallThickness=2.0;
wheelDiam=28.0;
baseDiam=29.0;
embossing=4.0;
embossingHeight=1.0;
bottom2film=9.2 + (35.0 - filmWidth)/2.0;
top2film=3.0;
filmTolerance=0.05;
shaftHoleDiam=14.0;

// calculated values
fullHeight=filmWidth+filmTolerance+bottom2film+top2film;
label=str(filmWidth,"mm");
echo (label);



module newMainMat(){
    cylinder(d1=baseDiam,d2=wheelDiam+embossing,h=bottom2film/2.0);
    translate([0,0,bottom2film/2.0])
        cylinder(d=wheelDiam+embossing,h=bottom2film/2.0-embossingHeight);
    translate([0,0,bottom2film-embossingHeight])
        cylinder(d1=wheelDiam+embossing,d2=wheelDiam,h=embossingHeight);
    translate([0,0,bottom2film])
        cylinder(d=wheelDiam,h=filmWidth+filmTolerance);
    translate([0,0,bottom2film+filmWidth+filmTolerance])
        cylinder(d1=wheelDiam,d2=wheelDiam+embossing,h=embossingHeight);
    translate([0,0,bottom2film+filmWidth+filmTolerance+embossingHeight])
        cylinder(d=wheelDiam+embossing,h=top2film-embossingHeight);
}


module printLabel(){
    translate([-5,-14.2, fullHeight-wallThickness/2])linear_extrude(height=wallThickness)text(label, size=2.5);
}

difference(){
    newMainMat();
    translate([0,0,-1])cylinder(d=bearingDiam+2*tolerance, h=bearingHeight+tolerance+1);
    translate([0,0,fullHeight-bearingHeight-1])cylinder(d=bearingDiam+2*tolerance, h=bearingHeight+tolerance+1);
    cylinder(d=shaftHoleDiam, h=fullHeight);
    printLabel();
    rotate([0,0,180])printLabel();
}
