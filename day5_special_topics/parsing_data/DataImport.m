%% Solution Day 6
% Created by BH @06042012
 
%% Clean workspace
close all
clc
clear
 
%% Load Data
% Use importdata(filename)
 
filename = 'GrayBootCamp2012__mm9-(Total1,Bulent)(0hr,1hr,6hr)__(EXN,INT)-EXPRESSION.tsv';
 
% click on data (or 'whos data'), look at what is inside
data = importdata(filename);
 
%Header
Header = data.textdata(1,:);
DataHeader = data.textdata(1,strcmpi(data.textdata(2,:),''));
% because there is a head line, so start at Row 2
GeneName = data.textdata(2:end,strcmpi(Header,'Gene'));
 
%% Reproducibility of replicates, Check scales
% Replicates have relative high reproducibility for highly expressing
% genes. Comparing scatter plots at linear and log scale, one might find that
% gene expression data cover a large range, so that log scale might be a
% better representation than linear scale
 
Replicate=[1,2]; %These could be passed in as variables
TimePoint=[0,1,6]; %These could be passed in as variables
Feature=['EXN_Density'];
%Feature=['EXN_nrds'];
 
%Experiment = [5, 8; 7, 10];
% Plate = [5,8;6,9];
%ExperimentName = {'ohr', '6hr'};
 
figure('name', 'Reproducibility')
 
for exper = 1:length(TimePoint)
    %Currently this shows off only the first two replicates
    ExperimentName{1}=[Feature,'.Rep',num2str(Replicate(1)),'.',num2str(TimePoint(exper)),'hr'];
    ExperimentName{2}=[Feature,'.Rep',num2str(Replicate(2)),'.',num2str(TimePoint(exper)),'hr'];
    subplot(length(TimePoint),2,exper*2-1)
    % try remove ", 'markersize', 10"
    plot(data.data(:,strcmpi(DataHeader,ExperimentName{1})), data.data(:,strcmpi(DataHeader,ExperimentName{2})), '.', 'markersize', 10)
    title([Feature,' ',num2str(TimePoint(exper)),'hr linear scale'])
    grid on
    
    subplot(length(TimePoint),2,exper*2)
    % "doc loglog" find out what is this function used for?
    loglog(data.data(:,strcmpi(DataHeader,ExperimentName{1})), data.data(:,strcmpi(DataHeader,ExperimentName{2})), '.', 'markersize', 10)
    title([Feature,' ',num2str(TimePoint(exper)),'hr log scale'])
    grid on
end
 
%maximize_window
%%Add text to a figure
figure
loglog(data.data(:,strcmpi(DataHeader,ExperimentName{1})), data.data(:,strcmpi(DataHeader,ExperimentName{2})), '.', 'markersize', 10)
    title([Feature,' ',num2str(TimePoint(exper)),'hr log scale'])
    grid on
xlabel(ExperimentName{1})
ylabel(ExperimentName{2})
GOI=strcmpi(GeneName,'fosb');
text(data.data(GOI,strcmpi(DataHeader,ExperimentName{1})), data.data(GOI,strcmpi(DataHeader,ExperimentName{2})),GeneName(GOI),'FontSize',18)
GOI=data.data(:,strcmpi(DataHeader,ExperimentName{1}))==max(data.data(:,strcmpi(DataHeader,ExperimentName{1})));
text(data.data(GOI,strcmpi(DataHeader,ExperimentName{1})), data.data(GOI,strcmpi(DataHeader,ExperimentName{2})),GeneName(GOI),'FontSize',18)
 
%% Reproducibility of relicates: MA plot
% MA plot is another way to display data.
%close all
exper = 1;    % indicate time = 0hr
 
%Think of what you would do to make this work automatically for all
%timepoints
figure('name', 'MA Plot')
for x=[1,2]
    ExperimentName{x}=[Feature,'.Rep',num2str(Replicate(x)),'.',num2str(TimePoint(1)),'hr'];
end
 
ExpMean=mean([log2(data.data(:,strcmpi(DataHeader,ExperimentName{1}))) , log2(data.data(:,strcmpi(DataHeader,ExperimentName{2})))],2);
ExpDiff=log2(data.data(:,strcmpi(DataHeader,ExperimentName{1}))) -log2(data.data(:,strcmpi(DataHeader,ExperimentName{2})));
plot(ExpMean,ExpDiff, '.', 'markersize', 10)
xlabel([Feature,' mean'])
ylabel([Feature,' fold change'])
grid on
 
%% Display EXN nrds 0hr vs 6hr
% MA plot. One might find that for highly expressed genes, expression reads
% are slightly lower than ones at 0 hour
 
