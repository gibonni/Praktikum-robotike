function [x_path, y_path] = dump_points(x_points, y_points, n, R_cam, t_cam)

    numPoints = length(x_points);

    indices = 1:n:numPoints;

    if indices(end) ~= numPoints
        indices = [indices, numPoints];
    end

    % Initialize paths
    x_path = zeros(1, length(indices));
    y_path = zeros(1, length(indices));

    for i = 1:length(indices)
        index = indices(i);
        [x_path(i), y_path(i)] = localise(x_points(index), y_points(index), R_cam, t_cam);
    end

end
