function f = brf(m,n,s1,s2,flag)

% BRF.M: band rejection filter
%
% f = brf(m,n,s1,s2,flag)
% where m and n are the number of rows and columns respectively
% s1 and s2 are the radii of the inner and outer reject regions
% and flag = 0 for sharp or 1 for gaussian filter boundaries
%
% NOTE: designed to be applied to an fftshift'd fft2 image
%
% RTB 17 May 2003

if nargin < 5
    flag = 0;
end

if flag
    g1 = nl(fspecial('gaussian', [m n], s1));
    g2 = nl(fspecial('gaussian', [m n], s2));
    f = nl(g1-g2);
else
    f = ones(m,n);
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

    f((ctr(1)-s2):(ctr(1)+s2), (ctr(2)-s2):(ctr(2)+s2)) = ~circle(s2*2+1);
    f((ctr(1)-s1):(ctr(1)+s1), (ctr(2)-s1):(ctr(2)+s1)) = circle(s1*2+1);
end
