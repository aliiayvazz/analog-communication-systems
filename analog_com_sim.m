%% ELM361 ANALOG HABERLESME SISTEMLERI MATLAB PROJESI
% Isim: Muhammet Ali Ayvaz
% Okul No: 210102002078

clear; clc; close all;

%% --- 1. PARAMETRELER ---
Fs = 100000;             % Ornekleme frekansi (100 kHz)
T_period = 0.02;         % Ortak periyot (20 ms)
t = 0:1/Fs:5*T_period;   % Zaman dizisi
L = length(t);           
f_ekseni = (-L/2:L/2-1)*(Fs/L); % Frekans ekseni (Hz)

%% --- SECTION a: MESAJ SINYALI ANALIZI ---
% m(t) = 8*cos(300*pi*t) + 10*sin(500*pi*t)
m_t = 8*cos(300*pi*t) + 10*sin(500*pi*t);

% Spektrum Analizi (FFT)
M_f = fftshift(fft(m_t));
M_f_genlik = abs(M_f)/L;

% Faz Temizligi ve pi Olcekli Cizim 
threshold = max(abs(M_f)) * 1e-4;
M_f_temiz = M_f;
M_f_temiz(abs(M_f) < threshold) = 0;
M_f_faz = angle(M_f_temiz) / pi;

figure('Name', 'Section A: Mesaj Sinyali', 'Color', 'w');
subplot(3,1,1); 
plot(t*1000, m_t, 'r', 'LineWidth', 2); title('Message Signal m(t)', 'FontSize', 14); 
ylabel('Amplitude', 'FontSize', 12); grid on; xlim([0 40]); set(gca, 'FontSize', 12);

subplot(3,1,2); 
plot(f_ekseni, M_f_genlik, 'r', 'LineWidth', 2); title('Magnitude Spectrum |M(f)|', 'FontSize', 14); 
ylabel('Amplitude', 'FontSize', 12); grid on; xlim([-500 500]); set(gca, 'FontSize', 12);

subplot(3,1,3); 
plot(f_ekseni, M_f_faz, 'b', 'LineWidth', 2); title('Phase Spectrum (Scaled by \pi)', 'FontSize', 14); 
xlabel('Frequency (Hz)', 'FontSize', 12); ylabel('Phase (\pi)', 'FontSize', 12); 
grid on; xlim([-500 500]); set(gca, 'FontSize', 12); 

%% --- SECTION b: DSB-SC AM ---
fc = 1500; % Tasiyici frekansi (1.5 kHz)
c_t = 10 * cos(2*pi*fc*t);
s_sc_t = m_t .* c_t; 

% Demodulasyon - LPF Oncesi (Carpim)
v_t = s_sc_t .* cos(3000*pi*t);
V_f = fftshift(fft(v_t));

% LPF Cikisi (Frekans domeninde manuel filtreleme)
H_f = abs(f_ekseni) <= 500; % 500 Hz ideal LPF maskesi
V_filt_f = V_f .* H_f;      % Z(f) = E(f)*H(f)
m_rec_sc = real(ifft(ifftshift(V_filt_f))) * 2; 

figure('Name', 'Section B: DSB-SC', 'Color', 'w');
subplot(2,1,1); 
plot(t*1000, s_sc_t, 'g', 'LineWidth', 2); title('DSB-SC Modulated Signal s(t)', 'FontSize', 14); 
ylabel('Amplitude', 'FontSize', 12); grid on; xlim([0 40]); set(gca, 'FontSize', 12);

subplot(2,1,2); 
plot(t*1000, m_rec_sc, 'b', 'LineWidth', 2); title('Demodulated Message (b-iii)', 'FontSize', 14); 
xlabel('Time (ms)', 'FontSize', 12); ylabel('Amplitude', 'FontSize', 12); 
grid on; xlim([0 40]); set(gca, 'FontSize', 12);

%% --- SECTION c-i: DSB-LC (AM) MODÜLASYONU ---
mu = 0.7; Ac = 10;
mp = 17.7; % Analitik hesaplanan tepe degeri
m_n = m_t / mp;     

s_am_t = Ac * (1 + mu * m_n) .* cos(2*pi*fc*t);
S_am_f = fftshift(fft(s_am_t));
S_am_genlik = abs(S_am_f)/L;

figure('Name', 'Section C-i: AM Modulasyonu', 'Color', 'w');
subplot(2,1,1); 
plot(t*1000, s_am_t, 'b', 'LineWidth', 1.5); title('DSB-LC (AM) Signal s(t)', 'FontSize', 14);
ylabel('Amplitude', 'FontSize', 12); grid on; xlim([0 40]); set(gca, 'FontSize', 12);

subplot(2,1,2); 
plot(f_ekseni, S_am_genlik, 'r', 'LineWidth', 2); title('AM Magnitude Spectrum', 'FontSize', 14);
xlabel('Frequency (Hz)', 'FontSize', 12); ylabel('Amplitude', 'FontSize', 12); 
grid on; xlim([-2500 2500]); set(gca, 'FontSize', 12);

%% --- SECTION c-ii: ZARF DEMODÜLASYONU (TOOLBOXSIZ) ---
% 1. Adim: 
v_rect = abs(s_am_t); 

% 2. Adim: LPF (Frekans domeninde)
V_rect_f = fftshift(fft(v_rect));
H_f_am = abs(f_ekseni) <= 400; 
zarf_sinyali = real(ifft(ifftshift(V_rect_f .* H_f_am)));

% 3. Adim: DC Cikarma ve Olceklendirme
zarf_olcekli = zarf_sinyali * (pi/2); 
m_demod_am = zarf_olcekli - mean(zarf_olcekli); 

figure('Name', 'Section C-ii: AM Demodulasyonu', 'Color', 'w');
subplot(2,1,1); 
plot(t*1000, s_am_t, 'b', 'LineWidth', 1); hold on;
plot(t*1000, zarf_olcekli, 'r', 'LineWidth', 2); 
title('AM Signal and Envelope Detection', 'FontSize', 14); 
grid on; xlim([0 40]); legend('AM Signal', 'Envelope'); set(gca, 'FontSize', 12);

subplot(2,1,2); 
plot(t*1000, m_t, 'k', 'LineWidth', 2); hold on;
plot(t*1000, m_demod_am * (mp/(Ac*mu)), 'r--', 'LineWidth', 2); 
title('Original Message vs Zarf Demodulasyonu', 'FontSize', 14);
xlabel('Time (ms)', 'FontSize', 12); grid on; xlim([0 40]);
legend('Original m(t)', 'Demodulated'); set(gca, 'FontSize', 12);