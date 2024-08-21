function [] = myPlot(x, y, z, linetype, mytitle, myxlabel, myylabel, myzlabel)
figure
if length(z) == 1
    plot(x, y, linetype)
    title(mytitle)
    xlabel(myxlabel)
    ylabel(myylabel)
    grid on

else
    plot3(x, y, z, linetype)
    title(mytitle)
    xlabel(myxlabel)
    ylabel(myylabel)
    zlabel(myzlabel)
    grid on 
end
end

