classdef GeneticAlgorithm
   
    properties
       
        m_mutation_rate;
        m_population_size;
        m_chromosone_length;
        m_population;
        m_structure;
        m_connections;
        m_children;
        m_network;
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
            
            for i = init : obj.m_population_size  
                for j = 1 : obj.m_chromosone_length
                   obj.m_population(i, j) = randi([0 1]); 
                end
            end
        end
        
        function net = Decoding(obj, index, population)
           
            binary2num([1 1], 10);
            a = load('net');
            net = a.net;
            len = length(obj.m_structure);
            struct = obj.m_structure;
            l = 0;
            
            for i = 1 : len - 1 
                for j = 1 : obj.m_structure(i)
                    if i > 1
                        l = i - 1;
                    else
                        l = i;
                    end
                    
                    ind = ((i > 1)*struct(l) + j) * 16 - 16 + 1;
                    net.neural{i}{1}{j}.rule = population(index, ind);
                    net.neural{i}{1}{j}.t = binary2num(population(index, ind + 11 : ind + 16), 100);
                    A = binary2num(population(index, ind + 1 : ind + 10), 1000);
                    net.neural{i}{1}{j}.A1 = A;
                    net.neural{i}{1}{j}.A2 = A;
                end
            end
        end
        
        function obj = Fitness(obj, populate)
         
            if populate == true
                population = obj.m_population;
            else
                population = obj.m_children;
            end
            
            len = size(obj.m_population);
            len = len(1);
            xRef = 10.1;
            yRef = 10.1;
            
            for i = 1 : len

                net = Decoding(obj, i, population);
                for k = 1:3
                    [x, y, wR, wL, net] = RunSim(net, 10.1, 10.1, 5);
                end

                sumPath = 0;
                
                for k = 1:length(x)
                    sumPath = sumPath + sqrt((x(k) - xRef)^2 + (y(k) - yRef)^2);
                end

               population(i, end) = 100 / sumPath;
            end
            
            if populate == true
                obj.m_population = population;
            else
                obj.m_children = population;
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
                divide_point = randi([1 (sum(obj.m_structure) - obj.m_structure(end) - 1)]);
                parent1 = Selection(obj, obj.m_population);
                parent2 = Selection(obj, obj.m_population);
                obj.m_children(i, 1 : divide_point * 16) = obj.m_population(parent1, 1 : divide_point * 16); 
                obj.m_children(i, divide_point * 16 + 1 : end - 1) = obj.m_population(parent2, divide_point * 16 + 1 : end - 1);
            end
            
        end
        
        function obj = Mutation(obj)
           
            len = obj.m_population_size;
            len1 = obj.m_chromosone_length - 1;
            mutation_probability =  obj.m_mutation_rate;
            
            for i = 1 : len
                for j = 1 : len1
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
            obj.m_population(2, :) = obj.m_children(GetBest(obj, obj.m_children), :);
            
            len = obj.m_population_size;
            
            for i = 3 : len
                parent = Selection(obj, obj.m_population);
                child = Selection(obj, obj.m_children);
                
                if obj.m_population(parent, end) > obj.m_children(child, end)
                    obj.m_population(i, :) = obj.m_population(parent, :);
                else
                    obj.m_population(i, :) = obj.m_children(child, :);
                end 
            end
            
        end
        
        function obj = Evolve(obj, generations)
           
            obj = Initialization(obj, true);
            obj = Fitness(obj, true);
            
            for i = 1 : generations
                obj = Crossover(obj);
                obj = Mutation(obj);
                obj = Fitness(obj, false);
                obj = Replace(obj);
                
                top = GetBest(obj, obj.m_population);
                net = Decoding(obj, top, obj.m_population);
                
                for k = 1:3
                    [x, y, wR, wL, net] = RunSim(net, 10.1, 10.1, 5);
                end
                obj.m_network = net;
                figure();
                plot(x, y)
                hold all
                plot(10.1, 10.1, 'r+');
                grid;

                if mod(i, 20) == 0
                    half = ceil(obj.m_population_size / 2);
                    obj = Initialization(obj, half);
                    obj = Fitness(obj, true);
                end
            end
            
        end
            
    end
    
end