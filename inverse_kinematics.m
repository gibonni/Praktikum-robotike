syms theta;

Xrot = [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];
Yrot = [cos(theta) 0 sin(theta); 0 1 0; -sin(theta) 0 cos(theta)];
Zrot = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
%x os ide od sredine prema gore u pozitvnom smjeru
%y os ide od sredine prema lijevo u pozitvnom smjeru
%z os ide u zrak pozitivno
syms theta1 theta2 theta3
a1 = 42;        %visina sredista prvog motora
a2 = 148;       %duljina prvog linka
a3 = 19.25;     %visina sredista drugog motora u odnosu na prvi
a4 = 152;       %duljina drugog linka
a5 = 25;        %spustanje u srediste treceg motora u odnosu na drugi
a6 = 69;        %duljina zadnjeg linka
a7 = 72.75;     %duljina olovke od papira do srednje reda kruzica
a8 = 5;         %radijus olovke
x1 = 50.404;    %offset sredista prvog motora
z1 = 50;        %offset sredista prvog motora

H1 = [eye(3) [x1;0;z1]; 0 0 0 1];
H2 = [subs(Zrot, theta, theta1) [a2*cos(theta1);a2*sin(theta1); a1]; 0 0 0 1];
H3 = [cos(theta2) 0 sin(theta2) a4*cos(theta2); sin(theta2) 0 -cos(theta2) a4*sin(theta2);
    0 1 0 -a3; 0 0 0 1];
H4 = [subs(Zrot, theta, theta3) [a6*cos(theta3); a6*sin(theta3); -a5]; 0 0 0 1];
H5 = [eye(3) [0;-a7;-a8]; 0 0 0 1];

FK=H1*H2*H3*H4*H5;

% Desired position
xd = 200; % example values
yd = 150;
zd = 291/4;

% Extract position from FK matrix
px = FK(1, 4);
py = FK(2, 4);
pz = FK(3, 4);

%disp(px)
%disp(py)
%disp(pz)

% Set up inverse kinematics equations
eq1 = px == xd;
eq2 = py == yd;
eq3 = pz == zd;

% Solve equations for joint angles
sol = solve([eq1, eq2, eq3], [theta1, theta2, theta3], 'Real', true);

% Convert solutions from radians to degrees if real solutions exist
if ~isempty(sol.theta1) && ~isempty(sol.theta2) && ~isempty(sol.theta3)
    theta1_sol = rad2deg(double(sol.theta1));
    theta2_sol = rad2deg(double(sol.theta2));
    theta3_sol = rad2deg(double(sol.theta3));

    % Display solutions in degrees
    disp(theta1_sol);
    disp(theta2_sol);
    disp(theta3_sol);
else
    disp('No real solutions found.');
end