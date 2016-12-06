clc
clear all
close all

global x_1
global y_1
global omegaR
global omegaL
global fi_1
global fi
% 
% net = SpikeNetwork([6 5 2], [0 0 0; 1 0 0; 1 1 0], 1, 0);
% RunSim(net, 0.1, 0.1, 10);

EA = GeneticAlgorithm(0.05, 2, [6 5 2], [0 0 0; 1 0 0; 1 1 0]);
EA = Evolve(EA, 2);

% for i = 1 :3
%     net = Decoding(EA, i, EA.m_population)
%     [x, y, wR, wL, net] = RunSim(net, 10.1, 10.1, 5);
%     figure();
%     plot(x, y)
%     hold all
%     plot(10.1, 10.1, 'r+');
% end

