%% Aguamiel extractor: reconstructed analytical sizing (not experimental data)
% Technical analytical scenarios; no experimental data inputs.
% Run this script in MATLAB. Results are written beside this script.
% No trial-level records, pump curve, or discharge profile are reconstructed.
clear; close all; clc;
root = fileparts(mfilename('fullpath'));
if isempty(root), root = pwd; end
outdir = root;
if ~exist(outdir,'dir'), mkdir(outdir); end

% Independent assumptions / reference values, SI unless otherwise stated.
Q_L_min=5; Q=Q_L_min*1e-3/60;
D=0.008; L=2; g=9.81; f=0.03; K=12; Hstatic=1;
rho=1050; mu=1.74e-3;
Vbat=12; Cbat_Ah=4.2; Ppump=60; Iref=5.5;
Vcontainer_L=10; dryMass_kg=8; % Illustrative configured values, not measurements.
Vout=5; VBE=0.7; Rbase=1000; Icoil_assumed_A=0.070;

v=4*Q/(pi*D^2); velocityHead=v^2/(2*g);
Re=rho*v*D/mu; fBlasius=0.3164/Re^0.25;
hf=f*(L/D)*velocityHead; hm=K*velocityHead;
H=Hstatic+hf+hm; dp_Pa=rho*g*H; Ph_W=dp_Pa*Q;
HBlasius=Hstatic+(fBlasius*L/D+K)*velocityHead;
E_Wh=Vbat*Cbat_Ah; PnominalReference_W=Vbat*Iref;
tIdeal60_min=60*E_Wh/Ppump;
tIdeal66_min=60*E_Wh/PnominalReference_W;
fillTime_s=60*Vcontainer_L/Q_L_min;
loadedMass_kg=dryMass_kg+rho*Vcontainer_L*1e-3;
Ib_A=(Vout-VBE)/Rbase; betaForced=Icoil_assumed_A/Ib_A;

metric={'Q_m3_s';'velocity_m_s';'velocity_head_m';'Re_consistency_check';...
 'f_Blasius_consistency_check';'distributed_loss_m';'local_loss_m';...
 'required_head_m';'required_pressure_kPa';'hydraulic_power_W';...
 'head_with_Blasius_m';'nominal_battery_energy_Wh';'ideal_runtime_60W_min';...
 'reference_power_W';'ideal_runtime_66W_min';'estimated_filling_time_s';...
 'estimated_loaded_mass_kg';'nominal_base_current_mA';'assumed_forced_gain'};
value=[Q;v;velocityHead;Re;fBlasius;hf;hm;H;dp_Pa/1000;Ph_W;HBlasius;...
 E_Wh;tIdeal60_min;PnominalReference_W;tIdeal66_min;fillTime_s;loadedMass_kg;...
 Ib_A*1000;betaForced];
writetable(table(metric,value),fullfile(outdir,'baseline_results.csv'));

% K sweep: illustrative scenarios, not measured bounds or fitted coefficients.
Kscenario=(0:0.25:24)';
localHead=Kscenario*velocityHead;
requiredHead=Hstatic+hf+localHead;
writetable(table(Kscenario,localHead,requiredHead),fullfile(outdir,'K_sensitivity.csv'));
fig=figure('Color','w','Position',[100 100 1000 600]);
plot(Kscenario,requiredHead,'Color',[0.1 .35 .7],'LineWidth',2); hold on;
plot(Kscenario,localHead,'Color',[.85 .4 .1],'LineWidth',2);
xline(K,'--k','Assumed K = 12','LabelVerticalAlignment','bottom');
plot(K,H,'o','MarkerFaceColor',[.1 .35 .7],'MarkerEdgeColor','k');
xlabel('Equivalent local-loss coefficient K_{tot}'); ylabel('Head (m)');
title('Analytical head sensitivity at fixed Q = 5 L/min'); grid on;
legend('Total required head','Local head loss','Location','northwest');
exportgraphics(fig,fullfile(outdir,'K_sensitivity.png'),'Resolution',300);
exportgraphics(fig,fullfile(outdir,'K_sensitivity.svg'),'ContentType','vector');

% Density effects isolated: Q, geometry, f and K held fixed.
rhoScenario=[1025;1050;1120];
pressure_kPa=rhoScenario*g*H/1000;
hydraulicPower_W=pressure_kPa*1000*Q;
relativeChange_percent=100*(rhoScenario-rho)/rho;
writetable(table(rhoScenario,pressure_kPa,hydraulicPower_W,relativeChange_percent),...
 fullfile(outdir,'density_sensitivity.csv'));
fig=figure('Color','w','Position',[100 100 1000 500]);
tiledlayout(1,2,'TileSpacing','compact');
nexttile;bar(rhoScenario,pressure_kPa,.45,'FaceColor',[.2 .55 .75]);
xlabel('Assumed density (kg/m^3)');ylabel('Required pressure (kPa)');grid on;
nexttile;bar(rhoScenario,hydraulicPower_W,.45,'FaceColor',[.3 .65 .4]);
xlabel('Assumed density (kg/m^3)');ylabel('Hydraulic power (W)');grid on;
sgtitle('Isolated density scenarios; hydraulic coefficients held fixed');
exportgraphics(fig,fullfile(outdir,'density_sensitivity.png'),'Resolution',300);
exportgraphics(fig,fullfile(outdir,'density_sensitivity.svg'),'ContentType','vector');

% Nominal energy balance: not a battery discharge model or confidence interval.
Pscenario=(40:1:90)'; idealRuntime_min=60*E_Wh./Pscenario;
writetable(table(Pscenario,idealRuntime_min),fullfile(outdir,'nominal_energy_scenarios.csv'));
fig=figure('Color','w','Position',[100 100 1000 600]);
plot(Pscenario,idealRuntime_min,'LineWidth',2,'Color',[.4 .25 .65]);hold on;
plot([Ppump PnominalReference_W],[tIdeal60_min tIdeal66_min],'ko','MarkerFaceColor','w');
xlabel('Assumed constant electrical power (W)');ylabel('Ideal runtime (min)');
title('Nominal energy balance: 12 V x 4.2 Ah = 50.4 Wh');grid on;
exportgraphics(fig,fullfile(outdir,'nominal_energy_sensitivity.png'),'Resolution',300);
exportgraphics(fig,fullfile(outdir,'nominal_energy_sensitivity.svg'),'ContentType','vector');

% Numerical self-checks; these check equations, not physical validity.
assert(abs(H-3.731702533998824)<1e-10);
assert(abs(dp_Pa/1000-38.438401951454885)<1e-9);
assert(abs(Ph_W-3.2032001626212403)<1e-10);
assert(abs(tIdeal60_min-50.4)<1e-12);
assert(abs(tIdeal66_min-45.81818181818182)<1e-10);
assert(abs(fillTime_s-120)<1e-12);
assert(abs(betaForced-16.27906976744186)<1e-10);
disp(table(metric,value));
disp('Numerical checks: PASS');
fprintf('Results saved to: %s\n',outdir);