%close all
figure('name', [Feature,' 0hr vs 6hr'])
 
row=0;
for i=[1,3]%Time Points
    row=row+1;
    col=0;
    for j=[1,2]%replicate
        col=col+1;
        ExperimentName{row,col}=[Feature,'.Rep',num2str(Replicate(j)),'.',num2str(TimePoint(i)),'hr'];
        Experiment(row,col)=find(strcmpi(DataHeader,ExperimentName{row,col}));
    end
end
 
plot((mean(log2(data.data(:,Experiment(1,:))),2)+mean(log2(data.data(:,Experiment(2,:))),2))/2,(mean(log2(data.data(:,Experiment(2,:))),2)-mean(log2(data.data(:,Experiment(1,:))),2)), '.', 'markersize', 10)
xlabel([Feature,' mean'])
ylabel([Feature,' fold change'])
 
% xlim([0 18])
% ylim([0 18])
 
grid on
 
%% Display EXN nrds 0hr vs 6hr
 
% Simple scatter plot
% close all
% figure('name', 'EXN nrds 0hr vs 6hr')
%
% plot(mean(log2(data.data(:,[Plate(1,1),Plate(1,2)])),2),mean(log2(data.data(:,[Plate(2,1),Plate(2,2)])),2), '.', 'markersize', 10)
% xlabel('EXN nrds 0hr')
% ylabel('EXN nrds 6hr')
%
% % xlim([0 18])
% % ylim([0 18])
%
% grid on
 
%% Normalization between replicates
 
% Using 'lowess' method to normalize between replicates.
close all
 
index_remain = find(~isinf(sum(log2(data.data(:,reshape(Experiment,1,[]))),2)));
log_data_tmp = log2(data.data(index_remain, :));
 
log_data_tmp_backup = log_data_tmp;
 
for exper = 1:2
    % log_data_tmp(:, Plate(exp,1))
    % log_data_tmp(:, Plate(exp,2))
    
    figure('name', num2str(exper))
    subplot(2,1,1)
    plot((log_data_tmp(:, Experiment(exper,1))+log_data_tmp(:, Experiment(exper,2)))/2, (log_data_tmp(:, Experiment(exper,2))-log_data_tmp(:, Experiment(exper,1))), '.')
    ylabel('rep2-rep1')
    title('before normalization')
    grid on
    
    yy = smooth((log_data_tmp(:, Experiment(exper,1))+log_data_tmp(:, Experiment(exper,2)))/2, (log_data_tmp(:, Experiment(exper,2))-log_data_tmp(:, Experiment(exper,1))), 'lowess');
    
    log_data_tmp(:,Experiment(exper,2)) = log_data_tmp(:,Experiment(exper,2))-yy/2;
    log_data_tmp(:,Experiment(exper,1)) = log_data_tmp(:,Experiment(exper,1))+yy/2;
    
    subplot(2,1,2)
    plot((log_data_tmp(:, Experiment(exper,1))+log_data_tmp(:, Experiment(exper,2)))/2, (log_data_tmp(:, Experiment(exper,2))-log_data_tmp(:, Experiment(exper,1))), '.')
    ylabel('rep2-rep1')
    title('after normalization')
    grid on
end
%% Calculate fold change of expression level for each gene
% To simplify the analysis, genes with zero expression reads are removed
 
close all
 
GeneName_tmp = GeneName(index_remain);
 
% fold change of expression (log_data_tmp is log2 scale)
outlier = mean(log_data_tmp(:,Experiment(2,:)),2) - mean(log_data_tmp(:,Experiment(1,:)),2);
 
% sorting, sort_outlier_i records sorted index,
[sort_outlier, sort_outlier_i] = sort(outlier);
GeneName_tmp_sorted = GeneName_tmp(sort_outlier_i);
 
% plot distribution of deviation
figure('name', 'histogram of expression changes')
hist(sort_outlier, 100)
xlabel('fold change of expression level, log2 scale')
ylabel('counts')
 
%% Calculate p value
% the following two commands calculate the fold change of expression level,
% under the 'NULL hypothesis' by randomizing data in two time points
 
% matrix used for random shuffle expression data for each gene
Rand_max = [1 1 -1 -1; ...
    1 -1 1 -1; ...
    1 -1 -1 1; ...
    -1 -1 1 1; ...
    -1 1 -1 1; ...
    -1 1 1 -1];
 
