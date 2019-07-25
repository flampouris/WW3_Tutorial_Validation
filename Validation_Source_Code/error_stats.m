function [bias,sigma_d,rmse,si,diff]=error_stats(obs,mod)
% Description
% The script calculates basic error statistics.
% 
% Input     :
%           obs     : dataset1
%           mod     : dataset2
%
% Output: bias,rmse,si,slope : real with the values 
%         diff = mod-obs
%
% To USE:    [bias,sigma, rmse,si,diff]=error_stats(obs,mod)
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
obs  = obs(:);
mod  = mod(:);
diff = mod-obs;
bias = mean(diff);
sigma_d = sqrt( sum ( ( mod - obs - bias).^2 ) /( length(mod)-1 ) );
rmse = sqrt( sum ( diff.^2) / ( length(mod)) );
si   = rmse/mean(obs);

