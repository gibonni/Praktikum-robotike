%% postavljanje parametara kamere
camera_info = imaqhwinfo('winvideo');
device_id=camera_info.DeviceIDs{2};
defaultFormat = camera_info.DeviceInfo(2).DefaultFormat;
video_obj = videoinput('winvideo', device_id, defaultFormat);
%% ucitavanje parametara iz file-a
filename = 'intrinsic_matrix.mat';
loadedData = load(filename);
intrinsicMatrix = loadedData.intrinsicMatrix;
filename = 'camera_params.mat';
loadedData = load(filename);
cameraParams = loadedData.camera_params;

%% dobivanje jedne slike
folder = 'calib_bot'; % Folder za slike
if ~exist(folder, 'dir')
   mkdir(folder); 
end

video_obj.ReturnedColorSpace = 'rgb';
f = figure('Visible', 'off'); 
vidRes = video_obj.VideoResolution;
imageRes = fliplr(vidRes);
hImage = imshow(zeros(imageRes));

preview(video_obj, hImage);
waitforbuttonpress;
stoppreview(video_obj);

start(video_obj);
img = getdata(video_obj);
img = img(:, :, (1:3));
filename = fullfile(folder, strcat('calib_bot', num2str(0), '.png'));
imwrite(img, filename)
stop(video_obj);

%% odredivanje prostora kamere
imageFilePath = 'calib_bot/calib_bot0.png';
% Load the image into a variable
calib_img = imread(imageFilePath);
[img_undist,newOrigin] = undistortImage(calib_img,cameraParams,'OutputView','full'); %undestort image
[imagePoints,boardSize] = detectCheckerboardPoints(img_undist); %get points of patern
squareSize = 18.5; % squer size on patern
checkerboard_points = generateCheckerboardPoints(boardSize, squareSize); 
checkerboard_points_h = [checkerboard_points zeros(size(checkerboard_points,1),1) ones(size(checkerboard_points,1),1)];
% measure the pose of the pattern in the frame {R} % nedes to be calculated
T_cam_robot = [1 0 0 -43;
     0 -1 0 103.5;
     0 0 -1 0;
     0 0 0 1];
worldPoints = transpose(T_cam_robot*transpose(checkerboard_points_h));
worldPoints = worldPoints(:,1:2);
[R, t] = extrinsics(imagePoints, worldPoints, cameraParams);
[camera_orientation, camera_location] = extrinsicsToCameraPose(R, t); %camera orijentation and location in respect to robot

T_robot_cam = [camera_orientation, camera_location'; 0 0 0 1];
T_cam_robot = inv(T_robot_cam); % transformacija iz kamere u prostor robota

%% Example of getting cordinate from detected object in camera to Robots cordinates
%red dot position in robat cords
detect_example=imread('calib_bot\calib_bot0.png');
red_channel = detect_example(:,:,1); % Red channel
green_channel = detect_example(:,:,2); % Green channel
blue_channel = detect_example(:,:,3); % Blue channel
red_dot= red_channel>100 & blue_channel < 80 & green_channel <80;
se = strel('disk', 10);
red_dot = imclose(red_dot, se);
cc = bwconncomp(red_dot);
props = regionprops(cc, 'Area');
[~, idx] = max([props.Area]);
red_dot_largest = zeros(size(red_dot));
red_dot_largest(cc.PixelIdxList{idx}) = 1;
%imshow(red_dot_largest); %detected dot
props_largest = regionprops(red_dot_largest, 'Centroid');
centroid = props_largest.Centroid;

%Geting position in robot frame of reds dot centroid
x_dot = centroid(1);
y_dot = centroid(2);
normalized_cam_cord = inv(intrinsicMatrix) * [x_dot; y_dot; 1];
% Ensure normalized_cam_cord is a column vector
if size(normalized_cam_cord, 2) > 1
    normalized_cam_cord = normalized_cam_cord';
end
normalized_cam_cord = [normalized_cam_cord; 1];
dot_cords = T_robot_cam * normalized_cam_cord;
dot_cords
