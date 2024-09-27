_border_tolerance=0.2;
_global_tolerance=0.001;
_default_color="orange";
_default_fs=2;
_default_fa=12;
_z_cutout=0.001;

default_render = true;

$fa=_default_fa;
$fs=_default_fs; 

do_base = default_render;

do_base_square = default_render;
do_base_circle = default_render;
do_base_oval = default_render;
do_base_rectangle = default_render;
do_base_rhombus = default_render;
do_base_star = default_render;
do_base_hexagon = default_render;
do_base_pentagon = default_render;
do_base_triangle = default_render;

do_square = default_render;
do_square_border = default_render;
do_circle = default_render;
do_circle_border = default_render;
do_oval = default_render;
do_oval_border = default_render;
do_rectangle = default_render;
do_rectangle_border = default_render;
do_rhombus = default_render;
do_rhombus_border = default_render;
do_star = default_render;
do_star_border = default_render;
do_hexagon = default_render;
do_hexagon_border = default_render;
do_pentagon = default_render;
do_pentagon_border = default_render;
do_triangle = default_render;
do_triangle_border = default_render;

//do_base=!default_render;

//do_base_star=!default_render;

// primitives


module __rectangle(x=0,y=0,z=0,sizex,sizey,thickness,angle=0) {
    translate([x,y,z])
    {
        linear_extrude(thickness)
            resize([sizex, sizey, 0],[true, true, false])
                rotate([0,0,angle])
                    square(sizex,center=true);
    }
}

*

module __polygon(x=0,y=0,z=0,sizex,sizey,thickness,sides) {
    translate([x,y,z])
    {
        linear_extrude(thickness)
            rotate([0,0,90])
                circle(d=sizex,$fn=sides);
    }
}

module _square(x=0,y=0,z=0,size,thickness) {
    __rectangle(x=x,y=y,z=z,sizex=size,sizey=size,thickness=thickness);
}

module _rectangle(x=0,y=0,z=0,size,thickness) {
    __rectangle(x=x,y=y,z=z,sizex=size,sizey=size*0.6,thickness=thickness);
}

module _rhombus(x=0,y=0,z=0,size,thickness) {
    __rectangle(x=x,y=y,z=z,sizex=size,sizey=size*0.6,thickness=thickness,angle=45);
}

module _circle(x=0,y=0,z=0,size,thickness) {
    __oval(x=x,y=y,z=z,sizex=size,sizey=size,thickness=thickness);
}

module _oval(x=0,y=0,z=0,size,thickness) {
    __oval(x=x,y=y,z=z,sizex=size,sizey=size*0.6,thickness=thickness);
}

module _triangle(x=0,y=0,z=0,size,thickness) {
    __polygon(x=x,y=y,z=z,sizex=size,sizey=size,thickness=thickness,sides=3);
}

module _pentagon(x=0,y=0,z=0,size,thickness) {
    __polygon(x=x,y=y,z=z,sizex=size,sizey=size,thickness=thickness,sides=5);
}
module _hexagon(x=0,y=0,z=0,size,thickness) {
    __polygon(x=x,y=y,z=z,sizex=size,sizey=size,thickness=thickness,sides=6);
}

// from https://gist.github.com/anoved/9622826?permalink_comment_id=4269985#gistcomment-4269985
module _star(x=0,y=0,z=0,size,thickness,points=5) 
{ 
    d1=size;
    d2=size/4;
    r1=0;
    r2=0;
    p=points;
    R1= r1!=0 ? r1: d1/2;
    D1= d1!=0 ? d1: 2*r1;
    R2= r2!=0 ? r2: d2/2;
    D2= d2!=0 ? d2: 2*r2;
    translate([x,y,z])
        linear_extrude(thickness)
            rotate([0,0,270])
                union()
                { 
                    for(i=[0:p-1])
                    { 
                        i1=[cos(i*360/p - 180/p)*R1,sin(i*360/p - 180/p )*R1]; //first inner point
                        i2=[cos(i*360/p + 180/p)*R1,sin(i*360/p + 180/p)*R1]; //second inner point
                        i3=[cos(i*360/p + 180)*R1,sin(i*360/p + 180)*R1];      //third inner point
                        o=[cos(i*360/p)*R2,sin(i*360/p)*R2];                           //outer point
                        polygon([i1,o,i2,i3],[[0,1,2,3]]);
                    }
                }
        
}

