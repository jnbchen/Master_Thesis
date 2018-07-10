function [ ] = CreateFigure( time,z0,z1,z2,xgyro,ygyro )
% Figure erstellen

t = time;
f1 = z0;
f2 = z1;
f3 = z2;

F1 = figure(1);
F1.Position(3) = 620;
F1.Color = [1,1,1];

% Unsichtbare Achse zu F1_axis_a
F1_axis_a2 = axes;
F1_axis_a2.Position = [0.077 0.08 1 0.91];
F1_axis_a2.XColor = [1,1,1];

axis(F1_axis_a2,[-2 2 -0.1 1.1]);
F1_axis_a2.YTick = 10;
F1_axis_a2.LineWidth = 1.0;

% Sichtbare Achse gyro
F1_axis_a = axes;
F1_axis_a.Position = [0.08 0.08 1 0.91];
F1_axis_a.XColor = [1,1,1];

axis(F1_axis_a,[-2 2 -0.1 1.1]);
F1_axis_a.LineWidth = 1.0;

% Unsichtbare Achse zu F1_axis_yy
F1_axis_b = axes;
F1_axis_b.Position = [0.167 0.08 1 0.91];
F1_axis_b.XColor = [1,1,1];

axis(F1_axis_b,[0 4 -7 9]);
F1_axis_b.YTick = 10;
F1_axis_b.LineWidth = 1.0;


F1_axes_yy = axes;
%PlotYY
[F1_axis_yy,Pyy1,Pyy3] = plotyy(t,f1,t,f3);

Pyy1.Color = [0,0,0.5]; %dunkelblau
F1_axis_yy(1).YColor = Pyy1.Color;
Pyy3.Color = [0.8500 0.3250 0.0980]; %orange
F1_axis_yy(2).YColor = Pyy3.Color;
F1_axis_yy(1).LineWidth = 1.0;
F1_axis_yy(2).LineWidth = 1.0;

hold(F1_axis_yy(1),'on');
Pyy2 = plot(F1_axis_yy(1),t,f2);
Pyy2.Color = [0 0.75 1]; %hellblau
Pyy2.LineStyle = '-';

F1_axis_yy(1).Position = [0.17 0.08 0.765 0.91];

axis(F1_axis_yy(1),[0 4 -7 9]);
axis(F1_axis_yy(2),[0 4 -5.5 1.75]);
F1_axis_yy(1).YTick = -7:1:9;
F1_axis_yy(2).YTick = 0:0.25:1.75;


F1_axis_ainv = axes;
F1_axis_ainv.Position = F1_axis_yy(1).Position;

Py4 = plot(F1_axis_ainv,t,xgyro);
Py4.Color = [0,0.5,0]; %dunkelgr?n
 
axis(F1_axis_ainv,[0 4 -0.1 1.1]);
F1_axis_ainv.Visible = 'off';

F1_axis_ainv.YTick = -0.1:0.05:0.1;
hold(F1_axis_ainv,'on');

Py5 = plot(F1_axis_ainv,t,ygyro);
Py5.Color = 'm';

%Eigenschaften ?bernehmen
F1_axis_a.YLim = F1_axis_ainv.YLim; 
F1_axis_a.YTick = F1_axis_ainv.YTick;
F1_axis_a.YColor = Py4.Color;

%Eigenschaften ?bernehmen
F1_axis_a2.YLim = F1_axis_ainv.YLim; 
% F1_axis_a2.YTick = F1_axis_ainv.YTick;
F1_axis_a2.YColor = Py5.Color;

%Eigenschaften ?bernehmen
F1_axis_b.YLim = F1_axis_yy(1).YLim; 
F1_axis_b.YColor = Pyy2.Color;

ylabel(F1_axis_a,'Winkelgeschwindigkeit (in rad/s)');
ylabel(F1_axis_yy(1),'Beschleunigung (in g)');
ylabel(F1_axis_yy(2),'Beschleunigung (in g)');
xlabel(F1_axis_yy(1),'Zeit (in s)');

axes(F1_axis_yy(1));
% Min & Max von f1 schreiben
indexmin = find(f1==min(f1));
t1min = t(indexmin)+0.05;
f1min = f1(indexmin);

indexmax = find(f1==max(f1));
t1max = t(indexmax)-0.05;
f1max = f1(indexmax);

strmin = ['Min = ',num2str(f1min)];
text(t1min,f1min,strmin,'HorizontalAlignment','left','Color',Pyy1.Color);

strmax = ['Max = ',num2str(f1max)];
text(t1max,f1max,strmax,'HorizontalAlignment','right','Color',Pyy1.Color);

% Min & Max von f2 schreiben
indexmin = find(f2==min(f2));
t2min = t(indexmin)+0.05;
f2min = f2(indexmin);

indexmax = find(f2==max(f2));
t2max = t(indexmax)-0.05;
f2max = f2(indexmax);

strmin = ['Min = ',num2str(f2min)];
text(t2min,f2min,strmin,'HorizontalAlignment','left','Color',Pyy2.Color);

strmax = ['Max = ',num2str(f2max)];
text(t2max,f2max,strmax,'HorizontalAlignment','right','Color',Pyy2.Color);

axes(F1_axis_yy(2));
% Min & Max von f3 schreiben
indexmin = find(f3==min(f3));
t3min = t(indexmin)+0.05;
f3min = f3(indexmin);

indexmax = find(f3==max(f3));
t3max = t(indexmax)-0.05;
f3max = f3(indexmax);

strmin = ['Min = ',num2str(f3min)];
text(t3min,f3min,strmin,'HorizontalAlignment','left','Color',Pyy3.Color);

strmax = ['Max = ',num2str(f3max)];
text(t3max,f3max,strmax,'HorizontalAlignment','right','Color',Pyy3.Color);

axes(F1_axis_ainv);
% Min & Max von xgyro schreiben
indexmin = find(xgyro==min(xgyro));
t4min = t(indexmin)+0.05;
xgyromin = xgyro(indexmin);

indexmax = find(xgyro==max(xgyro));
t4max = t(indexmax)-0.05;
xgyromax = xgyro(indexmax);

strmin = ['Min = ',num2str(xgyromin)];
text(t4min,xgyromin-0.01,strmin,'HorizontalAlignment','left','Color',Py4.Color);

strmax = ['Max = ',num2str(xgyromax)];
text(t4max,xgyromax+0.01,strmax,'HorizontalAlignment','right','Color',Py4.Color);

% Min & Max von ygyro schreiben
indexmin = find(ygyro==min(ygyro));
t5min = t(indexmin)+0.05;
ygyromin = ygyro(indexmin);

indexmax = find(ygyro==max(ygyro));
t5max = t(indexmax)-0.05;
ygyromax = ygyro(indexmax);

strmin = ['Min = ',num2str(ygyromin)];
text(t5min,ygyromin-0.01,strmin,'HorizontalAlignment','left','Color',Py5.Color);

strmax = ['Max = ',num2str(ygyromax)];
text(t5max,ygyromax+0.01,strmax,'HorizontalAlignment','right','Color',Py5.Color);

figureLegend = legend([Pyy1,Pyy2,Pyy3,Py4,Py5],'a_z (links)','a_z (rechts)','a_z (gefedert)','\omega_x (gefedert)','\omega_y (gefedert)');
figureLegend.Position = [0.75 0.26 0.1661 0.1047];


end

