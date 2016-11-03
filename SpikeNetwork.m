classdef SpikeNetwork
   
    
    properties
       
        neural;
        weights;
        connections;
        layers;
        time;
        
    end
    
    methods
       
        function obj = SpikeNetwork(structure, connections)
           
            obj.time = 0;
            len = length(structure);
            obj.layers = structure;
            obj.neural = {};
            
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
        
    end
    
end