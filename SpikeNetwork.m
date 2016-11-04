classdef SpikeNetwork
   
    
    properties
       
        neural;
        weights;
        connections;
        layers;
        time;
        a;
        
    end
    
    methods
       
        function obj = SpikeNetwork(structure, connections)
           
            obj.time = 0;
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
            
            for i = 1 : obj.layers
               
                obj.neural{1}{1}{i} = ComputeOutput(obj.neural{1}{1}{i}, data(i));
                
            end
            
            len = length(obj.layers);
            
            for i = 2 : len
                
                for j = 1 : obj.layers(i)
                    
                    input = 0;
                   
                    for k = 1 : len
                       
                        for l = 1 : obj.layers(k)
                          
                            input = input + (obj.neural{k}{1}{l}.output*obj.weights{i}{j}{k}{l}.value);
                            
                        end
                        
                    end
                    
                    obj.neural{i}{1}{j} = OutputCompute(obj.neural{i}{1}{j}, input);
                    
                end
                
            end
                       
        end
        
    end
    
end