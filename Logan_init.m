clc;
clear variables;

% Mass properties

disp(' '); % Adiciona um espaço
disp('======================== Mass Properties ========================');
disp(' '); % Adiciona um espaço

RefMass_kg = 31000; % kg
disp(['RefMass_kg: ', num2str(RefMass_kg), ' kg']);
Ixx = 43500.088; % kg·m²
disp(['Ixx: ', num2str(Ixx), ' kg·m²']);
Iyy = 405733.230; % kg·m²
disp(['Iyy: ', num2str(Iyy), ' kg·m²']);
Izz = 380687.333; % kg·m²
disp(['Izz: ', num2str(Izz), ' kg·m²']);
Ixz = 95202.923; % kg·m²
disp(['Ixz: ', num2str(Ixz), ' kg·m²']);
Inertia = [Ixx 0 -Ixz; 0 Iyy 0; -Ixz 0 Izz]; % Inertia tensor
disp(['Inertia Tensor: ', mat2str(Inertia)]);
y_cg = 0; % m (+ is to the right of ref. plane)
disp(['y_cg: ', num2str(y_cg), ' m']);
z_cg = -0.996; % m (+ is below the ref. plane)
disp(['z_cg: ', num2str(z_cg), ' m']);
g = 9.80665; % m/s²
disp(['Gravity: ', num2str(g), ' m/s²']);

% Engine Location Data

disp(' '); % Adiciona um espaço
disp('==================== Engine Location Data ====================');
disp(' '); % Adiciona um espaço
xf_m = 0; % m (+ is FWD of the CG)
disp(['xf_m: ', num2str(xf_m), ' m']);
zf_m = 0; % m (+ is below the ref. plane)
disp(['zf_m: ', num2str(zf_m), ' m']);

% Aircraft Data

disp(' '); % Adiciona um espaço
disp('======================== Aircraft Data =========================');
disp(' '); % Adiciona um espaço
S = 91.5; % Wing Area - m²
disp(['Wing Area S: ', num2str(S), ' m²']);
c = 15.252; % Mean Aerodynamic Chord - m
disp(['Mean Aerodynamic Chord c: ', num2str(c), ' m']);
b = 9; % Wing Span - m
disp(['Wing Span b: ', num2str(b), ' m']);

% Trimming

disp(' '); % Adiciona um espaço
disp('======================== Trimming Data =========================');
disp(' '); % Adiciona um espaço

Manual_Control = 0;
disp(['Manual Control: ', num2str(Manual_Control)]);
Refrigeration_ON = 0;
disp(['Refrigeration System: ', num2str(Refrigeration_ON)]);
Trimming = 0;
disp(['Trimming: ', num2str(Trimming)]);
Fuel_Freeze = 0;
disp(['Fuel Freeze: ', num2str(Fuel_Freeze)]);
Aileron_init = 0;
disp(['Aileron Initial: ', num2str(Aileron_init)]);
Elevator_init = 0;
disp(['Elevator Initial: ', num2str(Elevator_init)]);
Rudder_init = 0;
disp(['Rudder Initial: ', num2str(Rudder_init)]);

% Scramjet Properties

disp(' '); % Adiciona um espaço
disp('===================== Scramjet Properties ======================');
disp(' '); % Adiciona um espaço

R = 287; % J/(kg·K)
disp(['Gas Constant R: ', num2str(R), ' J/(kg·K)']);
gamma = 1.4; % Adiabatic Index
disp(['Adiabatic Index gamma: ', num2str(gamma)]);
theta1 = 4; % degrees
disp(['Theta1: ', num2str(theta1), ' degrees']);
theta2 = 6; % degrees
disp(['Theta2: ', num2str(theta2), ' degrees']);
theta3 = theta1 + theta2; % degrees
disp(['Theta3: ', num2str(theta3), ' degrees']);
theta_n = 4; % degrees
disp(['Theta_n: ', num2str(theta_n), ' degrees']);
MW_H2 = 2.00; % kg/kmol
disp(['Molecular Weight H2: ', num2str(MW_H2), ' kg/kmol']);
MW_air = 28.85; % kg/kmol
disp(['Molecular Weight Air: ', num2str(MW_air), ' kg/kmol']);
LHV = 120 * 10^6; % J/kg
disp(['Lower Heating Value LHV: ', num2str(LHV), ' J/kg']);
eta_comb = 0.95; % Combustion Efficiency
disp(['Combustion Efficiency: ', num2str(eta_comb)]);
cp = 1003; % J/(kg·K)
disp(['Specific Heat cp: ', num2str(cp), ' J/(kg·K)']);
h1 = 0.5746; % m
disp(['Height h1: ', num2str(h1), ' m']);
h2 = 0.7752; % m
disp(['Height h2: ', num2str(h2), ' m']);
h3 = 0.1502; % m
disp(['Height h3: ', num2str(h3), ' m']);
hc = h1 + h2 + h3;
disp(['Combined Height hc: ', num2str(hc), ' m']);
he = 2.6; % m
disp(['Height Exit he: ', num2str(he), ' m']);
w = 3.000; % m
disp(['Engine Width w: ', num2str(w), ' m']);
L_inlet = 5.5; % m
disp(['Inlet Length: ', num2str(L_inlet), ' m']);
x_n0 = 3; % m
disp(['Nacelle Position x_n0 reletad to C.G: ', num2str(x_n0), ' m']);
Ln0 = 4.8; % m
disp(['Nacelle inital length Ln0: ', num2str(Ln0), ' m']);
La = 5; % m
disp(['Aft Length La: ', num2str(La), ' m']);
tau1 = 3.1; % degrees
disp(['Inclination tau1: ', num2str(tau1), ' degrees']);
tau2 = 18.23; % degrees
disp(['Inclination tau2: ', num2str(tau2), ' degrees']);
x_inlet = 6; % m
disp(['Inlet Position x_inlet related to C.G: ', num2str(x_inlet), ' m']);
z_inlet = 0.7; % m
disp(['Inlet Position z_inlet related to C.G: ', num2str(z_inlet), ' m']);
x_a = 3.7; % m
disp(['Aft Force Position x_a related to C.G: ', num2str(x_a), ' m']);
z_a = 0.4; % m
disp(['Vertical Aft Force Position z_a related to C.G: ', num2str(z_a), ' m']);

