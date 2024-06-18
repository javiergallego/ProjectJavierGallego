

data =  filename
accX = data(:, 1);
accY = data(:, 2);
accZ = data(:, 3);

% Constants
g = 9.81;

% Here we assume the average of initial readings represents gravity. 
gravityX = mean(accX(1:100));
gravityY = mean(accY(1:100));
gravityZ = mean(accZ(1:100));

% Remove the gravity component
accX = accX - gravityX;
accY = accY - gravityY;
accZ = accZ - gravityZ;

% Sum the accelerations in the three axes
sumAcc = accX + accY + accZ;

% Energy is the sum of the squared values
energy = sum(sumAcc.^2);


