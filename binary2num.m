function res = binary2num(data, divider)
           
    len = length(data);
    res = 0;
            
   for i = 1 : len
               
    res = res + data(i)*2^(i - 1); 
                
   end
   
   res = res + 1;
   res = res / divider;
   
end