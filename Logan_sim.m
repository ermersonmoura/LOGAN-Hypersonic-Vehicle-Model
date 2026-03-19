close all

IndividualPlots = 0;

%% SIMULATION
% Writing initial inputs vector.
inputs = getinputstruct(opreport);                                          % Reads the model inputs
utin = zeros(size(inputs.signals,2),1);                                     % initialize with zeros the inputs vector - this is optional but reduces computational time of the code.
for i = 1:size(inputs.signals,2)
    utin(i,:) = inputs.signals(i).values;                                   % Creates a vector with the trimmed values for the inputs.
end

% Totalv simulation time - [s];
TF=300;
% Time data for the input;
t = [0 1 2 3 4 5 6 TF];                                          % This vector can be any kind of time vector to create the input.

% Create an input vector of the same size as t;
%First line is the time stamp itself (simulink coding!)
ut = zeros(size(t,2),size(inputs.signals,2));                               % initialize with zeros the inputs vector - this is optional but reducis computational time of the code.
for i=1:size(t,2)
    ut(i,1) = t(i);                                                         % Simulink default. The first line is the time vector.
    for j=1:size(inputs.signals,2)
        ut(i,j+1) = utin(j);                                                % Initial input vectors with the same size as t.
    end
end

% ELEVATOR DOUBLET
delta = 0;                                                                   %amplitude [deg]
%Control Surface index
for i=1:size(opreport.Inputs,1)
    intr{i,1} = opreport.Inputs(i).Block;                                   % Create a structure with the names of the inputs
end
in_ind = [1:size(opreport.Inputs,1)];                                       % Create a vector with the indices of the inputs.
ind_control = in_ind(logical(strcmp('Logan/Elevator_deg',intr)));            % Finds the position of the Elevator input.

% input command with the same size as t; You can draw anything here.
ut(:,ind_control+1) = [ut(1,ind_control+1) ut(1,ind_control+1) (ut(1,ind_control+1)-delta) (ut(1,ind_control+1)-delta) (ut(1,ind_control+1)+delta) (ut(1,ind_control+1)+delta) ut(1,ind_control+1) ut(1,ind_control+1)]' ;

%Simulation command
[tout,xout,yout]=sim('Logan',TF,simset('InitialState',getstatestruct(opreport),'Solver','ode4','FixedStep',0.01),ut);

%Plot
%Read Outputs
for i=1:size(opreport.Outputs,1)
    outr{i,1} = opreport.Outputs(i).Block;                                   % Create a structure with the names of the outputs.
end
out_ind = [1:size(opreport.Outputs,1)];                                      % Create a vector with the indices of the outputs.

