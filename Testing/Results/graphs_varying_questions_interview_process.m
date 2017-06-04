clear
results_algebra_random

plot(rmse,'LineWidth',2);
hold on

results_algebra_pop
plot(rmse,'LineWidth',2);

xlabel('Number of Questions');
ylabel('RMSE');
title('RMSE vs. Number of Questions')

legend('Random Interview', 'Popularity')