% calculate fold change distribution
% sort is not essential, but will make the script slightly faster
outlier_rand = sort(reshape(Rand_max*log_data_tmp(:, Experiment(:))',1,[]));
outlier_rand_length = length(outlier_rand);
 
hist(outlier_rand, 100)
xlabel('fold change of expression level, log2 scale')
ylabel('counts')
title('random diviation')
 
% initialize p value
p = zeros(1, length(sort_outlier));
 
% calculate p value
for i = 1:length(sort_outlier)
    p(i) = length(find(outlier_rand>sort_outlier(i)))/outlier_rand_length;
end
 
%% plot p value, because sort_outlier_remain is sorted, p should be
% descending order
figure
semilogy(p, '+')
hold all
 
xlim([0 15000])
plot([0 15000], [0.01 0.01], 'r-')
text(500, 0.06, '\alpha = 0.01')
xlabel('Sorted Gene')
ylabel('log10 p-value')
grid on
 
% alpha = 0.01, find outliers after bootstrapping
p_out_index = find(p<0.01);
display('Upregulated genes:')
GeneName_tmp_sorted(p_out_index(end:-1:1))
 
%% Fun stuff Below
%% Examples to illustrate how to plot with replicate information
close all
 
data_remain = data.data(index_remain, :);
 
figure('name', 'sample, EXN nrds 0hr vs 6hr')
subplot(1,3,1)
loglog(mean((data_remain(1:30,[5, 8])),2),mean((data_remain(1:30,[6, 9])),2), '.', 'markersize', 10)
xlim([1 10^6])
ylim([1 10^6])
xlabel('EXN nrds 0hr')
ylabel('EXN nrds 6hr')
title('before showing replicates')
grid on
 
subplot(1,3,2)
loglog(data_remain([1:30],[5, 8, 8, 5, 5])',data_remain([1:30],[6 6 9 9 6])', 'b','markersize', 10)
xlim([1 10^6])
ylim([1 10^6])
xlabel('EXN nrds 0hr')
ylabel('EXN nrds 6hr')
title('after showing replicates')
grid on
 
subplot(1,3,3)
plot(log_data_tmp([1:30],[5, 8, 8, 5, 5])',log_data_tmp([1:30],[6 6 9 9 6])', 'b','markersize', 10)
xlim([1 log2(10^6)])
ylim([1 log2(10^6)])
xlabel('EXN nrds 0hr')
ylabel('EXN nrds 6hr')
title('after normalization')
grid on
%% Visualize outliers with replicate information
close all
 
data_remain = data.data(index_remain, :);
 
figure('name', 'EXN nrds 0hr vs 6hr')
subplot(1,3,1)
loglog(mean((data_remain(:,Experiment(1,:))),2),mean((data_remain(:,Experiment(2,:))),2), '.', 'markersize', 10)
hold on
loglog(mean((data_remain(sort_outlier_i(p_out_index),Experiment(1,:))),2),mean((data_remain(sort_outlier_i(p_out_index),Experiment(2,:))),2), 'r.', 'markersize', 10)
xlim([1 10^6])
ylim([1 10^6])
xlabel('EXN nrds 0hr')
ylabel('EXN nrds 6hr')
title('before showing replicates')
grid on
 
% plot([1 2 2 1;2 2 3 3]', [1 1 2 2; 3 4 4 3]')
subplot(1,3,2)
loglog(data_remain(:,Experiment(1,[1 2 2 1 1]))',data_remain(:,Experiment(2,[1 1 2 2 1]))', 'b','markersize', 10, 'linewidth', 1)
hold on
loglog(data_remain(sort_outlier_i(p_out_index),Experiment(1,[1 2 2 1 1]))',data_remain(sort_outlier_i(p_out_index),Experiment(2,[1 1 2 2 1]))', 'r','markersize', 10, 'linewidth', 1)
xlim([1 10^6])
ylim([1 10^6])
% axis square
xlabel('EXN nrds 0hr')
ylabel('EXN nrds 6hr')
title('after showing replicates')
grid on
 
subplot(1,3,3)
hold on
plot(log_data_tmp(:,Experiment(1,[1 2 2 1 1]))',log_data_tmp(:,Experiment(2,[1 1 2 2 1]))', 'b','markersize', 10, 'linewidth', 1)
plot(log_data_tmp(sort_outlier_i(p_out_index),Experiment(1,[1 2 2 1 1]))',log_data_tmp(sort_outlier_i(p_out_index),Experiment(2,[1 1 2 2 1]))', 'r','markersize', 10, 'linewidth', 1)
xlim([1 log2(10^6)])
ylim([1 log2(10^6)])
xlabel('EXN nrds 0hr')
ylabel('EXN nrds 6hr')
title('after normalization')
grid on
 
%maximize_window
%%
close all
