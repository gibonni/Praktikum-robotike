%% dobivanje slika
camera_info = imaqhwinfo('winvideo');
video_obj = videoinput('winvideo', camera_info.DeviceInfo.DeviceID, camera_info.DeviceInfo.DefaultFormat);

folder = 'test_images'; % Folder za slike
if ~exist(folder, 'dir')
   mkdir(folder); 
end

video_obj.ReturnedColorSpace = 'rgb';
f = figure('Visible', 'off'); 
vidRes = video_obj.VideoResolution;
imageRes = fliplr(vidRes);
hImage = imshow(zeros(imageRes));
num_images = 15;
for i=1:num_images
    % preview video object
    preview(video_obj, hImage);
    waitforbuttonpress;
    stoppreview(video_obj);
    % start to enable grab
    start(video_obj);
    img = getdata(video_obj);
    img = img(:, :, (1:3));
    filename = fullfile(folder, strcat('test_img', num2str(i), '.png'));
    imwrite(img, filename)
    stop(video_obj);
end

clear video_obj
% nakon ovog napraviti kalibraciju u Camera Calibrator App-u

%%neke probna obrada slika