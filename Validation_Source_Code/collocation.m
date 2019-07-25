function [collo_sample,indNaN] = collocation(LON, LAT, TIME, SAMPLE, lon, lat, time, method)
% Description
% The script collocates the gridded fields with scattered "points" in space 
% and time. The basic idea is the interpolation of the SAMPLE values at the 
% points at (lon,lat,time)
% 
% Input     :
%           LON(nlon,nlat,ntime)    : 3d matrice with longtitude
%           LAT(nlon,nlat,ntime)    : 3d matrice with latitude
%           TIME(nlon,nlat,ntime)   : 3d matrice with time
%           SAMPLE(nlon,nlat,ntime) : 3d matrice with data, e.g. Hs
%           lon                     : 1d array with longtitude at PoI
%           lat                     : 1d array with latitude at PoI
%           time                    : 1d array with time of PoI
%
% Output:
%           collo_sample            : 1d array with sample values at PoI
%           ind_NaN                 : 1d logical array with NaN's (if any)  
%
% To USE:    [collo_sample,indNaN] = collocation(LON, LAT, TIME, SAMPLE, lon, lat, time)
%
% To do :   Add check input arguments
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
if nargin<8
    method=1;
end
if method==1
    F = scatteredInterpolant(LON(:), LAT(:), TIME(:), SAMPLE(:),'linear','none');
    collo_sample = F(lon, lat, time);
elseif method==2
    collo_sample=interp3 (LON, LAT, TIME, SAMPLE, lon, lat, time);
end
indNaN = ~isnan(collo_sample);
collo_sample=collo_sample(indNaN);
lon=lon(indNaN);
lat=lat(indNaN);
time=time(indNaN);
end