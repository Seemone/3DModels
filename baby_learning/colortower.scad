// an open tower with colored tokens to stack and 
// markers to design a sequence
// requires https://github.com/BelfrySCAD/BOSL2

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [Tokens] */

token_color = "red";
token_diameter = 26;
token_thickness = 4;

/* [Markers] */

marker_color = "red";
marker_width = 10;
marker_depth = 2;
marker_height = 15;

/* [Tower] */

tower_color = "white";
tower_height_in_tokens = 10;
tower_wall_thickness = 2;
tower_play = 0.5;

/* [Base] */

base_color = "white";
base_height = 10;
base_wall_thickness = 1;

/* [Options] */

tolerance = 0.15;

/* [Components] */

hide_token = false;
hide_marker = false;
hide_tower = false;
hide_base = false;

module roundtoken(diameter,thickness,anchor=BOTTOM)
{
    torus_radius = thickness/2;
    inner_radius = diameter/2-torus_radius;
    
    cylinder(thickness,inner_radius,inner_radius,anchor=anchor);
    
    rotate_extrude(angle=360)
    translate([inner_radius,0,0])
    circle(torus_radius,anchor=anchor);
}

module tower_side(height, inside_diameter, wall_thickness, play,anchor=BOTTOM)
{
    outside_diameter = inside_diameter+wall_thickness*2+play;
    difference() {
        tube(h=height,od=outside_diameter, id=inside_diameter+play,anchor=anchor);
        difference(){
            cuboid(size=[outside_diameter+5,outside_diameter+5,height+10],center=true);
            cuboid(size=[outside_diameter/4,outside_diameter/4,height+12],p1=[outside_diameter/4,outside_diameter/4,0]);
        }
    }
}


module tower(height, inside_diameter, wall_thickness, play,anchor=BOTTOM)
{
    for(angle = [0:90:360])
        rotate([0,0,angle])
            tower_side(height,inside_diameter,wall_thickness,play,anchor=anchor);
}

module marker(width,depth,height,anchor=BOTTOM)
{
    cuboid([width, depth, height], anchor=anchor, rounding=1);
}

module lid(width,depth,height,thickness)
{
    difference() {
        cuboid([width+thickness*2, depth+thickness*2, height], anchor=BOTTOM, rounding=1);
        translate([0,0,thickness])
            cuboid([width, depth, height+thickness*2], anchor=BOTTOM, rounding=0);
    }
}
module base(width)
{
    children(0);

    translate([-width/6,0,0]) children(1);

    translate([width/3,0,0]) children(2);
}

module towerbase(side,height)
{
    difference() {
        cuboid([side,side,height], anchor=BOTTOM);
        children(0);
    }
}

module markerbase(width,height,marker_depth,num)
{
    depth = (num)*(marker_depth*2);
    difference() {
        cuboid([width,depth,height], anchor=BOTTOM);
        for(i = [1:num]){
            translate([0,(i-num/2)*(marker_depth*2)-marker_depth,0])
                children(0);
        }
    }
}

$fn=100;

tower_height = (tower_height_in_tokens+1) * (token_thickness+tolerance) + 10;

base_side = tower_height+10;
box_height = tower_height/2+10+10;

if(!hide_tower){
    color(tower_color)
            
        tower(tower_height,token_diameter,tower_wall_thickness,tower_play,anchor=CENTER);
    //    intersection() {
    //        tower(tower_height,token_diameter,tower_wall_thickness,tower_play,anchor=CENTER);
    //        translate([0, 0, 0])
    //            cube([1000, 1000, 1000]);
    //    }
}

if(!hide_base){
    color(base_color)
        base(base_side)
        {
            // cuboid(0);
            %lid(base_side,base_side,base_height,base_wall_thickness);
            towerbase(token_diameter+2,base_height/2)
                tower(tower_height,token_diameter,tower_wall_thickness+tolerance*2,tower_play,anchor=CENTER);
            markerbase(marker_width+2,base_height/2,marker_depth,10)
                marker(marker_width+tolerance,marker_depth+tolerance*2,marker_height);
        }

//        intersection() {
//            base(base_side,base_side,base_height,base_wall_thickness,token_diameter+2,base_height/2) 
//                tower(tower_height,token_diameter,tower_wall_thickness+tolerance,tower_play,anchor=CENTER);
//            translate([0, 0, 0])
//                cube([1000, 1000, 1000]);
//        }

}

if(!hide_marker){
    color(marker_color)
        rotate([-90,0,0])
            marker(marker_width,marker_depth,marker_height,anchor=BACK);
}

if(!hide_token){
    color(token_color)
        roundtoken(token_diameter,token_thickness);
}