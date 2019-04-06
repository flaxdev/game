function U = getOkadaOnFault(params, Stations, Terrain)

% ###################################
% point = [(-params(5)) (+params(4)) 0];
% 
% rot1 = [cosd(params(3)), sind(params(3)), 0
%         -sind(params(3)), cosd(params(3)), 0
%         0,0,1];
%     
% rot2 = [cosd(params(6)), 0, sind(params(6))
%         0,1,0
%         -sind(params(6)), 0, cosd(params(6))];
% 
% newpoint = point*rot1*rot2;
% x0 = (Stations(2) - params(1) + newpoint(1))/1000;
% y0 = (Stations(1) - params(2) + newpoint(2))/1000;
% z0 = (Stations(3) + newpoint(3))/1000;

x0 = (Stations(2) - (params(1) + params(4)*cosd(90-params(3)) + params(5)*cosd(params(6))*cosd(-params(3))))/1000;
y0 = (Stations(1) - (params(2) + params(4)*sind(90-params(3)) + params(5)*cosd(params(6))*sind(-params(3))))/1000;
z0 = (Stations(3) - (params(5)*sind(params(6))))/1000;


XROT = [cosd(params(3)) -sind(params(3)) 0 
    sind(params(3)) cosd(params(3)) 0
    0 0  1];

newx = XROT*[x0;y0;z0];
% if (y0==0) & x0>-3
%     [x0;y0;z0]
%     newx
% end
params(1) = 0;
params(2) = 0;
H =  newx(3);
XX = newx(1);
YY = newx(2);
FA = 0;
% ###################################


ELAS = (1-2*Terrain.Poisson);

% FA=params(4)*pi/180;
% H=(Stations(3)-params(3))/1000;
% XX = Stations(2)/1000;
% YY = Stations(1)/1000;

US(1)=params(11);
US(2)=params(9);
US(3)=-params(10);
TA=params(6)*pi/180;
CT=cos(TA);
ST=sin(TA);
CTT=CT/ST;
CF=cos(FA);
SF=sin(FA);
W=params(8)/1000;
RA=params(7)/1000;
D=H+W*ST;
XPA=params(1)/1000-H*CF*CTT;
YPA=params(2)/1000+H*SF*CTT;

% #######
% XPA = 0;
% YPA = 0;
% ######

    % C ----------Donnee verticale
[tmpX,tmpY,AZ] = FAULT(XX,YY,XPA,YPA,RA,W,D,1,SF,CF,CT,ST,CTT,ELAS,US);
    % C ----------Donnee horizontale
[AX,AY,tmpZ] =  FAULT(XX,YY,XPA,YPA,RA,W,D,2,SF,CF,CT,ST,CTT,ELAS,US);

U = [AY, AX, AZ];

% ###################################
u = ((XROT')*([AX AY AZ]'))';
U = [u(2) u(1) u(3)];
% ###################################

function  [AX,AY,AZ] = FAULT(XX,YY,XP,YP,AL,W,D,IND,SF,CF,CT,ST,CTT,ELAS,US)
%
% C ----------Calcul du deplacement dans le repere geographique
% C           J.C.Ruegg-1986 d'apres Okada(1985,BSSA)
% C           Modifie le 30/8/87
%
% C           Faille en tension  I= 1
% C           Faille en coulissage  I= 2
% C           Faille plongeante  I= 3
% C           Coordonnes initiales XX,YY dans repere geographique UTM
% C           Repere local de faille X1,Y1
% C           Repere Okada  X2,Y2
% C           Sortie : Deplacements A,B,C surface libre

% C ----------Passage repere geographique au repere local X1,Y1
X1= (XX-XP)*SF + (YY-YP)*CF;
Y1=-(XX-XP)*CF + (YY-YP)*SF;

% C ----------Passage au repere Okada
X2= X1;
Y2= Y1 + D*CTT;

% C ----------Coins de la faille dans le repere Okada
QS1= X2+AL;
QS2= X2-AL;
P1= Y2*CT +D*ST;
P2= P1 - W;
Q= Y2*ST - D*CT;

