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
        
    end
    
    methods
        
        function obj = SpikeNeuron()
            
            obj.u = 0;
            
        end
        
        function obj = OutputCompute()
           
                     
           obj.v = obj.v + (0.04*obj.c^2 + 5*obj.v + 140 - obj.u + sum);
           obj.u = obj.u + (obj.a * (obj.b*obj.v-obj.u));
                        
        end
        
    end
end