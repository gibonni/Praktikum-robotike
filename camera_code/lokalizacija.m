%% postavljanje parametara kamere
camera_info = imaqhwinfo('winvideo');
device_id=camera_info.DeviceIDs{2};
defaultFormat = camera_info.DeviceInfo(2).DefaultFormat;
video_obj = videoinput('winvideo', device_id, defaultFormat);
%% ucitavanje intrinzicne matrice
filename = 'intrinsic_matrix.mat';
loadedData = load(filename);
intrinsicMatrix = loadedData.intrinsicMatrix;

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
[img_undist,newOrigin] = undistortImage(img,cameraParams,'OutputView','full');
[imagePoints,boardSize] = detectCheckerboardPoints(img_undist);
squareSize = 18.5;
checkerboard_points = generateCheckerboardPoints(boardSize, squareSize);
checkerboard_points_h = [checkerboard_points zeros(size(checkerboard_points,1),1) ones(size(checkerboard_points,1),1)];
% measure the pose of the pattern in the frame {R} % nedes to be calculated
T_cam_robot = [1 0 0 -43;
     0 -1 0 103.5; % translacija za (-43, 103.5)mm po (x,y)
     0 0 -1 0; % rotacija po x za 180 (obrce y i z osi)
     0 0 0 1];
worldPoints = transpose(T_cam_robot*transpose(checkerboard_points_h));
worldPoints = worldPoints(:,1:2);
[R, t] = extrinsics(imagePoints, worldPoints, cameraParams);
[orientation_from_world, location_from_world] = extrinsicsToCameraPose(R, t);
%location_from_world
