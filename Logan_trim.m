%% INPUT DATA

% clc

% peso ref 31k(15.5k a 31k) altitude media 65k(45k a 105k)

mass = 31000;
cg = 0.2;
Beta_deg=0;
Alt_ft = 65000;
Mach = 10;
a = 340.29;
V = Mach*a;
Gamma_deg = 0;
Phi_deg = 0;
Psi_deg = 0;
Throttle = Mach; 
Stick_Lat = 0;
Stick_Long = 0;
Trimming = 1;

set_param('Logan/Propulsion/ScramjetEngine/Ramp_Control', 'Commented', 'on');

%% Search for a specified operating point for the model - Logan.

% This MATLAB script is the command line equivalent of the trim model
% tab in linear analysis tool with current specifications and options.
% It produces the exact same operating points as hitting the Trim button.


%% Specify the model name
model = 'Logan';

hhh = get_param(model,'Handle');
set_param(hhh,'LoadExternalInput','off');
set_param(hhh,'LoadInitialState','off');

%% Create the operating point specification object.
opspec = operspec(model);

%% Set the constraints on the states in the model.
% - The defaults for all states are Known = false, SteadyState = true,
%   Min = -Inf, and Max = Inf.

% State (1) - Logan/EqM/BodyRates/p_radps
% - Default model initial conditions are used to initialize optimization.

% State (2) - Logan/EqM/BodyRates/q_radps
% - Default model initial conditions are used to initialize optimization.

% State (3) - Logan/EqM/BodyRates/r_radps
% - Default model initial conditions are used to initialize optimization.

% State (4) - Logan/EqM/BodyVelocities/u_mps
opspec.States(4).x = V/2;
opspec.States(4).SteadyState = false;

% State (5) - Logan/EqM/BodyVelocities/v_mps
% - Default model initial conditions are used to initialize optimization.

% State (6) - Logan/EqM/BodyVelocities/w_mps
% - Default model initial conditions are used to initialize optimization.

% State (7) - Logan/EqM/EulerAngles/PHI_rad
% - Default model initial conditions are used to initialize optimization.

% State (8) - Logan/EqM/EulerAngles/PSI_rad
% - Default model initial conditions are used to initialize optimization.
if Phi_deg ~= 0
    opspec.States(8).SteadyState = false;
else
    opspec.States(8).SteadyState = true;
end

% State (9) - Logan/EqM/EulerAngles/THETA_rad
% - Default model initial conditions are used to initialize optimization.

% State (10) - Logan/EqM/InertialData/XI_m
% - Default model initial conditions are used to initialize optimization.
opspec.States(10).SteadyState = false;

% State (11) - Logan/EqM/InertialData/YI_m1
% - Default model initial conditions are used to initialize optimization.
opspec.States(11).SteadyState = false;

% State (12) - Logan/EqM/InertialData/ZI_m
% - Default model initial conditions are used to initialize optimization.
opspec.States(12).SteadyState = false;

%% Set the constraints on the inputs in the model.
% - The defaults for all inputs are Known = false, Min = -Inf, and
% Max = Inf.

% Input (1) - Logan/Mass_kg
opspec.Inputs(1).u = mass;
opspec.Inputs(1).Known = true;

% Input (2) - Logan/CG_mac
opspec.Inputs(2).u = cg;
opspec.Inputs(2).Known = true;

% Input (3) - Logan/Elevator_deg
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(3).Min = -25;
opspec.Inputs(3).Max = 30;

% Input (4) - Logan/Aileron_deg
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(4).Min = -25;
opspec.Inputs(4).Max = 25;

% Input (5) - Logan/Rudder_deg
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(5).Min = -15;
opspec.Inputs(5).Max = 15;

% Input (6) - Logan/Fuel_ratio
% - Default model initial conditions are used to initialize optimization.
% opspec.Inputs(6).Min = 0.01;
% opspec.Inputs(6).Max = 0.5;

% Input (7) - Logan/WindX
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(7).Known = true;

% Input (8) - Logan/WindY
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(8).Known = true;

% Input (9) - Logan/WindZ
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(9).Known = true;

% Input (10) - Logan/Stick_Lat
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(10).u = Stick_Lat;
opspec.Inputs(10).Known = true;

% Input (11) - Logan/Stick_Long
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(11).u = Stick_Long;
opspec.Inputs(11).Known = true;

