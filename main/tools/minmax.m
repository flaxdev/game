function mm = minmax(x)

mm(:,1) = min(x',[], 1);
mm(:,2) = max(x',[], 1);

