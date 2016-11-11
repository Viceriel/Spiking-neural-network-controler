clc
clear all
close all

net = SpikeNetwork([6 5 2],[0 0 0; 1 0 0; 1 1 0], 1, 0);

xRef = 0.1;
yRef = 0.1;
xVec = [];
yVec = [];
fiVec = [];
x_1 = 0;
y_1 = 0;
fi_1 = 0;
omegaR = 0;
omegaL = 0;

for i = 1:0.05:1;
    wR = [];
    wL = [];
    deltaX = abs(xRef - x_1);
    deltaY = abs(yRef - y_1);
    rho = sqrt((xRef - x_1)^2 + (yRef - y_1)^2);
    Phi = atan((yRef - y_1)/(xRef - x_1)) - fi_1;
    n = Phi/pi;
    deltaPhi = ((Phi/n) + pi)/(2*pi);
    omegaR1 = omegaR;
    omegaL1 = omegaL;
    
    for j = 1:100
        net = Run(net,[deltaX, deltaY, rho, deltaPhi, omegaR1, omegaL1]);
        wR = [wR net.net_output(1)];
        wL = [wL net.net_output(2)];
    end

omegaR = sum(wR)/10;
omegaL = sum(wL)/10;

sim('mobileSim');
xVec = [xVec x(2)];
yVec = [yVec y(2)];
fiVec = [fiVec fi(2)];

x_1 = x(2);
y_1 = y(2);
fi_1 = fi(2);
end

plot(x,y)