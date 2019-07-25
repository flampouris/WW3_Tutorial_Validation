function [myStyle, scrsz, map] = setup_hgexport
%% Description 
% The script setup_hgexport is used for defining the properties for 
% exporting figures with hgexport (myStyle), the screen size for the 
% figures (scrsz) and the colormap according to the author's personal taste!
% To Call:
%  [myStyle, scrsz, map] = setup_hgexport;
%  No input is required. 
% 
% myStyle      : structure with the properties of saving the figure 
% scrsz(1,:)   : Full Screen
% scrsz(2,:)   : Square
% scrsz(3,:)   : Orthogonal
% map          : Colormap
% To use, at the calling script, e.g.:
%
% [...] 
% h=figure('Position',scrsz(2,:));
% [...] plot
%
% hgexport(h,[output_path,'/',output_name], myStyle);
%
%% Credits
% Author        : Stylianos 'Stelios' Flampouris
%
% Comunication  : stylianos.flampouris@gmail.com
%
% version       : 1.0
%
% Date          : 27th Jan 2017
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
  
    myStyle=[];
    vers=ver;
    for i1=1:1:length(vers)
      if strcmpi (vers(i1).Name, 'matlab')
        myStyle = hgexport('factorystyle');
        myStyle.Format = 'png';
        myStyle.Resolution = 300;
        myStyle.FixedFontSize = 12;
        dum=groot;
      elseif strcmpi (vers(i1).Name, 'octave')
        dum=0;
        graphics_toolkit('gnuplot');
      end
    end
%
    scrsz.full = get(dum,'ScreenSize');
    scrsz.ver = [10 10 round(scrsz.full(4)*0.75) round(scrsz.full(4)*0.75)];
    scrsz.hor = [1 1 scrsz.full(3) round(scrsz.full(4)/2)];
%
map = [0 0 0; 0 1 0.75; 0.5 0 0; 1 0 0; 0 1 0; 0 0 1];
end