% This code compute the Recall matrix for spike trains data and for shuffled
% spike trains (uncomment a small section for this). This script requires
% as input the z-scored spike trains of the active cells in all the
% Trials/ITIs. The residual Recall matrix can be then obtained by
% subtracting the residual recall with the average shuffled recall

% load data related to Cell type recorded and behavioural data from 
% https://crcns.org/data-sets/pfc/pfc-6/about-pfc-6

% CellType is a structure where each element is one column dataset with a 
% number that identify a putative pyramidal (2) or interneuron (1). 
% 0 for unknown. The length of this array correspond to the number of 
% neurons. In Load_CellType script all the dataset are loaded

% Similar to Load_CellType, Load_Behavior loads all the behavioural
% datasets for each sessions
% Behav is a structure where each element is a 6 colums data:
% 1st: trial start (ms)
% 2nd: Trial end  (ms)
% 3rd: trial rule (1: go right, 2: go the lit arm; 
%      3: go left, 4: go to dark arm)
% 4th: correct (1) or incorrect (0) trial
% 5th: the animal went right (0) or left (1)
% 6th: light location (switched on randomly at the beginning of each trial, 
%      even for left/right tasks). 1 or 0 (right or left)

clear all 
close all

run('Load_Behavior.m')
run('Load_CellType.m')

Qt = 0.01; % (seconds) time-resolution for convolution window : here 10 ms
% cluster analysis function arguments
binlessopts.Dmeth = 'corr';
binlessopts.BLmeth = 'Gaussian';
binlessopts.modopts = {{'sqEuclidean'},100};  % use 100 repetitions of k-means with Euclidean distance as basis for consensus
binlessopts.BLpars = 0.1; % width of convolution window, in seconds (here SD of Gaussian)
binlessopts.blnS = 0; % if 1 does not do the clustering, but compute only computes the similarity matrix
startts = 0;    % proportion of time from start of recording to begin analysis [0=first spike]
endts = 1;      % proportion of time from end of recording to end analysis [1 = final spike]

ndata = 50; % number of sessions
thresh = 0; % parameter used in F_DeleteCell_spikingCell
% deconstructThresh = .7;
start = 1;
learnSes = [1 3 7 14 19 28 32 41 44 46]; % ID for the learning sessions
InitSes = [1 13 27 38]; % ID for the first session of each animal
nrep = 1000; % number of repetitions for the shuffle control model
type = 'ITI'; % choose between 'Trial' and 'ITI'

% load the ID of the cells retained after deleting the silent ones. Comment this if you don't have those IDs and 
% uncomment below to identify the retained cells
load(['Processed Data\' type '_RetainedCell'])

for rep = 1:nrep
    Rmatrix = cell(ndata,1);
    RRmatrix = cell(ndata,1);
    before = cell(ndata,1);
    after = cell(ndata,1);
    Rmatrice = cell(ndata,1);

    for k = 1:ndata
        % load z-scored spike trains for ITIs or Trials
        switch type
            case 'ITI'
                load(['Processed Data\ITI_SpikeTrainsXTrial_',num2str(k)])
                TrData = ITIData;
            case 'Trial'
                load(['Processed Data\SpikeTrainsXTrial_',num2str(k)])
        end

        Cxy = cell(size(TrData,1),1);
        Sxy = cell(size(TrData,1),1);

%         % **********************************
%         % Uncomment this if you want to identify the silent neurons  
%         [TrData, num{k}, nallIDs{k}] = F_DeleteCell_spikingCell(TrData,length(CellType{k}),thresh);
%         CellIndex = setdiff(1:length(CellType{k}),num{k});
%         IDspk = CellIndex;    
%         N = length(IDspk);
        % **********************************
%         % Uncomment this if you want to compute the Recall matrix for the
%         % shuffled spike trains
%         % Shuffling the ISI distribution of spike train and test the correlation
%         [NewTrData] = F_ShuffleISISpikeTrain(TrData);
%         clear TrData
%         TrData = NewTrData;                
        % **********************************

        SpikeTrain = cell(size(TrData,1),1);
        NewTrData = cell(size(TrData,1),1);
        for j = 1:size(TrData,1)

            T_start_recording = min(TrData{j}(:,2));
            T_end_recording = max(TrData{j}(:,2));
            T_period = T_end_recording - T_start_recording;

            % fix start and end times of data-set to use
            T = [T_start_recording + startts*T_period T_start_recording + endts*T_period];

            %%%%%% compute similarity matrix %%%%%%%%%%%%%%%%%%%
            if ~exist('TrData','var'), error(['Data-file ' TrData{j} ' does not contain spks variable']); end  
            [Cxy{j},~,~] = F_SimilarityMatrix(TrData{j},newIDspk{k},T,Qt,binlessopts);
            Sxy{j}{1} = Cxy{j}{1};
            % rectifying similarity matrix
            Sxy{j}{1}(Sxy{j}{1} < 0) = 0; 
            Sxy{j}{1}(eye(length(newIDspk{k}))==1) = 0;
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        end
        % ***************************************
        % identifying error versus correct Trial/ITI
        switch type
            case 'ITI'
                erID = find(Behav{k}(1:end-1,4)==0);
                corID = find(Behav{k}(1:end-1,4)==1);
            case 'Trial'
                erID = find(Behav{k}(:,4)==0);
                corID = find(Behav{k}(:,4)==1);
        end
        % ***************************************
        % Compute Recall matrix
        Rmatrix{k} = zeros(size(TrData,1),size(TrData,1));
        for j = 1:size(Rmatrix{k},1)   
            for l = 1:size(Rmatrix{k},1)  
                Rmatrix{k}(j,l) = corr2(Sxy{j}{1},Sxy{l}{1});
            end
        end
        % rectify Recall matrix
        Rmatrix{k}(Rmatrix{k} < 0) = 0; 
        Rmatrix{k}(eye(size(TrData,1))==1) = 0;
        % ***************************************
        % Reshape Rmatrix according to error and correct trial
        Rmatrix{k} = Rmatrix{k}(:,[erID; corID]);
        Rmatrix{k} = Rmatrix{k}([erID; corID],:);    
        % *************************************** 
        % collect all the recall values corresponding to error/before and
        % correct/after Trial/ITI
        before{k} = reshape(Rmatrix{k}(start:length(erID),start:length(erID)),(length(erID))^2,1);
        after{k} = reshape(Rmatrix{k}(length(erID)+1:end,length(erID)+1:end),(size(Rmatrix{k},1)-length(erID))^2,1);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Some STATS
        [h(k), p(k)] = kstest2(before{k}, after{k});
        [pv(k), hi(k)] = ranksum(before{k}, after{k});
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end
    % save the Recall matrix
%     fname = ['Processed Data\' type '_Rmatrix_Rep_',num2str(rep)];
%     save(fname,'Rmatrice')
    
end


