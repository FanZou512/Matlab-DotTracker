
function freeCon = int_con_conversion2(bkgIntensity_cell,autoFluo)

saturatingCopy = 288; % max # of proteins bound to the dot
saturatingInt = 20250; % saturating intensity of the dot 32 Osys

p = 0.06; % 1 pixel equal 0.06um, 100X
%DOF = 0.6; % depth of focus, 0.6um, 100X
DOF = 1.6;
areaR = p^2; % actual area for 1 pixel in um^2

freeCon = [];

temp = saturatingCopy*(bkgIntensity_cell-autoFluo)/saturatingInt/DOF/areaR;
freeCon = temp*1e24/6.02e23; % concentration in nM

