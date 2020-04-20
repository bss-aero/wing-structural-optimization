function [ esforcos ] = beam_forces_SS(carga, prop, wing, panels)
%ESFORCOS_BIPLANO Calcula os esforcos nas longarinas do biplano
%   Detailed explanation goes here

%% configuracao
b = wing.b; % envergadura asa de cima
d = wing.d; % distancia entre as fixacoes asa de cima

%% vetores de posicao
s = carga.x; % vetor de posicao central dos paineis
s = [-wing.b/2 s wing.b/2];
s_0 = s + b/2; % deslocamento para ponta de asa

% posicao do centroide em relacao a 1/4 de corda (bdf positivo)
xl = [prop.centroide];
xl_b2 = xl(1:2:end);
xl = [flip(xl_b2) xl_b2];
xl = [xl(1) xl xl(1)];

%% carregamentos

% consideracoes aeroelasticas no carregamento
% static_aeroelastic_loads

w = carga.dLdb*1.15*1.5; % vetor de carregamento (sustentacao)
w = [0 w 0];
wt = carga.dMadb*1.15*1.5; % vetor de carregamento (momento torsor)
wt = [0 wt 0];

wi = w(2:end); wi1 = w(1:end-1);
si = s_0(2:end); si1 = s_0(1:end-1);
ws = (1/3)*(wi - wi1).*(si.^2 + si.*si1 + si1.^2) + (1/2)*(si.*wi1 - si1.*wi).*(si.^2 - si1.^2)./(si - si1); % linear


%% posicoes/indices de descontinuidade
[~, i1] = min(abs(s_0-(b-d)/2)); % indices das posicoes dos apoios
[~, i2] = min(abs(s_0-(b+d)/2));

%% integrais cumulativas
int_w = cumtrapz(s_0,w);
int_ws = [0 cumsum(ws)];
int_wt_1 = cumtrapz(s_0(1:i1),wt(1:i1)+xl(1:i1).*w(1:i1));
int_wt_2 = cumtrapz(s_0(i1:i2),wt(i1:i2)+xl(i1:i2).*w(i1:i2));
int_wt_3 = cumtrapz(s_0(i2:end),wt(i2:end)+xl(i2:end).*w(i2:end));

%% reacoes de apoio da asa de cima (vista frontal)
A = [1 1; (b-d)/2 ((b+d)/2)];
B = [int_w(end) int_ws(end)]';
X = linsolve(A,B);
Ra = X(1);
Rb = X(2);

%% esforcos na asa de cima
% primeira secao
V1 = int_w;
M1 = s_0.*V1 - int_ws;
Mt1 = int_wt_1;

% segunda secao
V2 = int_w - Ra;
M2 = s_0.*(V2 + Ra) - int_ws - Ra*(s_0-(b-d)/2);
x = trapz(s_0(i1:i2),wt(i1:i2).*s_0(i1:i2))/trapz(s_0(i1:i2),wt(i1:i2));
Mt2 = -int_wt_2 + int_wt_2(end)*((b+d)/2 - x)/d;

% terceira secao
V3 = int_w - Ra - Rb;
M3 = s_0.*(V3 + Ra + Rb) - int_ws - Ra*(s_0-(b-d)/2) - Rb*(s_0-(b+d)/2);
Mt3 = int_wt_3 - int_wt_3(end);

% esforco normal
N = horzcat(zeros(1,i1-1), ...
    0*ones(1,i2-i1+1), ...
    zeros(1,length(s_0)-i2));

%% vetores
high.s = s;
high.V = [V1(1:i1-1) abs(diff([V1(i1),V2(i1)])) V2(i1+1:i2-1) -abs(diff([V2(i2),V3(i2)])) V3(i2+1:end)];
high.M = [M1(1:i1-1) max([M1(i1) M2(i1)]) M2(i1+1:i2-1) max([M2(i2) M3(i2)]) M3(i2+1:end)];
high.Mt = [Mt1(1:end-1) abs(Mt1(end))*max(abs([Mt1(end) Mt2(1)]))/Mt1(end) Mt2(2:end-1) abs(Mt3(1))*max(abs([Mt2(end) Mt3(1)]))/Mt3(1) Mt3(2:end)];
high.F = N;
high.i1 = i1;
high.i2 = i2;
high.x =  high.Mt./high.V; % posicao do vetor de cortante no sistema equivalente estatico

right.i = i2 - (length(high.s)/2+1);
left.i = length(high.s)/2 - i1;

high.s([1,end]) = [];
high.V([1,end]) = [];
high.M([1,end]) = [];
high.Mt([1,end]) = [];
high.F([1,end]) = [];

right.s = high.s(end/2+1:end);
right.V = high.V(end/2+1:end);
right.M = high.M(end/2+1:end);
right.Mt = high.Mt(end/2+1:end);
right.F = high.F(end/2+1:end);

left.s = flip(-high.s(1:end/2));
left.V = flip(-high.V(1:end/2));
left.M = flip(high.M(1:end/2));
left.Mt = -flip(high.Mt(1:end/2));
left.F = flip(high.F(1:end/2));

esforcos.L = left;
esforcos.R = right;
esforcos.B = high;
end

