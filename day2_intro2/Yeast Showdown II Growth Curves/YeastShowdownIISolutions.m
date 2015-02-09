%% Solutions to Yeast Showdown II: Growth Curves
% Created 8/8/2011 by JW
% Updated 8/9/2011 by RJ, 5/24/2012 by BH, 5/28/2012 by JW.

% *SPOILER ALERT* This file provides solutions to the exercises from the
% MATLAB intro packet. The best way to remember what you learned is to
% spend time thinking about and doing the exercises on your own. Refer to
% this only after you've tried the exercises--first without, and then with
% the hints--and gotten stuck!

% HOW TO USE THIS FILE: This solution file doubles as a step-by-step
% tutorial reference. Each separate task in the problem is in its own cell
% (delimited by a %% at the beginning of the line). You should start by
% reading the comments and looking at the code without running it. Try to
% predict what each line of code does. Then, to see the code in action,
% press CTRL-ENTER to run your current cell. The cells should be run in
% order so that necessary variables are declared at the right times.

%% 0. Clear your workspace
% it is alway not bad to start with an empty workspace, to avoid
% unexpected variable name conflicts

clc     % clear command window
clear   % clear workspace
close all   % clear all figures

%% 1. Explore the data by plotting growth curves (OD versus time).

%% a. Warm up with one well. Before visualizing all the data, you probably 
% want to start to play with data for one single well (for example, A1). 
% How does OD change versus time? Convince yourself that there is an 
% exponential growth phase. Try to overlay data from two replicate plates, 
% and check how reproducible they are.

%% i. Load the data.
load ../growth_curve_data
% This syntax (without parentheses or quotation marks) is known as 'command
% form' and saves a bit of typing. It means the same as:
%   
%   load('growth_curve_data.mat');
%
% Many commands can be called in 'command form.' For more details, type
% 
%   doc load

% See how the data is organized:
whos all_data all_times
% This command is similar to looking at your workspace, and is often
% useful--imagine if all you knew about the data was that it contained OD
% measurements from 96-well plates over time, with experimental replicates.
% Can you tell from this output which dimensions contain the wells,
% timepoints, and replicates?

%% ii. Plot the growth curve from a single well
%
% Recall from the hints that well A1 is index 1, B1, is index 2, and A2 is
% index 9 (count down through the first column and then add 1).
%
% How would you plot the growth curve in A1 (mutant in rich media)?

t = all_times(1,:); % pull out the relevant times
ODs = all_data(1,:,1); % pull out ODs from 1st plate, all time points, well 1

figure, plot(t,log2(ODs),'+');
% The comma is a shortcut to put two commands on the same line. This is the
% same as typing:
%
%   figure;
%   plot(...);

% log2: Base 2 logarithm. In this scale, slope 1 means doubling once every
% time unit.

% always label plots!
title('Growth curve in A1');
ylabel('log2\_OD');
xlabel('Time (minutes)');

% make grid lines, which help to visualize curves
grid on

% Look at the growth curve. What are the cells doing at the beginning,
% middle, and end of the timecourse?

% How does curve look like without taking logarithm?
% figure, plot(t,ODs,'+');
% title('Growth curve in A1');
% ylabel('OD');
% xlabel('Time (minutes)');
% grid on

%% b. To get a sense of what the data looks like, plot growth curves for 
% all the data, including the wells that aren?t specific to this experiment. 
% In other words, make a grid of sub-plots in the same layout as the 96-well 
% plate, and plot both replicate curves in each sub-plot. Label each well 
% with its position (for example, ?A1?). Which wells are the ones we want? 
% How well do the replicates agree with each other? Do all the wells on the 
% 2 plates appear to contain growing cells? 

%% iii. Write the index well¬Index of a well in row r and column c. 
% In other words, use the explanation above to come up with the appropriate
% the MATLAB expression involving variables r and c and assign it to a
% variable named wellIndex. 
r = 1;
c = 2;
wellIndex = (c-1)*8 + r

% You may be tempted to write

%    wellIndex = (r-1)*12 + c;

% This is NOT correct to read all_data. Why? Try plugging in numbers for r and c.

