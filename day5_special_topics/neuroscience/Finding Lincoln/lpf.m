function f = lpf(m,n,s1,wtype)

% BRF.M: low pass filter in the frequency domain
%
% f = lpf(m,n,s1,wtype)
%
% where m and n are the number of rows and columns respectively
% and s1 is the radius
%
% NOTE: designed to be applied to an fftshift'd fft2 image
%
% RTB 17 May 2003

ws = s1*2+1;        % window size
switch lower(wtype)
    case 'hamming'
        w = hamming(ws);
        w2 = w * w';
    case 'kaiser'
        w = kaiser(ws);
        w2 = w * w';
    case 'gaussian'
        w = gausswin(ws);
        w2 = w * w';
    otherwise
        w2 = circle(s1*2+1);
end

f = zeros(m,n);
ctr = [0 0];
if mod(m,2)
    ctr(1) = floor(m/2) + 1;
else
    ctr(1) = m/2;
end

if mod(n,2)
    ctr(2) = floor(n/2) + 1;
else
    ctr(2) = n/2;
end

f((ctr(1)-s1):(ctr(1)+s1), (ctr(2)-s1):(ctr(2)+s1)) = w2;