% C ----------Boucle de calcul aux quatre coins de la faille
[UX1,UY1,UZ1] = DISLOK (QS1,P1,IND,CT,ST,CTT,ELAS,US,Q);
[UX2,UY2,UZ2] = DISLOK (QS1,P2,IND,CT,ST,CTT,ELAS,US,Q);
[UX3,UY3,UZ3] = DISLOK (QS2,P1,IND,CT,ST,CTT,ELAS,US,Q);
[UX4,UY4,UZ4] = DISLOK (QS2,P2,IND,CT,ST,CTT,ELAS,US,Q);

A2 = UX1-UX2-UX3+UX4;
B2 = UY1-UY2-UY3+UY4;
C2 = UZ1-UZ2-UZ3+UZ4;

% C ----------Deformation dans le repere geographique
AX=(A2*SF - B2*CF)/2./pi;
AY=(A2*CF + B2*SF)/2./pi;
AZ=C2/2./pi;


% C -------------------------
% C     SOUS-PROGRAMME DISLOK
% C -------------------------
%
% C ----------Calcul des deplacements ux,uy,uz
% C           associes a une dislocation
% C           FORMULES DE OKADA (1985, BSSA)
% C           D'apres J.C. RUEGG, 1986

function [FUX,FUY,FUZ] = DISLOK(QSI,ETA,IND,CT,ST,CTT,ELAS,US,Q)

BY=ETA*CT+Q*ST;
BD=ETA*ST-Q*CT;
R=sqrt(QSI^2+ETA^2+Q^2);
XX=sqrt(QSI^2+Q^2);

RE=R+ETA;
RQ=R+QSI;
QRE=Q/R/RE;
QRQ=Q/R/RQ;
ATQE=atan(QSI*ETA/Q/R);

AT= ETA*(XX+Q*CT)+XX*(R+XX)*ST;
BT= QSI*(R+XX)*CT;

FUX=0;
FUY=0;
FUZ=0;

AI4= ELAS*(log(R+BD)-ST*log(R+ETA))/CT;
AI5= 2*ELAS*atan(AT/BT)/CT;

% C ----------Choix entre calcul de donnees verticales ou horizontales
if(IND==1)

    % C ----------Faille en tension
    if (US(1)~=0)
        FUZ=(BY*QRQ+CT*QSI*QRE-CT*ATQE-AI5*ST*ST)*US(1);
    end

    % C ----------Faille de coulissage
    if(US(2)~=0)
        FUZ=FUZ-(BD*QRE+Q*ST/RE+AI4*ST)*US(2);
    end

    % C ----------Faille plongeante
    if (US(3)~=0)
        FUZ=FUZ+(-BD*QRQ-ST*ATQE+AI5*ST*CT)*US(3);
    end

else
    % C ----------Donnees horizontales
    AI3=ELAS*(BY/CT/(R+BD)-log(R+ETA))+AI4/CTT;
    AI1= -ELAS*QSI/CT/(R+BD)-AI5/CTT;
    AI2= -ELAS*log(R+ETA)-AI3;

    % C ----------Faille en tension
    if (US(1)~=0)
        FUX=(Q*QRE - AI3*ST*ST)*US(1);
        FUY=-(BD*QRQ+ST*QRE*QSI-ST*ATQE+AI1*ST*ST)*US(1);
    end

    % C ----------Faille de coulissage pur (strike-slip)
    if (US(2)~=0)
        FUX=FUX-(QSI*QRE+ATQE+AI1*ST)*US(2);
        FUY=FUY-(BY*QRE+Q*CT/RE+AI2*ST)*US(2);
    end

    % C ----------Faille plongeante pure ( dip-slip)
    if (US(3)~=0)
        FUX=FUX+(-Q/R+AI3*ST*CT)*US(3);
        FUY=FUY-(BY*QRQ+CT*ATQE-AI1*ST*CT)*US(3);
    end

end
