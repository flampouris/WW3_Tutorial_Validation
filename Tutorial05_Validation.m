%% Validation of WW3 output
%%
clear;close all;clc;
tic;
pause ('off')
%% Addpath
nstep=1;
display(['Step ', num2str(nstep)]);
nstep=nstep+1;
%
addpath([pwd,'/Validation_Source_Code/']);
%
%%  Step 1
disp(['Step ', num2str(nstep),'; Press enter to continue']);
nstep=nstep+1;
pause
%
[glyph] = check_compatibility;
%
dir.w   = [pwd, glyph]; % Path of the tutorial
dir.sat = [dir.w,'Input_Altimeter', glyph]; % Path of the satellite observations
dir.ins = [dir.w,'Input_Insitu', glyph]; % Path of the in-situ observations
dir.md  = [dir.w,'Input_ww3_GOM_Katrina', glyph]; % Path of the model outputs
dir.msc = [dir.w,'Input_Misc', glyph]; % Path of miscellaneous inputs
dir.out = [dir.w,'Output', glyph]; % Path of the validation outputs
mkdir (dir.out);
dir.cde = [dir.w,'Validation_Source_Code']; % Path of the validation source code
%
[myStyle, scrsz, mymap] = setup_hgexport;
nfig=1;
%% Import Data
disp(['Step ', num2str(nstep),'; Press enter to continue']);
nstep=nstep+1;
pause
%
% coastlinedb
cl = load ([dir.msc, 'coastline.mat']);
%
% model output
list.m=list_of_fl(dir.md,'nc');
cd (dir.md);
[md.lon, md.lat, md.time, md.hs] = ww3_import(list.m);
md.time1d = squeeze(unique(md.time));
md.lon2d = squeeze(md.lon(:,:,1)');
md.lat2d = squeeze(md.lat(:,:,1)');
%
% data from altimeters
list.o=list_of_fl(dir.sat,'.nc');
cd (dir.sat);
[~, tmp] = altimeter_import(list.o, 'short');
[sat.time,sat.lat,sat.lon,sat.hs,sat.cyc,sat.name] = altimeter_process (tmp, md.lon, md.lat, md.time);
clear tmp; % Minimize memory requirements J
%
% data from buoys
[~, ins.time, ins.hs, ins.lon, ins.lat, ins.name] = ndbc_import ([dir.ins, 'ndbc_timeseries.mat'], md.lon, md.lat, md.time);
[ins.unqlon,ia]= unique(ins.lon);
ins.unqlat    = ins.lat(ia);
ins.unqbuoy   = ins.name(ia);
%
% Wind from GDAS:
[~, wnd.u, wnd.v, wnd.lon, wnd.lat, wnd.time] = gdas_import ([dir.msc,'wnd10m.gdas.200508.nc'],md.lon, md.lat, md.time);
ind_t = ismember(wnd.time, md.time);
in=permute(repmat(ind_t,1,length(wnd.lon),length(wnd.lat)),[2,3,1]);
wnd.time = wnd.time(ind_t);
wnd.u = reshape(wnd.u(in), length(wnd.lon),length(wnd.lat),length(wnd.time));
wnd.v = reshape(wnd.v(in), length(wnd.lon),length(wnd.lat),length(wnd.time));
wnd.sp = sqrt(wnd.u.^2+wnd.v.^2);
%
% keyboard

%% Step 4 Vizualization of input data
%% 4A Static 3D plot
disp(['Step ', num2str(nstep), 'A; Press enter to continue']);
pause
%
fig(nfig)=figure('Position',scrsz.full,'Name',['fig', num2str(nfig),'.png'] );
slice(md.lon,md.lat,md.time,md.hs, [-85, -95], 28, squeeze(md.time(1,1,15)))
xlabel('Longitude (^o)', 'fontsize',10,'fontweight','bold');
ylabel('Latitude (^o)', 'fontsize',10,'fontweight','bold');
zlabel('Date', 'fontsize',10,'fontweight','bold');
datetick('z','mmm-dd');
h = colorbar;
ylabel(h, 'Significant Wave Height (m)', 'rotation',270, 'fontsize',10,'fontweight','bold' );
print (fig(nfig), [dir.out,fig(nfig).Name], '-dpng');
nfig=nfig+1;
% keyboard;
%% 4B Animation
disp(['Step ', num2str(nstep), 'B; Press enter to continue']);
pause

fig(nfig)=figure('Position',scrsz.full,'Name',['fig', num2str(nfig),'.gif'] );
for i1 = 1:1:length(wnd.time)
    subplot(1,2,1); hold on;
    pcolor(wnd.lon,wnd.lat,squeeze(wnd.sp(:,:,i1))');
    shading flat;
    h = colorbar;
    ylabel(h, 'Wind Speed (m/s)', 'rotation',270, 'fontsize',10,'fontweight','bold' );
    caxis([min(wnd.sp(:)) max(wnd.sp(:))]);
    plot(cl.lon,cl.lat, 'black', 'linewidth',2);
    axis ([min(wnd.lon) max(wnd.lon) min(wnd.lat) max(wnd.lat)]);
    pbaspect([1 1 1])
    box on;
    title (datestr(wnd.time(i1)))
    xlabel('Longitude (^o)', 'fontsize',10,'fontweight','bold');
    ylabel('Latitude (^o)', 'fontsize',10,'fontweight','bold');
%   
    subplot(1,2,2); hold on;
    pcolor(md.lon2d,md.lat2d, md.hs(:,:,i1)');
    shading flat;
    h = colorbar;
    ylabel(h, 'Significant Wave Height (m)', 'rotation',270, 'fontsize',10,'fontweight','bold', 'VerticalAlignment', 'cap');
    caxis([min(md.hs(:)) max(md.hs(:))]);
    plot(cl.lon,cl.lat, 'black', 'linewidth',2);
    axis ([min(wnd.lon) max(wnd.lon) min(wnd.lat) max(wnd.lat)]);
    pbaspect([1 1 1])
    box on;
    title (datestr(md.time1d(i1)))
    xlabel('Longitude (^o)', 'fontsize',10,'fontweight','bold');
    ylabel('Latitude (^o)', 'fontsize',10,'fontweight','bold');
    drawnow
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    if i1 == 1
        imwrite(imind,cm,[dir.out,fig(nfig).Name],'gif', 'Loopcount',inf);
    else
        imwrite(imind,cm,[dir.out,fig(nfig).Name],'gif','WriteMode','append');
    end
end
nfig = nfig + 1;
%% 4C Plot the locations of observations
disp(['Step ', num2str(nstep), 'C; Press enter to continue']);
nstep=nstep+1;
pause

fig(nfig)=figure('Position',scrsz.full,'Name',['fig', num2str(nfig),'.png']); hold on;
plot(cl.lon,cl.lat)
scatter(sat.lon,sat.lat,10,sat.name);
grid on; box on;
title(['Available Measurements : ',datestr(min(md.time(:)),'mmmm dd'),'-',datestr(max(md.time(:)),'mmmm dd')] , 'fontsize',10,'fontweight','bold')
xlabel('Longitude (^o)', 'fontsize',10,'fontweight','bold');
ylabel('Latitude (^o)', 'fontsize',10,'fontweight','bold');
limaxis = [min(md.lon(:)) max(md.lon(:)) min(md.lat(:)) max(md.lat(:))];% min(ob_sat(:)) max(ob_sat(:))];
h = colorbar;
colormap(mymap);
set(h,'YTick',2:1:7)
ylabel(h, 'Satellite', 'rotation',270, 'fontsize',10,'fontweight','bold' );
axis(limaxis);
%% 4D Plot Buoy locations
for i1 = 1:1:length(ins.unqbuoy)
    text( ins.unqlon(i1)+0.25 , ins.unqlat(i1)+0.25, num2str (ins.unqbuoy(i1))...
    , 'FontWeight','bold','Fontsize', 12, 'BackgroundColor', 'white', 'EdgeColor', [0,0.1,0.8])
end
scatter(ins.unqlon,ins.unqlat, 'redo','filled')
print (fig(nfig), [dir.out,fig(nfig).Name], '-dpng');
nfig=nfig+1;
%% Step 5. Data collocation and synchronization
% 
disp(['Step ', num2str(nstep),' Press enter to continue']);
pause
[sat.lon, sat.lat, sat.time, sat.hs, sat.name, col.hs.sat] = RightHere_RightNow (md.lon, md.lat, md.time, md.hs, sat.lon, sat.lat, sat.time,sat.hs, sat.name, 'interp');
%
[ins.lon, ins.lat, ins.time, ins.hs, ins.name, col.hs.buoy] = RightHere_RightNow(md.lon, md.lat, md.time, md.hs, ins.lon, ins.lat, ins.time,ins.hs, ins.name, 'interp');
% keyboard
%% Plot some buoy data
disp(['Step ', num2str(nstep), 'A; Press enter to continue']);
nstep=nstep+1;
pause

fig(nfig)=figure('Position',scrsz.hor ,'Name',['fig', num2str(nfig),'.png']); hold on;
buoy = 42001;
labelX = 'Date'; labelY = 'Significant Wave Height (m)';
plot_timeseries (ins,col.hs.buoy,buoy,labelX,labelY);
print (fig(nfig), [dir.out,fig(nfig).Name], '-dpng');
nfig=nfig+1;

% keyboard;
%% Step 6. Descriptive statistics
% 
disp(['Step ', num2str(nstep),' Press enter to continue']);
pause

bins = 0:0.25:10;
[count.abs.buoy,center.buoy] = hist(ins.hs,bins);
[count.abs.sat,center.sat] = hist(sat.hs,bins);
[count.abs.md,center.md] = hist(md.hs,bins);
[count.abs.mdcolsat,center.colsat] = hist(col.hs.sat,bins);
[count.abs.mdcolbuoy,center.colbuoy] = hist(col.hs.buoy,bins);
count.rel.buoy = 100*(count.abs.buoy./sum(count.abs.buoy(:)));
count.rel.sat = 100*(count.abs.sat./sum(count.abs.sat(:)));
count.rel.md = 100*(count.abs.md./sum(count.abs.md(:)));
count.rel.mdcolsat = 100*(count.abs.mdcolsat./sum(count.abs.mdcolsat(:)));
count.rel.mdcolbuoy = 100*(count.abs.mdcolbuoy./sum(count.abs.mdcolbuoy(:)));

% keyboard
%%
disp(['Step ', num2str(nstep), 'A; Press enter to continue']);
pause

fig(nfig)=figure('Position',scrsz.full ,'Name',['fig', num2str(nfig),'.png']); hold on;
subplot(1,2,1); hold on;
plot(center.buoy,count.rel.buoy,'-o',center.colbuoy,count.rel.mdcolbuoy,'-x', 'linewidth',2.5)
legend('In-Situ','WW3')
grid on, box on; axis square;
xlabel('Significant Wave Height (m)', 'fontsize',10,'fontweight','bold');
ylabel('Frequency (%)', 'fontsize',10,'fontweight','bold');
subplot(1,2,2); hold on;
plot(center.sat,count.rel.sat,'-o',center.colsat,count.rel.mdcolsat,'-x', 'linewidth',2.5)
legend('Satellite','WW3')
grid on, box on; axis square;
xlabel('Significant Wave Height (m)', 'fontsize',10,'fontweight','bold');
ylabel('Frequency (%)', 'fontsize',10,'fontweight','bold');
print (fig(nfig), [dir.out,fig(nfig).Name], '-dpng');
nfig=nfig+1;
%% 
disp(['Step ', num2str(nstep), 'B; Press enter to continue']);
nstep=nstep+1;
pause

fig(nfig)=figure('Position',scrsz.full ,'Name',['fig', num2str(nfig),'.png']); hold on;
subplot(1,2,1); hold on;
qqplot(ins.hs,col.hs.buoy)
axis equal; axis normal; axis square;axis tight;
box on;grid on;
title('Buoy - WW3')
subplot(1,2,2); hold on;
qqplot(sat.hs,col.hs.sat)
axis equal; axis normal; axis square;axis tight;
box on;grid on;
title('Satellite - WW3')
print (fig(nfig), [dir.out,fig(nfig).Name], '-dpng');
nfig=nfig+1;

% keyboard
%% Step 7. Linear Regression
disp(['Step ', num2str(nstep), '; Press enter to continue']);
nstep=nstep+1;
pause

[N.abs.buoy,Centers.buoy]=hist3([ins.hs,col.hs.buoy], {bins bins});
[N.abs.sat,Centers.sat]=hist3([sat.hs,col.hs.sat], {bins bins});
N.rel.buoy=100*N.abs.buoy/sum(N.abs.buoy(:));
N.rel.sat=100*N.abs.sat/sum(N.abs.sat(:));
N.rel.buoy(N.rel.buoy==0)=NaN;
N.rel.sat(N.rel.sat==0)=NaN;

R.buoy = corrcoef(ins.hs,col.hs.buoy);
R.sat = corrcoef(sat.hs,col.hs.sat);

p.buoy = polyfit(ins.hs,col.hs.buoy,1);
p.sat = polyfit(sat.hs,col.hs.sat,1);

fig(nfig)=figure('Position',scrsz.full ,'Name',['fig', num2str(nfig),'.png']);
subplot(1,2,1); hold on;
pcolor(Centers.buoy{1},Centers.buoy{2},N.rel.buoy)
shading flat;
plot([0 12], [0 12],'r','linewidth',2)
y_fit = polyval(p.buoy,[0 12]);
plot([0 12],y_fit,'black','linewidth',2);
xlabel('SWH from Buoys (m)', 'fontsize',10,'fontweight','bold');
ylabel('SWH from WW3 (m)', 'fontsize',10,'fontweight','bold');
text (1,11, ['y =',num2str(p.buoy(1)),'x ',num2str(p.buoy(2))], 'fontsize',10,'fontweight','bold' )
text (1,10, ['Cor Coef = ', num2str(R.buoy(1,2))], 'fontsize',10,'fontweight','bold' );
axis([0 12 0 12]); axis square;
box on; grid on;
h = colorbar;
ylabel(h, 'Frequency (%)', 'rotation',270, 'fontsize',10,'fontweight','bold' );

subplot(1,2,2); hold on;
pcolor(Centers.sat{1},Centers.sat{2},N.rel.sat)
shading flat;
plot([0 12], [0 12],'r','linewidth',2)
y_fit = polyval(p.sat,[0 12]);
plot([0 12],y_fit,'black','linewidth',2);
xlabel('SWH fron Satellites (m)', 'fontsize',10,'fontweight','bold');
ylabel('SWH from WW3 (m)', 'fontsize',10,'fontweight','bold');
axis([0 12 0 12]); axis square;
text (1,11, ['y =',num2str(p.sat(1)),'x ',num2str(p.sat(2))], 'fontsize',10,'fontweight','bold' )
text (1,10, ['Cor Coef = ', num2str(R.sat(1,2))], 'fontsize',10,'fontweight','bold' );
box on; grid on;
h = colorbar;
ylabel(h, 'Frequency (%)', 'rotation',270, 'fontsize',10,'fontweight','bold' );
print (fig(nfig), [dir.out,fig(nfig).Name], '-dpng');
nfig=nfig+1;
% keyboard
%% Step 8. Error analysis 
disp(['Step ', num2str(nstep), '; Press enter to continue']);
nstep=nstep+1;
pause

[error.buoy.bias, error.buoy.sigma, error.buoy.rmse, error.buoy.si, ~] = error_stats(ins.hs,col.hs.buoy);
[error.sat.bias, error.sat.sigma, error.sat.rmse, error.sat.si, error.sat.diff] = error_stats(sat.hs,col.hs.sat);

fig(nfig)=figure('Position',scrsz.full ,'Name',['fig', num2str(nfig),'.png']);
subplot(1,2,1); hold on;
plot(cl.lon,cl.lat)
scatter(sat.lon,sat.lat,10,error.sat.diff)
axis equal;
grid on; box on;
title(['Satellite Orbits : ',datestr(min(md.time(:)),'mmmm dd'),'-',datestr(max(md.time(:)),'mmmm dd')] , 'fontsize',10,'fontweight','bold')
xlabel('Longitude (^o)', 'fontsize',10,'fontweight','bold');
ylabel('Latitude (^o)', 'fontsize',10,'fontweight','bold');
limaxis = [min(md.lon(:)) max(md.lon(:)) min(md.lat(:)) max(md.lat(:))];% min(ob_sat(:)) max(ob_sat(:))];
h = colorbar;
ylabel(h, 'SWH_{WW3} - SWH_{Obs} (m)', 'rotation',270, 'fontsize',10,'fontweight','bold' );
axis(limaxis);
caxis([-max(error.sat.diff(:)) max(error.sat.diff(:))]);%max(diff(:))]);
%
subplot(1,2,2); hold on;
[ndiff,bin_diff]=hist(error.sat.diff,20);
ndiff=100*ndiff./sum(ndiff(:));
bar(bin_diff,ndiff,'b', 'linewidth', 3);
grid on, box on; axis square;
xlabel('SWH_{WW3} - SWH_{Obs} (m)', 'fontsize',10,'fontweight','bold');
ylabel('Frequency (%)', 'fontsize',10,'fontweight','bold');
text(1.5,21.5,['bias   =',num2str(round(error.sat.bias*100)/100)], 'fontsize',10,'fontweight','bold');
text(1.5,19.5,['median =',num2str(round(median(error.sat.diff)*100)/100)], 'fontsize',10,'fontweight','bold');
text(1.5,17.5,['rmse   =',num2str(round(error.sat.rmse*100)/100)], 'fontsize',10,'fontweight','bold');
text(1.5,15.5,['SI     =',num2str(round(error.sat.si*100)/100)], 'fontsize',10,'fontweight','bold');
print (fig(nfig), [dir.out,fig(nfig).Name], '-dpng');
nfig=nfig+1;