if IndividualPlots
figure (1)
hold on
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]); % Grid mais grosso
plot(tout,yout(:,out_ind(logical(strcmp('Logan/Alpha_deg',outr)))),'LineWidth', 1.5); xlabel('Time - [s]');ylabel('Alpha - [deg]'); grid on
figure (2)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/KCAS',outr))))); xlabel('Time - [s]');ylabel('KCAS'); grid on
figure (3)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/Theta_deg',outr))))); xlabel('Time - [s]');ylabel('Theta - [deg]'); grid on
figure (4)
plot(t',ut(:,ind_control+1)); xlabel('Time - [s]');ylabel('Elevator - [deg]'); grid on
figure (5)
hold on
plot(tout,yout(:,out_ind(logical(strcmp('Logan/Thrust_N',outr))))); xlabel('Time - [s]');ylabel('Thrust - [N]'); grid on
figure (6)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/PresAlt_ft',outr))))); xlabel('Time - [s]');ylabel('Altitude - [ft]'); grid on
figure (7)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/nz',outr))))); xlabel('Time - [s]');ylabel('Load Factor (Nz) - [g]'); grid on
figure (8)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/Mach',outr))))); xlabel('Time - [s]');ylabel('Mach'); grid on
figure (9)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/p_dps',outr)))));xlabel('Time - [s]');ylabel('Roll Rate - [deg/s]'); grid on
figure (10)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/q_dps',outr)))));xlabel('Time - [s]');ylabel(' Pitch Rate - [deg/s]'); grid on
figure (11)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/r_dps',outr))))); xlabel('Time - [s]');ylabel(' Yaw Rate - [deg/s]'); grid on
figure (12)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/Gamma_deg',outr))))); xlabel('Time - [s]');ylabel(' Gamma - [deg]'); grid on
figure (13)
plot(tout,eta_prop(1:end)); xlabel('Time - [s]');ylabel('Propulsive Efficiency'); grid on
figure (14)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/Phi_deg',outr)))));; xlabel('Time - [s]');ylabel('Phi - [deg]'); grid on
figure (15)
plot(tout,yout(:,out_ind(logical(strcmp('Logan/Psi_deg',outr)))));; xlabel('Time - [s]');ylabel('Psi - [deg]'); grid on

end

% Conversão de metros para pés
X_ft   = X_m   * 3.28084;
Y_ft   = Y_m   * 3.28084;
Alt_ft = Alt_m * 3.28084;

% Plotar a trajetória em ft
figure (16); % Nova figura
plot3(X_ft, Y_ft, Alt_ft, 'LineWidth', 1.5, 'Color', [0 0 0.5]); % Plota a trajetória em 3D
hold on;
title('Tridimensional Trajectory (ft)')

% Realçar pontos iniciais e finais
plot3(X_ft(1), Y_ft(1), Alt_ft(1), 'go', 'MarkerSize', 8, 'LineWidth', 1.5); % Ponto inicial
plot3(X_ft(end), Y_ft(end), Alt_ft(end), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5); % Ponto final

% Configurações do gráfico
xlabel('X (ft)');
ylabel('Y (ft)');
zlabel('Altitude (ft)');

grid on;
set(gcf, 'Renderer', 'painters');
set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.3f', y), get(gca, 'YTick'), 'UniformOutput', false));
set(gca, 'ZTickLabel', arrayfun(@(z) sprintf('%.0f', z), get(gca, 'ZTick'), 'UniformOutput', false));
zlim([20000 30000])
ylim([-100000 100000])

% % Plotar a trajetória em metros
% figure; % Nova figura
% plot3(X_m, Y_m, Alt_m, 'LineWidth', 1.5, 'Color', [0 0 0.5]); % Plota a trajetória em 3D
% hold on;
% title('Tridimensional Trajectory (m)')
% 
% % Realçar pontos iniciais e finais
% plot3(X_m(1), Y_m(1), Alt_m(1), 'go', 'MarkerSize', 8, 'LineWidth', 1.5); % Ponto inicial
% plot3(X_m(end), Y_m(end), Alt_m(end), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5); % Ponto final
% 
% % Configurações do gráfico
% xlabel('X (m)');
% ylabel('Y (m)');
% zlabel('Altitude (m)');
% 
% grid on;
% set(gcf, 'Renderer', 'painters');

% Thermo_Analysis - Temperatures
figure(17)
hold on
plot(tout(20:end), T1(20:end), 'DisplayName', 'T1')
plot(tout(20:end), T2(20:end), 'DisplayName', 'T2')
plot(tout(20:end), T3(20:end), 'DisplayName', 'T3')
plot(tout(20:end), T4(20:end), 'DisplayName', 'T4')
plot(tout(20:end), T5(20:end), 'DisplayName', 'T5')
plot(tout(20:end), T6(20:end), 'DisplayName', 'T6')
legend('show', 'Location', 'best') % Displays the legend
xlabel('Time (s)') % Labels the x-axis
ylabel('Temperature (K)') % Labels the y-axis
% title('Temperatures in Stages') % Adds a title to the plot
grid on % Activates the grid
hold off
set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Pressures
figure(18)
hold on
grid on
plot(tout(20:end), p1(20:end)/1000, 'DisplayName', 'p1') % Series 1
plot(tout(20:end), p2(20:end), 'DisplayName', 'p2') % Series 2
plot(tout(20:end), p3(20:end), 'DisplayName', 'p3') % Series 3
plot(tout(20:end), p4(20:end), 'DisplayName', 'p4') % Series 4
plot(tout(20:end), p5(20:end), 'DisplayName', 'p5') % Series 5
plot(tout(20:end), p6(20:end), 'DisplayName', 'p6') % Series 6
legend('show', 'Location', 'best')
xlabel('Time (s)')
ylabel('Pressure (kPa)')
% title('Pressure in Stages')
set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Mach Numbers
figure(19)
hold on
grid on
plot(tout(20:end), M1(20:end), 'DisplayName', 'M1') % Series 1
plot(tout(20:end), M2(20:end), 'DisplayName', 'M2') % Series 2
plot(tout(20:end), M3(20:end), 'DisplayName', 'M3') % Series 3
plot(tout(20:end), M4(20:end), 'DisplayName', 'M4') % Series 4
plot(tout(20:end), M5(20:end), 'DisplayName', 'M5') % Series 5
plot(tout(20:end), M6(20:end), 'DisplayName', 'M6') % Series 6
legend('show', 'Location', 'best')
xlabel('Time (s)')
ylabel('Mach Number')
% title('Mach Number Comparison Over Time')
xlim([min(tout(20:end)), max(tout(20:end))])
ylim('auto')
set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));

