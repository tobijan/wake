close all
load('test_data.mat')

%%% Enter you own data here: %%%
% D := rotor diameter in meter
% k := wake decay constant, set to k=0.0750
% u := wind speeds in m/s
% dir := wind directions in degree
% Ct := turbine thrust coefficient
% Ct_u := wind speed vector
% xy := geographical alignment of wind turbines
%       xy(:,1) := x-axis coordinates
%       xy(:,2) := y-axis coordinates
%       size(xy,1) = number of turbines

D = 112;              % rotor diameter in meter
k = 0.0750;         % wake decay constant, set to k=0.0750
data = readmatrix('ninjawind.xlsx');
data = data(6:end,4);
u = data;              % wind speeds in m/s

sample = [
    0.03,1,0;
    0.01,2,30;
    0.01,3,60;
    0.02,4,90;
    0.1,5,120;
    0.02,6,150;
    0.03,7,180;
    0.04,8,210;
    0.07,9,240;
    0.07,10,270;
    0.37,11,300;
    0.22,12,330
];

% Extract values from the data
probabilities = sample(:, 1);
directions = sample(:, 3);

% Create an empty vector for the wind directions
wind_directions = zeros(8760, 1);

% Generate wind directions for each hour of the year
for i = 1:8760
    % Generate a random sample based on the provided distribution
    direction_vector = randsample(directions, 1, true, probabilities);
    % Apply the rotation
    direction_vector_rotated = mod(direction_vector - 45, 360);
    wind_directions(i) = direction_vector_rotated;
end

dir = wind_directions;          % wind directions in degree

x = [ones(1,24)*0 ones(1,24)*1000 ones(1,24)*2000 ones(1,24)*3000 ones(1,24)*4000];
y = [0 250 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250 3500 3750 4000 4250 4500 4750 5000 5250 5500 5750 0 250 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250 3500 3750 4000 4250 4500 4750 5000 5250 5500 5750 0 250 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250 3500 3750 4000 4250 4500 4750 5000 5250 5500 5750 0 250 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250 3500 3750 4000 4250 4500 4750 5000 5250 5500 5750 0 250 500 750 1000 1250 1500 1750 2000 2250 2500 2750 3000 3250 3500 3750 4000 4250 4500 4750 5000 5250 5500 5750];
y(25:48) = y(25:48)+125;
y(73:96) = y(73:96)+125;
% x = [ones(1,16)*0 ones(1,16)*1000 ones(1,16)*2000 ones(1,16)*3000 ones(1,16)*4000];
% y = [0 375 ]
% y(25:48) = y(25:48)+125;
% y(73:96) = y(73:96)+125;
xy = [ x',y'];     % geographical alignment of the wind turbines
      

%% Run this code to get the reduced wind speeds at each turbine

u2 = reduced_wind_speeds(xy,D,k,u,dir,Ct,Ct_u);
subplot(1,2,1)
scatter(xy(:,1),xy(:,2))
xlabel('W-E coordinate (m)')
ylabel('S-N coordinate (m)')
subplot(1,2,2)
scatter(dir,u-mean(u2,2))
xlabel('Direction (degrees)')
ylabel('Reduction in wind speed (m/s)')





% Display the first few elements of the resulting vector
disp(wind_directions(1:10));