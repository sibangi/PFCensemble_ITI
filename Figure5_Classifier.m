% This script reproduce panels in Figure 5 and Figure 6 of Maggi et al., 2018

clear all
close all

filepath = 'Processed Data\';
run('Load_Behavior.m') 

% common parameters
run figure_properties

TrType = 'ITI';
siz = 3;

%% Data parameters
ndata = 50;
learnSes = [1 3 7 14 19 28 32 41 44 46];
InitSes = [1 13 27 38 ndata];
%************************************
% Here identify the first session of each animal, the sessions before rule
% change and the first rule change session of each animal
rule = zeros(ndata,1);
FirstRC = [];
for k = 1:ndata
    rule(k) = Behav{k}(end,3);
end

for s = 1:length(InitSes)-1;
    indses = find(diff(rule(InitSes(s):InitSes(s+1)))>0,1,'first'); 
    FirstRC(end+1) = indses+InitSes(s)-1;
end
FirstRC(end) = 37;

BeforeRC = [];
for s = 1:length(InitSes)-1 
    BeforeRC = horzcat(BeforeRC, [InitSes(s):FirstRC(s)]); 
end
%************************************
% Identification of Rule change and Other sessions. Then identification direction and 
% cue rule sessions whitin the learning, rule-change and other sessions
nsez = 5;
RuleChange = [];
NonLearn = [];
for k = 1:ndata
    if (length(unique(Behav{k}(1:end-1,3)))>1) && (~ismember(k,learnSes))
        RuleChange(end+1) = k;
    elseif ~ismember(k,learnSes)
        NonLearn(end+1) = k;
    end
end

Learn1 = []; Learn2 = [];
Rchan1 = []; Rchan2 = [];
NLearn1 = []; NLearn2 = [];
for k = 1: length(learnSes)
    if (Behav{learnSes(k)}(1,3)==1) || (Behav{learnSes(k)}(1,3)==3)
        Learn1(end+1) = learnSes(k);
    else
        Learn2(end+1) = learnSes(k);
    end
end
for k = 1: length(RuleChange)
    if (Behav{RuleChange(k)}(1,3)==1) || (Behav{RuleChange(k)}(1,3)==3)
        Rchan1(end+1) = RuleChange(k);
    else
        Rchan2(end+1) = RuleChange(k);
    end
end
for k = 1:length(NonLearn)
    if (Behav{NonLearn(k)}(1,3)==1) || (Behav{NonLearn(k)}(1,3)==3)
        NLearn1(end+1) = NonLearn(k);
    else
        NLearn2(end+1) = NonLearn(k);
    end
end
    
%% load name of classifiers, variable decoded (outcome, direction, light), controls
load([filepath num2str(TrType),'_Name_Decode_Control_Classifiers.mat']);

controlli = [0 1 0 1 0 1]; % controls, alternate 1 and 2 with outcome, direction and light 
nomi = [0 0 0 0 0 0 0 0 0 1]; % 10 names for the classifiers
ind = find(controlli == 1);
ind_name = find(nomi == 1);

%% panel : Decoder accuracy for prospective approach. Comparison between 
% session types (learning, rule change, others) within direction rules and
% light rules

