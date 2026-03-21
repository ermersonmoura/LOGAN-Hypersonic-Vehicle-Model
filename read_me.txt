QUICK GUIDE

To run the model, you must first execute the Logan_init.m script.
This file is responsible for loading all model variables. Within this script, it is possible to modify key parameters such as reference mass, moments of inertia, and the control configuration of the PA modes.

After running Logan_init.m, open the logan.slx file. This is the main Simulink model where the equations of motion and subsystem interactions are solved.

For trim conditions, you can execute the logan_trim_m script. In this file, you must specify the center of gravity position, vehicle mass, trim altitude, and Mach number. Caution is required when modifying the center of gravity, since certain CG positions may lead to destabilizing behavior of the vehicle.

After trimming, simulations can be executed either directly from the Simulink environment or by running the logan_sim.m script, which serves as an example of a complete simulation workflow.