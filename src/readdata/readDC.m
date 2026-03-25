function data=readDC(file)
    raw = dlmread(file, ',', 4, 0);
    data.time=raw(:,1);data.DCop=raw(:,2);

end