% For example, A6 or (1,6) becomes the index (6-1)*8 + 1 = 41, but NOT 
% (1-1)*12 + 6 = 6. What is it about our setup that makes this distinction
% important?

% BUT, this is exactly what you need to count SUBPLOT, which counts in the
% following order: A1, A2, A3, ..., A12, B1, ..., H12
 
% Now you’re ready to plot growth curves on a mass scale.

%% iv. Using a loop (or two), plot an 8-by-12 grid of growth curves 
% corresponding to the wells on replicate plate 1. You’ll probably want to
% open up a new figure, and then use the subplot command many times. Where
% does the wellIndex from the previous part come in?

% Next, plot both replicates (in different colors, if you can) on the same
% grid of subplots. You need to add no more than 1 or 2 lines of additional
% code.

figure;
% If the figure window isn't big enough for you to see all the subplots,
% you may have to maximize it to fill your screen.

for r=1:8
    for c=1:12
        plotIndex = (r-1)*12 + c;   % index for subplot
        subplot(8,12,plotIndex);

        % use dots for a less messy plot
        wellIndex = (c-1)*8 + r;    % index for all_data
        plot(all_times(1,:),all_data(1,:,wellIndex),'.')
        
        % uncomment the below to also plot 2nd replicate plate
%         hold all;
%         plot(all_times(2,:),all_data(2,:,wellIndex),'.')

        % add a title for each well. Does each well have the right title?
        title_str = strcat(char(unicode2native('A')+r-1), num2str(c));
        title(title_str)
        % strcat is used to catenate strings
        % unicode2native convert 'A' to ascii code
        % char convert ascii code to letters
        % for example, char('A'+1) = 'B'
        
        % try this:
        %  title_str = strcat(('A'+r-1), num2str(c));
        %  title(title_str)
        
        % omitting axis labels to save screen space. you should remember
        % that growth curves are plots of OD versus time.
        
        % scales y axis. try commenting this out. which way do you prefer?
        ylim([min(all_data(:)),max(all_data(:))]) 
    end
end

%% 1c. Now plot growth curves only for the 6 wells (four experiment + two 
% control) that you are concerned with for the current experiment. 
% Compare the growth rates of the strains qualitatively. What do you see?  
% What do your media control “growth curves” tell you?

% i. Use the subplot command to compare growth curves for mutant and
% wildtype in both media. Let’s arrange the 2x2=4 growth curves we want to
% compare as follows:
% 
%   WT/rich      WT/Gly+
%   mut/rich     mut/Gly+
%   rich control Gly+ control

% One problem is that now the wellIndex doesn't increment sequentially, but
% jumps around on the plate. Now that we don't need 96 plots anymore, we
% could write the code for each plot manually. However, this would still
% repeat a lot of code. Instead, notice that we still want a grid of plots,
% so we can loop through 4 positions and call subplot with a different plot
% position every time. The only thing that isn't predictable is the index
% of the well we want to plot, so we'll just code that into an array:

figure

wellIndices = [2, 42, 1, 41, 8, 48]; % corresponds to [B1 B6 A1 A6 H1 H6]
% a cell array of plot titles
plotTitles = {'WT/rich', 'WT/Gly+', 'mut/rich', 'mut/Gly+',...
              'rich media control','Gly+ media control'};

for subplotIndex = 1:6    % iterate through the subplot positions
    subplot(3,2,subplotIndex);      % focus on current subplot
    wellIndex = wellIndices(subplotIndex); % which well to get on this run of the loop

    % all the code below same as above!
    t = all_times(1,:);
    ODs = all_data(1,:,wellIndex); 
    plot(t,ODs);
    ylim([min(all_data(:)),max(all_data(:))])     

    title(plotTitles{subplotIndex});
    ylabel('OD')
    xlabel('time (minutes)');
    
    grid on
end

% Q: Now look at the plots. What do you see? How do WT and mut compare in rich
% media? How do they compare in Gly+ media? What can you conclude about the
% effect of the mutation?