% Ignition and T4 Comparison
figure(20)
hold on
plot(tout(20:end), T_ign(20:end), 'DisplayName', 'Ignition Temperature')
plot(tout(20:end), T4(20:end), 'DisplayName', 'T4 - Stage 4')
legend('show', 'Location', 'best')
xlabel('Time (s)')
ylabel('Temperature (K)')
% title('Ignition Temperature vs T4')
grid on
hold off
set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Theta Angles
figure(21)
hold on
plot(tout(20:end), theta1_deg(20:end), 'DisplayName', '\theta_1')
plot(tout(20:end), theta2_deg(20:end), 'DisplayName', '\theta_2')
legend('show', 'Location', 'best')
xlabel('Time (s)')
ylabel('Angle (degrees)')
% title(' \theta_1 and \theta_2 Angles')
grid on
hold off
set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Fuel Flow Rate
figure(22)
hold on
plot(tout(20:end), m_dot_fuel(20:end), 'DisplayName', 'Fuel Mass Flow Rate (kg/s)')
% legend('show', 'Location', 'best')
xlabel('Time (s)')
ylabel('Mass Flow Rate (kg/s)')
% title('Fuel Flow Rate Over Time')
grid on
hold off
set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Specific Impulse (Isp)
figure(23)
hold on
plot(tout(20:end), Isp(20:end), 'DisplayName', 'Specific Impulse (Isp)')
% legend('show', 'Location', 'best')
xlabel('Time (s)')
ylabel('Isp (s)')
% title('Specific Impulse Over Time')
grid on
hold off
set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));


% Calculando médias dos vetores
T1_mean = mean(T1);
T2_mean = mean(T2);
T3_mean = mean(T3);
T4_mean = mean(T4);
T5_mean = mean(T5);
T6_mean = mean(T6);
p1_mean = mean(p1);
p2_mean = mean(p2);
p3_mean = mean(p3);
p4_mean = mean(p4);
p5_mean = mean(p5);
p6_mean = mean(p6);

M1_mean = mean(M1);
M2_mean = mean(M2);
M3_mean = mean(M3);
M4_mean = mean(M4);
M5_mean = mean(M5);
M6_mean = mean(M6);

% Vetores de plotagem (usando valores médios)
pressures = [p1_mean/1000, p2_mean, p3_mean, p4_mean, p5_mean, p6_mean] ;  % kPa
temperatures = [T1_mean, T2_mean, T3_mean, T4_mean, T5_mean, T6_mean];      % K
mach_numbers = [M1_mean, M2_mean, M3_mean, M4_mean, M5_mean, M6_mean];      % Mach

% Plot for pressures
figure;
plot(1:6, pressures, '-o', 'LineWidth', 2);
% title('Average Pressures in Each Stage');
xlabel('Stage'); ylabel('Pressure (kPa)'); grid on;
xticks(1:1:6);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Plot for temperatures
figure;
plot(1:6, temperatures, '-o', 'LineWidth', 2);
% title('Average Temperatures in Each Stage');
xlabel('Stage'); ylabel('Temperature (K)'); grid on;
xticks(1:1:6);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Plot for Mach numbers
figure;
plot(1:6, mach_numbers, '-o', 'LineWidth', 2);
% title('Average Mach Numbers in Each Stage');
xlabel('Stage'); ylabel('Average Mach Number'); grid on;
xticks(1:1:6);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));

