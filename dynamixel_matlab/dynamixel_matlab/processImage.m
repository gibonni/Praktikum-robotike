function [x_path, y_path] = processImage(image, target_labels_str, avoid_labels_str, bboxes, labels)
    % Pretvori nizove labela u cell array
    target_labels = strsplit(target_labels_str, ',');
    avoid_labels = strsplit(avoid_labels_str, ',');

    % Napravi crne kvadrate na slici
    black_boxes_image = blackenBoundingBoxes(image, bboxes, labels, avoid_labels);

    % Nađi središta odredišnih točaka
    [centers_x, centers_y] = findCentersByLabels(bboxes, labels, target_labels);
    [centers_x, centers_y]
    imshow(black_boxes_image);
    hold on;

    % Prikaži putanju kao crvene točke
    %plot(x_path, y_path, 'r-', 'LineWidth', 2);
    plot(centers_x, centers_y, 'ro', 'MarkerFaceColor', 'r');

    hold off;
    
    % Planiraj put

    

    [x_path, y_path] = plan_path(black_boxes_image, centers_x, centers_y);

    % Prikaži sliku s detektiranim objektima
    imshow(black_boxes_image);
    hold on;

    % Prikaži putanju kao crvene točke
    plot(x_path, y_path, 'r-', 'LineWidth', 2);
    plot(centers_x, centers_y, 'ro', 'MarkerFaceColor', 'r');

    hold off;
end