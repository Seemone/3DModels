// A square box, with a lid with a slot in it
// round, triangular, square and star shaped tokens to push thru
// a tray holder to put multiple together
// tolerances are set to a default that offers some resistance
// requires https://github.com/BelfrySCAD/BOSL2

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [Shape] */

tokenshape = "round"; // ["round","triangle","square","star"]

/* [Sizes] */

side = 40;
height = 30;
wall_thickness = 1;
slotlength=26;
slotwidth=4;
lidheight=10;
outline_width=5;

/* [Options] */

box_color = "blue";
token_color = "red";
slotted = true;
lid_tolerance=0.15;
slot_tolerance=0.1;

/* [Components] */

hide_box = false;
hide_lid = false;
hide_holder = false;
holder_rows = 2;
holder_columns = 2;
shape_rows = 2;
shape_columns = 2;


module roundtoken(x,y,z,diameter,thickness,anchor=BOTTOM)
{
   torus_radius = thickness/2;
   inner_radius = diameter/2-torus_radius;
   
   translate([x,y,z])
      cylinder(thickness,inner_radius,inner_radius,anchor=anchor);
   
   translate([x,y,z])
      rotate_extrude(angle=360)
      translate([inner_radius,0,0])
      circle(torus_radius,anchor=anchor);
}

module roundtoken_lid(x,y,z,diameter,thickness,anchor=BOTTOM)
{
   torus_radius = thickness/2;
   inner_radius = diameter/2-torus_radius;
   
   translate([x,y,z])
      cylinder(thickness,diameter,diameter,anchor=anchor);

}

module squaretoken(x,y,z,side,thickness,anchor=BOTTOM)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   translate([x,y,z])
      cuboid([side, side, thickness], anchor=anchor, rounding=torus_radius);
}

module triangletoken(x,y,z,side,thickness,anchor=BOTTOM)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   translate([x,y,z])
      rotate([0,0,270])
         rounded_prism(regular_ngon(n=3, side=side),
         joint_top=torus_radius,
         joint_bot=torus_radius,
         joint_sides=torus_radius,
         h=thickness,anchor=anchor); 
}

module triangletoken_lid(x,y,z,side,thickness,anchor=BOTTOM)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   translate([x,y,z])
      rotate([0,0,270])
         rounded_prism(regular_ngon(n=3, side=side),h=thickness,anchor=anchor, k=0); 
}

module startoken(x,y,z,side,thickness,anchor=BOTTOM)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   translate([x,y,z])
      rotate([0,0,270])
         rounded_prism(star(n=5,r=side/2,ir=side/4),
         joint_top=torus_radius,
         joint_bot=torus_radius,
         joint_sides=torus_radius,
         h=thickness,anchor=anchor); 
}

module startoken_lid(x,y,z,side,thickness,anchor=BOTTOM)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   translate([x,y,z])
      rotate([0,0,270])
         rounded_prism(star(n=5,r=side/2,ir=side/4),h=thickness,anchor=anchor, k=0); 
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

module boxlid(x,y,z,side,thickness,slotlength=0,slotwidth=0,lidheight=0, tolerance=-1)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   lidh = lidheight>0 ? lidheight : max(5,(side/8));
   
   difference() {
   translate([x,y,z])
      cuboid([side+thickness*2+tolerance, side+thickness*2+tolerance, lidh], anchor=BOTTOM, rounding=1);
   translate([x,y,z+thickness])
      cuboid([side+tolerance, side+tolerance, lidh+thickness*2], anchor=BOTTOM, rounding=0);
   }
}

module boxslot(x,y,z,side,thickness,slotlength=0,slotwidth=0)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;
   
   translate([x,y,z])
      cuboid([slotlength+slot_tolerance, slotwidth+slot_tolerance, thickness*3], anchor=CENTER, rounding=0);
}

module boxoutline(x,y,z,side,thickness,slotlength=0,slotwidth=0,outline_width=0)
{
   torus_radius = thickness/2;
   inner_radius = side/2-torus_radius;

   color(token_color)       
      translate([x,y,z])
         cuboid([slotlength+outline_width,slotwidth+outline_width,thickness], anchor=BOTTOM);
}

