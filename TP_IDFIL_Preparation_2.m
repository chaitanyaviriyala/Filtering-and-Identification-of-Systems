
% ---TP IDFIL 2020-2021---

% Chaitanya V

% 1.2 Elimination d�une note par ?ltrage coupe-bande

% Generation du signal :
%duree = 1; fe = 8192;
%[ sig , t ] = gamme(duree , fe );
%soundsc(sig , fe )

% Parametres du filtre num�rique RII
Ap = 1; % Amplitude dB bande passante
Aa = 40; % Amplitude dB bande attenuee
fc = [340;360]; % Fr�quence Hz de coupure basse et haute
deltaf = 10; % Frequence Hz de la bande de transition 
fa = [fc(1)+deltaf/2; fc(2)-deltaf/2]; % frequence hz bande attenue
fp = [fc(1)-deltaf/2; fc(2)+deltaf/2]; % frequence hz bande passane
ep = 1-10^(-Ap/20); % ondulation 1-/+epsilon 
da = 10^(-Aa/20) ; % ondulation delta a 
% 1. Synthese du filtre num�rique RII chebyshev type 2 num�rique
[ndc2, wndc2] = cheb2ord(2*fp/fe , 2*fa/fe , Ap, Aa) ; % Filtre num�rique Chebyshev 2
[numdc2, dendc2] = cheby2(ndc2 ,Aa,wndc2, 'stop') ; % Fct de transfert chebyshev 2 coupe-bande
f2 = linspace (0 ,1000 ,1000) ; % f min fmax et nombre de point  
Hdc2 = freqz (numdc2,dendc2 , f2 , fe ) ; % Reponse frequentielle du filtre num�rique


% 2. Allure temporelle et le spectre d'amplitude de la gamme filtr�e
% Appliquation du filtre num�rique RII au signal audio
sigf_dc2 = filter(numdc2,dendc2,sig); % Signal audio filtr� num�riquement RII par Chebyshev ordre 2
%soundsc(sigf_dc2,fe) % Signal audio filtr� par FII Chebyshev 2 

% Analyse fr�quentielle sur [0, Fe]
f2 = [0 : length(sigf_dc2)-1]*(fe/length(sigf_dc2));
ampli_sigf_dc2 = fft(sigf_dc2)/fe;

figure(7), subplot(2,1,1), plot(f2, abs(ampli_sigf_dc2), 'black');
grid on
title({'Spectre d amplitude du signal filtr� de fa�on RII par Chebyshev 2'});
xlabel({'Fr�quence en Hz'});
ylabel({'|Amplitude|'});
axis([250 550 0 1]);

figure(7),subplot(2,1,2), plot (t, sigf_dc2, 'black');
grid on
title({'Allure temporelle signal filtr� de fa�on RII par Chebyshev 2'});
xlabel({'temps en sec'});
ylabel({'amplitude'});


[n_kaiser,wc_kaiser,beta] = kaiserord([fp(1) fa(1) fa(2) fp(2)],[1 0 1], [ep da ep], fe);
h_kaiser = fir1(n_kaiser,wc_kaiser,'stop',kaiser(n_kaiser+1,beta));

% Appliquation du filtre num�rique RIF au signal audio
sigf_kaiser= filter(h_kaiser, 1,sig);
soundsc(sigf_kaiser,fe) % Signal audio filtr� par RIF Kaiser 

% Analyse fr�quentielle sur [0, Fe]
ampli_sigf_Kaiser = fft(sigf_kaiser)/fe;
f3 =[0 : length(sigf_kaiser)-1]*(fe/length(sigf_kaiser));

figure(8), subplot(2,1,1), plot(f3, abs(ampli_sigf_Kaiser), 'black');
grid on
title({'Spectre d amplitude du signal filtr� de fa�on RIF par Fenetre Kaiser'});
xlabel({'Fr�quence en Hz'});
ylabel({'|Amplitude|'});
axis([250 550 0 1]);

figure(8),subplot(2,1,2), plot (t, sigf_kaiser, 'black');
grid on
title({'Allure temporelle signal filtr� de fa�on RIF par Fenetre Kaiser'});
xlabel({'temps en sec'});
ylabel({'amplitude'});

f = linspace(0,1000,1000); % f min fmax et nombre de point 
hd_kaiser=freqz(h_kaiser,1,f,fe);
figure (9), plot(f,20*log10(abs(Hdc2)),f,20*log10(abs(hd_kaiser)));
legend ('RII','RIF');