module _star(x=0,y=0,z=0,size,thickness,points=5) 
{
  r1=size/2;
  r2=size/4;
  p=points;
  s = [for(i=[0:p*2]) 
    [
      (i % 2 == 0 ? r1 : r2)*cos(180*i/p),
      (i % 2 == 0 ? r1 : r2)*sin(180*i/p)
    ]
  ];
    translate([x,y,z])
        linear_extrude(thickness)
            rotate([0,0,90])    
                polygon(s);
}

module _peg(x=0,y=0,z=0,size,thickness){
    translate([x,y,z])
    {
        linear_extrude(thickness)
            circle(d=size);
    }
}

// cutouts

module _cutout_square(x=0,y=0,z=0,size,thickness,gap,border){
    __rectangle(x=x,y=y,z=z,sizex=size+gap+border,sizey=size+gap+border,thickness=thickness);
}

module _cutout_rectangle(x=0,y=0,z=0,size,thickness,gap,border){
    __rectangle(x=x,y=y,z=z,sizex=size+gap+border,sizey=size*0.6+gap+border,thickness=thickness);
}

module _cutout_rhombus(x=0,y=0,z=0,size,thickness,gap,border){
    __rectangle(x=x,y=y,z=z,sizex=size+gap+border,sizey=size*0.6+gap+border,thickness=thickness,angle=45);
}

module _cutout_circle(x=0,y=0,z=0,size,thickness,gap,border){
    __oval(x=x,y=y,z=z,sizex=size+gap+border,sizey=size+gap+border,thickness=thickness);
} 

module _cutout_oval(x=0,y=0,z=0,size,thickness,gap,border){
    __oval(x=x,y=y,z=z,sizex=size+gap+border,sizey=size*0.6+gap+border,thickness=thickness);
} 

module _cutout_triangle(x=0,y=0,z=0,size,thickness,gap,border){
    __polygon(x=x,y=y,z=z,sizex=size+gap+border,sizey=size+gap+border,thickness=thickness,sides=3);
} 
module _cutout_pentagon(x=0,y=0,z=0,size,thickness,gap,border){
    __polygon(x=x,y=y,z=z,sizex=size+gap+border,sizey=size+gap+border,thickness=thickness,sides=5);
} 
module _cutout_hexagon(x=0,y=0,z=0,size,thickness,gap,border){
    __polygon(x=x,y=y,z=z,sizex=size+gap+border,sizey=size+gap+border,thickness=thickness,sides=6);
} 

module _cutout_star(x=0,y=0,z=0,size,thickness,gap,border,points=5){
    _star(x=x,y=y,z=z,size=size+gap*2+border*2,thickness=thickness,points);
} 



module border_square(x=0,y=0,z=0,size,thickness,gap,border){
    difference(){
        _square(x=x,y=y,z=z,size=size+gap+border-_border_tolerance,thickness=thickness);
        _square(x=x,y=y,z=z,size=size+gap,thickness=thickness);
    }
}

module border_rectangle(x=0,y=0,z=0,size,thickness,gap,border){
    difference(){
        __rectangle(x=x,y=y,z=z,sizex=size+gap+border-_border_tolerance,sizey=size*0.6+gap+border-_border_tolerance,thickness=thickness);
        __rectangle(x=x,y=y,z=z,sizex=size+gap,sizey=size*0.6+gap,thickness=thickness+_z_cutout);
    }
}

