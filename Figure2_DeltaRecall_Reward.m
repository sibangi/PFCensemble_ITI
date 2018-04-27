%% script to assemble sub-panels for Figure
% This code generate Figure 2 of Maggi et al., 2018 
clear all;
close all

filepath = 'Processed Data\';

% common parameters
run figure_properties

type = 'ITI';

barsize = [10 15 5 4.5];
siz = 3;

%% Data parameters
ndata = 50;
learnSes = [1 3 7 14 19 28 32 41 44 46];
InitSes = [1 13 27 38];
run('Load_Behavior.m') 
learning = load([filepath 'LearningTrials.txt']);
learn = learning(:,2);
RuleChange = [];
Other = [];
for k = 1:ndata
    if (length(unique(Behav{k}(1:end-1,3)))>1) && (~ismember(k,learnSes))
        RuleChange(end+1) = k;
    elseif (~ismember(k,learnSes))
        Other(end+1) = k;
    end
end

load([filepath 'ITI_Rmatrix_correlation.mat']);
load([filepath 'ITI_ResidualRmatrixShuffleISI_correlation.mat']);
is = 9; % id for the learning sessions used as example session
idSes = learnSes(is); % learning sessions used as example session


er = find(Behav{idSes}(1:end-1,4)==0);
cor = find(Behav{idSes}(1:end-1,4)==1);
RRmat = ResidMat{idSes}(:,[er; cor]);
RRmat = RRmat([er; cor],:);
Rmat = Rmatrice{idSes}(:,[er; cor]);
Rmat = Rmat([er; cor],:);

%% panel :  Example Residual Recall matrix (reward-driven error-correct order)
M=abs(max(max([RRmat])));
m=abs(min(min([RRmat])));

figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',barsize); hold on;
shading flat
axis([0.5 size(ResidMat{idSes},1)+.5 0.5 size(ResidMat{idSes},1)+.5])
imagesc(RRmat); hold on
axis equal
axis tight
colormap(b2r(-m,M));
colorbar;
plot([1 size(ResidMat{idSes},1)],[length(er)+.5 length(er)+.5],'k'); hold on
plot([length(er)+.5 length(er)+.5],[1 size(ResidMat{idSes},1)],'k'); hold on
set(gca,'XTick',1:size(ResidMat{idSes},1))
set(gca,'XTickLabel',Behav{idSes}([er; cor],4))
set(gca,'YTick',1:size(ResidMat{idSes},1))
set(gca,'YTickLabel',Behav{idSes}([er; cor],4))
xlabel([type '(0=incorrect, 1=correct)'],'FontSize',fontsize)
ylabel(type,'FontSize',fontsize)
title('Residual Recall matrix','FontSize',fontsize)
set(gca,'FontName','Helvetica','FontSize',fontsize);
set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);
xticks = get(gca,'XTick'); xticklbls = get(gca,'XTickLabel');
set(gca,'XTick',xticks+0.5,'XTickLabel',xticklbls);

% print -depsc Figures/FigDelatRecall_ExampleResidualRecal
% exportfig(gcf,['Figures/FigDelatRecall_ExampleResidualRecal'],'Color',color,'Format',format,'Resolution',dpi)

%% panel : PDF of error-correct residual recall values distribution
barsize0 = [10 15 2.5 1.5];

[f_Err,xi_Err] = hist(reshape(Rmat(1:length(er),1:length(er)),[length(er)^2 1]),30);
[f_Cor,xi_Cor] = hist(reshape(Rmat(1+length(er):end,1+length(er):end),[length(cor)^2 1]),30);

figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',barsize0); hold on;
bar(xi_Err,f_Err./sum(f_Err),'hist'); hold on
bar(xi_Cor,f_Cor./sum(f_Cor),'hist'); hold on
h2 = findobj(gca,'Type','patch');
set(h2(1),'FaceColor',[1 0 0],'EdgeColor','none','Facealpha',.3)
set(h2(2),'FaceColor',[0 0 0],'EdgeColor','none','Facealpha',.3)
set(gca,'FontName','Helvetica','FontSize',fontsize);
set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);
xlim([0 1])

% print -depsc Figures/FigDelatRecall_DistributionErCorRecal
% exportfig(gcf,['Figures/FigDelatRecall_DistributionErCorRecal'],'Color',color,'Format',format,'Resolution',dpi)

[f_residErr,xi_residErr] = hist(reshape(RRmat(1:length(er),1:length(er)),[length(er)^2 1]),30);
[f_residCor,xi_residCor] = hist(reshape(RRmat(1+length(er):end,1+length(er):end),[length(cor)^2 1]),30);

figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',barsize0); hold on;
bar(xi_residErr,f_residErr./sum(f_residErr),'hist'); hold on
bar(xi_residCor,f_residCor./sum(f_residCor),'hist'); hold on
h2 = findobj(gca,'Type','patch');
set(h2(1),'FaceColor',[1 0 0],'EdgeColor','none','Facealpha',.3)
set(h2(2),'FaceColor',[0 0 0],'EdgeColor','none','Facealpha',.3)
xlim([-.2 .8])
set(gca,'FontName','Helvetica','FontSize',fontsize);
set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);

