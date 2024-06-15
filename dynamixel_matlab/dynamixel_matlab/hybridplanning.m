%State space
ss = stateSpaceSE2;

%Validator
sv = validatorOccupancyMap(ss);

% Učitajte sliku
bw_image = imread('map2.pgm');

% Pretvaranje slike u binarnu matricu
binary_map = imbinarize(bw_image);

% Proširivanje prepreka
se = strel('disk', 20);
inflated_map = imdilate(binary_map, se);

% Kreiranje occupancyMap objekta
map = occupancyMap(inflated_map);

sv.Map = map;
sv.ValidationDistance = 0.01;
ss.StateBounds = [map.XWorldLimits;map.YWorldLimits;[-pi pi]];

%Odabir koordinata
show(map);
[x, y] = ginput(2);
start = [x(1) y(1) 0];
goal = [x(2) y(2) 0];



% Kreiranje A* planera
planner = plannerHybridAStar(sv, ...
                             MinTurningRadius=40, ...
                             MotionPrimitiveLength=30);

[pthObj,solnInfo] = plan(planner,start,goal, SearchMode='greedy');

show(dummy)
hold on
% Draw path
plot(pthObj.States(:,1),pthObj.States(:,2),'r-','LineWidth',2)
hold off;




