% CellBodyAreaAnalysis.m
%
% Two-sample test of medians

% This file contains two variables, FF and FB, each of which contains ten
% values which are the measurements of the cell body area for FeedForward
% and Feedback neurons. (Data from Misbah Hasan's masters dissertation)
load cellBodyArea

tail = 'right';

% Plot a histogram:
nFF = length(FF); nFB = length(FB);
figure, hist([FF,FB]);
legend('FF','FB');
xlabel('Cell Body Area'); ylabel('# of neurons');

% What is the difference in median values of the two populations?
realDiffMedian = (median(FB) - median(FF))

% How likely is it that we got a difference this big by chance?
% Permutation test:
nPerm = 100000;
H0DiffMedian = ones(nPerm,1) .* NaN;
H0data = [FB;FF];   % pool it all
nObs = length(H0data);

for k = 1:nPerm
    shuffledData = H0data(randperm(nObs));
    H0DiffMedian(k) = (median(shuffledData(1:nFF)) - median(shuffledData(nFF+1:end)));
end

switch tail
    case 'both' 
        pVal = sum(abs(H0DiffMedian) >= abs(realDiffMedian)) / nPerm
        H0DiffMedian = abs(H0DiffMedian);   % for histogram below
    case 'right'
        pVal = sum(H0DiffMedian >= realDiffMedian) / nPerm
    case 'left'
        pVal = sum(H0DiffMedian <= realDiffMedian) / nPerm
    otherwise
        warning('Unexpected tail label');
        pVal = NaN
end

% Look at H0
figure, hist(H0DiffMedian,nPerm/100);
title('Differences in median under H0');
ax = axis;
hl = line([realDiffMedian, realDiffMedian],[ax(3), ax(4)]);
set(hl,'Color','r','LineWidth',2);

% Questions for further study:
% 1. How would you make this a 2-tailed test?
% 2. What standard statistical test is our test most similar to?
% 3. How would you convert this to a t-test?
% 4. Plot the H0 distribution. Why does it look funny?