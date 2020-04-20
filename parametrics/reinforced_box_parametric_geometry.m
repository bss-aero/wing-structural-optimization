function [geometry] = reinforced_box_parametric_geometry( X )
%% This script uses a parametrization for a reinforced box configuration
% it must outputs a geometry struct

% tip spar section
tip_spar_position        = X(1); %
tip_spar_width           = X(2); %
tip_spar_thickness       = X(4); %
tip_reinforcer_thickness = X(5); %

% root spar section
root_spar_width           = X(3); % largura / corda
root_spar_thickness       = X(4); % espessura da alma em metros
root_reinforcer_thickness = X(5); % espessura da mesa de compressao em metros

%% definicao das secoes parametrizadas ao longo da envergadura
% seta secoes baseando-se no vetor de carregamento
n_sec = length(carga(1).x)/2;
s = carga(1).x(n_sec+1:end);

geometry.spans = [0 wing.b/2];

geometry.chords = interp1(wing.spans, wing.chords, geometry.spans);

geometry.web_position = [tip_spar_position*geometry.chords(2) - geometry.chords(2)/4, ...
                   tip_spar_position*geometry.chords(2) - geometry.chords(2)/4];
               
geometry.width = [root_spar_width*geometry.chords(2), ...
                  tip_spar_width*geometry.chords(2)];
              
geometry.t_caixao = [t_caixao_s, tip_spar_thickness];
               
geometry.t_refor = [root_reinforcer_thickness tip_reinforcer_thickness];

geometry.limits = [(geometry.p_alma+geometry.chords/4)./geometry.chords; ...
                   (geometry.p_alma+geometry.chords/4+geometry.width)./geometry.chords];
end
