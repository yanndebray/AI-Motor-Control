function [dataonecycle] = OneElecCycleExtrac(data)
% This function extracts one electrical cycle data.

% Copyright 2024 The MathWorks, Inc.

dataonecycle = data;

[m,n] = size(data);

for ite1 =1:m

    for ite2 =1:n
       thetadatalenght=length(data(ite1,ite2).theta);
       for ite3 = 1:thetadatalenght
           if data(ite1,ite2).theta(ite3,1) > data(ite1,ite2).theta(ite3+1,1)
               ite3=ite3+1;
               break;
           end
       end

       for ite4 = ite3:thetadatalenght-1
           if data(ite1,ite2).theta(ite4,1) > data(ite1,ite2).theta(ite4+1,1)
               break;
           end
       end
    

    dataonecycle(ite1,ite2).Valpha = data(ite1,ite2).Valpha(ite3:ite4,:);
    dataonecycle(ite1,ite2).Vbeta = data(ite1,ite2).Vbeta(ite3:ite4,:);
    dataonecycle(ite1,ite2).Ialpha = data(ite1,ite2).Ialpha(ite3:ite4,:);
    dataonecycle(ite1,ite2).Ibeta = data(ite1,ite2).Ibeta(ite3:ite4,:);
    dataonecycle(ite1,ite2).theta = data(ite1,ite2).theta(ite3:ite4,:);
    end
end


end % EoF