figure;
set(gcf, 'Renderer', 'painters');
% Subplot 1: Altitude
subplot(3, 2, 1); % Define posição do subplot
plot(tout, yout(:, out_ind(logical(strcmp('Logan/PresAlt_ft', outr)))), 'LineWidth', 1.5);
xlabel('Time - [s]');
ylabel('Altitude - [ft]');
title('(a) Altitude');
grid on;
% set(gca, 'GridLineStyle', '-', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Subplot 2: Mach
subplot(3, 2, 2); % Define posição do subplot
plot(tout, yout(:, out_ind(logical(strcmp('Logan/Mach', outr)))), 'LineWidth', 1.5);
xlabel('Time - [s]');
ylabel('Mach');
title('(b) Mach');
grid on;
% set(gca, 'GridLineStyle', '-', 'LineWidth', 1.5, 'GridColor', [0 0 0]);
% Subplot 3: KCAS
subplot(3, 2, 3); % Define posição do subplot
plot(tout, yout(:, out_ind(logical(strcmp('Logan/KCAS', outr)))), 'LineWidth', 1.5);
xlabel('Time - [s]');
ylabel('KCAS [kt]');
title('(c) KCAS');
grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Subplot 4: Alpha
subplot(3, 2, 4); % Define posição do subplot
plot(tout, yout(:, out_ind(logical(strcmp('Logan/Alpha_deg', outr)))), 'LineWidth', 1.5);
xlabel('Time - [s]');
ylabel('Alpha - [deg]');
% title('(d) \alpha', 'Interpreter', 'tex');
title('(d) Alpha');
grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Subplot 5: Thrust e Drag
subplot(3, 2, 5); % Define posição do subplot
hold on;
plot(tout(20:end), T_thrust(20:end), 'DisplayName', 'Thrust', 'LineWidth', 1.5);
plot(tout(20:end), Drag(20:end), 'DisplayName', 'Drag', 'LineWidth', 1.5);
xlabel('Time - [s]');
ylabel('Force - [N]');
title('(e) Thrust and Drag');
legend('show', 'Location', 'best');
grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% Subplot 6: Gamma
subplot(3, 2, 6); % Define posição do subplot
plot(tout, yout(:, out_ind(logical(strcmp('Logan/Gamma_deg', outr)))), 'LineWidth', 1.5);
xlabel('Time - [s]');
ylabel('Gamma - [deg]');
title('(f) Gamma');
% title('(f) \gamma', 'Interpreter', 'tex');
grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));



% Dynamic Pressure
figure
hold on
plot(tout(20:end), Qdyn_Pa(20:end)/1000, 'DisplayName', 'Dynamic Pressure (kPa)')
xlabel('Time (s)')
ylabel('Dynamic Pressure [kPa]')
% title('Dynamic pressure Over Time')
grid on
hold off
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));


figure('Name', 'Trajectory and Actuator Responses');
set(gcf, 'Renderer', 'painters', 'Position', [1000 178 664 700]);
t = tiledlayout(3,2, 'TileSpacing','compact', 'Padding','compact');

