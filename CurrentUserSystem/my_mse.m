function e = my_mse(I,R,Q,P)
    val = ((I.*(R-P*Q')).^2)/length(I(I>0));
     e = sum(val(:));
end

