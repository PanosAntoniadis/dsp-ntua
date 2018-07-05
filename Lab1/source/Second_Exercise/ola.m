function [] = ola(M,R,N)

% Check Constant winoverlap Add Property
%  M = 33;          % window length
%  R = (M-1)/2;     % hop size
%  N = 3*M;         % winoverlap-add span

w = hamming(M);  % window
z = zeros(N,1);  plot(z,'-r');  hold on;  s = z;
for so=0:R:N-M
  ndx = so+1:so+M;        % current window location
  s(ndx) = s(ndx) + w;    % window winoverlap-add
  wzp = z; wzp(ndx) = w;  % for plot only 
  so = so + R;            % hop along now
  plot(wzp,'--or');        % plot just this window
end
plot(s,'ok');  hold off;  % plot window winoverlap-add
end

