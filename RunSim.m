function [ xVec, yVec ] = RunSim( net, xRef, yRef, time )

xVec = [];
yVec = [];
fiVec = [];
global x_1
global y_1
global fi_1
global omegaR
global omegaL
global fi
x_1 = 10;
y_1 = 10;
fi_1 = 0;
omegaR = 0;
omegaL = 0;

for i = 1:0.05:time;
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
    
    for j = 1:50
        net = Run(net,[deltaX, deltaY, rho, deltaPhi, omegaR1, omegaL1]);
        wR = [wR net.net_output(1)];
        wL = [wL net.net_output(2)];
    end

omegaR = sum(wR)/5;
omegaL = sum(wL)/5;

sim('mobileSim');

xVec = [xVec x(2)];
yVec = [yVec y(2)];
fiVec = [fiVec fi(2)];

x_1 = x(2);
y_1 = y(2);
fi_1 = fi(2);

end

end

