%This scripts is responsible for retraining the models: IGCN and ABDT

% 
% %% Train IGCN
% smoothing = 0; %Smoothing determines if the models should first smooth the data before operating on it.
% [N, idx, C, topics ] = train_IGCN_model(smoothing);
% save('Database/IGCN-Model-Params.mat', 'N','idx','C','topics') 
% 
% clearvars -except smoothing

%% Train DT
smoothing = 0; %Smoothing determines if the models should first smooth the data before operating on it.
tree = train_ABDT_model(smoothing);
save('Database\ABDT-Model-Params.mat', 'tree');

