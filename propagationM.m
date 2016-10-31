function [dbm1, dbm2, dbm3, dbmall, signal_space_dist] = propagationM()
R1 = [100 100]; R2 = [300 700]; R3 = [700 400]; % coorditanes of the stations [m]
modelrange = [0 : 10 : 1000]; % grid size
dbm1 = zeros(length(modelrange), length(modelrange));
dbm2 = zeros(length(modelrange), length(modelrange));
dbm3 = zeros(length(modelrange), length(modelrange));
dbmall = zeros(length(modelrange), length(modelrange));
Rmean = 300; % mean distance from the cell tower
measurement = [-119.3 -106.9 -119.0]; % our measurement
signal_space_dist = zeros(length(modelrange), length(modelrange));
for i = 1 : 1 : length(modelrange) % for every position in the grid
    for j = 1 : 1 : length(modelrange)
        % compute the distance from the 3 cell towers at position i, j
        d1 = sqrt((R1(1) - modelrange(i)) ^ 2 + (R1(2) - modelrange(j)) ^ 2);
        d2 = sqrt((R2(1) - modelrange(i)) ^ 2 + (R2(2) - modelrange(j)) ^ 2);
        d3 = sqrt((R3(1) - modelrange(i)) ^ 2 + (R3(2) - modelrange(j)) ^ 2);
        % compute the signal strength at position i, j
        dbm1(i, j) = -113 - 40 * log10(d1 / Rmean);
        dbm2(i, j) = -113 - 40 * log10(d2 / Rmean);
        dbm3(i, j) = -113 - 40 * log10(d3 / Rmean);
        % mean signal strength from the 3 cell towers
        dbmall(i, j) = mean([dbm1(i, j), dbm2(i, j), dbm3(i, j)]);
        % get the eucledean signal space distance between prediction and the masurement
        signal_space_dist(i, j) = sqrt((measurement(1) - dbm1(i, j)) ^ 2 + (measurement(2) - dbm2(i, j)) ^ 2 + (measurement(3) - dbm3(i, j)) ^ 2);                                 
    end
end
figure % plot prediction
mesh(modelrange, modelrange, dbmall)
colormap jet;
xlabel('X Dim [m]')
ylabel('Y Dim [m]')
zlabel('Power [dBm]')
ylim([0 1000]);
xlim([0 1000]);
zlim([-130 -100]);
title('Signal Propagation Prediction');
figure % plot signal space distance
[C, h] = contourf(modelrange, modelrange, log(1 ./ signal_space_dist));
colormap jet;
set(h,'ShowText','off')
set(h,'LineColor','none')
xlabel('X Dim [m]')
ylabel('Y Dim [m]')
title('Signal Space Distance');
end
        