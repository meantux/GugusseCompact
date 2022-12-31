$fn=360;


verticalClearance=4.0;
opaqueWallThickness=2.0;

// 35mm
//filmWidth=35.0;
//formatName="35mm"
//frameMax=18.999;
//LRHolesCenterSpacing=28.169;
//LRHolesBorderSpacing=25.375;
//HoleHeight=1.95;
//InBetweenHoles=(frameMax/4.0)-HoleHeight;
//edgeToHoleCenter=(35.0-LRHolesCenterSpacing)/2.0;
//BackOfHoleDiam=4.5;
//spillTrackWidth=1.0;
//detectorOffset=22.35;
//pinHoleDiam=1.0;

// 16mm
//filmWidth=16.0;
//formatName="16mm"
//frameMax=7.49;
//LRHolesBorderSpacing=10.26;
//HoleHeight=1.27;
//HoleWidth=1.9812;
//detectorOffset=19.75;
//InBetweenHoles=frameMax;
//edgeToHoleCenter=(16.0-LRHolesBorderSpacing-HoleWidth)/2.0;
//BackOfHoleDiam=2.6;
//spillTrackWidth=0.5;
//pinHoleDiam=0.9;

// 8mm
//filmWidth=7.9;
//formatName="8mm";
//frameMax=3.81;
//LRHolesBorderSpacing=10.26;
//HoleHeight=1.23;
//HoleWidth=1.8;
//detectorOffset=17.145;
//InBetweenHoles=frameMax;
//edgeToHoleCenter=0.91+(HoleWidth/2.0);
//BackOfHoleDiam=2.6;
//spillTrackWidth=0.5;
//pinHoleDiam=HoleWidth/2.0;

// super8
filmWidth=7.9;
formatName="Super8";
frameMax=4.23;
LRHolesBorderSpacing=10.26;
HoleHeight=1.14;
HoleWidth=0.91;
detectorOffset=19.035;
InBetweenHoles=frameMax;
edgeToHoleCenter=0.51+(HoleWidth/2.0);
BackOfHoleDiam=4;
spillTrackWidth=0.33;
pinHoleDiam=HoleWidth;


minimumDetectorOffset=frameMax/2.0+verticalClearance+opaqueWallThickness+HoleHeight/2.0;

//desired values
filmTolerance=0.33; // FDM
mechanicalTolerance=0.5; // FDM
lightPipeTolerance=0.3; // FDM
//filmTolerance=0.15; // resin
//mechanicalTolerance=0.3; // resin
//lightPipeTolerance=0.2; // resin
curvedPartHeight=43.0;
GateWidth=80.0;
ExternalDiam=200;
thicknessMax=8.0;
FilmCavity=3.25;
spillTrackDepth=1.0;
Borders=(curvedPartHeight-filmWidth)/2.0;
baseHeight=4.0;
baseDepth=22;
topDepth=baseDepth;
lightPipeDiam=2.2;
pipeHolderW=8;
pipeHolderL=pipeHolderW;
pipeHolderH=curvedPartHeight+2*baseHeight;
echo (formatName);




echo ("minimumDetectorOffset");
echo (minimumDetectorOffset);
minimumNumberOfHoles=round(minimumDetectorOffset/(frameMax/4.0)+0.5);
echo ("minimumNumberOfHoles");
echo (minimumNumberOfHoles);
//detectorOffset=minimumNumberOfHoles*(frameMax/4.0)+InBetweenHoles/2.0+HoleHeight;
angleOffset=360*detectorOffset/((ExternalDiam-FilmCavity)*PI);
echo ("detectorOffset");
echo (detectorOffset);
echo ("angleOffset");
echo (angleOffset);


module roundedSurface(thickness, height, width){
    linear_extrude(height=height){
        intersection(){
            translate([-ExternalDiam/2.0+1.0,-width/2.0,0])
                square([ExternalDiam/2.0+1.0+2.0,width]);
            translate([-ExternalDiam/2.0,0,0])
                difference(){
                    circle(d=ExternalDiam-thicknessMax+thickness);
                    circle(d=ExternalDiam-thicknessMax);
                }
        }
    }
    
}

