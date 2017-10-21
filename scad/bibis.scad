$fn=96;
difference() {
    union() {
        translate([-1.2, -1, 0]) {
            sphere(2);
        }
        translate([1.2, -1, 0]) {
            sphere(2);
        }
        rotate([-90, 0, 0]) {
            cylinder(h=8, r=1.2);
        }
        rotate([-90, 0, 0]) {
            translate([0, 0, 8]) {
                cylinder(h=1.5, r1=1.5, r2=0.5);
            }
            translate([0, 0, 7.8]) {
                cylinder(h=0.2, r=1.5);
            }
        }
    }
    translate([-4, -10, -2.5]) {
        cube([8, 20, 2]);
    }
}