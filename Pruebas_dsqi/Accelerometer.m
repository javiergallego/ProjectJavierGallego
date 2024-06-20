% Filtrado de las señales

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

% Procesar cada uno de los archivos
for i = 1:length(all_files)
    % Obtener el nombre del archivo
    filename = all_files{i};
    
    % Importar los datos del archivo de texto
    data = readmatrix(filename, 'Delimiter', ' ');  
    
    numSamples = 100000;
    
    % Separar los datos en los ejes X, Y, Z
    adcX = data(:, 1);
    adcY = data(:, 2);
    adcZ = data(:, 3);

    % Filtrar las señales
    [accX, accY, accZ] = calibrating(adcX, adcY, adcZ);

    % Calcular la media de las primeras 100000 muestras
    gravityX = mean(accX(1:numSamples));
    gravityY = mean(accY(1:numSamples));
    gravityZ = mean(accZ(1:numSamples));

    % Eliminar la componente gravitacional
    accX = accX - gravityX;
    accY = accY - gravityY;
    accZ = accZ - gravityZ;

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





