clear
%The purpose of this script is to provide task recommendation to a current
%student in the PAL system.

%Load data from database
load studentTopicmodels.mat
topicModel = utility;
clearvars -except questionAnswered questionModel topicModel

%Provide Task Recommendation for user 1;
user = 1;
%Provide Topic Recommendation
%Used to determine what method of topic recommendation to use (Average FPS (0) or Temporal FPS (1))
TopicRecommendation = 0;
%There are two options to provide topic recommendation: Average FPS or
%Temporal FPS.

if TopicRecommendation == 0
    StudentTopicModel = topicModel(user,:);
    TopicSuggestion = FPS(StudentTopicModel);
else
    %Load this students time series data used for Temporal FPS;
    StudentTopicModelAdjusted = zeros(size(topicModel(user,:)));
    load student1timeseriesdata.mat
    %---------------------------------------------------------
    %This method will not work as we do not have a users time series data
    %for each topic. The timeseries data that has been loaded is for a
    %single topic. 
    
    %The code that follows shows how to calculate the temporal average for a single topic.
    %This will need to be done for all topics for a single use once all
    %data is available.
    
    %Peform Logistic Regression - Determine coefficients
    coefTopic1 = LogisticRegression(timeseries);
    
    %Calculate predicted performance in a single topic.   
    TopicPerformance1 = coefTopic1(1) + coefTopic1(2)*(timeseries(end,2)+1);
    TopicPerformance1 = 1/(1 + exp(-TopicPerformance1));
    
    StudentTopicModelAdjusted(1) = TopicPerformance1;
    %-------------------------------------------------------------------
    TopicSuggestion = FPS(StudentTopicModelAdjusted);
    
end


%Provide Question Recommendation
%Again question data is only available for a single topic so the models that have
%been generated are for a single topic but it should serve as a proof of
%concept on how to use the models once generated

%Used to determine what method of question recommendation to use (NeighbourHood(0) or LatentFactors(1))
TopicRecommendation = 0;

if TopicRecommendation == 0
    [ userPredictedQuestionModel ] = NeighbourHoodModel(user,TopicSuggestion);
    QuestionSuggestion = FPS(userPredictedQuestionModel);
else
    %Load latentfactors for Topic = TopicSuggestion
    %As we only have data for a single topic we show how this is done for
    %topic 1
    
    load latentFactorsTopic1
    
    %Get latent factors for user = 1;
    userLatentFactors = P(user,:);
    userAdjustedQuestionModel = student_bias(user) + task_bias(user) + mu + userLatentFactors * Q';
    
    %User FPS to determine the next question, with questions closer to 0.5
    %rating with more liklihood of being chosen.
    
    QuestionSuggestion = FPS(userAdjustedQuestionModel);
    
    
end

fprintf('User 1: Topic Suggestion = %i, Question Suggestion = %i\n', TopicSuggestion, QuestionSuggestion)
clear
