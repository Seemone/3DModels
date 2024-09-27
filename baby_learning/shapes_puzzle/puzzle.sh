#!/bin/bash

function main 
{
    OSCADBIN=/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD
    puzzle=${1:-puzzle.scad}; shift
    fa=1
    fs=0.4
    
    mainelements="circle square oval rectangle rhombus triangle pentagon hexagon star circle_border square_border oval_border rectangle_border rhombus_border triangle_border pentagon_border star_border hexagon_border base base_star"
    testelements="base_circle base_square base_oval base_rectangle base_rhombus base_triangle base_pentagon base_hexagon base_star"
    
    for element in $mainelements; do
        render $element
    done
    
    for element in $testelements; do
        render $element
    done

}

function round()
{
    echo $(printf %.$2f $(echo "scale=$2;(((10^$2)*$1)+0.5)/(10^$2)" | bc))
}


function render
{
    element=$1
    echo -n "Rendering ${element}: " 
    start=$(perl -MTime::HiRes=time -e 'printf "%.9f\n", time')
    out=$($OSCADBIN -D do_"${element}"=true -D default_render=false -D _default_fa=$fa -D _default_fs=$fs -o ${element}.stl "${puzzle}" 2>&1)
    ret=$?
    end=$(perl -MTime::HiRes=time -e 'printf "%.9f\n", time')
    if [[ $ret -eq 0 ]]; then
        ret="OK"
    else
        ret="ERROR"
    fi
    runtime=$( echo "$end - $start" | bc -l )
    simple=$(echo "$out"|grep Simple:|awk '{print $2}')
    echo $ret Simple: $simple Duration: $(round $runtime 2)s
}



main "$@"