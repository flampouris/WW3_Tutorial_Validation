function [time_out, lat_out,lon_out,hs_out,cyc_out,sat_out]=altimeter_process(data,lon_in,lat_in,time_in)
% Description
% The script keeps the data that data insidee the domain defined by lon_in
% and lat_in.
% data      : array with the gridded data
%            data(:,1): time
%            data(:,2): latitude
%            data(:,3): long
%            data(:,4): hs
%            data(:,5): satellite cycle
%            data(:,6): satellite number (kind of ID as integer)
% 
% Output, arrays with data
%           time_out
%           lat_out  
%           lon_out
%           hs_out 
%           cyc_out
%           sat_out 
%
% To USE:    [time_out, lat_out,lon_out,hs_out,cyc_out,sat_out]=altimeter_process(data,lon_in,lat_in,time_in)
%   
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
%
% data=single(data);
%
ind = data(:,2)> min(lat_in(:))    ...
   &  data(:,2)< max(lat_in(:))    ...
   &  data(:,3)< max(lon_in(:))    ...
   &  data(:,3)> min(lon_in(:))    ...
   &  data(:,1)> min(time_in(:))   ...
   &  data(:,1)< max(time_in(:));
% 
data=data(ind,:);

time_out = double(data(:,1));
lat_out  = data(:,2);
lon_out  = data(:,3);
hs_out   = data(:,4);
cyc_out  = data(:,5);
sat_out  = data(:,6);

clear data;