% print -depsc Figures/FigDelatRecall_DistributionErCorResidualRecal
% exportfig(gcf,['Figures/FigDelatRecall_DistributionErCorResidualRecal'],'Color',color,'Format',format,'Resolution',dpi)

%% panel : Example Recall matrix (reward-driven error-correct order)
M=abs(max(max([Rmat])));
m=abs(min(min([Rmat])));

figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',barsize); hold on;
shading flat
axis([0.5 size(Rmatrice{idSes},1)+.5 0.5 size(Rmatrice{idSes},1)+.5]); hold on
colormap(b2r(-m,M));
imagesc(Rmat); hold on
axis equal
axis tight
colorbar;
plot([1 size(ResidMat{idSes},1)],[length(er)+.5 length(er)+.5],'k'); hold on
plot([length(er)+.5 length(er)+.5],[1 size(ResidMat{idSes},1)],'k'); hold on
set(gca,'XTick',1:size(ResidMat{idSes},1))
set(gca,'XTickLabel',Behav{idSes}([er; cor],4))
set(gca,'YTick',1:size(ResidMat{idSes},1))
set(gca,'YTickLabel',Behav{idSes}([er; cor],4))
xlabel([type '(0=incorrect, 1=correct)'],'FontSize',fontsize)
ylabel(type,'FontSize',fontsize)
title('Recall matrix','FontSize',fontsize)
set(gca,'FontName','Helvetica','FontSize',fontsize);
set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);
xticks = get(gca,'XTick'); xticklbls = get(gca,'XTickLabel');
set(gca,'XTick',xticks+0.5,'XTickLabel',xticklbls);

% print -depsc Figures/FigDelatRecall_ExampleRecal
% exportfig(gcf,['Figures/FigDelatRecall_ExampleRecal'],'Color',color,'Format',format,'Resolution',dpi)

%% panel : Comparison recall and delta recall for the selected learning sessions 
MeanErr = [nanmean(reshape(Rmat(1:length(er),1:length(er)),(length(er))^2,1)) ...
    nanmean(reshape(RRmat(1:length(er),1:length(er)),(length(er))^2,1))]; 
MeanCorr = [nanmean(reshape(Rmat(length(er)+1:end,length(er)+1:end),(size(Rmat,1)-length(er))^2,1)) ...
    nanmean(reshape(RRmat(length(er)+1:end,length(er)+1:end),(size(RRmat,1)-length(er))^2,1))];

barsize = [10 15 2 4];
figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',barsize); hold on;
h1=plot([1 2],[MeanErr(1) MeanCorr(1)],'ko-','MarkerFaceColor','k');hold on
h2=plot([1 2],[MeanErr(2) MeanCorr(2)],'o-','Color',[.4 .4 .4],'MarkerFaceColor',[.4 .4 .4]);hold on
xlim([.5 2.5])
ylim([0 .7])
ylabel('Average Recall','FontSize',fontsize)
legend([h1 h2],'Original', 'Residual')
set(gca,'XTick',1:2)
set(gca,'XTickLabel',{'Error','Correct'})
set(gca,'FontName','Helvetica','FontSize',fontsize);
set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);

% print -depsc Figures/FigDelatRecall_ExampleRecallResidualRecal_ErrCor
% exportfig(gcf,['Figures/FigDelatRecall_ExampleRecallResidualRecal_ErrCor'],'Color',color,'Format',format,'Resolution',dpi)

%% Stat test KS on Recall and Residual Recall
% Recall
[hR,pR] = kstest2(reshape(Rmat(1:length(er),1:length(er)),(length(er))^2,1), ...
    reshape(Rmat(length(er)+1:end,length(er)+1:end),(size(Rmat,1)-length(er))^2,1));
% Residual Recall
[hRR,pRR] = kstest2(reshape(RRmat(1:length(er),1:length(er)),(length(er))^2,1), ...
    reshape(RRmat(length(er)+1:end,length(er)+1:end),(size(RRmat,1)-length(er))^2,1));

%% panel : Delta Recall between error-correct for learning, rule change and others

before = cell(ndata,1);
after = cell(ndata,1);
hRecall = zeros(ndata,1);
pRecall = zeros(ndata,1);
bef = zeros(ndata,1);
aft = zeros(ndata,1);

