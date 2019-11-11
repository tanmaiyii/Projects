function acf_data = pACF(data, Maxlag)
 
L = length(data);
windowSize = Maxlag;
acf_data = zeros(1,windowSize);

for i = 1:windowSize;
    t1 = data(1:L+1-i);
    t2 = data(i:L);
    acf_data(i) = diag(corrcoef(t1, t2), -1);
end