%% dobivanje slika
camera_info = imaqhwinfo('winvideo');
device_id=camera_info.DeviceIDs{2};
defaultFormat = camera_info.DeviceInfo(2).DefaultFormat;
video_obj = videoinput('winvideo', device_id, defaultFormat);


folder = 'calibration_images'; % Folder za slike
if ~exist(folder, 'dir')
   mkdir(folder); 
end

video_obj.ReturnedColorSpace = 'rgb';
f = figure('Visible', 'off'); 
vidRes = video_obj.VideoResolution;
imageRes = fliplr(vidRes);
hImage = imshow(zeros(imageRes));
num_images = 10;
for i=1:num_images
    % preview video object
    preview(video_obj, hImage);
    waitforbuttonpress;
    stoppreview(video_obj);
    % start to enable grab
    start(video_obj);
    img = getdata(video_obj);
    img = img(:, :, (1:3));
    filename = fullfile(folder, strcat('calib_img', num2str(i), '.png'));
    imwrite(img, filename)
    stop(video_obj);
end

clear video_obj
% nakon ovog napraviti kalibraciju u Camera Calibrator App-u

%% pohrana dobivenih parametara u file
camera_params=cameraParams;
intrinsicMatrix = cameraParams.Intrinsics.IntrinsicMatrix;
filename = 'intrinsic_matrix.mat';
save(filename, 'intrinsicMatrix');
filename = 'camera_params.mat';
save(filename, 'camera_params');

%% ucitavanje parametara iz file-a
filename = 'intrinsic_matrix.mat';
loadedData = load(filename);
intrinsicMatrix = loadedData.intrinsicMatrix;
filename = 'camera_params.mat';
loadedData = load(filename);
cameraParams = loadedData.camera_params;
