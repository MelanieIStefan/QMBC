% BinoRat.m: Rattus binomialis
%
% MATLAB concepts covered:
% 1. 'rand' 
% 2. simulations for answering questions of probability
% 3. 'for' loops 
% 4. indexing arrays 
% 5. 'tic' and 'toc' to time code execution
% 6. binomial distribution
% 7. pdf's and cdf's
%
% RTB wrote it, 23 April 2011 as "binodemo.m"
% RTB revised it, 23 May 2011 as "binorat.m" 
% DAR updated it, 4 August 2011 as two files. This .m file and corresponding "Rattus binomialis.pdf"
% RTB added number-picking code, 27 May 2012
% MIS renamed probGuessing variable to avoid confusion. Took number-picking
% code out into separate file "fourChoics.m", 5 August 2013


% see Rattus binomialis.pdf for background information and questions

%% Step 1: Write a single line of MATLAB code to simulate one trial. 

% To answer with a real rat would take a long time, but computers are
% fast, so we can let the computer do the behavior. How? The MATLAB 'rand'
% command produces random entries chosen from a uniform distribution on the
% interval (0.0,1.0)

help rand  %explains how the rand function works

% To start with, we want to simulate a single trial
rand(1) %returns a single value between 0.0 and 1.0

% what does rand(3) do?  What about just  rand  ?

% How can we use the output of rand(1) to simulate a trial?

% We can ask if the output is greater than 0.5. How might we do this?

% MATLAB allows for the use of relational operators such as > and ~= type
% 'help >'  for a list of all operators and special characters

% So, the simple-minded line:
rand(1) > 0.5;
% will return either a 1 or 0 depending on whether the random number
% generated is larger than 0.5 or not. Notice that if you run this line of
% code multiple times, you get different answers. Why is that?

% Now, we can simulate a single trial, where each outcome has a probability of
% .5. So, we are in the position to simulate many trials in order to
% address our main question: How often would one expect to get 31 (or more)
% correct guesses out of 50 trials?

%% Step 2: Write a 'for' loop to simulate 50 trials and store the results

% Q: What is a 'for' loop? A: A 'for' loop repeats a statement a specific
% number of times.
%    Remember, a 'for' loop is completed by and 'end' statement

% Start by initializing some variables:
pNull = 0.5;        % our "null hypothesis" probability
nTrials = 50;       % the number of trials in one simulation
nCorrect = 31;      % the number of correct responses we obtained

% We'll also need a variable to hold the results of our simulation:
allTrials = zeros(nTrials,1);

% We've initialized the results vectors with zeros as if "failure" were the
% default. If we succeed (i.e. get a "tail"), we'll change the
% corresponding zero to a one.

% The first thing we want to do is write the statement that will flip the
% coin (remember to write loops from the inside out). Once we have this
% written, we can add the repetition element in the form of a for loop.
    
    % one round of n coin tosses
    for iTrial = 1:nTrials
        if rand > pNull
            allTrials(iTrial) = 1; % a single trial
        end
    end
    
% now, allTrials contains 50 values that are either 1s or 0s. To calculate the
% number of correct guesses (number of 1s), use sum
    
result = sum(allTrials);

% how many correct guesses did you get?  Was it more or less than 31? Run your loop a
% few more times, (but remember to reset allTrials before each time) do you
% get the same result? Why or why not?

% This was good for simulating 50 trials, but if we want to answer our
% original question, we will need to simulate 50 trials lots of
% times.

%% Step 3: Code a pair of nested 'for' loops that will do nSims simulations of 50 trials 
%  and store the resulting number of tails on each simulation in results.

% p, n and x were defined above. Now let's define the number of simulations
% we want to perform
nSims = 1000;    % the number of simulations we're going to run

% We'll also need an additional variable to hold the results of our
% simulation:
simResults = zeros(nSims,1);    % results of each simulation

% Also, if you ran the loop from Step 2, you'll need to re-set allTrials to
% zeros.
allTrials = zeros(nTrials,1);

