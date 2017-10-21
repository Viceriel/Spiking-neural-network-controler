classdef SpikeNetwork
   
    
    properties
       
        neural;     %neuron layers                
        weights;    %synapse layers
        connections; %connection matrix
        layers;      %count of layers
        time;        %time in network
        max;
        min;
        net_output;  %output vector of network
        
    end
    
    methods
       
        %Network constructor
        % structure- topology of network
        %connections- connections between layers
        %ma, mi- synapse bounding
        function obj = SpikeNetwork(structure, connections, ma, mi)
           
            obj.max = ma;
            obj.min = mi;
            obj.time = 1;
            len = length(structure);
            obj.layers = structure;
            obj.neural = {};
            obj.weights = {};
            obj.net_output = 0;
            
            %crerating connections between layers according to connection argument
            %every neuron(except input layer) has synapse vector in net topology
            %so there are four cycles, two for layer and neuron in layer, and another two for same reason(see comment two)
            for i = 2 : len
               
                obj.weights{i} = {};
                
                for j = 1 : obj.layers(i)
                    
                    obj.weights{i}{j} = {};
                    
                    for k = 1 : len
                        
                        obj.weights{i}{j}{k} = {};
                        
                        for l = 1 : obj.layers(k)
                                                     
                              obj.weights{i}{j}{k}{l} = Synapse();
                              
                              if connections(i, k) == 1
                                 obj.weights{i}{j}{k}{l}.value = (0.1 - 0.001)*rand(1, 1) + 0.001;
                              end
                                
                        end
                       
                    end
                    
                end
                
            end
            
            %creating layers of neurons
            %first layers is created from input neurons
            %another layers are spiking neurons
            for i = 1 : len
                
                neurons = {};
                
                for j = 1 : obj.layers(i)
                   
                    if i == 1
                       
                        neurons{j} = InputNeuron();
                        
                    else
                        
                        neurons{j} = SpikeNeuron();
                        
                    end
                    
                end
                
                obj.neural{i} = {neurons};
                
            end
            
        end
        
        %running network with input data
        %obj- network
        %data- vector of input data- obsolete because input neurons are injected in RunSim
        %return- network
        function obj = Run(obj, data)
            
            len = length(obj.layers);
            
            %running through first layer
            %if some neuron from first layer emitted spike, spike time is recorded
            %if isn't emitted spike, spike time is zero and time from spike is incremented
            for i = 1 : obj.layers(1)     
                obj.neural{1}{1}{i} = ComputeOutput(obj.neural{1}{1}{i});
                if obj.neural{1}{1}{i}.output == 1
                    obj.neural{1}{1}{i}.spike_time = obj.time;
                    for j = 2 : len
                         for k = 1 : obj.layers(j)
                            obj.weights{j}{k}{1}{i}.time_from_spike = 0;
                            obj.weights{j}{k}{1}{i}.spike_time = obj.time;
                         end
                    end
                else
                  for j = 2 : len
                    for k = 1 : obj.layers(j)
                        if obj.weights{j}{k}{1}{i}.spike_time == 0
                           obj.weights{j}{k}{1}{i}.time_from_spike = obj.weights{j}{k}{1}{i}.time_from_spike + 0.1;
                        end
                    end
                  end
                end                
            end
            
            %passing through remaining layers
            %after next layer, time is incremented
            for i = 2 : len
                obj.time = obj.time + 0.1;
                %computing input for neurons(output x synapse)
                for j = 1 : obj.layers(i)
                    input = 0;
                    for k = 1 : len
                        for l = 1 : obj.layers(k)
                            input = input + (obj.neural{k}{1}{l}.output*obj.weights{i}{j}{k}{l}.value); 
                        end    
                    end
                    
                    obj.neural{i}{1}{j} = OutputCompute(obj.neural{i}{1}{j}, input);
                    
                    %if neuron emitt spike, spike time is recorded
                    if obj.neural{i}{1}{j}.output == 1
                        obj.neural{i}{1}{j}.spike_time = obj.time;
                        
                        %recording spike time of neuron to synapses of neurons in next layer
                        if i ~= len
                           for x = i + 1 : len
                               for y = 1 : obj.layers(x)
                                    obj.weights{x}{y}{i}{j}.spike_time = obj.time;
                                    obj.weights{x}{y}{i}{j}.time_from_spike = 0;
                               end
                           end     
                        end
                         
                         %passing through all synapses of actual neuron
                         %applying STDP based on spike times
                         for m = 1 : len
                            for n = 1 : obj.layers(m)  
                                if obj.weights{i}{j}{m}{n}.value ~= 0
                                    if obj.weights{i}{j}{m}{n}.spike_time ~= 0
                                        obj = STDP(obj, obj.weights{i}{j}{m}{n}.spike_time -  obj.neural{i}{1}{j}.spike_time, [i j], [m n], obj.neural{m}{1}{n}.rule);
                                    else
                                        obj = STDP(obj, obj.weights{i}{j}{m}{n}.time_from_spike, [i j], [m n], obj.neural{m}{1}{n}.rule);
                                        obj.weights{i}{j}{m}{n}.time_from_spike = 0;
                                    end
                                end      
                            end        
                         end
                        
                        %reset of spike times
                        for x = i : -1 : 1
                            for y = 1 : obj.layers(x)
                                obj.weights{x}{y}{i}{j}.spike_time = 0;
                                obj.weights{i}{j}{m}{n}.time_from_spike = 0;
                            end
                        end
                    else %if no spike
                         if i ~= len
                          %incrementing of time distance from last spike to synapse of next layer neuron
                           for x = i + 1 : len
                               for y = 1 : obj.layers(x)
                                   if obj.weights{x}{y}{i}{j}.spike_time == 0
                                        obj.weights{x}{y}{i}{j}.time_from_spike = obj.weights{x}{y}{i}{j}.time_from_spike + 0.1;
                                   end
                               end
                           end     
                        end
                    end
                end
            end
            
            %this is because of first data pass, times in layers are 0.1, 0.2, 0.3
            %we want in second samples 0.2, 0.3, 0.4
            obj.time = obj.time - 0.1;
            
            %collecting  network output
            for i = 1 : obj.layers(len)
               
                obj.net_output(i) = obj.neural{len}{1}{i}.output;
                
            end
        end
        
        %Spike time dependent plasticity rule for updating synapses
        %parameters of STDP are optimized by Genetic algorithm
        function obj = STDP(obj, spike_differences, post, pre, rule)
            %if using STDP
            if rule == 1
                if spike_differences < 0 
                    obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value + obj.neural{post(1)}{1}{post(2)}.A1*exp(spike_differences / obj.neural{post(1)}{1}{post(2)}.t);
                else
                    obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value - obj.neural{post(1)}{1}{post(2)}.A2*exp(-spike_differences / obj.neural{post(1)}{1}{post(2)}.t);
                end
            else %ANTI STDP
                if spike_differences < 0
                    obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value - obj.neural{post(1)}{1}{post(2)}.A2*exp(-spike_differences / obj.neural{post(1)}{1}{post(2)}.t);
                else
                    obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value + obj.neural{post(1)}{1}{post(2)}.A1*exp(spike_differences / obj.neural{post(1)}{1}{post(2)}.t);
                end
            end
            
            %bounding of weight change
            if obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value > obj.max
                obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.max;
            elseif obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value < obj.min
                obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.min;
            end     
        end
        
    end
    
end
