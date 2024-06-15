%% postavljanje parametara kamere
camera_info = imaqhwinfo('winvideo');
device_id=camera_info.DeviceIDs{1};
defaultFormat = camera_info.DeviceInfo(1).DefaultFormat;
video_obj = videoinput('winvideo', device_id, defaultFormat);
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
%imageFilePath = 'calib_bot/calib_bot0.png';
% Load the image into a variable
%calib_img = imread(imageFilePath);
[R_cam, t_cam,cameraParams]=calib_robot();
%% Example of getting cordinate from detected object in camera to Robots cordinates
%red dot position in robat cords
%detect_example=imread('calib_bot\calib_bot0.png');
detect_example=imread('calib_bot\calib_bot0.png');
[detect_example,newOrigin] = undistortImage(detect_example,cameraParams,'OutputView','full'); %undestort image
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
imshow(red_dot_largest); %detected dot
props_largest = regionprops(red_dot_largest, 'Centroid');
centroid = cat(1, props_largest.Centroid);
%% Geting position in robot frame of reds dot centroid
u = centroid(:,1);
v = centroid(:,2);
[x,y]=localise(u, v, R_cam, t_cam);
x %
y %
