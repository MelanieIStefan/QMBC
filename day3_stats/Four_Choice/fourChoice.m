%% Write a function for our "random number" game:

% Have N people pick a number for 1 to R, inclusive. What is the
% probability, p, of K or more choices of any single number?

% % example from actual class demo on 15 August 2012:
% R = 4; N = 75; K = 34;  % i.e. 45% of class picked the number 3

R=4; N=65; K=35;

nSims = 1e6;

% What does this result look like?
A = randi(R,N,nSims);
Ctrs = zeros(R,nSims);

for j = 1:nSims
    for m = 1:R
        Ctrs(m,j) = sum(A(:,j) == m);
    end
end

%% Step 2: Looking at number 3 specifically
p3 = sum(Ctrs(3,:)>=K) / nSims;
 
%% Step 3: Looking at any number being picked more often than others
pAll = sum((sum(Ctrs >= K)) > 0) / nSims;

%% Step 4: Loop through K=1:75 to find number of picks that result in significance
for pickNum=1:N
    p = sum((sum(Ctrs >= pickNum)) > 0) / nSims;
    if p<0.05
        smallestNumber=pickNum;
        break
    end
end



% For MATLAB show-offs, this can be compressed into a single line of code:
pp = sum(any(hist(randi(R,N,nSims),1:R) >= K)) / nSims;

% What are the advantages and disadvantages of doing it this way?


%% Extra Exercise: Generate a 10 x 10 image of random histogram
nHists = 100;
A = randi(R,N,nHists);      % generate all of the random intetgers
allHists = hist(A,1:R);     % use 'hist' to bin everything

% values with which to scale all histograms to the same range
xmin = 0; xmax = R+1;
ymin = 0; ymax = ceil(max(allHists(:)) / 5) * 5;

for iHist = 1:nHists
    subplot(sqrt(nHists),sqrt(nHists),iHist);
    bar(1:R,allHists(:,iHist));
    axis([xmin xmax ymin ymax]);
end


%% RTB wrote this
%% MIS added different approaches for p3 and pAll, and code to determine miminum number of picks - 31 Jul 2014
