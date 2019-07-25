%% plot_timeseries.m
function plot_timeseries (A,B,buoy,labelX,labelY)
%% Description 
% The script plot_timeseries plots time series
% 
% Input
% A,B   : Structures with the following fields name, time, hs
% buoy  : An expected name at A.name, data of which will be plotted
% labelX,labelY : Labels for X and Y axis.
%
% To use: 
% plot_timeseries (ins,col.hs.buoy,buoy,labelX,labelY);
% 
%% Credits
% Author        : Stylianos 'Stelios' Flampouris
%
% Comunication  : stylianos.flampouris@gmail.com
%
% version       : 1.0
%
% Date          : 27th June 2017
%% The Code
plot(A.time(A.name==buoy),A.hs(A.name==buoy), A.time(A.name==buoy),B(A.name==buoy),'linewidth',2);
xlabel(labelX, 'fontsize',12,'fontweight','bold');
datetick('x','mmm-dd')
ylabel (labelY, 'fontsize',12,'fontweight','bold')
box on; grid on;
legend(['Buoy: ',num2str(buoy)],'Model', 'Location','Best');

end
