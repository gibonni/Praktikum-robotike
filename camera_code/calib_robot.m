function [R_cam, t_cam, camPose, cameraParams] = calib_robot(calib_img)
    %% ucitavanje parametara iz file-a
    filename = 'camera_params.mat';
    loadedData = load(filename);
    cameraParams = loadedData.camera_params;
    
    %% odredivanje prostora kamere
    intrinsics = cameraParams.Intrinsics;
    [img_undist,newIntrinsics] = undistortImage(calib_img,cameraParams,'OutputView','full'); %undestort image
    %imshow(img_undist);
    [imagePoints,boardSize] = detectCheckerboardPoints(img_undist); %get points of patern
    newOrigin = intrinsics.PrincipalPoint - newIntrinsics.PrincipalPoint; % compensate for shift from undistort
    imagePoints = imagePoints+newOrigin;
    squareSize = 18.5; % squer size on patern
    checkerboard_points = generateCheckerboardPoints(boardSize, squareSize); 
    checkerboard_points_h = [checkerboard_points zeros(size(checkerboard_points,1),1) ones(size(checkerboard_points,1),1)];
    % measure the pose of the pattern in the frame {R} % nedes to be calculated
    T = [0 -1 0 17;
         -1 0 0 306;
         0 0 1 0;
         0 0 0 1];
    worldPoints = transpose(T*transpose(checkerboard_points_h));
    worldPoints = worldPoints(:,1:2);
    camExtrinsics = estimateExtrinsics(imagePoints, worldPoints, newIntrinsics);
    camPose = extr2pose(camExtrinsics);
    t_cam = camPose.Translation;% 170, -23
    R_cam = camPose.Rotation;
end