function s = skewness(data)
    n = length(data);

    media = mean(data);

    sigma = std(data);

    s = (n * sum((data - media).^3)) / ((n - 1) * (n - 2) * sigma^3);

end
