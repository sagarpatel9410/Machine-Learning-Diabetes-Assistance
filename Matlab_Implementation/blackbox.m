function bb = blackbox(new_user, topic)
prob = rand();

if(new_user(topic,1) >= prob)
    bb = 1;
else
    bb = 0;
end
