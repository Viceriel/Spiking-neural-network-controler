classdef GeneticAlgorithm
   
    properties
       
        m_mutation_rate;
        m_population_size;
        m_chromosone_length;
        m_population;
        m_structure;
        m_connections;
        m_children;
        
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
            len =  obj.m_population_size;
            chromosone = obj.m_chromosone_length;
            obj.m_population = zeros(len, chromosone);
            obj.m_children = zeros(len, chromosone);
            
        end
        
        function obj = Initialization(obj, init)
            
            for i = 1 : init  
                for j = 1 : chromosone
                   obj.m_population(i, j) = randi([0 1]); 
                end
            end
        end
        
        function net = Decoding(obj, index, population)
           
            binary2num([1 1], 10);
            net = SpikeNetwork(obj.m_structure, obj.m_connections, 0.1, 0);
            len = length(obj.m_structure);
            struct = obj.m_structure;
            
            for i = 1 : len - 1 
                for j = 1 : obj.m_structure(i)
                    ind = ((i > 1)*struct(i) + j) * 16 - 16 + 1;
                    net.neural{i}{1}{1}.rule = population(index, ind);
                    net.neural{i}{1}{j}.t = binary2num(population(index, ind + 11 : ind + 16), 100);
                    A = binary2num(population(ind + 1 : ind + 10), 1000);
                    net.neural{i}{1}{j}.A1 = A;
                    net.neural{i}{1}{j}.A2 = A;
                end
            end
        end
        
        function obj = Fitness(obj, population)
         
            len = size(obj.m_population, population);
            len = len(1);
            
            for i = 1 : len
               
                net = Decoding(obj, i);
                
            end
            
        end
        
        function index = Selection(obj, population)
            
            choose1 = randi([1 obj.m_population_size]);
            choose2 = randi([1 obj.m_population_size]);
            
            while choose1 == choose2
                choose2 = randi([1 obj.m_population_size]);
            end
            
            if population(choose1, end) > population(choose2, end)
                index = choose1;
            else
                index = choose2;
            end
            
        end
        
        function obj = Crossover(obj)
           
            len = obj.m_population_size;
            
            for i = 1 : len
                divide_point = randi([1 (sum(obj.m_structure) - 1)]);
                parent1 = Selection(obj);
                parent2 = Selection(obj);
                obj.m_children(i, 1 : divide_point * 16) = obj.m_population(parent1, 1 : divide_point * 16); 
                obj.m_children(i, divide_point * 16 + 1 : end - 1) = obj.m_population(parent2, divide_point * 16 + 1 : end - 1);
            end
            
        end
        
        function obj = Mutation(obj)
           
            len = obj.m_population_size;
            len1 = obj.m_chromosone_length - 1;
            mutation_probability =  obj.m_mutation_rate;
            
            for i = 1 : len
                for j = 1 : len
                    if rand([1 1]) <= mutation_probability
                        if obj.m_children(i, j) == 1
                            obj.m_children(i, j) = 0;
                        else
                            obj.m_children(i, j) = 1;
                        end
                    end
                end
            end
            
        end
        
        function index = GetBest(obj, population)
           
            maximum = population(1, end);
            len = obj.m_population_size;
            index = 1;
            
            for i = 2 : len
               if population(i, end) > maximum
                   maximum = population(i, end);
                   index = i;
               end
            end
            
        end
        
        function obj = Replace(obj)
           
            obj.m_population(1, :) = obj.m_population(GetBest(obj, obj.m_population), :);
            obj.m_population(2, :) = obj.m_population(GetBest(obj, obj.m_children), :);
            
            len = obj.m_population_size;
            
            for i = 1 : len
                parent = Selection(obj, obj.m_population);
                child = Selection(obj, obj.m_children);
                
                if obj.m_population(parent, end) > obj.m_population(child, end)
                    obj.m_population(i, :) = obj.m_population(parent, :);
                else
                    obj.m_population(i, :) = obj.m_children(parent, :);
                end 
            end
            
        end
        
        function top = Evolve(obj, generations)
           
            obj = Initialize(obj, 1);
            obj = Fitness(obj, obj.m_population);
            
            for i = 1 : generations
                obj = Crossover(obj);
                obj = Mutation(obj);
                obj = Fitness(obj, obj.m_children);
                obj = Replace(obj);
                
                if mod(i, 20) == 0
                    half = ceil(obj.m_population_size / 2);
                    obj = Initialize(obj, half)
                end
            end
            
            top = GetBest(obj, obj.m_population);
            
        end
            
    end
    
end