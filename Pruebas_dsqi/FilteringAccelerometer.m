%Code to filter the acceloremeter

function [accx, accy, accz] = calibrating(adcx, adcy, adcz)
    % Valores mínimos de cada borde
    min_x = 26568;
    min_y = 32036;
    min_z = 32444;

    % Valores máximos de cada borde
    max_x = 33580;
    max_y = 38632;
    max_z = 35940;

    % Función de transferencia
    accx = (adcx - min_x) / (max_x - min_x) * 2 - 1;
    accy = (adcy - min_y) / (max_y - min_y) * 2 - 1;
    accz = (adcz - min_z) / (max_z - min_z) * 2 - 1;
end