% keyboard;
%% Step 9. Taylor diagram
disp(['Step ', num2str(nstep), '; Press enter to continue']);
nstep=nstep+1;
pause

buoy = [ 42001,42002,42038]; %Buoy Of Interest

for i1 = 1:length(buoy)
    ind = find(ins.name==buoy(i1));
    if ~isempty(ind)
        ts{:,i1} = [ins.hs(ind), col.hs.buoy(ind)];
    end
end
fig(nfig)=figure('Position',scrsz.ver ,'Name',['fig', num2str(nfig),'.png']);
stt = norm_taylor_diag(ts);

% legend for taylor diagrams

figure(100)
ax = gca;
marker = 'osd^v><ph+*x.';
marker_edge_color = ax.ColorOrder;
marker_face_color = ax.ColorOrder;
close(100)
n = 0;
for k = 1:length(ts)
    n = n + 1;
    h(n) = plot(-1, -1);
    h(n).LineStyle = 'none';
    h(n).Marker = marker(k);
    h(n).MarkerFaceColor = 'w';
    h(n).MarkerEdgeColor = 'k';
end

n=0;
for k = 2:size(ts{1}, 2)
    n = n + 1;
    h(n) = plot(-1, -1);
    
    h(n).LineStyle = 'none';
    h(n).Marker = 'o';
    h(n).MarkerFaceColor = marker_face_color(k - 1, :);
    h(n).MarkerEdgeColor = marker_edge_color(k - 1, :);
end

h = legend(h);
for i1 = 1:length(buoy)
   h.String{i1} = num2str(buoy(i1));
end

print (fig(nfig), [dir.out,fig(nfig).Name], '-dpng');
nfig=nfig+1;

% keyboard;
%%
toc;
% EoF
