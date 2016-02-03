function res = BlockTrans(sour) 
    
    mid = sour(:,2);
    sour(:,2) = sour(:,1);
    sour(:,1) = mid;
    mid = sour(:,4);
    sour(:,4) = sour(:,3);
    sour(:,3) = mid;
    res = sour;
    
end