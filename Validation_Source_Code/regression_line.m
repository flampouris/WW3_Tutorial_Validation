function [AA, f, p] = regression_line (A,B)
%% regression_line.m
% Description
% The matlab function calculates the linear regression used to plot the 
% regression line. It has an equation of the form Y = a + bX, where X is 
% the explanatory variable and Y is the dependent variable. The slope of 
% the line is b, and a is the intercept (the value of y when x = 0).
%
%% License and more typicallities etc 
%   Copyright (C) 2017 Stylianos Flampouris
%   GNU Lesser General Public License
%       
%   Washington, DC, USA, Earth
%
%   For a copy of the GNU Lesser General Public License, 
%   see <http://www.gnu.org/licenses/>.
%% Communication - Comments             | Beers 
% email: stylianos.flampouris@noaa.gov  | stelios@flampouris.com
%% Code

AA = A(~isnan(A(:))&~isnan(B(:)));
BB = B(~isnan(A(:))&~isnan(B(:)));

[p] = polyfit(AA,BB,1);
f = polyval(p,AA);

end 
