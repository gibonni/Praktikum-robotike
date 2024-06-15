function img = kalibracija5()
%% dobivanje slika
camera_info = imaqhwinfo('winvideo');
device_id=camera_info.DeviceIDs{1};
defaultFormat = camera_info.DeviceInfo(1).DefaultFormat;
video_obj = videoinput('winvideo', device_id, defaultFormat);


video_obj.ReturnedColorSpace = 'rgb';
f = figure('Visible', 'off'); 
vidRes = video_obj.VideoResolution;
imageRes = fliplr(vidRes);
hImage = imshow(zeros(imageRes));
num_images = 1;
for i=1:num_images
    % preview video object
    preview(video_obj, hImage);
    waitforbuttonpress;
    stoppreview(video_obj);
    % start to enable grab
    start(video_obj);
    img = getdata(video_obj);
    img = img(:, :, (1:3));
    stop(video_obj);
end
%img = imread('test_images\test_img14.png');
clear video_obj
end
