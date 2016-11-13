classdef GeneticAlgorithm
   
    properties
       
        m_mutation_rate;
        m_population_size;
        m_chromosone_length;
        m_population;
        
    end
    
    methods
       
        function obj = GeneticAlgorithm(mutation_rate, population_size, neurons)
            
            obj.m_mutation_rate = mutation_rate;
            obj.m_population_size = population_size;
            n = sum(neurons);
            obj.m_chromosone_length = n * (1 + 10 + 5) - neurons(end) * (1 + 10 + 5);
            
        end
        
        function obj = Initialization(obj)
           
            len =  obj.m_population_size;
            chromosone = obj.m_chromosone_length;
            obj.m_population = zeros(len, chromosone);
            
            for i = 1 : len  
                for j = 1 : chromosone
                   obj.m_population(i, j) = randi([0 1]); 
                end
            end
        end
        
        
        
    end
    
end