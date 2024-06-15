function [R_cam, t_cam, camPose, cameraParams, newIntrinsics] = calib_robot()
    %% ucitavanje parametara iz file-a
    filename = 'camera_params.mat';
    loadedData = load(filename);
    cameraParams = loadedData.camera_params;

    imageFilePath = 'calib_bot/calib_bot0.png';
    % Load the image into a variable
    calib_img = imread(imageFilePath);
    
    %% odredivanje prostora kamere
    intrinsics = cameraParams.Intrinsics;
    [img_undist, newOrigin] = undistortImage(calib_img,cameraParams,'OutputView','full'); %undestort image
    %imshow(img_undist);
    %newIntrinsics = cameraParams.Intrinsics;
    [imagePoints,boardSize] = detectCheckerboardPoints(img_undist); %get points of patern
    imagePoints = imagePoints+newOrigin;
    squareSize = 19.5; % squer size on patern
    checkerboard_points = generateCheckerboardPoints(boardSize, squareSize); 
    checkerboard_points_h = [checkerboard_points zeros(size(checkerboard_points,1),1) ones(size(checkerboard_points,1),1)];
    % measure the pose of the pattern in the frame {R} % nedes to be calculated
    T = [0 -1 0 27;
         -1 0 0 318;
         0 0 1 0;
         0 0 0 1];
    worldPoints = transpose(T*transpose(checkerboard_points_h));
    worldPoints = worldPoints(:,1:2);
    camExtrinsics = estimateExtrinsics(imagePoints, worldPoints, intrinsics);
    camPose = extr2pose(camExtrinsics);
    t_cam = camPose.Translation;% 170, -23
    R_cam = camPose.Rotation;
end