for n = 1:length(ind_name)
    figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',[10 15 10 7])
    for cl = 1:length(ind)
        load([filepath num2str(TrType),'_Classifiers_',num2str(control(ind(cl),:)),'_',num2str(decode(ind(cl),:)),'.mat']);        
        subplot(3,3,cl)
        h1=errorbar(nanmean(SCORE(Learn1,:,ind_name(n)))-nanmean(SCORE_shuf(Learn1,:,ind_name(n))), ...
            nansem(SCORE(Learn1,:,ind_name(n))),'o-','Color',Clearn,'MarkerFaceColor',Clearn,'MarkerSize',siz); hold on
        errorbar(nanmean(SCORE(Learn2,:,ind_name(n)))-nanmean(SCORE_shuf(Learn2,:,ind_name(n))), ...
            nansem(SCORE(Learn2,:,ind_name(n))),'o-','Color',Clearn,'MarkerSize',siz); hold on
        plot([1,nsez],[0,0],'k--'); hold on
        ylim([-.2, 0.5])
        xlim([.5 5.5])
        title([decode(ind(cl),:) ' ' control(ind(cl),:)],'FontSize',fontsize)
        set(gca,'FontName','Helvetica','FontSize',fontsize);
        set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);
        
        subplot(3,3,cl+3)
        h2=errorbar(nanmean(SCORE(Rchan1,:,ind_name(n)))-nanmean(SCORE_shuf(Rchan1,:,ind_name(n))), ...
            nansem(SCORE(Rchan1,:,ind_name(n))),'o-','Color',Crulec,'MarkerFaceColor',Crulec,'MarkerSize',siz); hold on
        errorbar(nanmean(SCORE(Rchan2,:,ind_name(n)))-nanmean(SCORE_shuf(Rchan2,:,ind_name(n))), ...
            nansem(SCORE(Rchan2,:,ind_name(n))),'o-','Color',Crulec,'MarkerSize',siz); hold on
        plot([1,nsez],[0,0],'k--'); hold on
        ylim([-.2, 0.5])
        xlim([.5 5.5])
        set(gca,'FontName','Helvetica','FontSize',fontsize);
        set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);
        
        subplot(3,3,cl+6)
        h3=errorbar(nanmean(SCORE(NLearn1,:,ind_name(n)))-nanmean(SCORE_shuf(NLearn1,:,ind_name(n))), ...
            nansem(SCORE(NLearn1,:,ind_name(n))),'o-','Color',Cother,'MarkerFaceColor',Cother,'MarkerSize',siz); hold on
        errorbar(nanmean(SCORE(NLearn2,:,ind_name(n)))-nanmean(SCORE_shuf(NLearn2,:,ind_name(n))), ...
            nansem(SCORE(NLearn2,:,ind_name(n))),'o-','Color',Cother,'MarkerSize',siz); hold on
        plot([1,nsez],[0,0],'k--'); hold on
        ylim([-.2, 0.5])
        xlim([.5 5.5])
        set(gca,'FontName','Helvetica','FontSize',fontsize);
        set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);
        xlabel('Maze position','FontSize',fontsize)
    end
    subplot(3,3,1)
    legend([h1,h2,h3],'Learning','Rule change','Other')
    subplot(3,3,4)
    ylabel([{names(ind_name(n),:)},{'Prospective'}],'FontSize',fontsize) 
    
%     print(['Figures/FigClassifier_ProspectiveWithinSesType_',num2str(n)], '-depsc ')
%     exportfig(gcf,['Figures/FigClassifier_ProspectiveWithinSesType_',num2str(n)],'Color',color,'Format',format,'Resolution',dpi)

end

%% panel : Decoder accuracy for retrospective approach. Comparison within 
% session types (learning, rule change, others) between direction rules and
% light rules

