function [theta1, theta2, theta3] = solve_thetas(x, y, z)
    % Check if the variables x, y, z exist in the workspace
    %if evalin('base', 'exist(''x'', ''var'') && exist(''y'', ''var'') && exist(''z'', ''var'')')
        % Get the values of x, y, z from the workspace
        %x = evalin('base', 'x');
        %y = evalin('base', 'y');
        %z = evalin('base', 'z');
    %else
       % error('Variables x, y, z must be defined in the workspace.');
    %end

    % Initial guess for theta1, theta2, theta3
    initial_guess = [0, 0, 0];

    % Solve the system of equations
    options = optimset('Display', 'iter');
    solution = fsolve(@(vars) equations(vars, x, y, z), initial_guess, options);

    % Convert the solutions to degrees
    theta1 = wrapTo180(rad2deg(solution(1)));
    theta2 = wrapTo180(rad2deg(solution(2)));
    theta3 = wrapTo180(rad2deg(solution(3)));

    % Wrap the angles to the range [-180, 180]
    theta1 = wrapTo180(theta1);
    theta2 = wrapTo180(theta2);
    theta3 = wrapTo180(theta3);

    % Display the solutions in degrees
    %fprintf('Solutions: theta1 = %.4f degrees, theta2 = %.4f degrees, theta3 = %.4f degrees\n', theta1, theta2, theta3);
end

function F = equations(vars, x, y, z)
    theta1 = vars(1);
    theta2 = vars(2);
    theta3 = vars(3);

    eq1 = 148 * cos(theta1) ...
        + 152 * cos(theta1) * cos(theta2) ...
        - 30 * cos(theta1) * sin(theta2) ...
        - 30 * cos(theta2) * sin(theta1) ...
        - 152 * sin(theta1) * sin(theta2) ...
        + 69 * cos(theta3) * (cos(theta1) * cos(theta2) - sin(theta1) * sin(theta2)) ...
        + (291 / 4) * sin(theta3) * (cos(theta1) * cos(theta2) - sin(theta1) * sin(theta2)) ...
        + 12601 / 250 ...
        - x;

    eq2 = 148 * sin(theta1) ...
        + 30 * cos(theta1) * cos(theta2) ...
        + 152 * cos(theta1) * sin(theta2) ...
        + 152 * cos(theta2) * sin(theta1) ...
        - 30 * sin(theta1) * sin(theta2) ...
        + 69 * cos(theta3) * (cos(theta1) * sin(theta2) + cos(theta2) * sin(theta1)) ...
        + (291 / 4) * sin(theta3) * (cos(theta1) * sin(theta2) + cos(theta2) * sin(theta1)) ...
        - y;

    eq3 = 69 * sin(theta3) ...
        - (291 / 4) * cos(theta3) ...
        + 291 / 4 ...
        - z;

    F = [eq1; eq2; eq3];
end

function angle = wrapTo180(angle)
    % Wraps angles to the range [-180, 180]
    angle = mod(angle + 180, 360) - 180;
end