$fn=100;

pos_x=0;
pos_y=0;
pos_z=0;

for(r = [1:shape_rows])
   for(c = [1:shape_columns])
      translate([(side+wall_thickness*2+lid_tolerance*2)*(r-1), -(side+wall_thickness*2+lid_tolerance*2)*(c), 0])
         if(tokenshape=="triangle")
            color(token_color) triangletoken(pos_x,pos_y, pos_z, slotlength, slotwidth);
         else if(tokenshape=="square")
            color(token_color) squaretoken(pos_x,pos_y, pos_z, slotlength, slotwidth);
         else if(tokenshape=="round")
            color(token_color) roundtoken(pos_x,pos_y, pos_z, slotlength, slotwidth);   
         else if(tokenshape=="star")
            color(token_color) startoken(pos_x,pos_y, pos_z, slotlength, slotwidth);

if(!hide_box)
   color(box_color) boxbase(pos_x,pos_y, pos_z,side,height,wall_thickness,slotlength,slotwidth);

if(!hide_lid)
   translate([pos_x+(side+10),pos_y,pos_z])
      if(slotted){
         biggest_slot_measure=max(slotlength,slotwidth);
         outline_w = side-5 < biggest_slot_measure+outline_width ? side-biggest_slot_measure-5 : outline_width;
         difference() {
            color(box_color) boxlid(0,0, 0,side,wall_thickness,slotlength,slotwidth,lidheight,lid_tolerance);
            boxslot(0,-pos_y+10, pos_z,side,wall_thickness,slotlength+outline_w,slotwidth+outline_w);
         if(tokenshape=="triangle")
            color(token_color) triangletoken(0,-side/4+5, 0, slotlength/3*2, wall_thickness*2,anchor=CENTER);
         else if(tokenshape=="square")
            color(token_color) squaretoken(0,0-side/4+5, 0, slotlength/3*2, wall_thickness*2,anchor=CENTER);
         else if(tokenshape=="round")
            color(token_color) roundtoken(0,0-side/4+5, 0, slotlength/3*2, wall_thickness*2,anchor=CENTER);
         else if(tokenshape=="star")
            color(token_color) startoken(0,0-side/4+5, 0, slotlength/3*2, wall_thickness*2,anchor=CENTER);
         }
      } else {
         color(box_color) boxlid(-pos_x,-pos_y, pos_z,side,wall_thickness,slotlength,slotwidth,lidheight);
      }

if(!hide_lid)
   translate([pos_x+(side+10),pos_y,pos_z])
      if(slotted){
         biggest_slot_measure=max(slotlength,slotwidth);
         outline_w = side-5 < biggest_slot_measure+outline_width ? side-biggest_slot_measure-5 : outline_width;
         difference() {
            boxoutline(0,10, 0,side,wall_thickness,slotlength,slotwidth,outline_w);
            boxslot(0,10, 0,side,wall_thickness,slotlength,slotwidth);
         }
      }
if(!hide_lid)
   translate([pos_x+(side+10),pos_y,pos_z])
      if(slotted){
         if(tokenshape=="triangle")
            color(token_color) triangletoken(0,-side/4+5, 0, slotlength/3*2, wall_thickness,anchor=BOTTOM);
         else if(tokenshape=="square")
            color(token_color) squaretoken(0,-side/4+5, 0, slotlength/3*2, wall_thickness,anchor=BOTTOM);
         else if(tokenshape=="round")
            color(token_color) roundtoken_lid(0,-side/4+5, 0, slotlength/3, wall_thickness,anchor=BOTTOM);
         else if(tokenshape=="star")
            color(token_color) startoken_lid(0,-side/4+5, 0, slotlength/3*2, wall_thickness,anchor=BOTTOM);
         }


if(!hide_holder)
translate([pos_x,pos_y+10, pos_z])
   for(r = [1:holder_rows])
      for(c = [1:holder_columns])
         translate([(side+wall_thickness*2+lid_tolerance*2)*(r-1), (side+wall_thickness*2+lid_tolerance*2)*(c), 0])
            color(box_color) boxlid(0,0,0,side,wall_thickness,slotlength,slotwidth,5,tolerance=lid_tolerance*2);