for n = 1:length(ind_name)
    figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',[10 15 10 7])
    for cl = 1:length(ind)
        load([filepath num2str(TrType),'_Classifiers_',num2str(control(ind(cl),:)),'_',num2str(decode(ind(cl),:)),'.mat']);        
        subplot(3,3,cl)
        h1=errorbar(nanmean(SCORE_retro(Learn1,:,ind_name(n)))-nanmean(SCORE_retro_shuf(Learn1,:,ind_name(n))), ...
            nansem(SCORE_retro(Learn1,:,ind_name(n))),'o-','Color',Clearn,'MarkerFaceColor',Clearn,'MarkerSize',siz); hold on
        h2=errorbar(nanmean(SCORE_retro(Learn2,:,ind_name(n)))-nanmean(SCORE_retro_shuf(Learn2,:,ind_name(n))), ...
            nansem(SCORE_retro(Learn2,:,ind_name(n))),'o-','Color',Clearn,'MarkerSize',siz); hold on
        plot([1,nsez],[0,0],'k--'); hold on
        ylim([-.2, 0.5])
        xlim([.5 5.5])
        title([decode(ind(cl),:) ' ' control(ind(cl),:)],'FontSize',fontsize)
        set(gca,'XTick',1:5)
        set(gca,'XTickLabel',{1:5},'FontSize',fontsize)
        set(gca,'FontName','Helvetica','FontSize',fontsize);
        set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);

        subplot(3,3,cl+3)
        errorbar(nanmean(SCORE_retro(Rchan1,:,ind_name(n)))-nanmean(SCORE_retro_shuf(Rchan1,:,ind_name(n))), ...
            nansem(SCORE_retro(Rchan1,:,ind_name(n))),'o-','Color',Crulec,'MarkerFaceColor',Crulec,'MarkerSize',siz); hold on
        errorbar(nanmean(SCORE_retro(Rchan2,:,ind_name(n)))-nanmean(SCORE_retro_shuf(Rchan2,:,ind_name(n))), ...
            nansem(SCORE_retro(Rchan2,:,ind_name(n))),'o-','Color',Crulec,'MarkerSize',siz); hold on
        plot([1,nsez],[0,0],'k--'); hold on
        ylim([-.2, 0.5])
        xlim([.5 5.5])
        set(gca,'XTick',1:5)
        set(gca,'XTickLabel',{1:5},'FontSize',fontsize)
        set(gca,'FontName','Helvetica','FontSize',fontsize);
        set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);
        
        subplot(3,3,cl+6)
        errorbar(nanmean(SCORE_retro(NLearn1,:,ind_name(n)))-nanmean(SCORE_retro_shuf(NLearn1,:,ind_name(n))), ...
            nansem(SCORE_retro(NLearn1,:,ind_name(n))),'o-','Color',Cother,'MarkerFaceColor',Cother,'MarkerSize',siz); hold on
        errorbar(nanmean(SCORE_retro(NLearn2,:,ind_name(n)))-nanmean(SCORE_retro_shuf(NLearn2,:,ind_name(n))), ...
            nansem(SCORE_retro(NLearn2,:,ind_name(n))),'o-','Color',Cother,'MarkerSize',siz); hold on
        plot([1,nsez],[0,0],'k--'); hold on
        ylim([-.2, 0.5])
        xlim([.5 5.5])
        xlabel('Maze position','FontSize',fontsize)
        set(gca,'XTick',1:5)
        set(gca,'XTickLabel',{1:5},'FontSize',fontsize)
        set(gca,'FontName','Helvetica','FontSize',fontsize);
        set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);
        
    end
    subplot(3,3,1)
    legend([h1,h2],'Dir rule','Lig rule')
    ylabel([{names(ind_name(n),:)},{'Retrospective'},{'Learning'}],'FontSize',fontsize) 
    subplot(3,3,4)
    ylabel([{names(ind_name(n),:)},{'Retrospective'},{'Rule Change'}],'FontSize',fontsize) 
    subplot(3,3,7)
    ylabel([{names(ind_name(n),:)},{'Retrospective'},{'Others'}],'FontSize',fontsize) 
   
end
% print -depsc Figures/FigClassifier_WithinSesType
% exportfig(gcf,['Figures/FigClassifier_WithinSesType'],'Color',color,'Format',format,'Resolution',dpi)

%% panel : Retrospective comparison of classifier accuracy between the first 
% session of each animal, the light rule sessions and all the sessions
% before the first rule change.

for n = 1:length(ind_name)
    figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',[10 15 10 2.2])
    for cl = 1:length(ind)
        load([filepath num2str(TrType),'_Classifiers_',num2str(control(ind(cl),:)),'_',num2str(decode(ind(cl),:)),'.mat']);  
        subplot(1,3,cl)
        h1 = errorbar(nanmean(SCORE_retro(InitSes(1:end-1),:,ind_name(n)))-nanmean(SCORE_retro_shuf(InitSes(1:end-1),:,ind_name(n))), ...
            nansem(SCORE_retro(InitSes(1:end-1),:,ind_name(n))),'o-','Color',[.6 .6 .6],'MarkerFaceColor',[.6 .6 .6],'MarkerSize',siz); hold on
        h2 = errorbar(nanmean(SCORE_retro(BeforeRC,:,ind_name(n)))-nanmean(SCORE_retro_shuf(BeforeRC,:,ind_name(n))), ...
            nansem(SCORE_retro(BeforeRC,:,ind_name(n))),'o-','Color','k','MarkerFaceColor', 'k','MarkerSize',siz); hold on
        h3 = errorbar(nanmean(SCORE_retro(Learn2,:,ind_name(n)))-nanmean(SCORE_retro_shuf(Learn2,:,ind_name(n))), ...
            nansem(SCORE_retro(Learn2,:,ind_name(n))),'o-','Color',Clearn,'MarkerSize',siz); hold on
        plot([0,nsez],[0,0],'k--'); hold on
        ylim([-.2 0.5])   
        xlim([.5 5.5])
        title([decode(ind(cl),:) ' ' control(ind(cl),:)],'FontSize',fontsize)
        set(gca,'FontName','Helvetica','FontSize',fontsize);
        set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);
    end
    subplot(1,3,1)
    legend([h1,h2,h3],'First ses','Before RC','Lig rule')
    ylabel([{names(ind_name(n),:)},{'Retrospective'},{'rules'}],'FontSize',fontsize)    
    
