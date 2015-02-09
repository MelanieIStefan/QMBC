function [FPrate] = dfSim(nInit,nAddObs,nMax,myAlpha,nSims)

% dfSim: Simulation of expected false positive rates when data collection
% ends upon obtaining significance, as a function of the frequency with
% which significance tests are performed. This replicates figure 1 from
% Simmons et al. 2011.
%
% Inputs:
% - nInit, # of initial observations prior to first t-test (default, 10)
% - nAddObs, # of additional observations added before next t-test
% - nMax, maximum # of observations to make (default, 50)
% - myAlpha, criterion for rejecting H0 (default, 0.05)
% - nSims, # of simulations to run (default, 1000)
% 
% Outputs:
% - FPrate, percentage of simulations yielding a false positive
%
% RTB wrote it, winter rain storm, 21 Dec 2012; Gill, MA

% Reference:
% Simmons JP, Nelson LD, Simonsohn U. False-positive psychology:
% undisclosed flexibility in data collection and analysis allows presenting
% anything as significant. Psychol Sci. 2011 Nov;22(11):1359-66.

% Execution speed:
% tic;FPrate = dfSim(10,[1,2,5,10,20],50,0.05,1000);toc
% Elapsed time is 37.183327 seconds on my lenovo T61

if nargin < 5, nSims = 1000; end
if nargin < 4, myAlpha = 0.05; end
if nargin < 3, nMax = 50; end
if nargin < 2, nAddObs = [1,2,5,10,20]; end
if nargin < 1, nInit = 10; end

FPrate = ones(size(nAddObs)) .* NaN;
for iVal = 1:length(nAddObs)
    FP = zeros(nSims,1);
    for jSim = 1:nSims
        [pVals, nSamples] = SampleSizeDF(nInit, nAddObs(iVal), nMax, 0);
        if any(pVals <= myAlpha)
            FP(jSim) = 1;
        end
    end
    FPrate(iVal) = (sum(FP) / nSims) * 100;
end

figure, plot(nAddObs,FPrate,'b-'); hold on;
plot(nAddObs,FPrate,'k.');
ax = axis;
axis([ax(1), ax(2), 0, (floor(ax(4)/5)+1)*5]);
hl = line([ax(1),ax(2)], [myAlpha*100,myAlpha*100]);
set(hl,'Color','r','LineStyle','--');
xlabel('Number of Additional Observations Before Performing Another t-Test');
ylabel('Percentage of False-Positive Results');

