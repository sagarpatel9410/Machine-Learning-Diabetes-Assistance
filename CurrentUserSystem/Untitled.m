valbefore = Data(1,1);
a(1) = 1;
for i = 2:size(Data(:,1),1)
   if isequal(valbefore,Data(i,1))
       a(i) = a(i - 1);
   else
        a(i) = a(i-1) + 1;
        valbefore = Data(i,1);
   end
   i
end