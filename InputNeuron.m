classdef InputNeuron
   
    properties
        
        output;
        spike_time;
        A1;
        A2;
        t;
        rule;
       
    end
    
    methods
        
        function obj = InputNeuron()
            
            obj.output = 0;
            obj.A1 = 0;
            obj.A2 = 0;
            obj.t = 0;
            obj.rule = 0;
        end
        
        function r = ComputeOutput(obj, input)
            
            if (rand(1, 1) < input)
               
                obj.output = 1;
                
            else
                
                obj.output = 0;
                
            end
            
            r = obj;
            
        end
        
    end
    
end