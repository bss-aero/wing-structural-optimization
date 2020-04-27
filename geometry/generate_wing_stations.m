function [stations] = generate_wing_stations(wing_geometry, structure_params)
%GENERATE_WING_STATION This function generates N interpolated stations
%   Detailed explanation goes here
chord       = interp1(wing_geometry.span_transitions, wing_geometry.chord_transitions, s);

a_limit     = interp1(structure_params.spans, structure_params.p_alma, s);
a_limit     = (a_limit+chord/4)./chord;
w           = interp1(structure_params.spans, structure_params.width, s);
b_limit     = a_limit + w./chord;
limits      = vertcat(a_limit, b_limit);

t_caixao    = interp1(structure_params.spans, structure_params.t_caixao, s);
t_refor     = interp1(structure_params.spans, structure_params.t_refor, s);

for i = n_sec:-1:1
    stations(i).limits = limits(:,i)';
    stations(i).t_caixao = t_caixao(i);
    stations(i).t_refor = t_refor(i);
    stations(i).span = s(i);
    stations(i).chord = chord(i);
end
end

