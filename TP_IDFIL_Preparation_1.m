
% ---TP IDFIL 2020-2021---


% Chaitanya V


% 1 Filtrage d'une gamme musicale


% Pr�liminaire : G�n�ration du signal
duree = 1; fe = 8192;
[sig,t] = gamme(duree, fe);
%soundsc(sig, fe) % Envoi du signal au speaker

% 1.1 Filtrage passe-bas analogique
% Parametres des filtres analogiques 
Ap = 3; % Amplitude bande passante en dB
Aa = 40; % Amplitude bande attenu�e en dB
fc = 420 ; % Fr�quence de coupure en Hz
deltaf = 100; % Fr�quence bande de transition en Hz
fa = fc + (deltaf /2) ; % Fr�quence bande attenu�e en Hz
fp = fc - (deltaf /2) ; % Fr�quence bande passane en Hz
% 1. Calcul de l'ordre de chaque filtre analogique
[ncb, wncb] = buttord(2*pi*fp , 2*pi*fa , Ap, Aa, 's');% Butterworth
[ncc1, wncc1] = cheb1ord(2*pi*fp , 2*pi*fa , Ap, Aa, 's');% Chebyshev type 1 
[ncc2, wncc2] = cheb2ord(2*pi*fp , 2*pi*fa , Ap, Aa, 's');% Chebyshev type 2
[nce, wnce] = ellipord (2*pi*fp , 2*pi*fa , Ap, Aa, 's');% Cauer
% 2. Tracer les reponses frequentielles(Hz) en amplitude(dB)
[numcb, dencb] = butter(ncb, wncb, 'low', 's') ; % Butterworth
[numcc1, dencc1] = cheby1(ncc1, Ap, wncc1, 'low', 's'); % Chebyshev type 1 
[numcc2, dencc2] = cheby2(ncc2, Aa, wncc2, 'low', 's'); % Chebyshev type 2 
[numce, dence] = ellip(nce, Ap, Aa, wnce, 'low', 's'); % Cauer
% Reponse frequentielle des filtres analogiques 
f = linspace(0,1000,1000); % f min fmax et nombre de point 
Hcb = freqs(numcb,dencb,2*pi*f); % Butterworth 
Hcc1 = freqs(numcc1,dencc1,2*pi*f); % Chebychev type 1 
Hcc2 = freqs(numcc2,dencc2,2*pi*f); % Chebyshev type 2 
Hce = freqs(numce,dence,2*pi*f); % Cauer
% Trac�s des reponse frequentielles des filtres analogiques
figure (1), plot(f,20*log10(abs(Hcb)), f,20*log10(abs(Hcc1)), f,20*log10(abs(Hcc2)), f,20*log10(abs(Hce))) 
xlabel('Fr�quence(Hz)');
ylabel('Amplitude(db)'); 
title('R�ponses fr�quentielles en amplitude'); 
legend('Butterworth','Chebyshev ordre 1','Chebyshev ordre 2','Cauer');
grid on 
% 3. Appliquer les filtres au signal audio
sigf_b = lsim(tf(numcb,dencb),sig,t); % Signal audio filtr� par Butterworth
sigf_c1 = lsim(tf(numcc1,dencc1),sig,t); % Signal audio filtr� par Chebyshev ordre 1
sigf_c2 = lsim(tf(numcc2,dencc2),sig,t); % Signal audio filtre par Chebyshev ordre 2 
sigf_e = lsim(tf(numce,dence),sig,t); % Signal audio filtr� par Cauer
% Envoi des signaux filtr�s au speaker
%soundsc(sigf_b,fe) % Signal audio filtr� par Butterworth 
soundsc(sigf_c1,fe) % Signal audio filtr� par Chebyshev 1 
%soundsc(sigf_c2,fe) % Signal audio filtr� par Chebyshev 2 
%soundsc(sigf_e,fe) % Signal audio filtr� par Cauer
% 4. Allure temporelle et le spectre d'amplitude de la gamme filtr�e



% Analyse fr�quentielle des signaux sur [0, Fe] par TFD

f1 = [0 : length(sigf_b)-1]*(fe/length(sigf_b));

ampli_sigf_b = fft(sigf_b)/fe;
figure(2), subplot(2,1,1), plot(f1, abs(ampli_sigf_b), 'black');
grid on
title({'Spectre d amplitude du signal filtr� par Butterworth'});
xlabel({'Fr�quence en Hz'});
ylabel({'|Amplitude|'});
axis([250 550 0 1]);

figure(2), subplot(2,1,2), plot (t, sigf_b, 'black');
grid on
title({'Allure temporelle signal du filtr� par Butterworth'});
xlabel({'Temps en sec'});
ylabel({'Amplitude'});

ampli_sigf_c1 = fft(sigf_c1)/fe;
figure(3),subplot(2,1,1), plot (f1, abs(ampli_sigf_c1),'black');
grid on
title({'Spectre d amplitude du signal filtr� par Chebyshev 1'});
xlabel({'Fr�quence en Hz'});
ylabel({'|Amplitude|'});
axis([250 550 0 1]);
figure(3),subplot(2,1,2), plot (t, sigf_c1, 'black');
grid on
title({'Allure temporelle signal filtre par Chebyshev 1'});
xlabel({'temps en sec'});
ylabel({'amplitude'});

ampli_sigf_c2 = fft(sigf_c2)/fe;
figure(4),subplot(2,1,1), plot (f1, abs(ampli_sigf_c2), 'black');
grid on
title({'spectre d amplitude signal filtre par Chebyshev 2'});
xlabel({'frequence en Hz'});
ylabel({'|amplitude|'});
axis([250 550 0 1]);
figure(4),subplot(2,1,2), plot (t, sigf_c2, 'black');
grid on
title({'allure temporelle signal filtre par Chebyshev 2'});
xlabel({'temps en sec'});
ylabel({'amplitude'});

ampli_sigf_e = fft(sigf_e)/fe;
figure(5),subplot(2,1,1), plot (f1, abs(ampli_sigf_e), 'black');
grid on
title({'spectre d amplitude signal filtre par Cauer'});
xlabel({'frequence en hz'});
ylabel({'|amplitude|'});
axis([250 550 0 1]);
figure(5),subplot(2,1,2), plot (t, sigf_e, 'black');
grid on
title({'allure temporelle signal filtre par Cauer'});
xlabel({'temps en sec'});
ylabel({'amplitude'});







