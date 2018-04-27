function [SpkData, num, nallIDs] = F_DeleteCell_spikingCell(SpkData,nCell,thresh)
% 
% This function delete the cells that are silent for a specified amount of 
% trials defined by a tollerance value (thresh)  
% INPUT
% SpkData :   are the spike trains of each cell for each trial. This is
%             a cell array. For each trial a cell contains the spike 
%             trains of the neurons   
% nCell   :   is a scalar and contains the total number of cell recorded in
%             the session
% thresh  :   is the threshold between 0 and 1 over which the silent cell 
%             will be deleted. 0 if a cell is silent in at least one trial 
%             is eliminated; 1 no cell are eliminated. 
% OUTPUT
% SpkData :   new cell array containing only the spike trains that satisfy
%             the treshold condition
% num     :   is a vector containing the index of the cell excluded
% nallIDs :   is the number of cell in all the Trials/ITIs 

    emptyspk = [];
    for j = 1:size(SpkData,1);
        SpikeData = SpkData{j};

        % identify for each Trials/ITIs the non-spiking cell or cells with
        % only one spike
        IDspk = unique(SpikeData(:,1));
        nallIDs = numel(IDspk);
        if nCell > nallIDs;
           ISM = ismember(1:nCell,IDspk);
           emptyspk = [emptyspk find(ISM==0)];
        end
        
        for i = 1:nCell;
            if sum(SpikeData(:,1)==i)==1;
                emptyspk = [emptyspk i];
            end
        end
                
    end
    
    %  For each cell, if the proportion of Trials/ITIs with empty spike is
    %  > thresh then that cell is removed
    IDemptyspk = unique(emptyspk);
    num = [];
    for h = 1:length(IDemptyspk);
        if length(find(emptyspk==IDemptyspk(h)))/size(SpkData,1) > thresh;
            num(end+1) = IDemptyspk(h);
            for j = 1:size(SpkData,1);
                clear SpkData{j}
                SpkData{j}(SpkData{j}(:,1)==num(end),:) = [];
            end
        end
    end
    
    
    
    
    
 