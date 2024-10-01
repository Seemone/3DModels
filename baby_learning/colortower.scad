// an open tower with colored tokens to stack and 
// markers to design a sequence
// requires https://github.com/BelfrySCAD/BOSL2

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [Tokens] */

token_color = "red";
token_diameter = 26;
token_thickness = 4;
token_hole_diameter = 3;

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

/* [Box] */

// box_height = 10;

/* [Options] */

tolerance = 0.05;

/* [Components] */

show_token = false;
show_marker = false;
show_tower = false;
show_towerbase = false;
show_base = false;
show_box = false;

module roundtoken(diameter,thickness,hole_diameter,anchor=BOTTOM)
{
    torus_radius = thickness/2;
    inner_radius = diameter/2-torus_radius;
    
    difference() {
        cylinder(thickness,inner_radius,inner_radius,anchor=anchor);
        children(0);
    }
    
    rotate_extrude(angle=360)
    translate([inner_radius,0,0])
    circle(torus_radius,anchor=anchor);
}

module tower_side(height, inside_diameter, wall_thickness, tolerance, play,anchor=BOTTOM)
{
    od = inside_diameter+wall_thickness*2+play+tolerance;
    id = inside_diameter+play-tolerance;
    difference() {
        tube(h=height,od=od, id=id,anchor=anchor);
        difference(){
            translate([0,0,-1])
                cuboid(size=[od+5,od+5,height+10],center=true,anchor=anchor);
                cuboid(size=[od/4,od/4,height+12],p1=[od/4-tolerance,od/4-tolerance,0],anchor=anchor);
        }
    }
}

module tower(height, inside_diameter, wall_thickness, tolerance, play,anchor=BOTTOM)
{
    for(angle = [0:90:360])
    {
        rotate([0,0,angle])
            tower_side(height,inside_diameter,wall_thickness,tolerance,play,anchor=anchor);
    }
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
    translate([-width/6,0,0]) children(0);
}
module base(width)
{
    children(0);
    translate([width/4,0,0]) children(1);
}

module towerbase(side,height)
{
    difference() {
        cuboid([side,side,height], anchor=BOTTOM);
        children(0);
        children(1);
        children(2);
    }
}

module pylon(height, diameter,anchor=BOTTOM)
{
    cyl(h=height,r=diameter,anchor=anchor);
}

module towerbase_lid_interface(side,height)
{
    difference(){
        cuboid([side,side,height], anchor=BOTTOM);
        children(0);
    }
}

module markerbase(width,height,marker_depth,num)
{
    depth = (num+0.5)*(marker_depth*2);
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
box_height = tower_height/2+10;

towerbase_lid_interface_side = token_hole_diameter+5;
towerbase_lid_interface_height = 3;

if(show_tower){
    color(tower_color)
    {
        tower(tower_height,token_diameter,tower_wall_thickness,0,tower_play,anchor=BOTTOM);
        pylon(tower_height,token_hole_diameter-tower_play,anchor=BOTTOM);
    }
}

if(show_base){
    color(base_color)
        base(base_side)
        {
            lid(base_side,base_side,base_height,base_wall_thickness)
                towerbase_lid_interface(towerbase_lid_interface_side-tolerance,towerbase_lid_interface_height-tolerance)
                    pylon(tower_height,token_hole_diameter-tower_play+tolerance*2,anchor=CENTER);
            markerbase(marker_width+3,base_height/2,marker_depth,10)
                marker(marker_width+tolerance*6,marker_depth+tolerance*3,marker_height);
        }
}

if(show_towerbase){
    color(base_color)
        rotate([0,180,0])
            towerbase(token_diameter+2,base_height/2)
            {
                towerbase_lid_interface(towerbase_lid_interface_side+tolerance*3,towerbase_lid_interface_height+tolerance) cuboid(0);
                tower(tower_height,token_diameter,tower_wall_thickness, tolerance*2,tower_play,anchor=CENTER);
                pylon(tower_height,token_hole_diameter-tower_play+tolerance*2,anchor=CENTER);
            }
}

if(show_marker){
    color(marker_color)
        marker(marker_width,marker_depth,marker_height);
}

if(show_token){
    color(token_color)
        roundtoken(token_diameter,token_thickness)
            pylon(tower_height,token_hole_diameter+tower_play,anchor=BOTTOM);
}

if(show_box){
    color(base_color)
        lid(base_side-base_wall_thickness*2-tolerance*2,base_side-base_wall_thickness*2-tolerance*2,box_height,base_wall_thickness) cuboid(0);
}

