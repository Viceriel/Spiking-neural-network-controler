classdef SpikeNeuron
   
   properties
       
        output;
        tau;
        uprah;
        u
        R;
        C;
        i;
    end
    
    methods
        
        function obj = SpikeNeuron()
            obj.uprah = 0;
            obj.u = obj.uprah;
            obj.i = 0;
            obj.tau = 0.5;
            obj.R = 10;
            obj.C = obj.tau/obj.R;
        end
        
        function obj = OutputCompute(obj, thalamic_input)
           
                     
           obj.u = obj.u + (obj.uprah/obj.tau) - (obj.u/obj.tau) + (obj.R*thalamic_input)/obj.tau;
           
           if obj.u >= 40
               obj.i = obj.i + 1;
               obj.output = 1; 
               obj.u = obj.uprah;
               
           else
               
               obj.output = 0;
               
           end               
        end
    end
end