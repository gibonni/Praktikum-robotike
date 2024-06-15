function [x_wor,y_wor] = localise(x_pix,y_pix, R_cam, t_cam)

    T_front = [0 -1 0 27;
         -1 0 0 316;
         0 0 1 0;
         0 0 0 1];
    
    filename = 'camera_params.mat';
    loadedData = load(filename);
    cameraParams = loadedData.camera_params;
    %x_pix = 481;
    %y_pix = 452;
    worldCoords = pointsToWorld(cameraParams, R_cam, t_cam, [x_pix, y_pix]);
    x_wor = worldCoords(1);
    y_wor = worldCoords(2);
    h_worldCoords = T_front\[x_wor; y_wor; 0; 1];
    x_wor = h_worldCoords(1);
    y_wor = h_worldCoords(2);
    disp(['World coordinates (x_wor, y_wor): ', num2str(x_wor), ', ', num2str(y_wor)]);
end