module border_rhombus(x=0,y=0,z=0,size,thickness,gap,border){
    difference(){
        __rectangle(x=x,y=y,z=z,sizex=size+gap+border-_border_tolerance,sizey=size*0.6+gap+border-_border_tolerance,thickness=thickness,angle=45);
        __rectangle(x=x,y=y,z=z,sizex=size+gap,sizey=size*0.6+gap,thickness=thickness+_z_cutout,angle=45);
    }
}


module border_circle(x=0,y=0,z=0,size,thickness,gap,border){
    difference(){
        _circle(x=x,y=y,z=z,size=size+gap+border-_border_tolerance,thickness=thickness);
        _circle(x=x,y=y,z=z,size=size+gap,thickness=thickness+_z_cutout);
    }
}

module border_oval(x=0,y=0,z=0,size,thickness,gap,border){
    difference(){
        __oval(x=x,y=y,z=z,sizex=size+gap+border-_border_tolerance,sizey=size*0.6+gap+border-_border_tolerance,thickness=thickness);
        __oval(x=x,y=y,z=z,sizex=size+gap,sizey=size*0.6+gap,thickness=thickness+_z_cutout);
    }
}

module border_triangle(x=0,y=0,z=0,size,thickness,gap,border){
    difference(){
        __polygon(x=x,y=y,z=z,sizex=size+gap+border-_border_tolerance,sizey=size+gap+border-_border_tolerance,thickness=thickness,sides=3);
        __polygon(x=x,y=y,z=z,sizex=size+gap,sizey=size+gap,thickness=thickness+_z_cutout,sides=3);
    }
}

module border_pentagon(x=0,y=0,z=0,size,thickness,gap,border){
    difference(){
        __polygon(x=x,y=y,z=z,sizex=size+gap+border-_border_tolerance,sizey=size+gap+border-_border_tolerance,thickness=thickness,sides=5);
        __polygon(x=x,y=y,z=z,sizex=size+gap,sizey=size+gap,thickness=thickness+_z_cutout,sides=5);
    }
}

module border_hexagon(x=0,y=0,z=0,size,thickness,gap,border){
    difference(){
        __polygon(x=x,y=y,z=z,sizex=size+gap+border-_border_tolerance,sizey=size+gap+border-_border_tolerance,thickness=thickness,sides=6);
        __polygon(x=x,y=y,z=z,sizex=size+gap,sizey=size+gap,thickness=thickness+_z_cutout,sides=6);
    }
}
module border_star(x=0,y=0,z=0,size,thickness,gap,border,points=5){
    difference(){
        _star(x=x,y=y,z=z,size=size+gap*2+border*2-_border_tolerance*2,thickness=thickness,points=points);
        _star(x=x,y=y,z=z,size=size+gap*2,thickness=thickness+_z_cutout,points=points);
    }
}


//full pieces

module piece_square(x=0,y=0,z=0,piece_size,piece_thickness,piece_gap,piece_border,_color=_default_color,_alpha=1){
    color(_color,_alpha) 
        _square(x=x,y=y,z=z,size=piece_size,thickness=piece_thickness);
}

module piece_circle(x=0,y=0,z=0,piece_size,piece_thickness,piece_gap,piece_border,_color=_default_color,_alpha=1){
    color(_color,_alpha) 
        _circle(x=x,y=y,z=z,size=piece_size,thickness=piece_thickness);
}

module piece_oval(x=0,y=0,z=0,piece_size,piece_thickness,piece_gap,piece_border,_color=_default_color,_alpha=1){
    color(_color,_alpha) 
        _oval(x=x,y=y,z=z,size=piece_size,thickness=piece_thickness);
}