% For most programmers, the most intuitive way to run the simulations would
% be as a pair of nested 'for' loops. The inner loop would consist of a
% single simulation of 50 coin tosses; the outer loop would be the number
% of simulations.

for iSim = 1:nSims
    
    % one round of 50 coin tosses
    for iTrial = 1:nTrials
        if rand > pNull
            allTrials(iTrial) = 1; % a single trial
        end
    end
    simResults(iSim) = sum(allTrials);
    allTrials = zeros(nTrials,1);  % need to re-set prior to next simulation
end

% results contains the number tails that occurred in each set of 50 coin
% flips. See EXTRA STEP 7 for help visualizing this array and questions
% about descriptive statistics of the distribution.

% That's all there is to it. Now we just ask how many times we "succeeded"
% in getting 31 or more tails. The probability is simply the number of
% times we succeeded divided by the number of times we tried.
probThisOrMoreRightIfGuessing = sum(simResults >= nCorrect) ./ nSims

% If you run this simulation again, do you get exactly the same answer?
% How can you get a progressively "better" answer?


% We find a probability of something greater than 0.05. Every simulation
% will be a little bit different -- it is random, after all. But you can
% satisfy yourself that it gets close to the same answer each time by
% running the loops multiple times. And we could make our variation in
% 'probGuessing' arbitrarily small by running more and more simulations.

% So we've answered our question. We cannot reject the null hypothesis that
% the rat is still guessing at the p = 0.05 level of confidence.
% How many would he have to get right before we concluded that he probably was not guessing?


%% Step 4: Write a script that will do the same thing without 'for' loops. 

% Step 3 solved our question, but to a true MATLAB programmer, the presence
% of 'for' loops in the code always raises suspicions. Because MATLAB is a
% vector-based language, we can often do things much more efficiently using
% indexing and operators (such as '>') that work across entire arrays or
% functions that work along a specific dimension, such as down columns. For
% example, we don't need to call 'rand' so many times. In fact, we can call
% it only once and get all of the coin tosses in one giant array:

allSims = rand(nTrials,nSims);% a 50 x nSims matrix of random numbers
L = allSims > pNull;          % a logical array of 0s and 1s; result of all trials

% By default, 'sum' works down columns. But you can also specify which
% dimension will be used: sum(L) is the same as sum(L,1); sum(L,2) would
% sum along rows.
simResults = sum(L);            % what did this line do?
LL = simResults >= nCorrect;    % How about this line?
probThisOrMoreRightIfGuessing = sum(LL) ./ nSims;

% Or, to be super-MATLAB macho:
nSims = 10000;
pGuess = sum(sum(rand(nTrials,nSims) >= pNull) >= nCorrect) ./ nSims;

% This is cute and it would execute more quickly, but it comes at the great
% cost of clarity. Don't write code like this.

%% You can test the speed using MATLAB's 'tic' and 'toc' functions.
% You execute a 'tic' at the beginning of your code, and then a
% 'toc' at the end, and you'll get the amount of elapsed time. Try it for
% your loops in Step 3 and compare it to the code in Step 4
help tic  % for help using tic and toc

% For example, the code from Step 3 would look like this:
tic
for iSim = 1:nSims
    
    % one round of 50 coin tosses
    for iTrial = 1:nTrials
        if rand > pNull
            allTrials(iTrial) = 1; % a single trial
        end
    end
    simResults(iSim) = sum(allTrials);
    allTrials = zeros(nTrials,1);               % need to re-set prior to next simulation
end

probThisOrMoreRightIfGuessing = sum(simResults >= nCorrect) ./ nSims
toc


% When I do it for the 'for-loop' version, I get: Elapsed time is 0.139723
% seconds (with nsim = 1000). For the non-for-loop version, I get: Elapsed
% time is 0.023866 seconds. That's nearly 6 times faster for the 2nd
% version.

%% Step 5: Using a built in binomial function:
% Write code that will give the probability of getting 5 or fewer heads in
% 10 tosses.

