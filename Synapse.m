classdef Synapse
   
    properties
       
        value;
        spike_time;
        time_from_spike;
        
    end
    
    methods
       
        function obj = Synapse()
           
            obj.value = 0;
            obj.time_from_spike = 0;
            obj.spike_time = 0;
            
        end
        
    end
end