module piece_rectangle(x=0,y=0,z=0,piece_size,piece_thickness,piece_gap,piece_border,_color=_default_color,_alpha=1){
    color(_color,_alpha) 
        _rectangle(x=x,y=y,z=z,size=piece_size,thickness=piece_thickness);
}
module piece_rhombus(x=0,y=0,z=0,piece_size,piece_thickness,piece_gap,piece_border,_color=_default_color,_alpha=1){
    color(_color,_alpha) 
        _rhombus(x=x,y=y,z=z,size=piece_size,thickness=piece_thickness);
}

module piece_triangle(x=0,y=0,z=0,piece_size,piece_thickness,piece_gap,piece_border,_color=_default_color,_alpha=1){
    color(_color,_alpha) 
        _triangle(x=x,y=y,z=z,size=piece_size,thickness=piece_thickness);
}

module piece_pentagon(x=0,y=0,z=0,piece_size,piece_thickness,piece_gap,piece_border,_color=_default_color,_alpha=1){
    color(_color,_alpha) 
        _pentagon(x=x,y=y,z=z,size=piece_size,thickness=piece_thickness);
}

module piece_hexagon(x=0,y=0,z=0,piece_size,piece_thickness,piece_gap,piece_border,_color=_default_color,_alpha=1){
    color(_color,_alpha) 
        _hexagon(x=x,y=y,z=z,size=piece_size,thickness=piece_thickness);
}
module piece_star(x=0,y=0,z=0,piece_size,piece_thickness,piece_gap,piece_border,_color=_default_color,_alpha=1,points=5){
    color(_color,_alpha) 
        _star(x=x,y=y,z=z,size=piece_size,thickness=piece_thickness,points=points);
}


// piece sizes

piece_size=50;                             // piece max size
piece_thickness=3;                         //piece thickness excluding peg
piece_gap=1;                               // gap between piece and border
piece_border=3;                            // border thickness
piece_distance=(piece_gap+piece_border)*1; // distance between pieces (min)
peg_size=8;                                // peg diameter
peg_thickness=10;                          // peg thickness
piece_total_size=(piece_size+piece_gap+piece_border);
star_points=5;
// base sizes

base_grid_size=3;
base_thickness=piece_thickness+2;
base_external_border=piece_gap*4;

// geometric origin of the full model

base_x=0;
base_y=0;
base_z=0;

base_deltay=piece_total_size*base_grid_size+piece_distance*base_grid_size-1+base_external_border;
//base_deltay=0;
// relative (matrix) positions of pieces

square_x_position=0;
square_y_position=0;
square_z_position=0;

rectangle_x_position=1;
rectangle_y_position=0;
rectangle_z_position=0;

rhombus_x_position=1;
rhombus_y_position=1;
rhombus_z_position=0;

circle_x_position=0;
circle_y_position=1;
circle_z_position=0;

oval_x_position=-1;
oval_y_position=-1;
oval_z_position=0;

triangle_x_position=-1;
triangle_y_position=0;
triangle_z_position=0;

pentagon_x_position=-1;
pentagon_y_position=1;
pentagon_z_position=0;

hexagon_x_position=0;
hexagon_y_position=-1;
hexagon_z_position=0;

star_x_position=1;
star_y_position=-1;
star_z_position=0;



// geometric positions of pieces

square_x=base_x+square_x_position*(piece_total_size+piece_distance);
square_y=base_y+square_y_position*(piece_total_size+piece_distance);
square_z=base_z+square_z_position*(piece_total_size+piece_distance);

rectangle_x=base_x+rectangle_x_position*(piece_total_size+piece_distance);
rectangle_y=base_y+rectangle_y_position*(piece_total_size+piece_distance);
rectangle_z=base_z+rectangle_z_position*(piece_total_size+piece_distance);

rhombus_x=base_x+rhombus_x_position*(piece_total_size+piece_distance);
rhombus_y=base_y+rhombus_y_position*(piece_total_size+piece_distance);
rhombus_z=base_z+rhombus_z_position*(piece_total_size+piece_distance);

