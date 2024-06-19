
TEST = 0;

if (TEST)
    time_vector = 1:((7*60 + 59)*60); 
    
    files_ShirtM = {'C:\Registros\Javi1m.txt', 
        'C:\Registros\Javi2m.txt',
        'C:\Registros\Javi3m.txt',
        'C:\Registros\Javi4m.txt'};

    files_ShirtS = {'C:\Registros\Javi1s.txt', 
        'C:\Registros\Javi2s.txt',
        'C:\Registros\Javi3s.txt',
        'C:\Registros\Javi4s.txt'};

    files_ShirtL = {'C:\Registros\Javi1l.txt', 
        'C:\Registros\Javi2l.txt',
        'C:\Registros\Javi3l.txt',
        'C:\Registros\Javi4l.txt'}; 
else
     time_vector = 1:(((7*60 + 59)*60)*1000-360000); 
     
    files_ShirtM = {'C:\Registros\Javi1m.txt', 
        'C:\Registros\Javi2m.txt',
        'C:\Registros\Javi3m.txt',
        'C:\Registros\Javi4m.txt'};

    files_ShirtS = {'C:\Registros\Javi1s.txt', 
        'C:\Registros\Javi2s.txt',
        'C:\Registros\Javi3s.txt',
        'C:\Registros\Javi4s.txt'};

    files_ShirtL = {'C:\Registros\Javi1l.txt', 
        'C:\Registros\Javi2l.txt',
        'C:\Registros\Javi3l.txt',
        'C:\Registros\Javi4l.txt'};
end


fileSets = {files_ShirtL, files_ShirtM, files_ShirtS};
indexes = cell(1, length(fileSets)); % indexes = cell(1, length(fileSets)); -> vector de 3 pos

for setIndex = 1: length(indexes)
    currentFiles = fileSets{setIndex};% ej: currentFiles= fileSets{1} -> files_ShirtL ->(...,...,....,....)
    indexes{setIndex} = cell(1, length(currentFiles)); % indexes{1}= a un vector con 4 pos 

    for fileIndex = 1:length(currentFiles) % fileIndex = 1:length(currentFiles)=4
        data = ImportPluxData(currentFiles{fileIndex}, 3);
        ecg = data(time_vector);
        [kSQI_01_vector, sSQI_01_vector, pSQI_01_vector, rel_powerLine01_vector, cSQI_01_vector, basSQI_01_vector, dSQI_01_vector, geometricMean_vector, averageGeometricMean] = mSQI(ecg, 1000);
        indexes{setIndex}{fileIndex} = geometricMean_vector;
        filename = 'valores_mSQI.txt';
        fileID = fopen(filename, 'w');
        fprintf(fileID, geometricMean_vector);
        fprintf("Average mean of windows of %s: %f\n", currentFiles{fileIndex}, averageGeometricMean);
    end
end

indexes_ShirtL = indexes{1};
indexes_ShirtM = indexes{2};
indexes_ShirtS = indexes{3};



%significance level for calculating the confidence intervals
alph = 0.01;
%number of iterations to use in boostrap
iter = 1000;

% Data for the Comparison Within Each Register
% data of ShirtL that will be used for the CI
data_ShirtL_R2R3R4 =[indexes_ShirtL{2},indexes_ShirtL{3},indexes_ShirtL{4}]; % data_ShirtL_R2R3R4 -> R2:register2, R3:register3, R4:register of  of ShirtL
data_ShirtL_R1R3R4 =[indexes_ShirtL{1},indexes_ShirtL{3},indexes_ShirtL{4}];
data_ShirtL_R1R2R4 =[indexes_ShirtL{1},indexes_ShirtL{2},indexes_ShirtL{4}];
data_ShirtL_R1R2R3 =[indexes_ShirtL{1},indexes_ShirtL{2},indexes_ShirtL{3}];

% data of ShirtM that will be used for the CI
data_ShirtM_R2R3R4 =[indexes_ShirtM{2},indexes_ShirtM{3},indexes_ShirtM{4}]; % data_ShirtM_R2R3R4 -> R2:register2, R3:register3, R4:register of  of ShirtM
data_ShirtM_R1R3R4 =[indexes_ShirtM{1},indexes_ShirtM{3},indexes_ShirtM{4}];
data_ShirtM_R1R2R4 =[indexes_ShirtM{1},indexes_ShirtM{2},indexes_ShirtM{4}];
data_ShirtM_R1R2R3 =[indexes_ShirtM{1},indexes_ShirtM{2},indexes_ShirtM{3}];

