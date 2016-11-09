classdef SpikeNetwork
   
    
    properties
       
        neural;
        weights;
        connections;
        layers;
        time;
        max;
        min;
        
    end
    
    methods
       
        function obj = SpikeNetwork(structure, connections, ma, mi)
           
            obj.max = ma;
            obj.min = mi;
            obj.time = 1;
            len = length(structure);
            obj.layers = structure;
            obj.neural = {};
            obj.weights = {};
            
            for i = 2 : len
               
                obj.weights{i} = {};
                
                for j = 1 : obj.layers(i)
                    
                    obj.weights{i}{j} = {};
                    
                    for k = 1 : len
                        
                        obj.weights{i}{j}{k} = {};
                        
                        for l = 1 : obj.layers(k)
                                                     
                              obj.weights{i}{j}{k}{l} = Synapse();
                              
                              if connections(i, k) == 1
                                 obj.weights{i}{j}{k}{l}.value = (ma - mi)*rand(1, 1) + mi;
                              end
                                
                        end
                       
                    end
                    
                end
                
            end
            
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
        
        function obj = Run(obj, data)
            
            len = length(obj.layers);
            
            for i = 1 : obj.layers(1)     
                obj.neural{1}{1}{i} = ComputeOutput(obj.neural{1}{1}{i}, data(i));
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
                           obj.weights{j}{k}{1}{i}.time_from_spike = obj.weights{j}{k}{1}{i}.time_from_spike + 1;
                        end
                    end
                  end
                end                
            end
            
            obj.time = obj.time + 1;
            
            for i = 2 : len
                obj.time = obj.time + 1;
                for j = 1 : obj.layers(i)
                    input = 0;
                    for k = 1 : len
                        for l = 1 : obj.layers(k)
                            input = input + (obj.neural{k}{1}{l}.output*obj.weights{i}{j}{k}{l}.value); 
                        end    
                    end
                    
                    obj.neural{i}{1}{j} = OutputCompute(obj.neural{i}{1}{j}, input);
                    
                    if obj.neural{i}{1}{j}.output == 1
                        obj.neural{i}{1}{j}.spike_time = obj.time;
                        
                        if i ~= len
                           for x = i + 1 : len
                               for y = 1 : obj.layers(x)
                                    obj.weights{x}{y}{i}{j}.spike_time = obj.time;
                                    obj.weights{x}{y}{i}{j}.time_from_spike = 0;
                               end
                           end     
                        end
                        
                         for m = 1 : len
                            for n = 1 : obj.layers(m)  
                                if obj.weights{i}{j}{m}{n}.value ~= 0
                                    if obj.weights{i}{j}{m}{n}.spike_time ~= 0
                                        b = obj.neural{m}{1}{n}.spike_time;
                                        c = obj.neural{i}{1}{j}.spike_time;
                                        obj = STDP(obj, obj.neural{m}{1}{n}.spike_time - obj.neural{i}{1}{j}.spike_time, [i j], [m n], obj.neural{i}{1}{j}.rule);
                                    else
                                        obj = STDP(obj, obj.weights{i}{j}{m}{n}.time_from_spike, [i j], [m n], obj.neural{i}{1}{j}.rule);
                                        obj.weights{i}{j}{m}{n}.time_from_spike = 0;
                                    end
                                end      
                            end        
                         end
                         
                        for x = i : -1 : 1
                            for y = 1 : obj.layers(x)
                                obj.weights{x}{y}{i}{j}.spike_time = 0;
                                obj.weights{i}{j}{m}{n}.time_from_spike = 0;
                            end
                        end
                    else
                         if i ~= len
                           for x = i + 1 : len
                               for y = 1 : obj.layers(x)
                                   if obj.weights{x}{y}{i}{j}.spike_time == 0
                                        obj.weights{x}{y}{i}{j}.time_from_spike = obj.weights{x}{y}{i}{j}.time_from_spike + 1;
                                   end
                               end
                           end     
                        end
                    end
                end
            end    
        end
        
        function obj = STDP(obj, spike_differences, post, pre, rule)
            
            if rule == 1
                if spike_differences < 0 
                    obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value + obj.neural{post(1)}{1}{post(2)}.A1*exp(spike_differences / obj.neural{post(1)}{1}{post(2)}.tau)*obj.neural{post(1)}{1}{post(2)}.output;
                else
                    obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value - obj.neural{post(1)}{1}{post(2)}.A2*exp(-spike_differences / obj.neural{post(1)}{1}{post(2)}.tau)*obj.neural{post(1)}{1}{post(2)}.output;
                end
            else
                if spike_differences < 0
                    obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value - obj.neural{post(1)}{1}{post(2)}.A2*exp(-spike_differences / obj.neural{post(1)}{1}{post(2)}.tau)*obj.neural{post(1)}{1}{post(2)}.output;
                else
                    obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value + obj.neural{post(1)}{1}{post(2)}.A1*exp(spike_differences / obj.neural{post(1)}{1}{post(2)}.tau)*obj.neural{post(1)}{1}{post(2)}.output;
                end
            end
            
            if obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value > obj.max
                obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.max;
            elseif obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value < obj.min
                obj.weights{post(1)}{post(2)}{pre(1)}{pre(2)}.value = obj.min;
            end     
        end
        
    end
    
end