function [vMonotonic, cMonotonic] = makeMonotonicVectors(v, c)

    % This function ensures that a set of vectors are monotonically
    % increasing or monotonically decreasing, depending on the first and 
    % last entries of the first vector inputted

    if v(end) > v(1)
        for i = length(v):-1:2
            if v(i-1) >= v(i)
                % Remove decreasing values
                v(i) = [];
                c(i) = [];
            end
        end
    else
        for i = length(v):-1:2
            if v(i-1) <= v(i)
                % Remove increasing values
                v(i) = [];
                c(i) = [];
            end
        end
    end

    % Return monotonic vectors
    vMonotonic = v;
    cMonotonic = c;
end