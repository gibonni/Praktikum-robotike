function [x, y, z] = direct_kinematics(th1, th2, th3)
    % Define the robot parameters
    a1 = 42;        % Height of the center of the first motor
    a2 = 148;       % Length of the first link
    a3 = 19.25;     % Height of the center of the second motor relative to the first
    a4 = 152;       % Length of the second link
    a5 = 25;        % Lowering to the center of the third motor relative to the second
    a6 = 69;        % Length of the rear link
    a7 = 72.75;     % Length of the pencil from paper to the middle row of circles
    a8 = 5;         % Pencil radius
    x1 = 50.404;    % Offset of the center of the first motor
    z1 = 50;        % Offset of the center of the first motor

    % Convert angles from degrees to radians
    theta1 = th1 * pi / 180;
    theta2 = th2 * pi / 180;
    theta3 = th3 * pi / 180;

    % Define the rotation matrices
    Zrot1 = [cos(theta1) -sin(theta1) 0; sin(theta1) cos(theta1) 0; 0 0 1];
    Zrot3 = [cos(theta3) -sin(theta3) 0; sin(theta3) cos(theta3) 0; 0 0 1];

    % Define the homogeneous transformation matrices
    H1 = [eye(3) [x1;0;z1]; 0 0 0 1];
    H2 = [Zrot1 [a2*cos(theta1); a2*sin(theta1); a1]; 0 0 0 1];
    H3 = [cos(theta2) 0 sin(theta2) a4*cos(theta2); sin(theta2) 0 -cos(theta2) a4*sin(theta2); 0 1 0 -a3; 0 0 0 1];
    H4 = [Zrot3 [a6*cos(theta3); a6*sin(theta3); -a5]; 0 0 0 1];
    H5 = [eye(3) [0;-a7;-a8]; 0 0 0 1];

    % Compute the forward kinematics
    FK = H1 * H2 * H3 * H4 * H5;

    % Extract the position
    x = FK(1,4);
    y = FK(2,4);
    z = FK(3,4);
end
