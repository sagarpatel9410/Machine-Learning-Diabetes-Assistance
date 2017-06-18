clear
%The background process is used to build the latent factor models

%As there is only question data available for a single topic we show how it
%is done using a single topic, once all data is available for each topic
%then you would repeat the process over all topics.

topic = 1;
[P,Q, mu,student_bias,task_bias ] = LatentFactorAnalysis(topic);
save('Database/latentFactorsTopic1','P','Q','mu','student_bias','task_bias')