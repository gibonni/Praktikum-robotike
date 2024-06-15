% Učitajte sliku
bw_image = imread('map2.pgm');

% Pretvaranje slike u binarnu matricu
binary_map = imbinarize(bw_image);

% Proširivanje prepreka
se = strel('disk', 10);
inflated_map = imdilate(binary_map, se);

% Kreiranje occupancyMap objekta
map = occupancyMap(inflated_map);


%Odabir koordinata
show(map);
[x, y] = ginput(2);
[r, c, numberOfColorChannels] = size(binary_map);

% Prebacivanje koordinata u koordinate plannera 
% (drugačije se gleda nego kod odabira točaka)
start = [(r-floor(y(1))) (floor(x(1)))];
goal = [(r-floor(y(2))) (floor(x(2)))];


% Kreiranje A* planera
planner = plannerAStarGrid(map);

[pthObj,solnInfo] = plan(planner,start,goal);

%Koordinate putanje u okviru slike
x_show = pthObj(:,2);
y_show = - (pthObj(:,1) - r(1));


show(map);
hold on;
plot(x_show,y_show, 'r-','LineWidth',2);
hold off;

