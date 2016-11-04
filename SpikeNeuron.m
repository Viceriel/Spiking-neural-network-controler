classdef SpikeNeuron
   
    properties
       
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
        
        function obj = OutputCompute(thalamic_input)
           
                     
           obj.v = obj.v + (0.04*obj.c^2 + 5*obj.v + 140 - obj.u + thalamic_input);
           obj.u = obj.u + (obj.a * (obj.b*obj.v-obj.u));
           
           if u >= 30
              
               obj.output = 1; 
               
           else
               
               obj.output = 0;
               
           end
                        
        end
        
    end
end