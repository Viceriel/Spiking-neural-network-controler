classdef InputNeuron
   
    properties
        
        output
       
    end
    
    methods
        
        function obj = InputNeuron()
            
            obj.output = 0;
            
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