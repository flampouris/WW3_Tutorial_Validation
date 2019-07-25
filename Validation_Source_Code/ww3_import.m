function [lon, lat, time, hs] = ww3_import(fl_nm)
%% Description
% The subroutine imports the ww3 structured and unstructured outputs:

% [ww3_hs,data] = ww3_import(fl_nm)
%
% ww3_hs    : structure with the hs data from ww3
% data      : array with all the data from ww3_hs
%
% fl_nm     : structure with field .Name, the name of the files to be imported. 
%             The list is created automatically from list_of_fl.m
%% Credits
% Author        : Stylianos 'Stelios' Flampouris
%
% Comunication  : stylianos.flampouris@gmail.com
%
% version       : 1.2
%
% Date          : 14-Jan-2017
% Date          : 25-May-2017 - Support of unstructured grid
%
% TODO          : Check input Arguments
%% License and more typicallities etc 
%   Copyright (C) 2015 Stylianos Flampouris
%   GNU Lesser General Public License
%       
%   Stennis Space Center, MS, USA, Earth
%
%   For a copy of the GNU Lesser General Public License, 
%   see <http://www.gnu.org/licenses/>.
%
%% The Code
%Basic Check of the input
%%
vers=ver;
for i1=1:1:length(vers)
   if strcmpi (vers(i1).Name, 'Octave')
      pkg load netcdf;
   end
end
%%
if ~nargin == 1 || isempty(fl_nm)
    error('Declare at least one NC file')
end
%%
keep_data = {'time'             ;...
             'latitude'         ;...
             'longitude'        ;...
             'hs'               ;...
             'MAPSTA'           };
%
%% The main
for i = 1:1:length(fl_nm)
    infowv = ncinfo(fl_nm(i).name);
    for i1 = 1:1:length(infowv.Variables)
        for i2 = 1:1:length(keep_data);
            if strcmpi(infowv.Variables(i1).Name, keep_data(i2))
                ww3_hs(i).([infowv.Variables(i1).Name]).Attributes = infowv.Variables(i1).Attributes;
                ww3_hs(i).([infowv.Variables(i1).Name]).Dimensions = infowv.Variables(i1).Dimensions;
                ww3_hs(i).([infowv.Variables(i1).Name]).Size = infowv.Variables(i1).Size;
                ww3_hs(i).([infowv.Variables(i1).Name]).Datatype = infowv.Variables(i1).Datatype;
                ww3_hs(i).([infowv.Variables(i1).Name]).Data = double(ncread(fl_nm(i).name,infowv.Variables(i1).Name));
            end       
        end
    end
end

lon=ww3_hs(1).longitude.Data;
lat=ww3_hs(1).latitude.Data;
if max(lon(:))>180
    lon=lon0360tolon180(lon);
end

for i=1:length(ww3_hs)
    ww3_hs(i).hs.Data = ww3_hs(i).hs.Data(:);
    if i==1
        hs=ww3_hs(1).hs.Data;
        time=ww3_hs(1).time.Data;
    else
        hs = cat(1,hs,ww3_hs(i).hs.Data);
        time = cat(1,time,ww3_hs(i).time.Data);
    end
%     if (length(ww3_hs(i).time.Data)==1)
%         ww3_hs(i).time.Data = ww3_hs(i).time.Data(:);
    
%     end

%     hs=[hs;ww3_hs(i).hs.Data];
%     time=[time;ww3_hs(i).time.Data];

end
time = datenum(1990,1,1,0,0,0)+time;

if length(hs(:))~=length(lon)
    hs = reshape(hs,length(lon),length(lat),length(time));
    hs = permute(hs, [2,1,3]);
    [lon, lat, time] = meshgrid(lon, lat, time);
    
end
end