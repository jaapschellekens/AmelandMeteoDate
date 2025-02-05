#!/usr/local/bin/octave -q
ls binfiles/
pref = input('Input file prefix to use for report: ','S');

of = fopen(sprintf('%s.tex',pref),'w');

% Write the TeX header...

% Now load the files...
eval(sprintf('load -force binfiles/%s_t',pref));
eval(sprintf('load -force binfiles/%s_s',pref));
eval(sprintf('load -force binfiles/%s_f',pref));

xt = eval(sprintf('%s_t;',pref));
xs = eval(sprintf('%s_s;',pref));
xf = eval(sprintf('%s_f;',pref));

fprintf(of,'\\documentclass{article}\\author{J. Schellekens}');
fprintf(of,'\\usepackage{epsfig}\\title{Report of %s}\\begin{document}\\maketitle\n',pref);

fprintf(of,'\\footnotesize\\begin{verbatim}');
fprintf(of,"Ameland meteo setup: Report of the file %s\n",pref);
fprintf(of,'\n================================================================================\n');
xsl = \
    ["Accu";"T(log)";"Regen";"T(1)";"T(2)";"Wind(1)";"Wind(2)";"Inrad";"Refrad";"Wind";"Winddir";"Dummy";"Dummy";"Dummy","Dummy"];
fprintf(of,'\nHourly data:\n');
ts_stats(xs,'%14.2f',xsl,of);
xtl = ["Tc1"; "Tc2" ;"std1"; "std2"];
fprintf(of,'\n30 min data:\n');
ts_stats(xt,'%14.2f',xtl,of);
fprintf(of,'\\end{verbatim}\\clearpage\\centerline{\\epsfig{figure=%s1.eps}}\n',pref);
fprintf(of,'\\centerline{\\epsfig{figure=%s2.eps}}\n',pref);

## Now make plots of T, RH, cumm P, Wind, Winddir, irad
## Use the hourly values for this.
gset term  postscript   eps 

eval(sprintf('gset output \'%s1.eps\'',pref)); 
ts_init;
gset key left
subplot(1,1,1);
subplot(3,1,1);
ts_plot(xs(:,[1 5 6]),'Temperature','lines',1);
subplot(3,1,2);
ts_plot(xs(:,[1 7 8]),'Windspeed','lines',1);
subplot(1,1,1);
gset output

eval(sprintf('gset output \'%s2.eps\'',pref)); 
subplot(3,1,1)
ts_plot(xs(:,[1 9]),'Radiation','lines',1);
subplot(3,1,2);
ts_plot(xs(:,[1 12]),'Winddirection','lines',1);
subplot(3,1,3);
ts_plot([xs(:,1) cumsum(xs(:,4))],'Precipitation','lines',1);
subplot(1,1,1);
gset output
fprintf(of,'\\end{document}');

