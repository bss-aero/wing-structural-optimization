function [ raw_fit, data ] = fit_function( X )
% fitness_function
% X -> a array of the optimization variables
%
%% Load files

% run configuration
load('data/run_config.mat', 'section_type', 'constraint_type', ...
     'constraint_inclination');

% wing basic geometry
load('data/wing_geometry.mat', 'wing', 'transitions');

% wing aerodynamic loading with N stations and M cases
load('data/loads.mat', 'loads');

%% Generates beam geometry from parametrization
addpath parametrics
switch section_type
    case 'reinforced_box'
        geometry = reinforced_box_parametric_geometry(X);
end

%% Generates the wing stations
addpath geometry
stations = generate_wing_stations(transitions, geometry);

%% Calculate section properties per station
for i = n_sec:-1:1
    switch section_type
        case 'reinforced_box'
            properties = reinforced_box_section(stations(i));
            stations(i).properties = properties;
    end
end

%% Calculate force and moment diagrams for the structure per loading case
for i = length(carga):-1:1
    switch constraint_type
        case 'ss'
            esforcos(i) = beam_forces_SS(loads(i), wing, stations);
        case 'fx'
            esforcos(i) = beam_forces_FX(loads(i), wing, stations);
    end
end

%% Calculate structural criterias
for j = length(esforcos):-1:1
    for i = 1:n_sec
        ms_asa_l(i) = safety_margin(station(i), esforcos(j).L, i, sections(i)); % semi-asa esquerda
        ms_asa_r(i) = safety_margin(station(i), esforcos(j).R, i, sections(i)); % semi-asa direita
    end
    ms(j) = min([ms_asa_l ms_asa_r]);
end

[min_ms, i] = min(ms);
critic_cond = loads(i);

report = report_45(station, sections, wing);

%% Calculate total mass
[mass, dm] = long_mass(station, sections, long_geo, freijo, balsa);
mass = 2*mass;

%% Calculate the fitness of X
raw_fit = weight_function(mass, min_ms, report);

%% Data for future analysis
data.panels = station;
data.report_45 = report;
data.long_geo = long_geo;
data.wing = wing;
data.mass = mass;
data.dm = dm;
data.min_ms = min_ms;
data.ms = ms;
data.esforcos = esforcos;
data.props = sections;
data.desenho = desenho;
data.critic_cond = critic_cond;

%toc
end
