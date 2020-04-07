//
// Hugomatic
//
// On ubuntu, the convert utility 
// allows to create animated gifs from png files
// convert -delay 10 -loop 0 frame*.png jansen_solver.gif
// 
// check for empty frames before creating animation!
//

include <x_pin.scad>

$fn = 60;

// size variables
leg_w = 3;
layer_h = 2;
leg_clear = 0.2;	
rad_clear = leg_clear;
knee_rad = 4.5;
pin_rad = 3;


scale = 0.75;

// the link geometry
// http://www.strandbeest.com/beests_leg.php
a = 38 * scale;
b = 41.5 * scale;
c = 39.3 * scale;
d = 40.1 * scale;
e = 55.8 * scale;
f = 39.4 * scale;
g = 36.7 * scale;
h = 65.7 * scale;
i = 49 * scale;
j = 50 * scale;
k = 61.9 * scale;
l = 7.8 * scale;
m = 15 * scale;


// Theo crank_angle= 90
A = [-46.735652302443299 * scale, 32.770166118107248 * scale];
B = [0, 15.0 * scale];
C = [0.0, 0.0];
D = [-77.667791263174934 * scale, -13.671655328881542 * scale];
E = [-38.0 * scale, -7.7999999999999998 * scale];
EC = [0.0 * scale, -7.7999999999999998 * scale];
F = [-57.44759936753168 * scale, -47.487388940668879 * scale];
G = [-20.995300642707395 * scale, -43.230639279698188 * scale];
H = [-7.6890662306416502 * scale, -90.389351367404288 * scale];



module pin (p, start_layer, end_layer)
{

	leg_h = layer_h	- leg_clear;
	translate ([p[0], p[1], -leg_h/2])
	{
		multi_layer_pin(start_layer, end_layer, layer_h=layer_h, clear = leg_clear, joint_radius=knee_rad);
	}
	
}

module leg(a, b, layer)
{
	leg_h = layer_h	- leg_clear;
	z = layer * layer_h;
	
	link(a, b, z, layer_h= layer_h, leg_w=leg_w, clear = leg_clear, joint_radius = knee_rad);
}



module jansen()
{
	// frame
	leg(E, C, layer=  0);

	// crank
	leg(C, B, layer= 1);

	// stuff
	leg(B, A, layer= 2);  // j
	leg(G, B, layer= 3); // k

	// triangle ebd [AED]
	leg(E,  A, layer= 1);
	leg(E,  D, layer= 1);
	leg(A,  D, layer= 1);

	// trapez
	leg(E,  G, layer=  2);
	leg(D,  F, layer= 2);

	// triangle ghi [FGH]
	leg(F,G, layer= 1);
	leg(G,H, layer= 1);
	leg(F,H, layer= 1);
	
	
}

module jansen_with_pins()
{

jansen();

pin(C, 0, 1);
pin(B, 1, 4); 
pin(A, 1, 2);
pin(E, 0, 2);
pin(D, 1,2);
pin(F,1,2);
pin(G,1,3);

}

// this is where 2 legs are connected
// in a hurry
dx = 8;
TIP = [0,25];  // some point in the middle
LEFT =[-dx,0]; // left leg crank center
RIGTH = [dx,0]; // right leg crank center

// left leg crank
BB = [B[0]-dx, B[1]];
// right side crank
BBB = [-BB[0], B[1]];


// skeleton that joins the 2 legs
leg(BB, BBB, layer=4  );
leg(LEFT, TIP, layer=0);
leg(RIGTH, TIP, layer=0);
leg(RIGTH, LEFT, layer=0);



// a complete leg, offset to the left by dx
translate([-dx,0,0]) jansen_with_pins();
// another leg, the mirror image of the first one, offset to the right by dx
translate([dx,0,0]) mirror([1,0,0]) jansen_with_pins();