% === Trajetória 3D ocupando toda a primeira linha (duas colunas)
ax1 = nexttile(t, [1 2]);
plot3(X_m, Y_m, Alt_m, 'LineWidth', 1.5); hold on;
plot3(X_m(1), Y_m(1), Alt_m(1), 'go', 'MarkerSize', 8, 'LineWidth', 1.5);
plot3(X_m(end), Y_m(end), Alt_m(end), 'ro', 'MarkerSize', 8, 'LineWidth', 1.5);
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('(a) 3D Trajectory');
 grid on; 
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% === Subplot esquerdo inferior: Rudder
ax2 = nexttile(t, 3);
hold on;
plot(tout(20:end), Rudder_Demand(20:end), 'DisplayName', 'Rudder Demand', 'LineWidth', 1.5);
plot(tout(20:end), RudderActuator_Actual(20:end), 'DisplayName', 'Rudder Actual', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Deflection [deg]');
title('(b) Rudder Response');
legend('Location', 'best');
 grid on; 
 % set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% === Subplot direito inferior: Elevons (Elevator)
ax3 = nexttile(t, 4);
hold on;
plot(tout(20:end), Elevator_Demand(20:end), 'DisplayName', 'Elevator Demand', 'LineWidth', 1.5);
plot(tout(20:end), L_ElevActuator_Actual(20:end), 'DisplayName', 'Left Elevon Actual', 'LineWidth', 1.5);
plot(tout(20:end), R_ElevActuator_Actual(20:end), 'DisplayName', 'Right Elevon Actual', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Deflection [deg]');
title('(c) Elevon Response');
legend('Location', 'best');
grid on; 
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
%%
figure('Name', 'Thermo-Aerodynamic Variables (Full)', 'Renderer', 'painters', 'Position', [1696 87 835 805]);
t = tiledlayout(4,2, 'TileSpacing','compact', 'Padding','compact');
set(gcf, 'Renderer', 'painters');
% 1. Pressões
nexttile;
hold on;
% plot(tout(20:end), p1(20:end)/1000, 'DisplayName', 'Stage 1');
% plot(tout(20:end), p2(20:end), 'DisplayName', 'Stage 2', 'LineWidth', 1.5);
% plot(tout(20:end), p3(20:end), 'DisplayName', 'Stage 3', 'LineWidth', 1.5);
% plot(tout(20:end), p4(20:end), 'DisplayName', 'Stage 4', 'LineWidth', 1.5);
% plot(tout(20:end), p5(20:end), 'DisplayName', 'Stage 5', 'LineWidth', 1.5);
% plot(tout(20:end), p6(20:end), 'DisplayName', 'Stage 6', 'LineWidth', 1.5);
plot(tout(20:end), p1(20:end)/1000, 'DisplayName', 'p1', 'LineWidth', 1.5);
plot(tout(20:end), p2(20:end), 'DisplayName', 'p2', 'LineWidth', 1.5);
plot(tout(20:end), p3(20:end), 'DisplayName', 'p3', 'LineWidth', 1.5);
plot(tout(20:end), p4(20:end), 'DisplayName', 'p4', 'LineWidth', 1.5);
plot(tout(20:end), p5(20:end), 'DisplayName', 'p5', 'LineWidth', 1.5);
plot(tout(20:end), p6(20:end), 'DisplayName', 'p6', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Pressure [kPa]');
title('(a) Pressures'); legend('show','location','best'); grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 2. Temperaturas
nexttile;
hold on;
% plot(tout(20:end), T1(20:end), 'DisplayName', 'Stage 1', 'LineWidth', 1.5);
% plot(tout(20:end), T2(20:end), 'DisplayName', 'Stage 2', 'LineWidth', 1.5);
% plot(tout(20:end), T3(20:end), 'DisplayName', 'Stage 3', 'LineWidth', 1.5);
% plot(tout(20:end), T4(20:end), 'DisplayName', 'Stage 4', 'LineWidth', 1.5);
% plot(tout(20:end), T5(20:end), 'DisplayName', 'Stage 5', 'LineWidth', 1.5);
% plot(tout(20:end), T6(20:end), 'DisplayName', 'Stage 6', 'LineWidth', 1.5);
plot(tout(20:end), T1(20:end), 'DisplayName', 'T1', 'LineWidth', 1.5);
plot(tout(20:end), T2(20:end), 'DisplayName', 'T2', 'LineWidth', 1.5);
plot(tout(20:end), T3(20:end), 'DisplayName', 'T3', 'LineWidth', 1.5);
plot(tout(20:end), T4(20:end), 'DisplayName', 'T4', 'LineWidth', 1.5);
plot(tout(20:end), T5(20:end), 'DisplayName', 'T5', 'LineWidth', 1.5);
plot(tout(20:end), T6(20:end), 'DisplayName', 'T6', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Temperature [K]');
title('(b) Temperatures'); legend('show','location','best'); grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 3. Machs
nexttile;
hold on;
% plot(tout(20:end), M1(20:end), 'DisplayName', 'Stage 1', 'LineWidth', 1.5);
% plot(tout(20:end), M2(20:end), 'DisplayName', 'Stage 2', 'LineWidth', 1.5);
% plot(tout(20:end), M3(20:end), 'DisplayName', 'Stage 3', 'LineWidth', 1.5);
% plot(tout(20:end), M4(20:end), 'DisplayName', 'Stage 4', 'LineWidth', 1.5);
% plot(tout(20:end), M5(20:end), 'DisplayName', 'Stage 5', 'LineWidth', 1.5);
% plot(tout(20:end), M6(20:end), 'DisplayName', 'Stage 6', 'LineWidth', 1.5);
plot(tout(20:end), M1(20:end), 'DisplayName', 'M1', 'LineWidth', 1.5);
plot(tout(20:end), M2(20:end), 'DisplayName', 'M2', 'LineWidth', 1.5);
plot(tout(20:end), M3(20:end), 'DisplayName', 'M3', 'LineWidth', 1.5);
plot(tout(20:end), M4(20:end), 'DisplayName', 'M4', 'LineWidth', 1.5);
plot(tout(20:end), M5(20:end), 'DisplayName', 'M5', 'LineWidth', 1.5);
plot(tout(20:end), M6(20:end), 'DisplayName', 'M6', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Mach');
title('(c) Mach Numbers'); legend('show','location','best'); grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 4. Calor
nexttile;
hold on;
plot(tout(20:end), q1(20:end), 'DisplayName', '\Delta h_1', 'LineWidth', 1.5);
plot(tout(20:end), q2(20:end), 'DisplayName', '\Delta h_2', 'LineWidth', 1.5);
plot(tout(20:end), q3(20:end), 'DisplayName', '\Delta h_3', 'LineWidth', 1.5);
plot(tout(20:end), q4(20:end), 'DisplayName', '\Delta h_4', 'LineWidth', 1.5);
plot(tout(20:end), q5(20:end), 'DisplayName', '\Delta h_5', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('\Delta h [J/kg]');
title('(d) \Delta Enthalpy'); legend('show','location','best'); grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 5. Pressão média
nexttile;
pressures = [mean(p1)/1000, mean(p2), mean(p3), mean(p4), mean(p5), mean(p6)];
plot(1:6, pressures, '-o', 'LineWidth', 1.5);
xlabel('Stage'); ylabel('Pressure [kPa]');
title('(e) Mean Pressure'); grid on;
xticks(1:6);
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 6. Mach médio
nexttile;
mach_numbers = [mean(M1), mean(M2), mean(M3), mean(M4), mean(M5), mean(M6)];
plot(1:6, mach_numbers, '-o', 'LineWidth', 1.5);
xlabel('Stage'); ylabel('Mach');
title('(f) Mean Mach'); grid on;
xticks(1:6);
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 7. Temperatura média
nexttile;
temperatures = [mean(T1), mean(T2), mean(T3), mean(T4), mean(T5), mean(T6)];
plot(1:6, temperatures, '-o', 'LineWidth', 1.5);
xlabel('Stage'); ylabel('Temperature [K]');
title('(g) Mean Temperature'); grid on;
xticks(1:6);
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 8. Pressão Dinâmica
nexttile;
plot(tout(20:end), Qdyn_Pa(20:end)/1000, 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Dynamic Pressure [kPa]');
title('(h) Dynamic Pressure'); grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('Name', 'Efficiencies and Irreversibilities (All Stages)', ...
       'Renderer', 'painters', 'Position', [1000 178 664 700]);
t = tiledlayout(3,2, 'TileSpacing','compact', 'Padding','compact');
set(gcf, 'Renderer', 'painters');
% 1. Eficiências global (energética e exergética)
nexttile(1);
hold on;
plot(tout(20:end), eta_t(20:end)*100, 'DisplayName', '\eta_t (Thermal)', 'LineWidth', 1.5);
plot(tout(20:end), eta_ex(20:end)*100, 'DisplayName', '\eta_{ex} (Exergy)', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Efficiency [%]');
title('(a) Global Thermal and Exergy Efficiencies');
legend('show', 'Location', 'best');
grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 2. Eficiência propulsiva
nexttile(2);
plot(tout(20:end), eta_prop(20:end)*100, 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Propulsive Efficiency [%]');
title('(b) Propulsive Efficiency');
grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 3. Eficiências exergéticas por estágio
nexttile(3);
hold on;
plot(tout(20:end), eta_ex1(20:end)*100, 'DisplayName', 'Stage 1', 'LineWidth', 1.5);
plot(tout(20:end), eta_ex2(20:end)*100, 'DisplayName', 'Stage 2', 'LineWidth', 1.5);
plot(tout(20:end), eta_ex3(20:end)*100, 'DisplayName', 'Stage 3', 'LineWidth', 1.5);
plot(tout(20:end), eta_ex4(20:end)*100, 'DisplayName', 'Stage 4', 'LineWidth', 1.5);
plot(tout(20:end), eta_ex5(20:end)*100, 'DisplayName', 'Stage 5', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Exergy Efficiency [%]');
title('(c) Exergy Efficiencies');
legend('show', 'Location', 'best');
grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 4. Irreversibilidades por estágio
nexttile(4);
hold on;
plot(tout(20:end), irre_stage1(20:end), 'DisplayName', 'Stage 1', 'LineWidth', 1.5);
plot(tout(20:end), irre_stage2(20:end), 'DisplayName', 'Stage 2', 'LineWidth', 1.5);
plot(tout(20:end), irre_stage3(20:end), 'DisplayName', 'Stage 3', 'LineWidth', 1.5);
plot(tout(20:end), irre_stage4(20:end), 'DisplayName', 'Stage 4', 'LineWidth', 1.5);
plot(tout(20:end), irre_stage5(20:end), 'DisplayName', 'Stage 5', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Irreversibility [J/kg]');
title('(d) Irreversibilities');
legend('show', 'Location', 'best');
grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% 5. Irreversibilidade total (centralizado)
nexttile([1 2]);
total_irre = irre_stage1 + irre_stage2 + irre_stage3 + irre_stage4 + irre_stage5;
plot(tout(20:end), total_irre(20:end), 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Total Irreversibility [J/kg]');
title('(e) Total Irreversibility');
grid on;
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Name', 'Mean Irreversibilities and Exergy Efficiencies', 'Renderer', 'painters', 'Position', [1000 178 664 700]);
t = tiledlayout(1,2, 'TileSpacing','compact', 'Padding','compact');
set(gcf, 'Renderer', 'painters');
% 1. Irreversibilidades Médias
nexttile(1);
bar(1:5, [mean(irre_stage1(20:end)), mean(irre_stage2(20:end)), ...
          mean(irre_stage3(20:end)), mean(irre_stage4(20:end)), ...
          mean(irre_stage5(20:end))]);
xticks(1:5);
xticklabels({'1', '2', '3', '4', '5'});
xlabel('Stages'); ylabel('Avg Irreversibility [J/kg]');
title('(a) Average Irreversibility per Stage');
grid on; 
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);

% 2. Eficiências Exergéticas Médias
nexttile(2);
bar(1:5, [mean(eta_ex1(20:end)), mean(eta_ex2(20:end)), ...
          mean(eta_ex3(20:end)), mean(eta_ex4(20:end)), ...
          mean(eta_ex5(20:end))]*100);
xticks(1:5);
xticklabels({'1', '2', '3', '4', '5'});
xlabel('Stages'); ylabel('Avg Exergy Efficiency [%]');
title('(b) Average Exergy Efficiency per Stage');
grid on; 
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
% set(gca, 'XTickLabel', arrayfun(@(x) sprintf('%.0f', x), get(gca, 'XTick'), 'UniformOutput', false));
% set(gca, 'YTickLabel', arrayfun(@(y) sprintf('%.0f', y), get(gca, 'YTick'), 'UniformOutput', false));

%%%%%%%%%


figure('Name', 'Thrust and Combustion Variables', 'Renderer', 'painters', 'Position', [1000 178 664 700]);
t = tiledlayout(3,2, 'TileSpacing','compact', 'Padding','compact');

% 1. Thrust
nexttile(1);
plot(tout(20:end), T_thrust(20:end), 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Thrust [N]');
title('(a) Thrust');
grid on; 
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);

% 2. Fuel Flow Rate
nexttile(2);
plot(tout(20:end), m_dot_fuel(20:end), 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Fuel Flow Rate [kg/s]');
title('(b) Fuel Mass Flow Rate');
grid on; 
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);

% 3. T4 e Ignition Temp
nexttile(3);
hold on;
plot(tout(20:end), T_ign(20:end), 'DisplayName', 'T_{ign}', 'LineWidth', 1.5);
plot(tout(20:end), T4(20:end), 'DisplayName', 'T_4', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Temperature [K]');
title('(c) T_{ign} and T_4'); legend('show');
grid on; 
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);

% 4. Theta1 e Theta2
nexttile(4);
hold on;
plot(tout(20:end), theta1_deg(20:end), 'DisplayName', '\theta_1', 'LineWidth', 1.5);
plot(tout(20:end), theta2_deg(20:end), 'DisplayName', '\theta_2', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Angle [deg]');
title('(d) \theta_1 and \theta_2'); legend('show');
grid on; 
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);

% 5 & 6. Impulso Específico centralizado na linha inferior
nexttile([1 2]);
plot(tout(20:end), Isp(20:end), 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Specific Impulse [s]');
title('(e) Specific Impulse (I_{sp})');
grid on; 
% set(gca, 'GridLineStyle', ':', 'LineWidth', 1.5, 'GridColor', [0 0 1]);
