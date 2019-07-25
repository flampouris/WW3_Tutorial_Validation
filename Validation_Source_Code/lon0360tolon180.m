function lon = lon0360tolon180 (lon)
%% Description
% The script calculates basic error statistics.
% 
% Input     : lon [0:360]
%
% Output    : lon [-180 180]
%
% To USE:     lon = lon0360tolon180 (lon)
%   
%% License and more typicallities etc 
%   Copyright (C) 2017 Stylianos Flampouris
%   GNU Lesser General Public License
%       
%   Washington, DC, USA, Earth
%
%   For a copy of the GNU Lesser General Public License, 
%   see <http://www.gnu.org/licenses/>.
%% The Code
lon(lon>=180) = mod(lon(lon>=180)+180,360)-180;
end