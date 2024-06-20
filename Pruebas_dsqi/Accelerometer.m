
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

% Combinamos todas las listas de archivos
all_files = [files_ShirtM, files_ShirtS, files_ShirtL];

% Inicializar las componentes gravitacionales
gravityX = 0;
gravityY = 0;
gravityZ = 0;

% Constante de filtrado para media exponencial
alpha = 0.1;

% Procesar cada uno de los archivos
for i = 1:length(all_files)
    % Obtener el nombre del archivo
    filename = all_files{i};
    
    % Importar los datos del archivo de texto
    fprintf('Procesando archivo: %s\n', filename);
    
    % Leer el archivo omitiendo las líneas de cabecera
    fileID = fopen(filename, 'r');
    data = textscan(fileID, '%f%f%f%f%f%f', 'HeaderLines', 3, 'Delimiter', '\t');
    fclose(fileID);
    
    % Convertir el cell array a matriz
    data = cell2mat(data);

    % Separar los datos en los ejes X, Y, Z
    adcX = data(:, 4);
    adcY = data(:, 5);
    adcZ = data(:, 6);

    % Filtrar las señales
    [accX, accY, accZ] = calibrating(adcX, adcY, adcZ);

    % Actualizar la componente gravitacional usando media exponencial
    for j = 1:length(accX)
        gravityX = alpha * accX(j) + (1 - alpha) * gravityX;
        gravityY = alpha * accY(j) + (1 - alpha) * gravityY;
        gravityZ = alpha * accZ(j) + (1 - alpha) * gravityZ;
        
        % Remover la componente gravitacional de las señales de aceleración
        accX(j) = accX(j) - gravityX;
        accY(j) = accY(j) - gravityY;
        accZ(j) = accZ(j) - gravityZ;
    end

    % Mostrar las componentes gravitacionales finales
    fprintf('gravityX: %f, gravityY: %f, gravityZ: %f\n', gravityX, gravityY, gravityZ);

    % Sumar las aceleraciones en los tres ejes
    sumAcc = accX + accY + accZ;

    % Calcular la energía como la suma de los valores cuadrados
    energy = sum(sumAcc.^2);

    % Calcular la potencia dividiendo la energía por el número de muestras
    numTotalSamples = length(sumAcc);
    power = energy / numTotalSamples;

    % Mostrar la potencia calculada para cada archivo
    fprintf('La potencia calculada para %s es: %f\n', filename, power);
end






