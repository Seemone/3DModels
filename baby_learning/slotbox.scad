// A square box, with a lid with a slot in it
// round, triangular and square tokens to push thru
// tolerances are set to a default that offers some resistance
// requires https://github.com/BelfrySCAD/BOSL2

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

side = 40;
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

module roundtoken(x,y,z,diameter,thickness)
{
   torus_radius = thickness/2;
   inner_radius = diameter/2-torus_radius;
   
   translate([x,y,z])
      cylinder(thickness,inner_radius,inner_radius);
   
   translate([x,y,z])
      translate([0,0,torus_radius])
            rotate_extrude(angle=360)
            translate([inner_radius,0,0])
            circle(torus_radius);
}

module squaretoken(x,y,z,side,thickness)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   translate([x,y,z])
      cuboid([side, side, thickness], anchor=BOTTOM, rounding=torus_radius);
}


module triangletoken(x,y,z,side,thickness)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   translate([x,y,z])
      rounded_prism(regular_ngon(n=3, side=side),
      joint_top=torus_radius,
      joint_bot=torus_radius,
      joint_sides=torus_radius,
      h=thickness, anchor=BOTTOM); 
}

module boxbase(x,y,z,side,height,thickness,slotlength=0,slotwidth=0)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   difference() {
   translate([x,y,z])
      cuboid([side, side, height], anchor=BOTTOM, rounding=1);
   translate([x,y,z+thickness])
      cuboid([side-thickness*2, side-thickness*2, height+thickness*2], anchor=BOTTOM, rounding=0);
   }
}

module boxlid(x,y,z,side,thickness,slotlength=0,slotwidth=0,lidheight=0)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   lidh = lidheight>0 ? lidheight : max(5,(side/8));
   
   difference() {
   translate([x+side+10,y,z])
      cuboid([side+thickness*2+lid_tolerance, side+thickness*2+lid_tolerance, lidh], anchor=BOTTOM, rounding=1);
   translate([x+side+10,y,z+thickness])
      cuboid([side+lid_tolerance, side+lid_tolerance, lidh+thickness*2], anchor=BOTTOM, rounding=0);
   }
}

module boxslot(x,y,z,side,thickness,slotlength=0,slotwidth=0)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   translate([x+side+10,y,z])
      cuboid([slotlength+slot_tolerance, slotwidth+slot_tolerance, thickness*3], anchor=CENTER, rounding=0);
}

module boxoutline(x,y,z,side,thickness,slotlength=0,slotwidth=0,outline_width=0)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;

   color(lid_color)       
      translate([x+side+10,y,z])
         cuboid([slotlength+outline_width,slotwidth+outline_width,thickness], anchor=BOTTOM);
}


$fn=100;

pos_x=20;
pos_y=20;
pos_z=0;

if(slotted)
   if(!hide_triangletoken)
      color(lid_color) triangletoken(pos_x,pos_y, pos_z, slotlength, slotwidth);

if(slotted)
   if(!hide_squaretoken)
      color(lid_color) squaretoken(-pos_x,pos_y, pos_z, slotlength, slotwidth);
   
if(slotted)
   if(!hide_roundtoken)
      color(lid_color) roundtoken(pos_x*3,pos_y, pos_z, slotlength, slotwidth);
   
if(!hide_box)
   color(box_color) boxbase(-pos_x,-pos_y, pos_z,side,height,wall_thickness,slotlength,slotwidth);

if(!hide_lid)
   if(slotted){
      biggest_slot_measure=max(slotlength,slotwidth);
      outline_w = side-5 < biggest_slot_measure+outline_width ? side-biggest_slot_measure-5 : outline_width;
      difference() {
         color(box_color) boxlid(-pos_x,-pos_y, pos_z,side,wall_thickness,slotlength,slotwidth,lidheight);
         boxslot(-pos_x,-pos_y, pos_z,side,wall_thickness,slotlength+outline_w,slotwidth+outline_w);
      }
      difference() {
         boxoutline(-pos_x,-pos_y, pos_z,side,wall_thickness,slotlength,slotwidth,outline_w);
         boxslot(-pos_x,-pos_y, pos_z,side,wall_thickness,slotlength,slotwidth);
      }
   } else {
      color(box_color) boxlid(-pos_x,-pos_y, pos_z,side,wall_thickness,slotlength,slotwidth,lidheight);
   }
