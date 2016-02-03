function res = ChiSqu(sour1, sour2) 

    h1 = sour1 - sour2;
    h2 = sour1 + sour2;
    h3 = (h1.^2)./h2;
    h3(isnan(h3)) = 0;
    res = sum(h3,2);

end