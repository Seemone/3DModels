// a cart coin with name
// requires https://github.com/BelfrySCAD/BOSL2

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/* [Coin] */

coin_diameter = 24;
coin_thickness= 2.4;

/* [Keychain] */

keychain_hole_diameter = 7.5;

keychain_border_width = 2;
keychain_coin_border_width = 2;

keychain_lower_lip_thickness = 2;
keychain_lower_lip_width = 2;
keychain_upper_lip_thickness = 1;
keychain_upper_lip_width = 1;

/* [Mark] */

text = "Name here";

/* [Tolerances] */

coin_tolerance = 0.2;
extrude_cyls = 30; // design quality
// extrude_cyls = 150; // final_quality

/* [Components] */

show_coin = true;
show_keychain = true;
show_mark = true;

module coin(diameter, thickness)
{
    cyl(d=diameter, height=thickness, anchor=BOTTOM);
}

module keychain2(coin_diameter, coin_thickness,keychain_coin_border_width, keychain_border_width,lower_lip_thickness, lower_lip_width, upper_lip_thickness, upper_lip_width, keychain_hole_diameter, aperture_degrees, aperture_degrees2, tolerance, n=300)
{
    outside_diameter = coin_diameter + tolerance + keychain_coin_border_width*2;
    total_thickness = lower_lip_thickness + coin_thickness + tolerance + upper_lip_thickness;
    echo(total_thickness);
    start_angle = aperture_degrees/2;
    end_angle = 360 - start_angle;
    start_angle2 = aperture_degrees2/2;
    end_angle2 = 360 - start_angle2;

    lower_lip_diameter = outside_diameter - keychain_coin_border_width*2 - keychain_lower_lip_width*2;
    upper_lip_diameter = outside_diameter - keychain_coin_border_width*2 - keychain_upper_lip_width*2;
    translate([0,0,lower_lip_thickness])
    {
        // lower lip
        extrude_cylinder_on_arc((outside_diameter-(lower_lip_width*2+keychain_coin_border_width*2)/2)/2, lower_lip_thickness, start_angle, end_angle,(lower_lip_width+keychain_coin_border_width)/2, n, anchor=TOP);
        // coin shaped hole
        extrude_cylinder_on_arc((outside_diameter-keychain_coin_border_width)/2, coin_thickness+tolerance, start_angle2, end_angle2, keychain_coin_border_width/2, n, anchor=BOTTOM);
        // upper lip
        translate([0,0,coin_thickness+tolerance])
            extrude_cylinder_on_arc((outside_diameter-(upper_lip_width*2+keychain_coin_border_width*2)/2)/2, upper_lip_thickness, start_angle2, end_angle2,(upper_lip_width+keychain_coin_border_width)/2, n, anchor=BOTTOM);
    }
        difference()
        {
            translate([-outside_diameter/2-keychain_hole_diameter/2,0,(lower_lip_thickness+upper_lip_thickness+coin_thickness+tolerance)/2])
            {
                difference()
                {
                    cyl(d=keychain_hole_diameter+keychain_border_width*2,h=lower_lip_thickness+upper_lip_thickness+coin_thickness+tolerance);
                    cyl(d=keychain_hole_diameter,h=lower_lip_thickness+upper_lip_thickness+coin_thickness+tolerance+2);
                }
            }
            translate([-coin_diameter*0.95,0,2])
                rotate([90,0,0])
                    cyl(d=(keychain_hole_diameter+keychain_border_width*2)*2,h=coin_diameter,anchor=FRONT);
        }
}

module extrude_cylinder_on_arc(r, h, start_angle, end_angle, cyl_radius, segments, anchor=CENTER) {
    angle_step = (end_angle - start_angle) / segments;
    for (i = [0 : segments]) {
        angle = start_angle + i * angle_step;
        x = r * cos(angle);
        y = r * sin(angle);
        translate([x, y, 0]) {
            rotate([0, 0, angle])  // Rotate to align with the circular path
            cyl(h=h, r=cyl_radius,anchor=anchor);
        }
    }
}
$fn=300;

pos_x=0;
pos_y=0;
pos_z=0;

translate([pos_x+coin_diameter,pos_y,pos_z])
    if(show_coin)
        coin(coin_diameter,coin_thickness);

translate([pos_x,pos_y,pos_z])
    if (show_keychain)
        keychain2(coin_diameter,coin_thickness,keychain_coin_border_width,keychain_border_width,keychain_lower_lip_thickness,keychain_lower_lip_thickness,keychain_upper_lip_thickness,keychain_upper_lip_width,keychain_hole_diameter,120,150,coin_tolerance,n=extrude_cyls);
