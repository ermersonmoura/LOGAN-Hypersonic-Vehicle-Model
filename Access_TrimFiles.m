mass = 31000;
Mach = 10;
Alt_ft = 65000;

load('TrimDatabase_Logan.mat')

% Montar o nome dos campos
field_mass = sprintf('Mass_%d', mass);
field_mach = sprintf('M%d', Mach);
field_alt  = sprintf('Alt_%d', Alt_ft);

% Carregar o trim correspondente
op = TrimDatabase.(field_mass).(field_mach).(field_alt).op;
opreport = TrimDatabase.(field_mass).(field_mach).(field_alt).opreport;
Elevator_init = TrimDatabase.(field_mass).(field_mach).(field_alt).Elevator_init;
Aileron_init  = TrimDatabase.(field_mass).(field_mach).(field_alt).Aileron_init;
Rudder_init   = TrimDatabase.(field_mass).(field_mach).(field_alt).Rudder_init;

% Jogar para o base workspace se necessário
assignin('base', 'op', op);
assignin('base','opreport',opreport);
assignin('base', 'Elevator_init', Elevator_init);
assignin('base', 'Aileron_init', Aileron_init);
assignin('base', 'Rudder_init', Rudder_init);

% Rodar a simulação
[tout, xout, yout] = sim('Logan', TF, ...
                simset('InitialState', getstatestruct(opreport), 'Solver', 'ode4', 'FixedStep', 0.01));