% data of ShirtS that will be used for the CI
data_ShirtS_R2R3R4 =[indexes_ShirtS{2},indexes_ShirtS{3},indexes_ShirtS{4}]; % data_ShirtS_R2R3R4 -> R2:register2, R3:register3, R4:register of  of ShirtS
data_ShirtS_R1R3R4 =[indexes_ShirtS{1},indexes_ShirtS{3},indexes_ShirtS{4}];
data_ShirtS_R1R2R4 =[indexes_ShirtS{1},indexes_ShirtS{2},indexes_ShirtS{4}];
data_ShirtS_R1R2R3 =[indexes_ShirtS{1},indexes_ShirtS{2},indexes_ShirtS{3}];

% Data for the Comparison Across Registers
data_ShirtLvsShirtM_ShirtS=cell2mat([indexes_ShirtM,indexes_ShirtS]); % cell2mat-> convert the contents of a cell array into a single matrix
data_ShirtMvsShirtL_ShirtS=cell2mat([indexes_ShirtL,indexes_ShirtS]);
data_ShirtSvsShirtL_ShirtM=cell2mat([indexes_ShirtL,indexes_ShirtM]);


%CONFIDENCE INTERVALS (CI)
% Comparison Within Each Register of ShirtL Data
%CI for R1 vs {R2, R3 y R4}
CIMedian_ShirtL_R1vsR2R3R4 = estimateCIMedian(indexes_ShirtL{1},data_ShirtL_R2R3R4,alph,iter);
CIMean_ShirtL_R1vsR2R3R4 = estimateCIMean(indexes_ShirtL{1},data_ShirtL_R2R3R4,alph,iter);
%CI for R2 vs {R1, R3 y R4}
CIMedian_ShirtL_R2vsR1R3R4 = estimateCIMedian(indexes_ShirtL{2},data_ShirtL_R1R3R4,alph,iter);
CIMean_ShirtL_R2vsR1R3R4 = estimateCIMean(indexes_ShirtL{2},data_ShirtL_R1R3R4,alph,iter);
%CI for R3 vs {R1, R2 y R4}
CIMedian_ShirtL_R3vsR1R2R4 = estimateCIMedian(indexes_ShirtL{3},data_ShirtL_R1R2R4,alph,iter);
CIMean_ShirtL_R3vsR1R2R4 = estimateCIMean(indexes_ShirtL{3},data_ShirtL_R1R2R4,alph,iter);
%CI for R4 vs {R1, R2 y R3}
CIMedian_ShirtL_R4vsR1R2R3 = estimateCIMedian(indexes_ShirtL{4},data_ShirtL_R1R2R3,alph,iter);
CIMean_ShirtL_R4vsR1R2R3 = estimateCIMean(indexes_ShirtL{4},data_ShirtL_R1R2R3,alph,iter);

% Comparison Within Each Register of ShirtM Data
%CI for R1 vs {R2, R3 y R4}
CIMedian_ShirtM_R1vsR2R3R4 = estimateCIMedian(indexes_ShirtM{1},data_ShirtM_R2R3R4,alph,iter);
CIMean_ShirtM_R1vsR2R3R4 = estimateCIMean(indexes_ShirtM{1},data_ShirtM_R2R3R4,alph,iter);
%CI for R2 vs {R1, R3 y R4}
CIMedian_ShirtM_R2vsR1R3R4 = estimateCIMedian(indexes_ShirtM{2},data_ShirtM_R1R3R4,alph,iter);
CIMean_ShirtM_R2vsR1R3R4 = estimateCIMean(indexes_ShirtM{2},data_ShirtM_R1R3R4,alph,iter);
%CI for R3 vs {R1, R2 y R4}
CIMedian_ShirtM_R3vsR1R2R4 = estimateCIMedian(indexes_ShirtM{3},data_ShirtM_R1R2R4,alph,iter);
CIMean_ShirtM_R3vsR1R2R4 = estimateCIMean(indexes_ShirtM{3},data_ShirtM_R1R2R4,alph,iter);
%CI for R4 vs {R1, R2 y R3}
CIMedian_ShirtM_R4vsR1R2R3 = estimateCIMedian(indexes_ShirtM{4},data_ShirtM_R1R2R3,alph,iter);
CIMean_ShirtM_R4vsR1R2R3 = estimateCIMean(indexes_ShirtM{4},data_ShirtM_R1R2R3,alph,iter);

