function [wnd, u_out, v_out, lon_out, lat_out, time_out] = gdas_import (filename, lon_in, lat_in, time_in)
%% gdas_import.m
%% Description
% The subroutine imports wind field reanalysis from GDAS. 
%
%% Use
% [ins_wv]=ndbc_import (filename, lon_in, lat_in, time_in)
% 
% Input     : filename - The path/filename with the data
%             lon_in - array with at least two values, the min and max
%             longitude
%             lat_in - array with at least two values, the min and max
%             latitude
%             time_in - array with at least two values, the min and max
%             time for analysis
% Output    : wnd - structure with the data
%             *_out - arrays with the output quantity of their name 
%% License and more typicallities etc 
%   Copyright (C) 2017 Stylianos Flampouris
%   GNU Lesser General Public License
%       
%   Washington, DC, USA, Earth
%
%   For a copy of the GNU Lesser General Public License, 
%   see <http://www.gnu.org/licenses/>.
%
%% The Code
if exist(filename,'file')==2
    display(['Wind data are imported... Taking some time!']);
else
    error(['The ', filename, ' does not exist!']);
end
%
startM = [1 1 1];
countM = [Inf Inf Inf];
%
time_out = ncread(filename,'time');
time_out = datenum(1970,1,1,0,0,0)+time_out/86400;
lon_out = ncread(filename, 'longitude');
lon_out = lon0360tolon180(lon_out);
lat_out = ncread(filename, 'latitude');

if nargin>1
    ind_t = find(time_out>= min(time_in(:)) & time_out<= max(time_in(:)));
    time_out = time_out(ind_t);
    ind_lon = find(lon_out>= min(lon_in(:)) & lon_out<= max(lon_in(:)));
    lon_out = lon_out(ind_lon);
    ind_lat = find(lat_out>= min(lat_in(:)) & lat_out<= max(lat_in(:)));
    lat_out = lat_out(ind_lat);
    startM = [ind_lon(1) ind_lat(1) ind_t(1)];
    countM = [length(ind_lon) length(ind_lat) length(ind_t)];
end
u_out = ncread(filename, 'UGRD_10maboveground', startM, countM );
v_out = ncread(filename, 'VGRD_10maboveground', startM, countM );

wnd.t = time_out;
wnd.lon = lon_out;
wnd.lat = lat_out;
wnd.u = u_out;
wnd.v = v_out;

end