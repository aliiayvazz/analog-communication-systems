# Analog Communication Systems Simulation (MATLAB)

This repository contains high-fidelity MATLAB simulations for fundamental analog communication techniques. It covers the entire signal processing chain from message signal analysis to modulation, spectral visualization, and signal recovery (demodulation).

## Core Communication Techniques
* **Signal Spectral Analysis:** Implementation of FFT (Fast Fourier Transform) to analyze the magnitude and phase spectrum of multi-tone message signals.
* **Double Sideband - Suppressed Carrier (DSB-SC):** Modeling of synchronous detection and Coherent Demodulation using Low-Pass Filtering (LPF).
* **Amplitude Modulation (AM / DSB-LC):** Simulation of large carrier modulation with specific modulation indices ($\mu$) and **Envelope Detection** (Asynchronous Demodulation) algorithms.
* **Filter Design:** Manual implementation of ideal LPF masks in the frequency domain for precise signal recovery.

## Technology & Tools
* **Language:** MATLAB
* **Engineering Concepts:** Fourier Analysis, Filtering, Modulation Theory, Nyquist Sampling.

## Engineering Relevance for Defense & RF
In the defense industry, understanding the physical layer of communication is vital. This project demonstrates foundational knowledge applicable to:
* **Software Defined Radio (SDR):** Designing digital-analog hybrid communication chains.
* **Electronic Warfare (EW):** Analyzing and intercepting analog signal modulations.
* **RF System Design:** Evaluating signal integrity and bandwidth efficiency.

---
*Note: This repository includes the full MATLAB script (`analog_com_sim.m`) showcasing time and frequency domain visualizations for each modulation stage.*
