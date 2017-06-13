[rows columns] = size(table)

for i = 1:rows
    for g = 1:columns
        
        if isempty(table{i,g})
            table{i,g}{1,1} = 0;
        end
    end
end