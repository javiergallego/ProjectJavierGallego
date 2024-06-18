

function k = kurtosis(data)
    n = length(data);

    media = mean (data);
    % Desviación estándar de los datos
    sigma = std(data);
    % Kurtosis
    k = (n * sum((data - media).^4)) / ((sum((data - media).^2))^2) - 3;
end