% A: What you should see in all the plots is an S-shaped curve in OD that
% starts off flat, rises steeply, and then flattens out with increasing
% time. This corresponds to the yeast cells growing exponentially and then
% running out of nutrients and thus saturating.
%
% The WT grows faster than the mut in both conditions (although for rich
% media this difference is hard to tell by eye). Both strains grow faster
% in rich media than in Gly+. However, the mut strain suffers a much larger
% handicap in the Gly+ strain relative to how it does in rich media,
% suggesting that the mutant allele is causing a defect specific to glycine
% metabolism.

% Q: What can you conclude from looking at the data from the media control
% wells? Is this what you expected? Why did we need to include this in the
% first place? What other outcomes could you have seen in the control
% wells?

% A: The media controls (bottom row) are a nice sanity check. Here the OD
% remains at a low (similar to background in the other wells) value,
% indicating that the media was clean and that there was no severe
% cross-contamination between wells during the experiment. If we had seen
% another S-shaped curve here, it would call our other results into
% question.

%% Run this to clear your screen
close all;

%% 2a. Compare the growth rates quantitatively.
% In other words, calculate the growth rate of each strain in each
% condition.

% Replot everything, but log-transform the OD data.
figure;
wellIndices = [2, 42, 1, 41, 8, 48]; % corresponds to [B1 B6 A1 A6 H1 H6]
% a cell array of plot titles
plotTitles = {'WT/rich', 'WT/Gly+', 'mut/rich', 'mut/Gly+',...
              'rich media control','Gly+ media control'};

for subplotIndex = 1:6    % iterate through the subplot positions
    subplot(3,2,subplotIndex);      % focus on current subplot
    wellIndex = wellIndices(subplotIndex); % which well to get on this run of the loop

    % all the code below same as above!
    t = all_times(1,:);
    ODs = all_data(1,:,wellIndex); 
    plot(t,log2(ODs));
    ylim([-5 0])

    title(plotTitles{subplotIndex});
    ylabel('log2\_OD')
    xlabel('time (minutes)');

    grid on
end

% What changed about the growth curves? Is this what you expected?

% The log-transform should turn exponential growth into linear growth,
% which we do see in the middle time points. However, the growth curves
% still look S-shaped. This may be surprising if you expected only
% exponential growth followed by saturation (which would yield a straight
% upward line followed by a flat line), but in fact, as mentioned before,
% yeast take a while to reach their maximum growth rate, so the beginning
% of the curve is still flat. Notice that the mut strain in Gly+ does look
% mostly linear. This is because it grew so slowly that it was still in
% exponential phase when the experiment stopped.

% The base of the logarithm isn't important for comparisons between
% different strains -- a strain that grows twice as fast as another will
% still show the same relative difference no matter what log we use. (Why
% is this?) However, if we use log base 2, the units of growth rate come
% out to the doublings / hr, which is very intuitive to think about.


%% 2b. Plot the derivatives of each growth curve.
% Look up the diff command. What does it do? Use it to calculate the
% derivative and plot each of the derivatives instead of the growth curves
% themselves.

% The diff command gives the successive differences in an array of numbers.
% If we take the differences in the log-transformed data and divide by the
% differences in time, we will get something like a discrete derivative (or
% slope) of the growth curves. 

% Also calculate growth rates (i.e. the maximum derivative) values for all
% 4 strain/condition pairings. 

% Let's do this in the loop from above and see what it looks like:
figure;
wellIndices = [2, 42, 1, 41, 8, 48]; % corresponds to [B1 B6 A1 A6 H1 H6]
% a cell array of plot titles
plotTitles = {'WT/rich', 'WT/Gly+', 'mut/rich', 'mut/Gly+',...
              'rich media control','Gly+ media control'};
          
gRates = [];  % save results of calculations

for subplotIndex = 1:4        % no need to look at controls
    subplot(2,2,subplotIndex);
    wellIndex = wellIndices(subplotIndex); 

    t = all_times(1,:);
    ODs = all_data(1,:,wellIndex);  % ODs
    logODs = log2(ODs);     % log-transformed ODs;

    % smooth, first try not to smooth logODs
    % then, compare with smoothed dODs
