function [sat_wv,data] = altimeter_import(fl_nm, keep)
% Description
% The subroutine imports the altimeter data available from ifremer: 
% ftp://ftp.ifremer.fr/ifremer/cersat/products/swath/altimeters/waves/data/
% 
% [sat_wv,data] = altimeter_import(fl_nm, keep)
%
% sat_wv    : structure with daily data according to the "keep" value (see 
%             below for the content of keep_data)
% data      : array with all the data, the data are tabulated according to
%             the content of "keep_data"
%
% fl_nm     : structure with field .Name, it's the name of the file
%
% keep      : 'All' or anything else, All: keeps the data from all the
%             variables of NetCDF. With anything else, the data from the 
%             the short list of "keep_data" are kept. 
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
if strcmpi(keep,'all')
    keep_data = {'time'             ;...
                 'lat'              ;...
                 'lon'              ;...
                 'wind_speed'       ;...
                 'wind_speed_cor'   ;...
                 'sigma0'           ;...
                 'sigma0_cal'       ;...
                 'sigma0std'        ;...
                 'sigma0second'     ;...
                 'sigma0secondstd'  ;...
                 'swh'              ;...
                 'swhstd'           ;...
                 'swhcor'           ;...
                 'satellite'        ;...
                 'cycle'            ;...
                 'pass_number'      ;...    
                 'absolute_orbit'   };
else
    keep_data = {'time'             ;...
                 'lat'              ;...
                 'lon'              ;... 
                 'swh'              ;...
                 'cycle'            ;...
                 'satellite'        };
end
%
%% Basic Check of the input
if ~nargin == 1 || isempty(fl_nm)
    error('Declare at least one NC file')
end
%
%% The main

for i = 1:1:length(fl_nm)
    infowv = ncinfo(fl_nm(i).name);
    for i1 = 1:1:length(infowv.Variables)
        for i2 = 1:1:length(keep_data);
            if strcmpi(infowv.Variables(i1).Name, keep_data(i2))
                sat_wv(i).([infowv.Variables(i1).Name]).Attributes = infowv.Variables(i1).Attributes;
                sat_wv(i).([infowv.Variables(i1).Name]).Dimensions = infowv.Variables(i1).Dimensions;
                sat_wv(i).([infowv.Variables(i1).Name]).Size = infowv.Variables(i1).Size;
                sat_wv(i).([infowv.Variables(i1).Name]).Datatype = infowv.Variables(i1).Datatype;
                sat_wv(i).([infowv.Variables(i1).Name]).Data = ncread(fl_nm(i).name,infowv.Variables(i1).Name);
            end       
        end
    end
end
data=[];
for i=1:length(fl_nm)
    data1=[];
	for i2 = 1:1:length(keep_data);
        data1(:,i2)=sat_wv(i).(keep_data{i2}).Data;
    end
    data=[data;data1];
end
data(:,1) = datenum(1900,1,1,0,0,0)+data(:,1);
%%
% toc;