function [prop_cx] = reinforced_box_section(panel)
addpath prop_geo

chord = panel.chord;
caixao_thick = panel.t_caixao;
limits = panel.limits;

% calculo da geometria da secao

% perfil
foil = get_foil_prop(chord, 0, limits, [0 0]);

% limites do perfil
a1_c = foil.ex(1,:);
a2_c = foil.ex(end,:);
a1_t = foil.in(1,:);
a2_t = foil.in(end,:);

% limites construtivos do retangulo

if a1_c(2) < a2_c(2)
    A = a1_c;
    B = [a2_c(1) a1_c(2)];
else
    A = [a1_c(1) a2_c(2)];
    B = a2_c;
end
if a1_t(2) < a2_t(2)
    C = [a1_t(1) a2_t(2)];
    D = a2_t;
else
    C = a1_t;
    D = [a2_t(1) a1_t(2)];
end

% dimensoes
width = D(1) - C(1);
height = A(2) - C(2);
alma_len = height-2*caixao_thick;

% areas
mc_area = caixao_thick*width;
mt_area = caixao_thick*width;
alma_area = caixao_thick*alma_len;

% centroides
mc_cent = A + [width -caixao_thick]/2;
mt_cent = C + [width caixao_thick]/2;
a1_cent = C + [caixao_thick/2 caixao_thick+alma_len/2];
a2_cent = D + [-caixao_thick/2 caixao_thick+alma_len/2];
c = [mc_cent; mt_cent; a1_cent; a2_cent];
a = [mc_area; mt_area; alma_area; alma_area];
cent = centroide_multielemento(c, a);

% segundo momento de inercia
alma_Ix = caixao_thick*alma_len^3/12; % no eixo do centroide
alma_Iy = caixao_thick^3*alma_len/12;
alma_I = [alma_Ix 0; 0 alma_Iy]; % produto de inercia avaliado no eixo de simetria vale 0 (centroide) (aproximando a alma para um retangulo)

mc_Ix = width*caixao_thick^3/12;
mc_Iy = width^3*caixao_thick/12;
mc_I = [mc_Ix 0; 0 mc_Iy];

mt_Ix = width*caixao_thick^3/12;
mt_Iy = width^3*caixao_thick/12;
mt_I = [mt_Ix 0; 0 mt_Iy];

% translacao dos eixos para o centroide da secao
mc_I = translada_eixo(mc_I, mc_cent-cent, mc_area);
mt_I = translada_eixo(mt_I, mt_cent-cent, mt_area);
a1_I = translada_eixo(alma_I, a1_cent-cent, alma_area);
a2_I = translada_eixo(alma_I, a2_cent-cent, alma_area);

% tensor de inercia da secao
I = mc_I + mt_I + a1_I + a2_I;
I(1,2) = 0; % Ixy deve ser nulo
I(2,1) = 0;

% tensor de inercia principal da secao
[I_max, theta] = inercia_principal(I);

% areas
width_med = width-caixao_thick;
height_med = height-caixao_thick;
area_media = (width-caixao_thick)*(height-caixao_thick);
area = sum(a);

% vertices e vertices na linha media
vert = [A;B;C;D];
vert_lm = vert + caixao_thick*[1 -1; -1 -1; 1 1; -1 1]/2;

prop_cx.I = I;
prop_cx.I_max = I_max;
prop_cx.Iz0 = I_max(1,1);
prop_cx.Iy0 = I_max(2,2);
prop_cx.theta_max = theta;
prop_cx.centroide = cent;
prop_cx.area_media = area_media;
prop_cx.area = area;
prop_cx.width = width;
prop_cx.height = height;
prop_cx.alma_len = alma_len;
prop_cx.vertices = vert;
prop_cx.vertices_lm = vert_lm;
prop_cx.width_med = width_med;
prop_cx.height_med = height_med;
prop_cx.mc_cent = mc_cent;
prop_cx.mt_cent = mt_cent;


end

