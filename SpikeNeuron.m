classdef SpikeNeuron
   
    properties
       
        output;
        spike_time;
        rule;
        u;
        v;
        a;
        b;
        c;
        d;
        A1;
        A2;
        tau;
        
    end
    
    methods
        
        function obj = SpikeNeuron()
            
            obj.a = 0.02;
            obj.b = 0.2;
            obj.c = -50.5;
            obj.d = 2;
            obj.output = 0;
            obj.u = obj.c*obj.b;
            obj.v = obj.c;
            obj.spike_time = 0;
            obj.A1 = 1;
            obj.A2 = 1;
            obj.rule = 1;
            obj.tau = 10;
            
        end
        
        function obj = OutputCompute(obj, thalamic_input)
           
                     
           obj.v = obj.v + (0.04*obj.v^2 + 5*obj.v + 140 - obj.u + thalamic_input);
           obj.u = obj.u + (obj.a * (obj.b*obj.v-obj.u));
           
           if obj.v >= 30
              
               obj.output = 1; 
               obj.v = obj.c;
               obj.u = obj.u + obj.d;
               
           else
               
               obj.output = 0;
               
           end
                        
        end
        
    end
    
end