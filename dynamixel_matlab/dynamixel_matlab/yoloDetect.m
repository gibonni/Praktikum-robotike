function [bboxes, labels] = yoloDetect(image)

    % Učitaj YOLO model
    yolo = yolov4ObjectDetector('csp-darknet53-coco');
    
    % Detektiraj objekte
    [bboxes, ~, labels] = detect(yolo, image);
    
    % Annotacija detektiranih objekata na slici
    detectedImg = insertObjectAnnotation(image, "Rectangle", bboxes, labels);
    %figure;
    imshow(detectedImg);

end