%     logODs = smooth(logODs)';
    
    dODs = diff(logODs)./diff(t); % derivative of logODs
    % diff will reduce # of elements by 1 -- why?
    % this means we need to remove an element from t, the time vector
    % we will omit the first element for convenience, but it would be more
    % correct to use the midpoint between times.
    plot(t(2:end),dODs);  % plot the derivatives
%     ylim([-10 0]);    % omit this for now, since we don't know scaling

    title(plotTitles{subplotIndex});
    if any(subplotIndex==[1, 3, 5])   % if subplotIndex is 1, 3, or 5
        ylabel('d(logOD)/dt')
    end
    if any(subplotIndex==[5, 6])      % if subplotIndex is 5 or 6
        xlabel('time (minutes)');
    end
    
    gRates(subplotIndex) = max(dODs);   % save this calculation
end

% Check out the plots. Are they what you expected? Re-run the last cell and
% look at those plots. Do the derivatives you calculated make sense,
% compared to the original growth curves?

% You now have the growth rates in quantitative form:
gRates

%% 2c. Make a table or graph of the growth rates.
% How do they compare with your qualitative conclusions from
% part 1?

% A good way to do this is with a bar graph, using the bar command
figure;
bar(gRates);
% Add some labels to the bars
barLabels = {'WT/rich', 'WT/Gly+', 'mut/rich', 'mut/Gly+'};
set(gca,'xticklabel',barLabels);
ylabel('growth rate (doublings/minute)');

% The bar command also does clustered bar graphs, if you give it data with
% more than one dimension. For example, can you guess what the following
% does? Uncomment and run it to see. What does the reshape command do?

% gRateMatrix = reshape(gRates,2,2)';   % what if this didn't have the ' ?
% bar(gRateMatrix);
% barLabels = {'WT','mut'};
% set(gca,'xticklabel',barLabels);
% legend('rich','Gly+');

% The graph agrees with the qualitative conclusions, and now we know for
% certain that WT grows more quickly than mut in both media. Furthermore,
% we can calculate exactly HOW much worse Gly+ is affecting the mut. For
% example, the percent decreases from rich to Gly+ media are:

decreaseWT = (gRates(1) - gRates(3)) / gRates(1)
decreaseMut = (gRates(2) - gRates(4)) / gRates(2)

% The WT strain suffers a 25% penalty from nitrogen limitation, but the mut
% strain suffers a 57% penalty. The difference between the two, roughly
% speaking, is explained by effects specific to glycine metabolism.

%% Clear the figure windows
close all

%% 3. Distinguish between technical and biological explanations for the 
% ‘lag’ phase. 

%% a. Is the lag phase an artifact of how you are scaling the OD axis 
%  (linear or logarithmic)? 
%% a. Use OD from media control well as background OD, and subtract 
% background for the four wells in the experiment. 



%% c. Using the given data and controls, think of a way to rule out or
% correct for one possible technical explanation for the lag phase. Perform
% this correction, and plot the growth curves. Do you think the lag phase
% is due to technical or biological factors? 

% We will do a background subtraction using the first OD reading in each
% growth curve as the background measurement. 
for p = 1:2 % p: plate
    
    % There could be many ways to subtract background
    % subtracted by first time point of medium control
    all_data_blank(p,:,2) = all_data(p,:,2) - all_data(p,1,8);
    all_data_blank(p,:,1) = all_data(p,:,1) - all_data(p,1,8);
    all_data_blank(p,:,42) = all_data(p,:,42) - all_data(p,1,48);
    all_data_blank(p,:,41) = all_data(p,:,41) - all_data(p,1,48);
end

% Note that this method of background correction requires assuming that the
% cells were inoculated below the detection limit. What controls might you
% do to convince yourself that this is a legitimate assumption?

%% Now let's plot the growth curves with and without background correciton.
% What differences do you see?

p = 1; % plate index

figure;
wellIndices = [2, 42, 1, 41, 8, 48]; % corresponds to [B1 B6 A1 A6 H1 H6]
% a cell array of plot titles
plotTitles = {'WT/rich', 'WT/Gly+', 'mut/rich', 'mut/Gly+',...
              'rich media control','Gly+ media control'};

