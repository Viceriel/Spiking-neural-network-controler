classdef Synapse
   
    properties
       
        value;
        rule;
        learning_rate;
        pre_synaptic_index;
        post_synaptic_index;
        pre_synaptic_time;
        post_synaptic_time;
        
    end
    
    methods
       
        function obj = Synapse()
           
            obj.value = 0;
            
        end
        
        function obj = UpdateSynapse(obj, foo)
           
            obj.value = obj.value + foo(obj.pre_synaptic_time - obj.post_synaptic_time);
            
        end
        
    end
end