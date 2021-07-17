in=25.4;
pad=0.1;
$fn=200; // how round things are 

ruler_thickness=3;
ruler_height=41.3;

bit=in/4;
hole=in/8; // how deep to lock into the calibration hole 

wall=ruler_thickness; // thickness of sides
top_wall=0.5; // thickness of top

end_r=80; // how long the end piece is
length=end_r;

vernier_gap=5; // rough gap of vernier lines
vernier=vernier_gap-1/10; // actual gap

text_gap=1.5; // space above and below text
scale_h=5; // how high the vernier scale is

text_size=vernier_gap*0.7; 
zero_size=text_size;  // zero can be made bigger


body=scale_h+text_gap*2+text_size;  // thickness of protractor

scale_depth=0.9;  // how deep vernier lines are

window=50;  // diamter of window exposing window on end

od=vernier*22; // outer diamter of protractor
bump=vernier;  // center bump below zero 

legend_depth=top_wall/3*2;  // depth of inner and outer legends

// RENDER png
module end(offset=0) {
    intersection() {
        difference() {
            cube([length+wall,ruler_height+wall*2,ruler_thickness+top_wall]);

            translate([wall,wall,-wall])
            cube([length+wall,ruler_height,ruler_thickness+wall]);

            intersection() {
                translate([0,0,ruler_thickness-pad])
                cylinder(d=window,h=wall+pad*2);

                translate([wall,wall,0])
                cube([length+wall,ruler_height,ruler_thickness+wall]);
            }

            translate([window/2+(end_r-window/2)/2,ruler_height/2+wall,ruler_thickness+top_wall-legend_depth])
            scale([3,3,1])
            linear_extrude(height=wall) 
            legend(-offset);
        }
        cylinder(r=end_r,h=wall+ruler_thickness+pad*2);
    }

    translate([wall-offset,wall-bit/2,-hole])
    cylinder(d=bit,h=ruler_thickness+hole+top_wall);

}

module ruler(line, gap, count, height) {
    for(x=[0:gap:gap*count])
    translate([x,height/2])
    square([line, height],center=true);
}

module test_rule() {
    color("dimgray")
    linear_extrude(0.0001)
    *ruler(0.2, 1, 100, 5);
}

module vernier() {
    translate([0,-scale_h])
    ruler(0.2, vernier, 10, scale_h+pad);
    numbers=["", "1", "2", "3", "4", "5", "6", "7", "8", "9", ""];

    for(n=[0:1:len(numbers)])
    translate([vernier*n,-scale_h-text_gap-(zero_size-text_size)/2])
    text(numbers[n], valign="top", halign="center", size=text_size);
}

module vernier_end(offset=0) {
    translate([offset,-bit/2,-hole])
    cylinder(d=bit,h=hole);
    difference() {
        cylinder(d=od,h=ruler_thickness);

        translate([-od/2,0,-pad])
        cube([od, od, ruler_thickness+pad*2]);

        translate([0,0,ruler_thickness-legend_depth])
        linear_extrude(height=wall) 
        translate([0,-od/2+body/2])
        legend(offset);

        difference() {
            translate([0,0,-pad])
            cylinder(d=od-body*2,h=ruler_thickness+pad*2);

            translate([-od/2,-body,-pad])
            cube([od, od, ruler_thickness+pad*2]);

            // center on text zero
            translate([0,-body+text_gap+zero_size/2])
            cylinder(r=bump,h=ruler_thickness+pad*2);

        }

        translate([0,0,ruler_thickness-scale_depth])
        linear_extrude(height=wall) {
            translate([-vernier*10,0])
            vernier();
            vernier();

            translate([0,-scale_h-text_gap])
            text("0", valign="top", halign="center", size=zero_size);
        }

        translate([vernier*12+window/2,-body/2,-pad])
        cylinder(d=window,h=ruler_thickness+pad*2);
    }
}

// RENDER png
module legend(pos=0) {
    size=8;
    line=size/10;

    module side() {
        // if these touch it breads stuff
        translate([size/2+line/2+0.01,0])
        square([line,size],center=true);
    }
    
    if(pos!=0) {
        difference() {
            circle(d=size);
            circle(d=size-line*2);
        }
        if(pos<0)
        side();

        if(pos>0)
        mirror([1,0])
        side();
    }

    // if(pos==0)
    // circle(d=line*2);
}



center=0;
inner=bit/2;
outer=-bit/2;

translate([0,length/2])
end();

vernier_end();


module printable_protractor(pos) {
    rotate([180,0,45])
    vernier_end(pos);
}

module printable_end(pos) {
    rotate([180,0,0])
    end(pos);
}

// RENDER stl
// RENDER scad
module center_protractor() {
    printable_protractor(center);
}

// RENDER stl
// RENDER scad
module inner_protractor() {
    printable_protractor(inner);
}

// RENDER stl
// RENDER scad
module outer_protractor() {
    printable_protractor(outer);
}


// RENDER stl
// RENDER scad
module center_end() {
    printable_end(center);
}

// RENDER stl
// RENDER scad
module inner_end() {
    printable_end(inner);
}

// RENDER stl
// RENDER scad
module outer_end() {
    printable_end(outer);
}
