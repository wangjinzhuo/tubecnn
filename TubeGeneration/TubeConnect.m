function res = TubeConnect(tube, img_cell)
 
     for tub_id = 1:max(size(tube))                
         tub_tmp = tube{tub_id};        
         noz = [];
         ct = 1;
         
         for fra_id = 1:max(size(tub_tmp))-1
             loc_n1 = tub_tmp{fra_id};
             loc_n2 = tub_tmp{fra_id+1};
             if isempty(loc_n1) && ~isempty(loc_n2)
                noz(ct,1) = fra_id+1;
                ct = ct+1;
             end
             
             if ~isempty(loc_n1) && isempty(loc_n2)
                sour = img_cell{fra_id};
                targ = img_cell{fra_id+1};
                loc_res = MeanshiftTracking(sour, targ, tub_tmp{fra_id});
                tub_tmp{fra_id+1} = loc_res;                  
             end                                     
         end         
         
         if ~isempty(noz)    % Ç°Ïò×·×Ù
             for idx = 1:max(size(noz))
                st = noz(idx);                
                for st_idx = st:-1:2
                    loc1 = tub_tmp{st_idx};
                    loc2 = tub_tmp{st_idx-1};
                    if ~isempty(loc1) && isempty(loc2)
                        sour = img_cell{st_idx};
                        targ = img_cell{st_idx-1};
                        loc_res = MeanshiftTracking(sour, targ, tub_tmp{st_idx});
                        tub_tmp{st_idx-1} = loc_res;                         
                    end                    
                end                 
             end
         end  
         tube{1,tub_id} = tub_tmp;
         
     end            
     res = tube;          
end