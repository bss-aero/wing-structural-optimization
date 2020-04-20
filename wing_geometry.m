%% Load and save the wing geometry data
load('data/run_config.mat', 'constraint_gap')

wing.root_chord = 1;
wing.b = 7; % wing full span
wing.taper_ratio = [1 0.5];
wing.pci = [0.75]; % percentage of span in wich it tapers
wing.gap = constraint_gap;

transitions.sec_span = wing.b*[wing.pci 1-wing.pci]/2;
transitions.chords = wing.root_chord*[1 wing.tpr_ratio];
transitions.spans = [0 cumsum(wing.sec_span)];
transitions.s_aileron = wing.spans(2:end);

save('data/wing_geometry.mat', 'wing', 'transitions');
clearvars wing transitions contraint_gap