% Structural Properties

disp(' '); % Adiciona um espaço
disp('==================== Structural Properties =====================');
disp(' '); % Adiciona um espaço

E = 110e9; % Pa
disp(['Modulus of Elasticity E: ', num2str(E), ' Pa']);
L = 22.5; % m
disp(['Vehicle Length L: ', num2str(L), ' m']);
airframe_thickness = 0.28 * 0.0254; % m
disp(['Airframe Thickness: ', num2str(airframe_thickness), ' m']);
area_secao = 79.402*1.5; % m²
disp(['Sectional Area: ', num2str(area_secao), ' m²']);
disp(' '); % Adiciona um espaço

% Auto-Pilot Mode
disp(' '); % Adiciona um espaço
disp('==================== Auto-Pilot Mode =====================');
disp(' '); % Adiciona um espaço

% TECS Mode
TECS_ON = 0;
disp(['TECS_ON: ', num2str(TECS_ON)]);

PA_TECSEngineInput = 0;
disp(['PA_TECSEngineInput: ', num2str(PA_TECSEngineInput)]);

disp(' ');

% Engine Mode
PA_EngineMode = 0;
disp(['PA_EngineMode: ', num2str(PA_EngineMode)]);

MachPoint = 10;
disp(['MachPoint: ', num2str(MachPoint)]);

disp(' ');

% Lateral Mode
PA_LatMode = 2;
disp(['PA_LatMode: ', num2str(PA_LatMode)]);

PhiPoint = 0;
disp(['PhiPoint: ', num2str(PhiPoint)]);

Waypoint_idx = 1;
disp(['Waypoint_idx: ', num2str(Waypoint_idx)]);

Waypoints = [
    35.6895, 139.6917;  % Tokyo
    55.7558, 37.6173;   % Moscow
    48.8566, 2.3522;    % Paris
    51.5074, -0.1278;   % London
    45.5017, -73.5673;  % Montreal
    40.7128, -74.0060;  % New York
    34.0522, -118.2437; % Los Angeles
    -23.5505, -46.6333; % São Paulo
    -82.8628, 135.0000; % Antarctica
    -33.9249, 18.4241;  % Cape Town
    -8.0476, -34.8770;  % Recife
];
disp('Waypoints: Tokyo, Moscow, Paris, London, Montreal, New York, Los Angeles, São Paulo, Antarctica, Cape Town, Recife');


disp(' ');

% Longitudinal Mode
PA_LongMode = 2;
disp(['PA_LongMode: ', num2str(PA_LongMode)]);

AltPoint = 100000;
disp(['AltPoint: ', num2str(AltPoint), ' m']);

ThetaPoint = 0;
disp(['ThetaPoint: ', num2str(ThetaPoint), ' deg']);

GammaRef_deg = 0;
disp(['GammaRef_deg: ', num2str(GammaRef_deg)]);

disp(' ');

% References

% Rationale for weight distribution in the hypersonic vehicle
%
% Considering that the vehicle is hypersonic and employs advanced materials 
% with compact systems, the weight distribution is estimated as follows:
%
% - Structure: 50–55% (high proportion due to thermal protection and 
%   structural strength for extreme speeds).
% - Engines: 15–20% (scramjet is lighter than traditional engines, but 
%   variable geometry adds complexity).
% - Systems: 10–15% (unmanned configuration, thus control systems are 
%   smaller and simpler).
% - Others: 10–15% (hydrogen tanks, compression ramp, and other specific mechanisms).
%
% For a dry weight of 15,500–16,500 kg:
% - Structure: ~8,500–9,000 kg (55%).
% - Engines: ~2,500–3,000 kg (18%).
% - Systems: ~2,000–2,500 kg (15%).
% - Others: ~2,000–2,500 kg (15%).
%
% Conclusion:
% The general average for dry weight distribution in aircraft typically follows:
% - Structure: ~50%.
% - Engines: ~20%.
% - Systems: ~15%.
% - Others: ~15%.
%
% Note: These proportions may vary depending on the mission profile and 
% specific design of the aircraft.


% Massa: 90,718.4 kg
% Envergadura (Span): 18.288 m
% Área da Asa: 334.73 m²
% Corda Aerodinâmica: 24.384 m 
% scale_factor_span = 6 / 18.288
% scale_factor_area = 91.51 / 334.73
% scale_factor_chord = 15.252 / 24.384
