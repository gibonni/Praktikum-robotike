function processImage(image, target_labels_str, avoid_labels_str)
    % Pretvori nizove labela u cell array
    target_labels = strsplit(target_labels_str, ',');
    avoid_labels = strsplit(avoid_labels_str, ',');

    % Učitaj YOLO model
    yolo = yolov4ObjectDetector('csp-darknet53-coco');
    
    % Detektiraj objekte
    [bboxes, ~, labels] = detect(yolo, image);
    
    % Annotacija detektiranih objekata na slici
    detectedImg = insertObjectAnnotation(image, "Rectangle", bboxes, labels);
    %figure;
    %imshow(detectedImg);

    % Napravi crne kvadrate na slici
    black_boxes_image = blackenBoundingBoxes(image, bboxes, labels, avoid_labels);

    % Nađi središta odredišnih točaka
    [centers_x, centers_y] = findCentersByLabels(bboxes, labels, target_labels);

    % Planiraj put
    [x_path, y_path] = plan_path(black_boxes_image, centers_x, centers_y);

    % Prikaži sliku s detektiranim objektima
    imshow(detectedImg);
    hold on;

    % Prikaži putanju kao crvene točke
    plot(x_path, y_path, 'r-', 'LineWidth', 2);
    plot(centers_x, centers_y, 'ro', 'MarkerFaceColor', 'r');

    hold off;
end