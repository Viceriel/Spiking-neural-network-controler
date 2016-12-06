function [ xVec, yVec, outOmegaR, outOmegaL, net ] = RunSim( net, xRef, yRef, time )

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

outOmegaR = [];
outOmegaL = [];

for i = 0:0.05:time;
    wR = [];
    wL = [];
    deltaX = abs(xRef - x_1);
    deltaY = abs(yRef - y_1);
    rho = sqrt((xRef - x_1)^2 + (yRef - y_1)^2);
%     Phi = atan((yRef - y_1)/(xRef - x_1)) - fi_1;
%     n = Phi/pi;
%     deltaPhi = ((Phi/n) + pi)/(2*pi);
    Phi = atan2((yRef - y_1),(xRef - x_1)) - fi_1;
    n = atan2(sin(Phi),cos(Phi));
    deltaPhi = (n + pi)/(2*pi);
    omegaR1 = omegaR;
    omegaL1 = omegaL;
    
    if deltaX > 1
        deltaX = 1;
    end
    if deltaY > 1
        deltaY = 1
    end
    if rho > 1
        rho = 1
    end
    omegaR1 = omegaR1 / 10;
    omegaL1 = omegaL1 / 10;
    in(1) = 1 / deltaX;
    in(1) = round(50 / in(1));
    in(2) = 1 / deltaY;
    in(2) = round(50 / in(2));
    in(3) = 1 / rho;
    in(3) = round(50 / in(3));
    in(4) = 1 / deltaPhi;
    in(4) = round(50 / in(4));
    in(5) = 1 /omegaR1;
    in(5) = round(50 / in(5));
    in(6) = 1 /omegaL1;
    in(6) = round(50 / in(6));
    
    net.neural{1}{1}{1}.count = in(1);
    net.neural{1}{1}{2}.count = in(2);
    net.neural{1}{1}{3}.count = in(3);
    net.neural{1}{1}{4}.count = in(4);
    net.neural{1}{1}{5}.count = in(5);
    net.neural{1}{1}{6}.count = in(6);
    
    for j = 1:50
        net = Run(net);
        wR = [wR net.net_output(1)];
        wL = [wL net.net_output(2)];
    end

omegaR = sum(wR)/5;
omegaL = sum(wL)/5;

outOmegaR = [outOmegaR omegaR];
outOmegaL = [outOmegaL omegaL];

sim('mobileSim');

xVec = [xVec x(2)];
yVec = [yVec y(2)];
fiVec = [fiVec fi(2)];

x_1 = x(2);
y_1 = y(2);
fi_1 = fi(2);

end

end

