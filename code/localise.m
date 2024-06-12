function [x,y] = localise(x_pix,y_pix, R_cam, t_cam)
    filename = 'camera_params.mat';
    loadedData = load(filename);
    cameraParams = loadedData.camera_params;
    u = x_pix;
    v = y_pix;
    world_coordinates = pointsToWorld(cameraParams.Intrinsics, R_cam, t_cam, [u, v]);
    x= world_coordinates(1);
    y= world_coordinates(2);
end