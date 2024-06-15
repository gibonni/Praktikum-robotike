function [x_path, y_path] = plan_path(image, centers_x, centers_y)

    %bw_image = rgb2gray(image);
    bw_image = imcomplement(image);

    % Pretvaranje slike u binarnu matricu
    binary_map = imbinarize(bw_image);

    % Proširivanje prepreka
    se = strel('disk', 15);
    inflated_map = imdilate(binary_map, se);

    % Kreiranje occupancyMap objekta
    map = occupancyMap(inflated_map);
    %dummy = occupancyMap(binary_map);
    [r, ~,~] = size(binary_map);
    start = [(r-double(centers_y(1))) (double(centers_x(1)))];
    goal = [(r-double(centers_y(2))) (double(centers_x(2)))];


    % Kreiranje A* planera
    planner = plannerAStarGrid(map);

    [pthObj,~] = plan(planner,start,goal);

    %Koordinate putanje u okviru slike
    x_path = pthObj(:,2);
    y_path = - (pthObj(:,1) - r(1));


end