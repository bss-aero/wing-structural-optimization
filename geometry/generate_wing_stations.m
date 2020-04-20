function [stations] = generate_wing_stations(transitions, geometry)
%GENERATE_WING_STATION This function generates N interpolated stations
%   Detailed explanation goes here
chord       = interp1(transitions.spans, transitions.chords, s);

a_limit     = interp1(geometry.spans, geometry.p_alma, s);
a_limit     = (a_limit+chord/4)./chord;
w           = interp1(geometry.spans, geometry.width, s);
b_limit     = a_limit + w./chord;
limits      = vertcat(a_limit, b_limit);

t_caixao    = interp1(geometry.spans, geometry.t_caixao, s);
t_refor     = interp1(geometry.spans, geometry.t_refor, s);

for i = n_sec:-1:1
    stations(i).limits = limits(:,i)';
    stations(i).t_caixao = t_caixao(i);
    stations(i).t_refor = t_refor(i);
    stations(i).span = s(i);
    stations(i).chord = chord(i);
end
end