%     print(['Figures/FigClassifier_FirstSesBeforeRCLightRule_',num2str(n)], '-depsc ')
%     exportfig(gcf,['Figures/FigClassifier_FirstSesBeforeRCLightRule_',num2str(n)],'Color',color,'Format',format,'Resolution',dpi)

end

%% panel : Decoder accuracy for retrospective approach. Comparison within 
% session types (learning, rule change, others) between direction rules and
% light rules

for n = 1:length(ind_name)
    figure('Units', 'centimeters', 'PaperPositionMode', 'auto','Position',[10 15 9.5 5])
    for cl = 1:length(ind)
        load([filepath num2str(TrType),'_Classifiers_',num2str(control(ind(cl),:)),'_',num2str(decode(ind(cl),:)),'.mat']);        
        subplot(2,3,cl)
        h1 = errorbar(nanmean(SCORE_retro(NLearn1,:,ind_name(n))), ...
            nansem(SCORE_retro(NLearn1,:,ind_name(n))),'o-','Color',Cother,'MarkerFaceColor',Cother,'MarkerSize',siz); hold on 
        h2 = errorbar(nanmean(SCORE_retro_shuf(NLearn1,:,ind_name(n))), ...
            nansem(SCORE_retro_shuf(NLearn1,:,ind_name(n))),'o-','Color',[.6 .6 .6],'MarkerFaceColor',[.6 .6 .6],'MarkerSize',siz); hold on

        plot([1,nsez],[0,0],'k--'); hold on
        ylim([.3 1])
        xlim([.5 5.5])
        title([decode(ind(cl),:) ' ' control(ind(cl),:)],'FontSize',fontsize)
        set(gca,'XTick',1:5)
        set(gca,'XTickLabel',{1:5},'FontSize',fontsize)
        set(gca,'FontName','Helvetica','FontSize',fontsize);
        set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);

        subplot(2,3,cl+3)
        errorbar(nanmean(SCORE_retro(NLearn2,:,ind_name(n))), ...
            nansem(SCORE_retro(NLearn2,:,ind_name(n))),'o-','Color',Cother,'MarkerSize',siz); hold on
        errorbar(nanmean(SCORE_retro_shuf(NLearn2,:,ind_name(n))), ...
            nansem(SCORE_retro_shuf(NLearn2,:,ind_name(n))),'o-','Color',[.6 .6 .6],'MarkerSize',siz); hold on
        
        plot([1,nsez],[0,0],'k--'); hold on
        ylim([.3 1])
        xlim([.5 5.5])
        set(gca,'XTick',1:5)
        set(gca,'XTickLabel',{1:5},'FontSize',fontsize)
        set(gca,'FontName','Helvetica','FontSize',fontsize);
        set(gca,'Box','off','TickDir','out','LineWidth',axlinewidth);
        
        xlabel('Maze position','FontSize',fontsize)
        
    end
    subplot(2,3,1)
    legend([h1,h2],'Data','Ctrl')
    ylabel([{names(ind_name(n),:)},{'Retrospective'},{'Dir rule'}],'FontSize',fontsize) 
    subplot(2,3,4)
    ylabel([{names(ind_name(n),:)},{'Retrospective'},{'Lit rule'}],'FontSize',fontsize) 

   
end
% print -depsc Figures/FigClassifier_ExampleClassifVsChanceLevel
% exportfig(gcf,['Figures/FigClassifier_ExampleClassifVsChanceLevel'],'Color',color,'Format',format,'Resolution',dpi)
