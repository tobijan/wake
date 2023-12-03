close all
load('test_data.mat')

%%% Enter you own data here: %%%

% Ct := turbine thrust coefficient
% Ct_u := wind speed vector


turbine = 1; % 1 for Vestas, 2 for Enercon
layout = 3; % 1 for even distribution, 2 for rows and 3 for circle

k = 0.0750; % wake decay constant, set to k=0.0750
data = readmatrix('ninjawind2.xlsx');
data = data(6:end,4);
u = data;              % wind speeds in m/s

sample = [
    0.04,1,0;
    0.01,2,30;
    0.01,3,60;
    0.05,4,90;
    0.16,5,120;
    0.04,6,150;
    0.04,7,180;
    0.06,8,210;
    0.08,9,240;
    0.11,10,270;
    0.33,11,300;
    0.08,12,330
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

if turbine == 1
    if layout == 1
        D = 112;              % rotor diameter in meter
        x = [ones(1,11)*0 ones(1,11)*454.5455 ones(1,11)*454.5455*2 ones(1,11)*454.5455*3 ones(1,11)*454.5455*4 ones(1,11)*454.5455*5 ones(1,11)*454.5455*6 ones(1,11)*454.5455*7 ones(1,11)*454.5455*8 ones(1,11)*454.5455*9 ones(1,7)*454.5455*10];
        y = [(0:10)*545.4545 (0:10)*545.4545 (0:10)*545.4545 (0:10)*545.4545 (0:10)*545.4545 (0:10)*545.4545 (0:10)*545.4545 (0:10)*545.4545 (0:10)*545.4545 (0:10)*545.4545 (2:8)*545.4545];
        xy = [x',y'];     % geographical alignment of the wind turbines
    elseif layout == 2
        D = 112;              % rotor diameter in meter
        x = [ones(1,24)*0 ones(1,24)*1000 ones(1,24)*2000 ones(1,24)*3000 ones(1,21)*4000];
        y = [(0:250:5750) (0:250:5750) (0:250:5750) (0:250:5750) (250:250:5250)];
        y(25:48) = y(25:48)+125;
        y(73:96) = y(73:96)+125;
        xy = [x',y'];     % geographical alignment of the wind turbines
    else
        % Définir les demi-axes de l'ovale
        demi_axe_horizontal = 2260; % Demi-axe horizontal de 1500 mètres
        demi_axe_vertical = 2130;   % Demi-axe vertical de 1000 mètres
        
        % Définir le pas du quadrillage
        pas_quadrillage = 360; % 260 mètres
        
        % Calculer le nombre de points dans l'ovale
        nombre_de_coordonnees = 117;
        
        % Initialiser la liste de coordonnées
        coordonnees = [];
        
        % Générer des coordonnées régulières dans l'ovale
        for x = -2000:pas_quadrillage:2000
            for y = -2000:pas_quadrillage:2000
                % Calculer la distance par rapport à l'origine (0,0) en tenant compte des demi-axes
                distance = sqrt((x/demi_axe_horizontal)^2 + (y/demi_axe_vertical)^2);
                
                % Vérifier si les coordonnées sont à l'intérieur de l'ovale
                if distance <= 1
                    coordonnees = [coordonnees; x, y];
                end
                
                % Arrêter si nous avons atteint le nombre de coordonnées souhaité
                if size(coordonnees, 1) >= nombre_de_coordonnees
                    break;
                end
            end
            if size(coordonnees, 1) >= nombre_de_coordonnees
                break;
            end
        end
        xy = coordonnees;
    end
else 
    if layout == 1
        D = 114;              % rotor diameter in meter
        x = [ones(1,9)*0 ones(1,9)*625 ones(1,9)*625*2 ones(1,9)*625*3 ones(1,9)*625*4 ones(1,9)*625*5 ones(1,9)*625*6 ones(1,9)*625*7 ones(1,6)*625*8];
        y = [(0:750:6000) (0:750:6000) (0:750:6000) (0:750:6000) (0:750:6000) (0:750:6000) (0:750:6000) (0:750:6000) (1500:750:5250)];
        xy = [x',y'];     % geographical alignment of the wind turbines
    elseif layout == 2
        D = 114;              % rotor diameter in meter
        x = [ones(1,16)*0 ones(1,16)*1000 ones(1,16)*2000 ones(1,16)*3000 ones(1,14)*4000];
        y = [(0:375:5750) (0:375:5750) (0:375:5750) (0:375:5750) (375:375:5750-375)];
        y(17:32) = y(17:32)+375/2;
        y(49:64) = y(49:64)+375/2;
        xy = [x',y'];     % geographical alignment of the wind turbines
    else
        % Définir les demi-axes de l'ovale
        demi_axe_horizontal = 2260; % Demi-axe horizontal de 1500 mètres
        demi_axe_vertical = 2130;   % Demi-axe vertical de 1000 mètres
        
        % Définir le pas du quadrillage
        pas_quadrillage = 440; % 260 mètres
        
        % Calculer le nombre de points dans l'ovale
        nombre_de_coordonnees = 78;
        
        % Initialiser la liste de coordonnées
        coordonnees = [];
        
        % Générer des coordonnées régulières dans l'ovale
        for x = -2000:pas_quadrillage:2000
            for y = -2000:pas_quadrillage:2000
                % Calculer la distance par rapport à l'origine (0,0) en tenant compte des demi-axes
                distance = sqrt((x/demi_axe_horizontal)^2 + (y/demi_axe_vertical)^2);
                
                % Vérifier si les coordonnées sont à l'intérieur de l'ovale
                if distance <= 1
                    coordonnees = [coordonnees; x, y];
                end
                
                % Arrêter si nous avons atteint le nombre de coordonnées souhaité
                if size(coordonnees, 1) >= nombre_de_coordonnees
                    break;
                end
            end
            if size(coordonnees, 1) >= nombre_de_coordonnees
                break;
            end
        end
        xy = coordonnees;
    end
end

%% Reduced wind speeds at each turbine
u2 = reduced_wind_speeds(xy,D,k,u,dir,Ct,Ct_u);

subplot(1,2,1)
scatter(xy(:,1),xy(:,2))
xlabel('W-E coordinate (m)')
ylabel('S-N coordinate (m)')
subplot(1,2,2)
scatter(dir,u-mean(u2,2))
xlabel('Direction (degrees)')
ylabel('Reduction in wind speed (m/s)')

if turbine == 1
    xvestas = (0:0.5:25);
    yvestas = [0 0 0 0 0 0 26 73 133 207 302 416 554 717 907 1126 1375 1652 1958 2282 2585 2821 2997 3050 3067 3074 3075 ones(1,24)*3075];
    f = fit(xvestas',yvestas','linearinterp');
else
    xenercon = (0:25);
    yenercon = [0 0 0 38 135 301 561 933 1393 2720 3540 4180 4450 ones(1,13)*4500];
    f = fit(xenercon',yenercon','linearinterp');
end
energy = 0.89*sum(f(u2))/1000; % MWh
ularge = u.*ones(1,length(xy));
optimalenergy = 0.89*sum(f(ularge))/1000; % MWh
wakeloss = optimalenergy-energy;
wakelosspercent = 100*wakeloss/energy;

if turbine ==1
    CF = energy/(8760*3.075*117);
else
    CF = energy/(8760*4.5*78);
end

if turbine == 1
    turbinestring = 'Vestas';
else
    turbinestring = 'Enercon';
end

if layout == 1
    layoutstring = 'even';
elseif layout == 2
    layoutstring = 'row';
else
    layoutstring = 'circle';
end

infodisp = ['For the ',turbinestring, ' turbine with the ', layoutstring, ' layout:'];
energydisp = ['The annual energy production is ',num2str(energy),' MWh'];
CFdisp = ['The capacity factor is ',num2str(CF)];
wakedisp = ['The wake losses are ',num2str(wakeloss) ' MWh', ', which is ',num2str(wakelosspercent),'%'];

disp(infodisp)

disp(energydisp)

disp(CFdisp)

disp(wakedisp)