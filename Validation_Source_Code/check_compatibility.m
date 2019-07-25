 function [glyph]=check_compatibility
%% octave_compatible.m
%% *Description*
% The script octave_compatible is used for checking if MATLAB or OCTAVE is
% used and loading the octave packages (toolboxes) for the validation.
%% *Use*
% Call the script octave_compatible
% INPUT     : None
% OUTPUT    : glyph :: slash or backslash depending on OS
%
%% *Credits*
% Author        : Stylianos 'Stelios' Flampouris
% Comunication  : stylianos.flampouris@noaa.gov
% version       : 1.0
% Date          : 14th Jun 2017
%% *License and more typicallities etc* 
%   Copyright (C) 2017 Stylianos Flampouris
%   GNU Lesser General Public License
%
%   Washington, DC, USA, Earth
%
%   For a copy of the GNU Lesser General Public License, 
%   see <http://www.gnu.org/licenses/>.
%
%% *Source Code*
vers=ver;
for i1=1:1:length(vers)
    if strcmpi (vers(i1).Name, 'Octave')
        pkg load statistics;
        pkg load netcdf;
        disp([vers(i1).Name,'is used and the nessecary Octave Packages are loaded!']);
    elseif strcmpi (vers(i1).Name, 'Matlab')
        disp([vers(i1).Name,' ', vers(i1).Release,' is used!']);
    end
end
%% MS vs UNIX
% OS depending Variables
if ispc
    glyph = '\';
elseif isunix
    glyph = '/';
end

disp({['Your system is ',computer];'Good Luck with the tutorial!'});