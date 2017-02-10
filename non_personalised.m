function [new_user_profile, questions_asked] = non_personalised(initial, IG, new_user)
new_user_profile = zeros(35,2);
questions_asked = 0;

for np = 1:initial 
    new_user_profile(IG(np,2),1) = new_user_profile(IG(np,2),1) + blackbox(new_user,IG(np,2));
    new_user_profile(IG(np,2),2) = new_user_profile(IG(np,2),2) + 1;
    questions_asked = questions_asked + 1;
end
