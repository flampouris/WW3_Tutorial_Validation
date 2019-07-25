function ls_fl = list_of_fl(wd,sfx)
%% Description 
% Returns the list of files for given directory and file suffix 
% To Call:
%  [ls_fl] = list_of_fl(wd,sfx)
%  
%   wd         : path of interest            // char
%   sfx        : suffix of files of interest // char
% 
%   ls_fl      : structure with the filenames in the path
%   e.g. ls_fl(:).name
%
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
if nargin == 0
    wd = pwd;
    sfx = '*';
elseif nargin == 1
    sfx = '*';
elseif nargin == 2
    
elseif nargin>2
  error ('No more than 2 input arguments')
end
ls_fl = dir([wd,'*',sfx]);
ls_fl = rmfield (ls_fl,{'date','bytes','isdir','datenum'});
if sfx=='*'
    ls_fl=ls_fl(3:end);
end
end
%% EoF list_of_fl.m