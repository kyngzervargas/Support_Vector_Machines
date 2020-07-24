clearvars;
close all;

load 'apple(hue,ecc).mat'
load 'orange(hue,ecc).mat'
load 'banana(hue,ecc).mat'


%%
% Initialization
% class1 = [[1,6];[1,10];[4,11]];
% class2 = [[5,2];[7,6];[10,4]];
class1 = apple;
class2 = orange;
% class2 = banana;

X = [class1;class2];

o = ones(length(class1),1);
no = -ones(length(class2),1);
% oo = zeros(length(class3),1);

z = [o;no];
% z = [o;no;oo];

%%
H = (X*X').*(z*z');
f = -ones(length(z),1);
A = -eye(length(z));
a = zeros(length(z),1);
B = [[z'];[zeros(length(z)-1,length(z))]];
b = zeros(length(z),1);

%%
%SVM magic
alpha = quadprog(H+eye(length(z))*0.001,f,A,a,B,b);

%%
% [rows,cols,vals] = find(alpha<1e-6);
% 
% for i = 1:cols
%     for j = 1:rows
%         check = alpha(j,i);
%         if check < 1e-6
%             alpha(j,i) = 0;
%         end
%     end
% end


alpha(alpha<0.00001) =0;

[rows,cols,vals] = find(alpha>0);
%%
w = (alpha.*z)'*X;
w0 = (1/z(rows(1),cols(1))) - w*X(rows(1),:)';
w = [w0,w];



%% GRAPH
figure(1);
% scatter((banana_ripe(:,1)),banana_ripe(:,2),'x');
hold on;
% scatter((banana_unripe(:,1)),banana_ripe(:,2),'*');
% scatter(banana(:,1),banana(:,2),'d');
% scatter(normalize(data(:,1),'range'),data(:,2));

% bxx = normalize(X(:,1),'range'); %normalizes the x-axis


% scatter((bxx(1:length(class1),1)),X(1:length(class1),2),'x');
% scatter((bxx(1+length(class1):length(class1)+length(class2),1)),X(1+length(class1):length(class1)+length(class2),2),'*');

% scatter((X(1:length(class1),1)),X(1:length(class1),2),'x');
% scatter((X(1+length(class1):length(class1)+length(class2),1)),X(1+length(class1):length(class1)+length(class2),2),'*');
% scatter((X(1+length(class1)+length(class2):length(class1)+length(class2)+length(class3),1)),...
%     X(1+length(class1)+length(class2):length(class1)+length(class2)+length(class3),2),'*');


scatter(apple(:,1),apple(:,2),'x');
scatter(orange(:,1),orange(:,2),'*');
scatter(banana(:,1),banana(:,2),'d');

xx = linspace(min(X(:,1)),max(X(:,1)));

A = w(2);
B = w(3);
C = -w(1);

m = -A/B;
bb = C/B;
yy = m*xx + bb;

% xx = normalize(xx,'range');
% yy = normalize(yy,'range');
% xx_sig = xx;
% yy_sig = yy;
plot(xx,yy);
% plot(xx_sig,yy_sig);
% legend('banana ripe','banana unripe','perceptron','sigmoid', 'Location', 'best');
% legend('banana ripe','banana unripe','sigmoid', 'Location', 'best');
% legend('banana ripe','banana unripe','unknowns','decision line', 'Location', 'best');
% legend('apple','orange','decision line', 'Location', 'best');
legend('apple','orange','banana','decision line', 'Location', 'best');
% legend('apple','orange', 'banana', 'Location', 'best');

yscale = 2;
y_min = min(X(:,2))-(max(X(:,2))/yscale);
y_max = max(X(:,2))+(max(X(:,2))/yscale);
ylim([y_min y_max]);
% ylim([-2 2]);

% title('Feature Extraction');
% title('Perceptron');
% title('Logistic Regression');
title('Support Vector Machines ');
xlabel('Hue');
ylabel('Eccentricity');