circle_x=base_x+circle_x_position*(piece_total_size+piece_distance);
circle_y=base_y+circle_y_position*(piece_total_size+piece_distance);
circle_z=base_z+circle_z_position*(piece_total_size+piece_distance);

oval_x=base_x+oval_x_position*(piece_total_size+piece_distance);
oval_y=base_y+oval_y_position*(piece_total_size+piece_distance);
oval_z=base_z+oval_z_position*(piece_total_size+piece_distance);

triangle_x=base_x+triangle_x_position*(piece_total_size+piece_distance);
triangle_y=base_y+triangle_y_position*(piece_total_size+piece_distance);
triangle_z=base_z+triangle_z_position*(piece_total_size+piece_distance);

pentagon_x=base_x+pentagon_x_position*(piece_total_size+piece_distance);
pentagon_y=base_y+pentagon_y_position*(piece_total_size+piece_distance);
pentagon_z=base_z+pentagon_z_position*(piece_total_size+piece_distance);

hexagon_x=base_x+hexagon_x_position*(piece_total_size+piece_distance);
hexagon_y=base_y+hexagon_y_position*(piece_total_size+piece_distance);
hexagon_z=base_z+hexagon_z_position*(piece_total_size+piece_distance);

star_x=base_x+star_x_position*(piece_total_size+piece_distance);
star_y=base_y+star_y_position*(piece_total_size+piece_distance);
star_z=base_z+star_z_position*(piece_total_size+piece_distance);



// conditional rendering

if (do_square) {
    piece_square(x=square_x,y=square_y,z=square_z,piece_size=piece_size,piece_thickness=piece_thickness,piece_gap=piece_gap,piece_border=piece_border);
    _peg(x=square_x,y=square_y,z=square_z+piece_thickness-_global_tolerance,size=peg_size,thickness=peg_thickness+_global_tolerance);
}

if (do_rectangle) {
    piece_rectangle(x=rectangle_x,y=rectangle_y,z=rectangle_z,piece_size=piece_size,piece_thickness=piece_thickness,piece_gap=piece_gap,piece_border=piece_border);
    _peg(x=rectangle_x,y=rectangle_y,z=rectangle_z+piece_thickness-_global_tolerance,size=peg_size,thickness=peg_thickness+_global_tolerance);
}

if (do_rhombus) {
    piece_rhombus(x=rhombus_x,y=rhombus_y,z=rhombus_z,piece_size=piece_size,piece_thickness=piece_thickness,piece_gap=piece_gap,piece_border=piece_border);
    _peg(x=rhombus_x,y=rhombus_y,z=rhombus_z+piece_thickness-_global_tolerance,size=peg_size,thickness=peg_thickness+_global_tolerance);
}

if (do_circle) {
    piece_circle(x=circle_x,y=circle_y,z=circle_z,piece_size=piece_size,piece_thickness=piece_thickness,piece_gap=piece_gap,piece_border=piece_border);
    _peg(x=circle_x,y=circle_y,z=circle_z+piece_thickness-_global_tolerance,size=peg_size,thickness=peg_thickness+_global_tolerance);
}

if (do_oval) {
    piece_oval(x=oval_x,y=oval_y,z=oval_z,piece_size=piece_size,piece_thickness=piece_thickness,piece_gap=piece_gap,piece_border=piece_border);
    _peg(x=oval_x,y=oval_y,z=oval_z+piece_thickness-_global_tolerance,size=peg_size,thickness=peg_thickness+_global_tolerance);
}

if (do_triangle) {
    piece_triangle(x=triangle_x,y=triangle_y,z=triangle_z,piece_size=piece_size,piece_thickness=piece_thickness,piece_gap=piece_gap,piece_border=piece_border);
    _peg(x=triangle_x,y=triangle_y,z=triangle_z+piece_thickness-_global_tolerance,size=peg_size,thickness=peg_thickness+_global_tolerance);
}