for subplotIndex = 1:4    % iterate through the subplot positions
    subplot(2,2,subplotIndex);      % focus on current subplot
    wellIndex = wellIndices(subplotIndex); % which well to get on this run of the loop

    % plot data after background subtraction
    t = all_times(p,:);
    ODs = all_data_blank(p,:,wellIndex); 
    plot(t,log2(ODs));
    ylim([-7 0])
    
    % plot data before background subtraction
    hold all
    ODs = all_data(p,:,wellIndex); 
    plot(t,log2(ODs));
    
    % make the plot more beautiful..
    title(plotTitles{subplotIndex});
    ylabel('log2\_OD')
    xlabel('time (minutes)');

    grid on

    % leave a legend for each subplot
    legend('background subtracted','raw data', 'location', 'southeast')
end

% What are the differences?
% after background subtraction, one can find that plate reader is actually 
% sensitive for a larger range. There seems to be a slight lag still in
% some of the cultures, but you can see exponential growth a lot earlier
% than was apparent in the uncorrected growth curves.

%% d. Now recalculate the growth rates of each of the cultures. 
% It's a good idea to also plot our results so we can make sure our growth
% rate calculations are correct.

figure;
wellIndices = [2, 42, 1, 41, 8, 48]; % corresponds to [B1 B6 A1 A6 H1 H6]
% a cell array of plot titles
plotTitles = {'WT/rich', 'WT/Gly+', 'mut/rich', 'mut/Gly+',...
              'rich media control','Gly+ media control'};
          
gRates = [];  % save results of calculations

for subplotIndex = 1:4        % no need to look at controls
    subplot(2,2,subplotIndex);
    wellIndex = wellIndices(subplotIndex); 

    t = all_times(1,:);
    ODs = all_data_blank(1,:,wellIndex);  % ODs
    logODs = log2(ODs);     % log-transformed ODs;

    % smooth, first try not smooth logODs
    % then, compare with smoothed dODs
%     logODs = smooth(logODs)';
    
    dODs = diff(logODs)./diff(t); % derivative of logODs
    % diff will reduce # of elements by 1 -- why?
    % this means we need to remove an element from t, the time vector
    % we will omit the first element for convenience, but it would be more
    % correct to use the midpoint between times.
    plot(logODs(2:end),dODs);  % plot the derivatives
%     ylim([-10 0]);    % omit this for now, since we don't know scaling

    title(plotTitles{subplotIndex});
    if any(subplotIndex==[1, 3, 5])   % if subplotIndex is 1, 3, or 5
        ylabel('d(logOD)/dt')
    end
    if any(subplotIndex==[5, 6])      % if subplotIndex is 5 or 6
        xlabel('time (minutes)');
    end
    
    % since OD measurements are very noisy around detection limits
    % here only record maximal growth rates when od is higher than 2^-5
    
    % search region when OD is higher than 2^-5, and save it to 'range'
    range = find(logODs>-5);
    gRates(subplotIndex) = max(dODs(range(1:end-1)));
    
%     gRates(subplotIndex) = max(dODs);   % save this calculation
    ylim([0 0.04])
end

% Check out the plots. Are they what you expected? 

% You now have the growth rates in quantitative form:
gRates

%% 3d. Does correcting for technical artifacts affect your conclusion from part 2?
% Let's answer this by plotting the growth rates we calculated in the
% previous cell.

% A good way to do this is with a bar graph, using the bar command
figure;
bar(gRates);
% Add some labels to the bars
barLabels = {'WT/rich', 'WT/Gly+', 'mut/rich', 'mut/Gly+'};
set(gca,'xticklabel',barLabels);
ylabel('growth rate (doublings/minute)');

% The percent decreases from rich to Gly+ media are:

decreaseWT = (gRates(1) - gRates(3)) / gRates(1)
decreaseMut = (gRates(2) - gRates(4)) / gRates(2)

% Growth rates are changed after background subtraction, but roughly
% speaking, mutants are still more sensitive than wild type to glycine
% depletion. 