barsize = [10 15 4 5.5];
figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',barsize)
for k = 1:ndata
    erID = find(Behav{k}(1:end-1,4)==0);
    corID = find(Behav{k}(1:end-1,4)==1);
    Rmatrix = ResidMat{k}(:,[erID; corID]);
    Rmatrix = Rmatrix([erID; corID],:);
    before{k} = reshape(Rmatrix(1:length(erID),1:length(erID)),(length(erID))^2,1);
    after{k} = reshape(Rmatrix(length(erID)+1:end,length(erID)+1:end),(size(Rmatrix,1)-length(erID))^2,1);
    [hRecall(k), pRecall(k)] = kstest2(before{k}, after{k});

    bef(k) = nanmean(before{k})-(nanmean(before{k}));
    aft(k) = nanmean(after{k})-(nanmean(before{k}));
    
    if ismember(k,learnSes)
        if pRecall(k)>=0.05
            plot(1,aft(k),'o-','Color',Clearn,'MarkerSize',siz);hold on
        elseif (pRecall(k)<0.05) && (aft(k)>0)
            plot(1,aft(k),'o-','Color',Clearn,'MarkerFaceColor',Clearn, ...
                'MarkerSize',siz); hold on
        end   
        if aft(k)<=0
            plot(1,aft(k),'o-','Color',Clearn,'MarkerSize',siz);hold on
        end
    end
end
hold on
b=boxplot(aft(learnSes),'Color',Clearn); hold on %,'boxstyle','filled'); hold on
set(b(7,:),'Visible','off');
plot([.7 1.3],[0 0],'k--'); hold on
xlim([.7 1.3])
ylim([-.2 .3])
set(gca,'XTick',1)
set(gca,'XTickLabel',{'Correct'})
ylabel('Delta Recall','FontSize',fontsize)
title('Learning','FontSize',fontsize)
set(gca,'FontName','Helvetica','FontSize',fontsize);
set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);

% print -depsc Figures/FigDelatRecall_Learning
% exportfig(gcf,['Figures/FigDelatRecall_Learning'],'Color',color,'Format',format,'Resolution',dpi)

figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',barsize)
for k = 1:ndata
    if ismember(k,RuleChange)
        if pRecall(k)>=0.05
            plot(1,aft(k),'o-','Color',Crulec,'MarkerSize',siz);hold on
        elseif (pRecall(k)<0.05) && (aft(k)>0)
            plot(1,aft(k),'o-','Color',Crulec,'MarkerFaceColor',Crulec,...
                'MarkerSize',siz); hold on
        end     
        if aft(k)<=0
            plot(1,aft(k),'o-','Color',Crulec,'MarkerSize',siz);hold on
        end
    end
end
b=boxplot(aft(RuleChange),'Color',Crulec); hold on %,'boxstyle','filled'); hold on
set(b(7,:),'Visible','off');
plot([.7 1.3],[0 0],'k--'); hold on
xlim([.7 1.3])
ylabel('Delta Recall','FontSize',fontsize)
set(gca,'XTick',1)
set(gca,'XTickLabel',{'Correct'})
title('Rule change','FontSize',fontsize)
ylim([-.2 .3])
set(gca,'FontName','Helvetica','FontSize',fontsize);
set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);

% print -depsc Figures/FigDelatRecall_RuleChange
% exportfig(gcf,['Figures/FigDelatRecall_RuleChange'],'Color',color,'Format',format,'Resolution',dpi)

figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',barsize)
for k = 1:ndata
    if ~ismember(k,RuleChange) || ~ismember(k,learnSes)
        if pRecall(k)>=0.05
            plot(1,aft(k),'o-','Color',Cother,'MarkerSize',siz);hold on
        elseif (pRecall(k)<0.05) && (aft(k)>0)
            plot(1,aft(k),'o-','Color',Cother,'MarkerFaceColor',Cother,...
                'MarkerSize',siz); hold on
        end   
        if aft(k)<=0
            plot(1,aft(k),'o-','Color',Cother,'MarkerSize',siz);hold on
        end
    end
end
b=boxplot(aft(Other),'Color',Cother); hold on %,'boxstyle','filled'); hold on
set(b(7,:),'Visible','off');
plot([.7 1.3],[0 0],'k--'); hold on
xlim([.7 1.3])
ylabel('Delta Recall','FontSize',fontsize)
set(gca,'XTick',1)
set(gca,'XTickLabel',{'Correct'})
title('Others','FontSize',fontsize)
ylim([-.2 .3])
set(gca,'FontName','Helvetica','FontSize',fontsize);
set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);

% print -depsc Figures/FigDelatRecall_Others
% exportfig(gcf,['Figures/FigDelatRecall_Others'],'Color',color,'Format',format,'Resolution',dpi)

[p,h] = signtest(aft(learnSes)); 
[p,h] = signtest(aft(RuleChange));
[p,h] = signtest(aft(Other));


%% ***************************
% test for significant erro-correct change in recall matrices (not
% residual)
n=0;
for k = 1:ndata
    erID = find(Behav{k}(1:end-1,4)==0);
    corID = find(Behav{k}(1:end-1,4)==1);
    Rmatrix = Rmatrice{k}(:,[erID; corID]);
    Rmatrix = Rmatrix([erID; corID],:);
    before{k} = reshape(Rmatrix(1:length(erID),1:length(erID)),(length(erID))^2,1);
    after{k} = reshape(Rmatrix(length(erID)+1:end,length(erID)+1:end),(size(Rmatrix,1)-length(erID))^2,1);
    [hRecall(k), pRecall(k)] = kstest2(before{k}, after{k});
    if (mean(before{k})<mean(after{k})) && (pRecall(k)<0.05)
        n = n+1;
    end
end