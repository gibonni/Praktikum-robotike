%% cuitavanje intrinzicne matrice
filename = 'intrinsic_matrix.mat';
loadedData = load(filename);
intrinsicMatrix = loadedData.intrinsicMatrix;

%% odredivanje prostora kamere

%% pronalazenje robota ?? i odredivanje transformacije iz prostora kamere u prostor robota