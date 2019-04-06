function d = evalerror(x,y,e,w)


d = (sum((((x(:)-y(:)).*w(:)).^2)./(e(:).^2))); %/(length(x)-n));
%d = sum(sqrt(sum((((x-y).^2))')));

% d = sum(mse(abs(x-y)));
% d = mse((sum(((abs(x-y)))'))) ;