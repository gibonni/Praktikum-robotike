function [centers_x, centers_y] = findCentersByLabels(bboxes, labels, target_labels)
    % Ispravan oblik labels
    labels = cellstr(labels);
    
    % Inicijalizacija praznih vektora za x i y koordinate središta
    numBoxes = size(bboxes, 1);
    centers_x = zeros(numBoxes, 1);
    centers_y = zeros(numBoxes, 1);
    
    % Brojač za validne točke
    count = 0;
    
    % Iteracija kroz detektirane objekte
    for i = 1:numBoxes
        bbox = bboxes(i, :);
        x_min = bbox(1);
        y_min = bbox(2);
        width = bbox(3);
        height = bbox(4);
        label = labels{i}; % Oznaka objekta
        
        % Provjeri je li oznaka među ciljanim oznakama
        if any(strcmp(label, target_labels))
            % Pronalaženje središta bounding boxa
            x_center = x_min + width / 2;
            y_center = y_min + height / 2;

            % Spremanje središta
            count = count + 1;
            centers_x(count) = floor(x_center);
            centers_y(count) = floor(y_center);
        end
    end
    
    % Trimanje praznih elemenata
    centers_x = centers_x(1:count);
    centers_y = centers_y(1:count);
end