module theSevenParts(){
    translate([-topDepth+3,-GateWidth/2,-baseHeight])
        cube([baseDepth,GateWidth,baseHeight]);
    roundedSurface(thicknessMax, Borders,GateWidth);
    translate([0,0,Borders]) 
        roundedSurface(thicknessMax-FilmCavity-spillTrackDepth,spillTrackWidth,GateWidth);
    translate([0,0,Borders+spillTrackWidth]) 
        roundedSurface(thicknessMax-FilmCavity,filmWidth+filmTolerance-2*spillTrackWidth,GateWidth);
    translate([0,0,Borders+filmWidth+filmTolerance-spillTrackWidth]) 
        roundedSurface(thicknessMax-FilmCavity-spillTrackDepth,spillTrackWidth,GateWidth);
    translate([0,0,Borders+filmWidth+filmTolerance])
        roundedSurface(thicknessMax, Borders,GateWidth);
    translate([-topDepth+3,-GateWidth/2,curvedPartHeight])
        cube([topDepth,GateWidth,baseHeight]);
}

module Holes(){
    translate([-baseDepth+1,-(frameMax+2*verticalClearance)/2.0,Borders-0.5])
        cube([baseDepth+2.0,frameMax+2*verticalClearance,filmWidth+filmTolerance+1]);
    translate([-ExternalDiam/2.0,0,Borders+filmWidth+filmTolerance/2.0-edgeToHoleCenter])rotate([0,0,angleOffset]){
        rotate([0,90,0])cylinder(d=BackOfHoleDiam,h=ExternalDiam/2.0+2);
    }
    translate([-ExternalDiam/2.0,0,0])rotate([0,0,angleOffset])translate([ExternalDiam/2.0,0,0])pipeHolderMat(pipeHolderW+mechanicalTolerance,pipeHolderL+mechanicalTolerance,pipeHolderH);
    translate([-3,-24,curvedPartHeight+baseHeight-1])rotate([0,0,90])linear_extrude(height=2)text(formatName,size=8);
}


module oneHole(){
    translate([0,0,-3])cylinder(d=pinHoleDiam,h=20);
    translate([0,0,3.5])cylinder(d=lightPipeDiam+lightPipeTolerance,h=20);
}

module pipeHoles(){
    translate([-1.2,0,Borders+filmWidth+filmTolerance/2.0-edgeToHoleCenter])
    {
        rotate([0,45,0])oneHole();
        rotate([0,135,0])oneHole();
    }
    translate([6,2,pipeHolderH+pipeHolderW-1])rotate([0,0,180])linear_extrude(height=2)text(formatName,size=3.8);
}

module pipeHolderMat(w,l,h){
    b=4.7;
    translate([-0.7,-l/2.0,0])cube([w,l,h]);            
    translate([w/2-0.7,0,-baseHeight/2.0])cylinder(d1=w/8.0,d2=w/4,h=baseHeight/2.0);
    translate([-b-w,-l/2.0,0])cube([w,l,h]);
    translate([-b-w/2.0,0,-baseHeight/2.0])cylinder(d1=w/8.0,d2=w/2.0,h=baseHeight/2.0);
    translate([-b-w,-l/2.0,h])cube([2.0*w+b-0.7,l,w]);
}


module pipeHolder(w,l,h){
    difference(){
        pipeHolderMat(w,l,h);
        pipeHoles();
    }
}


// HOLE SENSOR
//translate([-ExternalDiam/2.0,0,0])rotate([0,0,angleOffset])translate([ExternalDiam/2.0,0,0])
//    pipeHolder(pipeHolderW,pipeHolderL,pipeHolderH);

// GATE
difference(){
    theSevenParts();
    Holes();
}