if (do_pentagon) {
    piece_pentagon(x=pentagon_x,y=pentagon_y,z=pentagon_z,piece_size=piece_size,piece_thickness=piece_thickness,piece_gap=piece_gap,piece_border=piece_border);
    _peg(x=pentagon_x,y=pentagon_y,z=pentagon_z+piece_thickness-_global_tolerance,size=peg_size,thickness=peg_thickness+_global_tolerance);
}

if (do_hexagon) {
    piece_hexagon(x=hexagon_x,y=hexagon_y,z=hexagon_z,piece_size=piece_size,piece_thickness=piece_thickness,piece_gap=piece_gap,piece_border=piece_border);
    _peg(x=hexagon_x,y=hexagon_y,z=hexagon_z+piece_thickness-_global_tolerance,size=peg_size,thickness=peg_thickness+_global_tolerance);
}

if (do_star) {
    piece_star(x=star_x,y=star_y,z=star_z,piece_size=piece_size,piece_thickness=piece_thickness,piece_gap=piece_gap,piece_border=piece_border,points=star_points);
    _peg(x=star_x,y=star_y,z=star_z+piece_thickness-_global_tolerance,size=peg_size,thickness=peg_thickness+_global_tolerance);
}



if (do_square_border) {
    border_square(x=square_x,y=square_y,z=square_z,size=piece_size,thickness=piece_thickness-_z_cutout,gap=piece_gap,border=piece_border);
}

if (do_rectangle_border) {
    border_rectangle(x=rectangle_x,y=rectangle_y,z=rectangle_z,size=piece_size,thickness=piece_thickness-_z_cutout,gap=piece_gap,border=piece_border);
}

if (do_rhombus_border) {
    border_rhombus(x=rhombus_x,y=rhombus_y,z=rhombus_z,size=piece_size,thickness=piece_thickness-_z_cutout,gap=piece_gap,border=piece_border);
}

if (do_circle_border) {
    border_circle(x=circle_x,y=circle_y,z=circle_z,size=piece_size,thickness=piece_thickness-_z_cutout,gap=piece_gap,border=piece_border);
}

if (do_oval_border) {
    border_oval(x=oval_x,y=oval_y,z=oval_z,size=piece_size,thickness=piece_thickness-_z_cutout,gap=piece_gap,border=piece_border);
}

if (do_triangle_border) {
    border_triangle(x=triangle_x,y=triangle_y,z=triangle_z,size=piece_size,thickness=piece_thickness-_z_cutout,gap=piece_gap,border=piece_border);
}

if (do_pentagon_border) {
    border_pentagon(x=pentagon_x,y=pentagon_y,z=pentagon_z,size=piece_size,thickness=piece_thickness-_z_cutout,gap=piece_gap,border=piece_border);
}

if (do_hexagon_border) {
    border_hexagon(x=hexagon_x,y=hexagon_y,z=hexagon_z,size=piece_size,thickness=piece_thickness-_z_cutout,gap=piece_gap,border=piece_border);
}

if (do_star_border) {
    border_star(x=star_x,y=star_y,z=star_z,size=piece_size,thickness=piece_thickness-_z_cutout,gap=piece_gap,border=piece_border,points=star_points);
}