% Input (12) - Logan/Throttle
% - Default model initial conditions are used to initialize optimization.
opspec.Inputs(12).u = Throttle;
opspec.Inputs(12).Known = true;

%% Set the constraints on the outputs in the model.
% - The defaults for all outputs are Known = false, Min = -Inf, and
% Max = Inf.

% Output (1) - Logan/KCAS
% opspec.Outputs(1).y = KCAS;
% opspec.Outputs(1).Known = true;

% Output (2) - Logan/Mach
opspec.Outputs(2).y = Mach;
opspec.Outputs(2).Known = true;

% Output (3) - Logan/KTAS
% - Default model initial conditions are used to initialize optimization.

% Output (4) - Logan/Beta_deg
% - Default model initial conditions are used to initialize optimization.

% Output (5) - Logan/Alpha_deg
% - Default model initial conditions are used to initialize optimization.

% Output (6) - Logan/AlphaDot_radps
% - Default model initial conditions are used to initialize optimization.

% Output (7) - Logan/u_mps
% - Default model initial conditions are used to initialize optimization.

% Output (8) - Logan/v_mps
% - Default model initial conditions are used to initialize optimization.

% Output (9) - Logan/w_mps
% - Default model initial conditions are used to initialize optimization.

% Output (10) - Logan/p_radps
% - Default model initial conditions are used to initialize optimization.

% Output (11) - Logan/q_radps
% - Default model initial conditions are used to initialize optimization.

% Output (12) - Logan/r_radps
% - Default model initial conditions are used to initialize optimization.

% Output (13) - Logan/Phi_deg
opspec.Outputs(13).y = Phi_deg;
opspec.Outputs(13).Known = true;

% Output (14) - Logan/Theta_deg
% - Default model initial conditions are used to initialize optimization.

% Output (15) - Logan/Psi_deg
% - Default model initial conditions are used to initialize optimization.
opspec.Outputs(15).y = Psi_deg;
opspec.Outputs(15).Known = true;

% Output (16) - Logan/X_m
% - Default model initial conditions are used to initialize optimization.

% Output (17) - Logan/Y_m
% - Default model initial conditions are used to initialize optimization.

% Output (18) - Logan/PresAlt_ft
opspec.Outputs(18).y = Alt_ft;
opspec.Outputs(18).Known = true;

% Output (19) - Logan/GSpeed_kt
% - Default model initial conditions are used to initialize optimization.

% Output (20) - Logan/Gamma_deg
% - Default model initial conditions are used to initialize optimization.
opspec.Outputs(20).Known = false;

% Output (21) - Logan/Track_deg
% - Default model initial conditions are used to initialize optimization.

% Output (22) - Logan/nx
% - Default model initial conditions are used to initialize optimization.

% Output (23) - Logan/ny
% - Default model initial conditions are used to initialize optimization.

% Output (24) - Logan/nz
% - Default model initial conditions are used to initialize optimization.

% Output (25) - Logan/Thrust_N
% - Default model initial conditions are used to initialize optimization.


%% Create the options
% opt = findopOptions('DisplayReport','iter');
opt = findopOptions('OptimizerType','lsqnonlin',...
    'DisplayReport');

opt.OptimizationOptions.MaxFunEvals = 3000;
opt.OptimizationOptions.MaxIter = 5000;


%% Perform the operating point search.
[op,opreport] = findop(model,opspec,opt);

Trimming = 0;
hhh = get_param(model,'Handle');
set_param(hhh,'LoadExternalInput','on');
set_param(hhh,'LoadInitialState','on');

%Initialization of Actuators

disp(' '); % Adiciona um espaço
Elevator_init = op.Inputs(3).u + op.Inputs(4).u;
disp(['Elevator Initial: ', num2str(Elevator_init), 'deg']);
disp(' '); % Adiciona um espaço

Aileron_init = op.Inputs(3).u - op.Inputs(4).u;
disp(['Aileron Initial: ', num2str(Aileron_init), 'deg']);
disp(' '); % Adiciona um espaço

Rudder_init = op.Inputs(5).u;
disp(['Rudder Initial: ', num2str(Rudder_init), 'deg']);
disp(' '); % Adiciona um espaço

set_param('Logan/Propulsion/ScramjetEngine/Ramp_Control', 'Commented', 'off');