function [vMonotonic, cMonotonic] = makeMonotonicVectors(v, c)

    if v(end) > v(1)
        for i = length(v):-1:2
            if v(i-1) >= v(i)
                v(i) = [];
                c(i) = [];
            end
        end
    else
        for i = length(v):-1:2
            if v(i-1) <= v(i)
                v(i) = [];
                c(i) = [];
            end
        end
    end

    vMonotonic = v;
    cMonotonic = c;
end