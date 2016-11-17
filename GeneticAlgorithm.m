classdef GeneticAlgorithm
   
    properties
       
        m_mutation_rate;
        m_population_size;
        m_chromosone_length;
        m_population;
        m_structure;
        m_connections
        
    end
    
    methods
       
        function obj = GeneticAlgorithm(mutation_rate, population_size, neurons, connections)
            
            obj.m_mutation_rate = mutation_rate;
            obj.m_population_size = population_size;
            n = sum(neurons);
            %node count multiply rule parameter encoding and tau minus
            %count of output node + fitness
            obj.m_chromosone_length = n * (1 + 10 + 5) - neurons(end) * (1 + 10 + 5) + 1;
            obj.m_structure = neurons;
            obj.m_connections = connections;
            
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
        
        function net = Decoding(obj, index)
           
            binary2num([1 1], 10);
            net = SpikeNetwork(obj.m_structure, obj.m_connections, 0.1, 0);
            len = length(obj.m_structure);
            struct = obj.m_structure;
            
            for i = 1 : len - 1 
                for j = 1 : obj.m_structure(i)
                    ind = ((i > 1)*struct(i) + j) * 16 - 16 + 1;
                    net.neural{i}{1}{1}.rule = obj.m_population(index, ind);
                    net.neural{i}{1}{j}.t = binary2num(obj.m_population(index, ind + 11 : ind + 16), 100);
                    A = binary2num(obj.m_population(ind + 1 : ind + 10), 1000);
                    net.neural{i}{1}{j}.A1 = A;
                    net.neural{i}{1}{j}.A2 = A;
                end
            end
        end
        
        
        
    end
    
end