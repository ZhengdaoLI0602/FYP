fis=readfis('FYP_Fuzzy.fis');
pred_file= 'L_pred_C.csv';
pred= importdata(pred_file);
s=pred(1);
fz_prev=s;
T=table();
tempTable=table();
for k=1:length(pred)
    p=pred(k);
    h=evalfis(fis,[p fz_prev]);  
    tempTable.r=evalfis(fis,[p fz_prev]);
    fz_prev=h; 
    T=[T;tempTable];
    disp(h);
end
