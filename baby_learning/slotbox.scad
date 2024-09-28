// A square box, with a lid with a slot in it
// round, triangular and square tokens to push thru
// tolerances are set to a default that offers some resistance
// requires https://github.com/BelfrySCAD/BOSL2

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

radius = 20;
height = 30;
wall_thickness = 1;
slotlength=26;
slotwidth=4;
lidheight=10;
outline_width=5;

box_color = "blue";
lid_color = "red";

slotted = true;

hide_box = false;
hide_lid = false;

hide_roundtoken = false;
hide_triangletoken = false;
hide_squaretoken = false;

lid_tolerance=0.15;
slot_tolerance=0.1;

module token(x,y,z,radius,thickness)
{
   torus_radius = thickness/2;
   inner_radius = radius-torus_radius;
   
   translate([x,y,z])
      cylinder(thickness,inner_radius,inner_radius);
   
   translate([x,y,z])
      translate([0,0,torus_radius])
            rotate_extrude(angle=360)
            translate([inner_radius,0,0])
            circle(torus_radius);
}

module squaretoken(x,y,z,radius,thickness)
{
   torus_radius = thickness/2;
   inner_radius = radius-torus_radius;
   
   translate([x,y,z])
      cuboid([radius*2, radius*2, thickness], anchor=BOTTOM, rounding=torus_radius);
}


module triangletoken(x,y,z,radius,thickness)
{
   torus_radius = thickness/2;
   inner_radius = radius-torus_radius;
   
   translate([x,y,z])
      rounded_prism(regular_ngon(n=3, side=radius*2),
      joint_top=torus_radius,
      joint_bot=torus_radius,
      joint_sides=torus_radius,
      h=thickness, anchor=BOTTOM); 
}

module boxbase(x,y,z,radius,height,thickness,slotlength=0,slotwidth=0)
{
   torus_radius = thickness/2;
   inner_radius = radius-torus_radius;
   
   difference() {
   translate([x,y,z])
      cuboid([radius*2, radius*2, height], anchor=BOTTOM, rounding=1);
   translate([x,y,z+thickness])
      cuboid([radius*2-thickness*2, radius*2-thickness*2, height+thickness*2], anchor=BOTTOM, rounding=0);
   }
}

module boxlid(x,y,z,radius,thickness,slotlength=0,slotwidth=0,lidheight=0)
{
   torus_radius = thickness/2;
   inner_radius = radius-torus_radius;
   
   lidh = lidheight>0 ? lidheight : max(5,(radius/4));
   
   difference() {
   translate([x+radius*2+10,y,z])
      cuboid([radius*2+thickness*2+lid_tolerance, radius*2+thickness*2+lid_tolerance, lidh], anchor=BOTTOM, rounding=1);
   translate([x+radius*2+10,y,z+thickness])
      cuboid([radius*2+lid_tolerance, radius*2+lid_tolerance, lidh+thickness*2], anchor=BOTTOM, rounding=0);
   }
}

module boxslot(x,y,z,radius,thickness,slotlength=0,slotwidth=0)
{
   torus_radius = thickness/2;
   inner_radius = radius-torus_radius;
   
   translate([x+radius*2+10,y,z])
      cuboid([slotlength+slot_tolerance, slotwidth+slot_tolerance, thickness*3], anchor=CENTER, rounding=0);
}

module boxoutline(x,y,z,radius,thickness,slotlength=0,slotwidth=0,outline_width=0)
{
   torus_radius = thickness/2;
   inner_radius = radius-torus_radius;

   color(lid_color)       
      translate([x+radius*2+10,y,z])
         cuboid([slotlength+outline_width,slotwidth+outline_width,thickness], anchor=BOTTOM);
}


$fn=100;

pos_x=20;
pos_y=20;
pos_z=0;

if(slotted)
   if(!hide_triangletoken)
      color(lid_color) triangletoken(pos_x,pos_y, pos_z, slotlength/2, slotwidth);

if(slotted)
   if(!hide_squaretoken)
      color(lid_color) squaretoken(-pos_x,pos_y, pos_z, slotlength/2, slotwidth);
   
if(slotted)
   if(!hide_roundtoken)
      color(lid_color) token(pos_x*3,pos_y, pos_z, slotlength/2, slotwidth);
   
if(!hide_box)
   color(box_color) boxbase(-pos_x,-pos_y, pos_z,radius,height,wall_thickness,slotlength,slotwidth);

if(!hide_lid)
   if(slotted){
      difference() {
         color(box_color) boxlid(-pos_x,-pos_y, pos_z,radius,wall_thickness,slotlength,slotwidth,lidheight);
         boxslot(-pos_x,-pos_y, pos_z,radius,wall_thickness,slotlength+outline_width,slotwidth+outline_width);
      }
      difference() {
         boxoutline(-pos_x,-pos_y, pos_z,radius,wall_thickness,slotlength,slotwidth,outline_width);
         boxslot(-pos_x,-pos_y, pos_z,radius,wall_thickness,slotlength,slotwidth);
      }
   } else {
      color(box_color) boxlid(-pos_x,-pos_y, pos_z,radius,wall_thickness,slotlength,slotwidth,lidheight);
   }
