function [ins_wv, time_out, hs_out, lon_out,lat_out, name_out]=ndbc_import (filename, lon_in, lat_in, time_in)
%% ndbc_import.m
%% Description
% The subroutine imports insitu data available from NDBC: 
% http://www.ndbc.noaa.gov/
% The database with the data has been created by S.Fl.
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
% Output    : ins_wv - structure with the data, see the header for the content of
%             each collumn at .data 
%             data - To be added as output
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
if exist(filename,'file')==2
    display(['NDBC data to be imported... Be patient!']);
    load (filename);
else
    error(['The ', filename, ' does not exist!']);
end

coor = [];
time_out = [];
hs_out = [];
lon_out = [];
lat_out = [];
name_out = [];

cnt = 1;
for i1 = 1:length(ndbc)
    if ~isempty (ndbc(i1).data) 
        datedum = datenum(ndbc(i1).data(:,1:6));
        if ndbc(i1).coordinates(1)>=min(lat_in(:))  ...
            && ndbc(i1).coordinates(1)<=max(lat_in(:)) ...
            && ndbc(i1).coordinates(2)>=min(lon_in(:)) ...
            && ndbc(i1).coordinates(2)<=max(lon_in(:))

            ind = find (datedum>=min(time_in(:)) & datedum<=max(time_in(:)));
            if ~isempty(ind)
                coor = [coor;ndbc(i1).coordinates(2),ndbc(i1).coordinates(1)];
                dum = ndbc(i1);
                dum.data = dum.data(ind,:);
                indnan = ~isnan(dum.data(:,10));
                dum.data = dum.data(indnan,:);
                          
                if ~isempty (dum.data)
                    ins_wv(cnt).time = datenum(dum.data(:,1:6));
                    ins_wv(cnt).name = dum.name;
                    ins_wv(cnt).lon = dum.coordinates(2);
                    ins_wv(cnt).lat = dum.coordinates(1);
                    ins_wv(cnt).hs = dum.data(:,10);
                    
                    One = ones(size(ins_wv(cnt).time));
                    time_out = [time_out; ins_wv(cnt).time];
                    hs_out = [hs_out; ins_wv(cnt).hs];
                    lon_out = [lon_out; ins_wv(cnt).lon*One];
                    lat_out = [lat_out; ins_wv(cnt).lat*One];
                    name_out = [name_out; str2num(ins_wv(cnt).name)*One];
                    cnt = cnt + 1;   
                end
                
            end
        end
    end
end
end