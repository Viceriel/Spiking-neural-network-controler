classdef SpikeNeuron
   
    properties
       
        thalamic_input;
        output;
        u;
        v;
        a;
        b;
        c;
        d;
        weights;
        previous_layers;
        len;
        reccurent_weight;
        
    end
    
    methods
        
        function obj = SpikeNeuron(neurons, reccurency)
            
            if neurons ~= true
                
                obj.previous_layers = neurons;
                obj.len = size(obj.previous_layers);
                obj.weights = zeros(obj.len);
            
                for i = 1 : obj.len(1)
               
                    for j = 1 : obj.len(2)
                    
                   
                        obj.weights(i, j) = rand() * 2 - 1;
                    
                    end
                
                end
            
             obj.recurent_weight = reccurency * (rand() * 2 - 1);
             
            end
            
        end
        
        function obj = OutputCompute()
           
           sum = 0;
           sum = obj.weights(1, :) * obj.previous_layers{1}{1 : end}.output;
           sum = sum + obj.weights(2, :)* obj.previous_layers{2}{1 : end}.output;
           sum = sum + (obj.reccurent_weight * obj.v);
           
           obj.v = obj.v + (0.04*obj.c^2 + 5*obj.v + 140 - obj.u + sum);
           obj.u = obj.u + (obj.a * (obj.b*obj.v-obj.u));
            
            
        end
    end
end