function blackBoxesImage = blackenBoundingBoxes(image, bboxes, labels, target_labels)
    % Ispravan oblik labels
    labels = cellstr(labels);
    
    % Pretvori sliku u crno-bijelu
    bw_image = rgb2gray(image);
    
    % Inicijalizacija crne slike istih dimenzija kao originalna slika
    black_boxes_image = 255 * ones(size(bw_image), 'like', bw_image);
    
    % Iteriraj kroz detektirane objekte
    for i = 1:size(bboxes, 1)
        bbox = bboxes(i, :);
        x_min = bbox(1);
        y_min = bbox(2);
        width = bbox(3);
        height = bbox(4);
        label = labels{i}; % Oznaka objekta
        
        % Provjeri je li oznaka među ciljanim oznakama
        if any(strcmp(label, target_labels))
            % Postavi područje bounding boxa na crno
            black_boxes_image(floor(y_min):ceil(y_min+height), floor(x_min):ceil(x_min+width)) = 0;
        end
    end
    
    % Pretvori natrag u RGB format
    blackBoxesImage = black_boxes_image;
end