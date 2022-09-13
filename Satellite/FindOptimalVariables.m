function [OptimalSys] = FindOptimalVariables(Gp)


directory = fullfile('..\Figures','Satellite', 'PIController');
if exist(directory, 'dir')
    
else
    mkdir(fullfile('..\Figures','Satellite', 'PIController'));
end

N = 100;
c = linspace(-1,-9,N+1);
c = c(2:N);

Kp = linspace(1,10,100);

for i=1:length(c)
    for j=1:length(Kp)
        Sys(i,j).Gc = zpk(c(i), 0, Kp(j));
        Sys(i,j).Kp = Kp(j);
        Sys(i,j).Ki = (-c(i))*Kp(j);
        Sys(i,j).c = c(i);
        Sys(i,j).OpenLoopSys = Sys(i,j).Gc*Gp;
        Sys(i,j).ClosedLoopSys = feedback(Sys(i,j).Gc*Gp,1);
        Sys(i,j).StepInfo = stepinfo(Sys(i,j).ClosedLoopSys);
        if (Sys(i,j).StepInfo.Overshoot < 10) && (Sys(i,j).StepInfo.RiseTime < 1.2)
            OptimalSys = Sys(i,j);
            
            fig1 = figure(1);
            fig1.WindowState = 'maximized';
            rlocus(OptimalSys.OpenLoopSys);
            hold on;
            title(sprintf('Root Locus For $G_{c} = \\frac{%.3f (s+%.2f)}{s}$ (Open Loop)', Kp(j), c(i)*-1 ),'FontSize', 20, 'Interpreter', 'latex' );
            
            fig2 = figure(2);
            fig2.WindowState = 'maximized';
            step(OptimalSys.ClosedLoopSys);
            hold on;
            title(sprintf('Step Response For $G_{c} = \\frac{%.3f (s+%.2f)}{s}$ (Closed Loop)', Kp(j), c(i)*-1 ),'FontSize', 20, 'Interpreter', 'latex' );
            
            saveas(fig1, fullfile('..\Figures','Satellite', 'PIController', sprintf('rlocus(%.2f).svg', c(i))));
            saveas(fig2, fullfile('..\Figures','Satellite', 'PIController', sprintf('step(%.2f).svg', Kp(j))));

            return;
        end
    end
end

end