% Comparison Within Each Register of ShirtS Data
%CI for R1 vs {R2, R3 y R4}
CIMedian_ShirtS_R1vsR2R3R4 = estimateCIMedian(indexes_ShirtS{1},data_ShirtS_R2R3R4,alph,iter);
CIMean_ShirtS_R1vsR2R3R4 = estimateCIMean(indexes_ShirtS{1},data_ShirtS_R2R3R4,alph,iter);
%CI for R2 vs {R1, R3 y R4}
CIMedian_ShirtS_R2vsR1R3R4 = estimateCIMedian(indexes_ShirtS{2},data_ShirtS_R1R3R4,alph,iter);
CIMean_ShirtS_R2vsR1R3R4 = estimateCIMean(indexes_ShirtS{2},data_ShirtS_R1R3R4,alph,iter);
%CI for R3 vs {R1, R2 y R4}
CIMedian_ShirtS_R3vsR1R2R4 = estimateCIMedian(indexes_ShirtS{3},data_ShirtS_R1R2R4,alph,iter);
CIMean_ShirtS_R3vsR1R2R4 = estimateCIMean(indexes_ShirtS{3},data_ShirtS_R1R2R4,alph,iter);
%CI for R4 vs {R1, R2 y R3}
CIMedian_ShirtS_R4vsR1R2R3 = estimateCIMedian(indexes_ShirtS{4},data_ShirtS_R1R2R3,alph,iter);
CIMean_ShirtS_R4vsR1R2R3 = estimateCIMean(indexes_ShirtS{4},data_ShirtS_R1R2R3,alph,iter);


% Histograms for each register of ShirtL
for i = 1:4
    figure;
    histogram(indexes_ShirtL{i}, 20);
    title(['Histogram for indexes\_ShirtL{' num2str(i) '}']);
end

% Histograms for each register of ShirtM
for i = 1:4
    figure;
    histogram(indexes_ShirtM{i}, 20);
    title(['Histogram for indexes\_ShirtM{' num2str(i) '}']);
end

% Histograms for each register of ShirtS
for i = 1:4
    figure;
    histogram(indexes_ShirtS{i}, 20);
    title(['Histogram for indexes\_ShirtS{' num2str(i) '}']);
end

%histogram(indexes_ShirtL{1}, 20)
%figure()
%histogram(geometricMean_V_24, 20)


indexes_ShirtL_v = cell2mat(indexes_ShirtL);
indexes_ShirtM_v = cell2mat(indexes_ShirtM);
indexes_ShirtS_v = cell2mat(indexes_ShirtS);

z_mean_indexes_ShirtL = mean (indexes_ShirtL_v);
z_var_indexes_ShirtL = var(indexes_ShirtL_v);
z_mean_indexes_ShirtM = mean (indexes_ShirtM_v);
z_var_indexes_ShirtM = var(indexes_ShirtM_v);
z_mean_indexes_ShirtS = mean (indexes_ShirtS_v);
z_var_indexes_ShirtS = var(indexes_ShirtS_v);


y_CIMedian_ShirtLvsShirtM= estimateCIMedian(indexes_ShirtL_v, indexes_ShirtM_v, alph, iter);
y_CIMean_shirtLvsShirtM= estimateCIMean(indexes_ShirtL_v, indexes_ShirtM_v, alph, iter);

y_CIMedian_ShirtLvsShirtS= estimateCIMedian(indexes_ShirtL_v, indexes_ShirtS_v, alph, iter);
y_CIMean_ShirtLvsShirtS= estimateCIMean(indexes_ShirtL_v, indexes_ShirtS_v, alph, iter);

y_CIMedian_ShirtMvsShirtS= estimateCIMedian(indexes_ShirtM_v, indexes_ShirtS_v, alph, iter);
y_CIMean_ShirtMvsShirtS= estimateCIMean(indexes_ShirtM_v, indexes_ShirtS_v, alph, iter);


x_mean_indexes_ShirtL = cellfun(@mean, indexes_ShirtL);
x_mean_indexes_ShirtM = cellfun(@mean, indexes_ShirtM);
x_mean_indexes_ShirtS = cellfun(@mean, indexes_ShirtS);

x_var_indexes_ShirtL = cellfun(@var, indexes_ShirtL);
x_var_indexes_ShirtM = cellfun(@var, indexes_ShirtM);
x_var_indexes_ShirtS = cellfun(@var, indexes_ShirtS);

figure
histogram(indexes_ShirtL_v, 20);
title(['Histogram for indexes Shirt L']);

figure
histogram(indexes_ShirtM_v, 20);
title(['Histogram for indexes Shirt M']);

figure
histogram(indexes_ShirtS_v, 20);
title(['Histogram for indexes Shirt S']);


tiledlayout(3,1)

nexttile
histogram(indexes_ShirtL_v, 20);
title(['Histogram for indexes Shirt L']);

nexttile
histogram(indexes_ShirtM_v, 20);
title(['Histogram for indexes Shirt M']);

nexttile
histogram(indexes_ShirtS_v, 20);
title(['Histogram for indexes Shirt S']);