% Of course, we can do even better by taking advantage of all of the
% probability distributions provided in the statistics toolbox. You might
% vaguely recall that events like coin tosses, where there are only two
% possible outcomes, are described by the binomial distribution.
% Remembering only this key word, 'binomial', we can quickly find all of
% the functions that are relevant with:
lookfor binomial  % this line can be quite slow

% This produces a list of about 40 functions along with a 1-sentence
% description of what each computes. If we wanted to know more about a
% given function, we would just type its name after the 'help' command:
help binopdf

% This sounds useful. It gives us the probability of getting X successes
% out of N tries if the probability of success on each trial is P. What is
% the probability of getting (exactly) 5 heads from 10 tosses? Before
% looking at the code below, try to figure out the proper way of inputting
% values into the binopdf function.
%
%
%
%
binopdf(5,10,0.5)

% What is the probability of getting 5 or fewer heads? We could call
% 'binopdf' 6 times in a 'for' loop, but this is MATLAB, so we might expect
% the function to do it for us.
y = binopdf(0:5,10,0.5);
sum(y)

% Given that one often wants to know things like "probability of X or
% fewer" we might not be surprised to find a function that does this
% directly. This is called the "cumulative distribution function" and for
% binomial data, we would use 'binocdf' (it finds the integral of a portion
% of a distribution to the left of a specified value). What is the
% equivalent cdf command for the two lines of code above?
binocdf(5,10,0.5)

% is that the same answer that you got when you did the sum(y) command
% above?  Do you understand why?


%% Step 6: Using 'binocdf', calculate the probability that the rat gets it right 31 times or more by just guessing. 
% Back to our rat question. We want to know the probability of getting 31
% correct guesses or more out of 50 trials. We could use the pdf:
y = binopdf(31:50,50,0.5);
sum(y)

% But since we know that the sum of all possible outcomes (0 up to 50) must
% sum to one, we can calculate this as 1 - (probability of 30 or fewer).
prob = 1 - binocdf(30,50,0.5)

% Convince yourself that these are equivalent. Not bad. Just one line of
% code and much faster (0.001155 seconds).

% OK, so what do we think? Is the rat "getting it" or is he just guessing?
% How many would he need to get right (out of 50) before you believed?


%% Extra Step 7: Visualize the results from your simulation

% In step 3 you created the array results that contains the number of
% correct trials that occurred in each set of 50 trials. How could you
% visualize the values in results?

%one nice way is to use the function histc
% first we will define the edges of the histogram we will use see help
% histc to clarify
binCenters = [1:1:50];
[N,BIN] = histc(simResults,binCenters);
figure; bar(binCenters,N,'histc')

% Now calculate the mean, standard deviation and standard error of results.
% How do these values change if you rerun the simulation with a small
% number of simulations?  A larger number?

% Now make the same plot, but change the Y-axis values to percent
% occurrence instead of count number.


%% EXTRA Step 8: What if the distribution we cared about wasn't a binomial?

% One of the wonderful things about MATLAB's statistics toolbox is that it
% provides PDFs and CDFs for just about any statistical function you
% might imagine. Type:
lookfor 'cumulative distribution'

% alternatively, to view the available distributions in Matlab type:
help cdf % or
help pdf  

% for example, look for the poisson distribution. Using poisstat what
% interesting feature do you observe about the relationship between a
% poisson distribution's mean and its variance

% Is there an easy way to generate random numbers from non-uniform
% distribution types? Exponential? Normal? Plot them and compare them to
% the ouput of rand. When would these other distributions be useful?


%% EXTRA Step 9: Compute the 95% upper and lower confidence bounds for: 

%   a) 30 correct out of 50 b) 60 of 100 c) 300 of 500

% What do you notice about these values?  Do they change as a function of
% trial number? Why or why not?

% HINT: confidence intervals are a measure of the reliability of an
% estimate that are calculated from the observed data.

% BIG Hint: >> help binofit

