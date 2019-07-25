%% RightHere_RightNow.m
function [lon, lat, time, hs, name, COLLOHS] = RightHere_RightNow(LON, LAT, TIME, SAMPLE, lon, lat, time, hs, name, method)
% Description
% The script collocates the gridded fields with scattered "points" in space 
% and time. The basic idea is the interpolation of the SAMPLE values at the 
% points at (lon,lat,time)
% 
% Input     :
%           LON                     : ND array with longtitude
%           LAT                     : ND array with latitude
%           TIME                    : ND array with time
%           SAMPLE                  : ND array with data, e.g. Hs
%           lon                     : 1d array with longtitude at PoI
%           lat                     : 1d array with latitude at PoI
%           time                    : 1d array with time of PoI
%           hs                      : 1d array with data to be used for
%                                   interpolation
%           name                    : 1d array with the names of the intsrument 
%           method                  : collocation method 
%                                     options: 'interp' 'kd' 'sd'
%           
% Output:
%           COLLOHS                 : 1d array with sample values at PoI
%           lon,lat,time,hs,name    : 1d arrays at PoI  
%
% To USE:    [lon, lat, time, hs, name, COLLOHS] = RightHere_RightNow(LON, LAT, TIME, SAMPLE, lon, lat, time, hs, name, 'interp')
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
%% 
% Trivial Info
% The name of the function comes from the song 
% More info: https://en.wikipedia.org/wiki/Right_Here,_Right_Now_(Fatboy_Slim_song)
% and enjoy at https://www.youtube.com/watch?v=R795KiMD4zs
%% The code
if isempty(method)
    method='sd';
end
COLLOHS = [];
hs_out=[];
lon_out=[];
lat_out=[];
time_out=[];
% cyc_out=[];
name_out=[];

switch method
    case 'interp'
        [COLLOHS,ind] = collocation(LON, LAT, TIME, SAMPLE, lon, lat, time);
        hs_out   =   hs(ind)  ;
        lon_out  =   lon(ind) ;
        lat_out  =   lat(ind) ;
        time_out =   time(ind);
%         cyc_out  =   cyc(ind) ;
        name_out  =   name(ind) ;
%
    case 'sd'
        
        domain_lon = min(lon(:)):0.5: max(lon(:));
        domain_lat = min(lat(:)):0.5: max(lat(:));
%       
        for i1=1:length(domain_lon)-1
            for i2=1:length(domain_lat)-1
                ind_keep_ob = find(lon>=domain_lon(i1) & lon<=domain_lon(i1+1) & ...
                                   lat>=domain_lat(i2) & lat<=domain_lat(i2+1) );
                if ~isempty(ind_keep_ob)
                    ind_keep = find(LON>=domain_lon(i1) & LON<=domain_lon(i1+1) & ...
                                    LAT>=domain_lat(i2) & LAT<=domain_lat(i2+1) & ...
                                    TIME>=min(time(ind_keep_ob))-0.2            & ...
                                    TIME<=max(time(ind_keep_ob))+0.2            );
                    
                    disp(['i1:',num2str(i1),', i2:', num2str(i2)])
                    disp(['Available obs:', num2str(length(ind_keep_ob))])
                    disp(['Available nodes:', num2str(length(ind_keep))])
                    if ~isempty(ind_keep)
%
                        [dum_col_Hs,ind] = collocation( LON(ind_keep), LAT(ind_keep), TIME(ind_keep), SAMPLE(ind_keep) ...
                                                      , lon(ind_keep_ob), lat(ind_keep_ob), time(ind_keep_ob)           );
                        
                        COLLOHS  =  [COLLOHS;dum_col_Hs];
                        dummy    =  hs(ind_keep_ob);
                        hs_out   =  [hs_out; dummy(ind)];
                        dummy    =  lon(ind_keep_ob);
                        lon_out  =  [lon_out; dummy(ind)];
                        dummy    =  lat(ind_keep_ob);
                        lat_out  =  [lat_out; dummy(ind)];
                        dummy    =  time(ind_keep_ob);
                        time_out =  [time_out; dummy(ind)];
%                         dummy    =  cyc(ind_keep_ob);
%                         cyc_out  =  [cyc_out; dummy(ind)];
                        dummy    =  name(ind_keep_ob);
                        name_out  =  [name_out; dummy(ind)];
% 
                        dum_col_Hs = []; ind_keep = []; ind_keep_ob=[]; dummy=[];
                    end
                end
            end
        end
    case 'kd'
        nop = 5;
        LON=LON(:);
        LAT=LAT(:); 
        TIME=TIME(:);
        SAMPLE=SAMPLE(:);
        
        datain=[LON,LAT,TIME];
        tree = kd_buildtree(datain,0);
        clear datain
        COLLOHS = [];
        for i1 = 1:1:10%length(lon)
            disp([num2str(i1),' A'])
            [index,dist,vec] = kd_knn(tree,[lon(i1), lat(i1), time(i1)],nop,0);
            [dum_col_Hs, ind] = collocation( LON(index), LAT(index), TIME(index), SAMPLE(index)...
                                           , lon(i1), lat(i1), time(i1)                       );
             disp([num2str(i1),' B', num2str(dum_col_Hs)])

            COLLOHS  = [COLLOHS;dum_col_Hs];
            hs_out   =  [hs_out; hs(ind)];
            lon_out  =  [lon_out; lon(ind)];
            lat_out  =  [lat_out; lat(ind)];
            time_out =  [time_out; time(ind)];
%             cyc_out  =  [cyc_out; cyc(ind)];
            name_out  =  [name_out; name(ind)];
%
            dum_col_Hs = []; ind_keep = []; ind_keep_ob=[]; dummy=[]; 
        end
end
hs   = hs_out;
lon  = lon_out;
lat  = lat_out;
time = time_out;
% cyc  = cyc_out;
name  = name_out;
end 
