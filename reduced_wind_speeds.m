function [u2] = reduced_wind_speeds(xy,D,k,u,dir,Ct,Ct_u)
%CALCULATEAEP Calculate wind speeds reduced by wakes.
% xy: num * 2 matrix of E/W and N/S WT coordinates (meter system)
% D: Rotor diameter
% k: wake decay constant (e.g. 0.075 onshore and 0.04 offshore)
% u: wind speed time series
%   time_steps * 1 -> assume same raw wind speeds for all WTs
%   time_steps * num -> different raw wind speed for different WTs
% dir: wind direction time series (time_steps * 1, 0 is N, 90 is E etc)
% Ct and Ct_u: Ct and corresponding wind speeds (x * 1)
%   must be prepared for linear interpolation (two zeros in beginning / end), e.g.:
%   Ct_u = [0 3.99 4 4.5 ... 25 25.01 100]'
%   Ct = [0 0 0.83 0.82 ... 0.05 0 0]'

% Make model of Ct
Ct = fit(Ct_u,Ct,'linearinterp');

num = size(xy,1); % Number of WTs
d = pdist2(xy,xy); % distance between WTs
dir = round(dir); 
dir(dir==0) = 360;
if size(u,2) == 1
    u = repmat(u,1,num); % same raw wind speed for all WTs
end

% Which WTs are within wake for different angles?
% dimensions are [upwind dir downwind]
pin = zeros(num,360,num)>0; % initialize 
for n = 1:num
    pin = in_wake(xy,n,k,D,pin); % within wake for angles 1-360
end

% Calculate catic = 1 - V/U
catic = zeros(num,size(u,1),num,'single');
for n = 1:num   
    for m = 1:num
        if n~=m
            temp = ismember(dir,find(pin(m,:,n)));
            catic(m,temp,n) = (1-sqrt(1-Ct(u(temp,n))))./(1+2*k*d(n,m)/D)^2; 
        end
    end
end

% Calculate reduces wind speeds
for n = 1:num
    vu = 1-sqrt(sum(catic(n,:,:).^2,3));
    u2(:,n) = real(u(:,n).*vu');
end

end

