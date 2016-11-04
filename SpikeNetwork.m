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
                        
                          if connections(i, k) == 1
                             
                              obj.weights{i}{j}{k}{l} = Synapse();
                              
                          else
                              
                              obj.weights{i}{j}{k}{l} = 0;
                              
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
        
    end
    
end