function [R_cam, t_cam, cameraParams] = calib_robot()
    %% ucitavanje parametara iz file-a
    filename = 'camera_params.mat';
    loadedData = load(filename);
    cameraParams = loadedData.camera_params;

    imageFilePath = 'calib_bot/calib_bot0.png';
    % Load the image into a variable
    calib_img = imread(imageFilePath);
    squareSize=19.5;

    T_back = [0 -1 0 27;
         -1 0 0 316;
         0 0 1 0;
         0 0 0 1];

    T_front = [0 -1 0 27;
         -1 0 0 166;
         0 0 1 0;
         0 0 0 1];

    [img_undist, ~] = undistortImage(calib_img,cameraParams,'OutputView','full'); %undestort image
    [imagePoints,boardSize] = detectCheckerboardPoints(img_undist); %get points of patern
    worldPoints = generateCheckerboardPoints(boardSize, squareSize);
    [R_cam, t_cam] = extrinsics(imagePoints, worldPoints, cameraParams);
    worldPoints3D = [worldPoints, zeros(size(worldPoints, 1), 1)];
    homogeneousWorldPoints = [worldPoints3D, ones(size(worldPoints3D, 1), 1)];
    transformedHomogeneousPoints = (T_front * homogeneousWorldPoints')';
    transformedWorldPoints = transformedHomogeneousPoints(:, 1:3);
    transformedImagePoints = worldToImage(cameraParams, R_cam, t_cam, transformedWorldPoints);
    transformedWorldPoints = transformedWorldPoints(:, 1:2);
    [R_cam, t_cam] = extrinsics(transformedImagePoints, transformedWorldPoints, cameraParams);
    
    
    
    %Show maping of Points
    figure;
    imshow(img_undist); hold on;
    plot(imagePoints(1, 1), imagePoints(1, 2), 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'yellow', 'LineWidth', 2);
    plot(transformedImagePoints(1, 1), transformedImagePoints(1, 2), 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'yellow', 'LineWidth', 2);
    plot(imagePoints(:, 1), imagePoints(:, 2), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
    plot(transformedImagePoints(:, 1), transformedImagePoints(:, 2), 'bx', 'MarkerSize', 10, 'LineWidth', 2);
    title('Detected Checkerboard Points and Transformed Points');
    legend('Detected Points', 'Transformed Points');
    hold off;
end