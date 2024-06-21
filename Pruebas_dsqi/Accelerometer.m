% Listas de archivos
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

fileSets = {files_ShirtM, files_ShirtS, files_ShirtL};


alpha = 0.1;

for setIndex = 1:length(fileSets)
    currentFiles = fileSets{setIndex};  

    for fileIndex = 1:length(currentFiles)
        currentFile = currentFiles{fileIndex};  

        fileID = fopen(currentFile, 'r');
        data = textscan(fileID, '%f%f%f%f%f%f', 'HeaderLines', 3, 'Delimiter', '\t');
        fclose(fileID);
        data = cell2mat(data);

        % Separar los datos en los ejes X, Y, Z
        adcX = data(:, 4);
        adcY = data(:, 5);
        adcZ = data(:, 6);

        % Calibrar las señales
        [accX, accY, accZ] = calibrating(adcX, adcY, adcZ);

        % Inicializar variables para el cálculo por intervalos
        numSamples = length(accX);
        interval = 10000;
        numIntervals = ceil(numSamples / interval);

        % Inicializar variables para guardar los resultados
        gravityX_int = zeros(numIntervals, 1);
        gravityY_int = zeros(numIntervals, 1);
        gravityZ_int = zeros(numIntervals, 1);
        power_int = zeros(numIntervals, 1);

        % Procesar por intervalos de 10000 muestras
        for intervalIdx = 1:numIntervals
            startIdx = (intervalIdx - 1) * interval + 1;
            endIdx = min(intervalIdx * interval, numSamples);

            % Actualizar la componente gravitacional usando media exponencial
            gravityX = 0;
            gravityY = 0;
            gravityZ = 0;

            for j = startIdx:endIdx
                gravityX = alpha * accX(j) + (1 - alpha) * gravityX;
                gravityY = alpha * accY(j) + (1 - alpha) * gravityY;
                gravityZ = alpha * accZ(j) + (1 - alpha) * gravityZ;

                
                accX(j) = accX(j) - gravityX;
                accY(j) = accY(j) - gravityY;
                accZ(j) = accZ(j) - gravityZ;
            end

            % Guardar la componente gravitacional promediada en el intervalo
            gravityX_int(intervalIdx) = gravityX;
            gravityY_int(intervalIdx) = gravityY;
            gravityZ_int(intervalIdx) = gravityZ;

            % Calcular el módulo de los 3 ejes
            modulo = sqrt(accX(startIdx:endIdx).^2 + accY(startIdx:endIdx).^2 + accZ(startIdx:endIdx).^2);

            % Calcular la potencia promediada en el intervalo
            numSamplesInterval = length(modulo);
            power_int(intervalIdx) = sum(modulo) / numSamplesInterval;
        end

       
        save_filename = sprintf('results_accel_%d.txt', fileIndex);

        % Guardar los resultados en el archivo
        fid = fopen(save_filename, 'w');
        fprintf(fid, 'Interval\tGravityX\tGravityY\tGravityZ\tPower\n');
        for intervalIdx = 1:numIntervals
            fprintf(fid, '%d\t%f\t%f\t%f\t%f\n', intervalIdx, abs(gravityX_int(intervalIdx)), abs(gravityY_int(intervalIdx)), abs(gravityZ_int(intervalIdx)), power_int(intervalIdx));
        end
        fclose(fid);
    end
end





