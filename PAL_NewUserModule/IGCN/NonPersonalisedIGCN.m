function [ newUserPredicted ] = NonPersonalisedIGCN(topics, newUser, questions, newUserPredicted)
    for i = 1:questions
        newUserPredicted(topics(i), 1) = newUserPredicted(topics(i), 1) + (newUser(topics(i)) >= rand());
        newUserPredicted(topics(i), 2) = newUserPredicted(topics(i), 2) + 1;
    end

end