if (do_base) {
    difference(){
        _square(x=base_x,y=base_y+base_deltay,z=base_z+piece_thickness-base_thickness,size=piece_total_size*base_grid_size+piece_distance*base_grid_size-1+base_external_border,thickness=base_thickness);

        _cutout_square(x=square_x,y=square_y+base_deltay,z=square_z,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

        _cutout_rectangle(x=rectangle_x,y=rectangle_y+base_deltay,z=rectangle_z,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

        _cutout_rhombus(x=rhombus_x,y=rhombus_y+base_deltay,z=rhombus_z,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

        _cutout_circle(x=circle_x,y=circle_y+base_deltay,z=circle_z,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);
        
        _cutout_oval(x=oval_x,y=oval_y+base_deltay,z=oval_z,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

        _cutout_triangle(x=triangle_x,y=triangle_y+base_deltay,z=triangle_z,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);
        
        _cutout_pentagon(x=pentagon_x,y=pentagon_y+base_deltay,z=pentagon_z,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);
        
        _cutout_hexagon(x=hexagon_x,y=hexagon_y+base_deltay,z=hexagon_z,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

        _cutout_star(x=star_x,y=star_y+base_deltay,z=star_z,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border,points=star_points);

    }
}


if (do_base_square) {
    difference(){
        _square(x=base_x,y=base_y-base_deltay,z=base_z+piece_thickness-base_thickness,size=piece_total_size*1+piece_distance*base_grid_size-1+base_external_border,thickness=base_thickness);

        _cutout_square(x=base_x,y=base_y-base_deltay,z=base_x,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

    }
}

if (do_base_circle) {
    difference(){
        _square(x=base_x,y=base_y-base_deltay,z=base_z+piece_thickness-base_thickness,size=piece_total_size*1+piece_distance*base_grid_size-1+base_external_border,thickness=base_thickness);

        _cutout_circle(x=base_x,y=base_y-base_deltay,z=base_x,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

    }
}

if (do_base_oval) {
    difference(){
        _square(x=base_x,y=base_y-base_deltay,z=base_z+piece_thickness-base_thickness,size=piece_total_size*1+piece_distance*base_grid_size-1+base_external_border,thickness=base_thickness);

        _cutout_oval(x=base_x,y=base_y-base_deltay,z=base_x,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

    }
}

if (do_base_rectangle) {
    difference(){
        _square(x=base_x,y=base_y-base_deltay,z=base_z+piece_thickness-base_thickness,size=piece_total_size*1+piece_distance*base_grid_size-1+base_external_border,thickness=base_thickness);

        _cutout_rectangle(x=base_x,y=base_y-base_deltay,z=base_x,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

    }
}

if (do_base_rhombus) {
    difference(){
        _square(x=base_x,y=base_y-base_deltay,z=base_z+piece_thickness-base_thickness,size=piece_total_size*1+piece_distance*base_grid_size-1+base_external_border,thickness=base_thickness);

        _cutout_rhombus(x=base_x,y=base_y-base_deltay,z=base_x,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

    }
}



if (do_base_star) {
    difference(){
        _square(x=base_x,y=base_y-base_deltay,z=base_z+piece_thickness-base_thickness,size=piece_total_size*1+piece_distance*base_grid_size-1+base_external_border,thickness=base_thickness);

        _cutout_star(x=base_x,y=base_y-base_deltay,z=base_x,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border,points=star_points);

    }
}

if (do_base_hexagon) {
    difference(){
        _square(x=base_x,y=base_y-base_deltay,z=base_z+piece_thickness-base_thickness,size=piece_total_size*1+piece_distance*base_grid_size-1+base_external_border,thickness=base_thickness);

        _cutout_hexagon(x=base_x,y=base_y-base_deltay,z=base_x,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

    }
}

if (do_base_pentagon) {
    difference(){
        _square(x=base_x,y=base_y-base_deltay,z=base_z+piece_thickness-base_thickness,size=piece_total_size*1+piece_distance*base_grid_size-1+base_external_border,thickness=base_thickness);

        _cutout_pentagon(x=base_x,y=base_y-base_deltay,z=base_x,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

    }
}

if (do_base_triangle) {
    difference(){
        _square(x=base_x,y=base_y-base_deltay,z=base_z+piece_thickness-base_thickness,size=piece_total_size*1+piece_distance*base_grid_size-1+base_external_border,thickness=base_thickness);

        _cutout_triangle(x=base_x,y=base_y-base_deltay,z=base_x,size=piece_size,thickness=piece_thickness+_z_cutout,gap=piece_gap,border=piece_border);

    }
}




