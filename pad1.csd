<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac   ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
;-o test.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 2
0dbfs  = 1

; =============================================================================
; F tables
; =============================================================================

gi1        ftgen 1,  0, 16384, 10, 1	;sine wave
gi2        ftgen 2,  0, 16384, 10, 1, 0 , .33, 0, .2 , 0, .14, 0 , .11, 0, .09 ;odd harmonics
gi3        ftgen 3,  0, 16384, 10, 0, .2, 0, .4, 0, .6, 0, .8, 0, 1, 0, .8, 0, .6, 0, .4, 0,.2 ;even harmonics
gi4        ftgen 4,  0, 8192,  20, 2, 1  ;Hanning function
gi5        ftgen 5,  0, 1024,  19, .5, .5, 270, .5    ; Sigmoid
gi6        ftgen 6,  0, 16384, 10, 1, 0, 0.3, 0, 0.2, 0, 0.14, 0, .111 ; Square wave
gi7        ftgen 7,  0, 16384, 10, 1, 0.5, 0.3, 0.25, 0.2, 0.167, 0.14, 0.125, .111 ; Saw
gi8        ftgen 8,  0, 16384, 10, 1, 1, 1, 1, 0.7, 0.5, 0.3, 0.1
gi9        ftgen 9,  0, 2^10,9, 1,2,0, 3,2,0, 9,0.333,180
gi10       ftgen 10, 0, 16384, 11, 1, 1
gi11       ftgen 11, 0, 16384, 11, 10, 1, .7
gi12       ftgen 12, 0, 16384, 11, 10, 5, 2
gi13       ftgen 13, 0, 513, 6, 1, 128, -1, 128, 1, 64, -.5, 64, .5, 16, -.5, 8, 1, 16, -.5, 8, 1, 16, -.5, 84, 1, 16, -.5, 8, .1, 16, -.1, 17, 0
gi14       ftgen 14, 0, 513, 6, 0, 128, 0.5, 128, 1, 128, 0, 129, -1
gi15       ftgen 15, 0, 129, 5, 1, 100, 0.0001, 29
gi16       ftgen 16, 0, 129, 5, 0.00001, 87, 1, 22, .5, 20, 0.0001
gi17       ftgen 17, 0, 257, 9, .5,1,270
gi18       ftgen 18, 0, 1024, -19, 1, 0.5, 270, 0.5
gi19       ftgen 19, 0, 1024, 19, 0.5, 0.5, 270, 0.5    ; Sigmoid for FOF
gi20       ftgen 20, 0, 1024, 7, 0, 512, 1, 0, -1, 512, 0  ; for FOF
gi21       ftgen 21,  0,   4096,  10, .86, .9, .32, .2, 0, 0, 0, 0, 0, 0, 0, 0, 0, .3, .5
gi22       ftgen 22,  0,   2048,  10,  1
gi23       ftgen 23,  0,    512,   7,  0,   128, 1, 128, .7, 128, .7, 128,  0
gi24       ftgen 24,  0,    512,   7,  1,   128, .8, 128,  .6, 128,  .4,  64,  .2, 64, 0
gi25       ftgen 25,  0,    512,   7,  0,   128, .5, 128, 1, 128, .7, 128, 0
gi26       ftgen 26,  0,   4096,  10, .28, 1, .74, .66, .78, .48, .05, .33, .12, .08, .01, .54, .19, .08, .05, .16, .01, .11, .3, .02, .2
gi27       ftgen 27, 0,      4,   7,  1,     4,  1
gi28       ftgen 28, 0,   4096,  10,  1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0
gi29       ftgen 29, 0,    512,   7,  0,   128, .3, 128, .5, 128, 1, 128, 0
gi30       ftgen 30, 0,   4096,  10,  .6, .4, 1, .22, .09, .24, .02, .06, .05
gi31       ftgen 31, 0,    512,   5,  1,   128, .4, 128, .3, 128, .2, 128, .01
gi32       ftgen 32, 0,    512,   7,  0,   128, .1, 128, .2, 128, .3, 128, 1


; =============================================================================
; Instrument
; =============================================================================

instr 3

idur          = p3
iamp          = p4
ifunc         = p5
iattack       = p6 * idur
idecline      = p7 * idur
ipch_s1       = p8
ipch_s2       = p9
ipch_e1       = p10
ipch_e2       = p11
iscale        = p12
ipch_fract    = p13
isc           = iamp * .333

icps_s1   cps2pch  ipch_s1, iscale
icps_s2   cps2pch  ipch_s2, iscale
icps_e1   cps2pch  ipch_e1, iscale
icps_e2   cps2pch  ipch_e2, iscale

kpitch_ramp1 linseg  icps_s1, idur, icps_e1
kpitch_ramp2 linseg  icps_s2, idur, icps_e2

if (iattack <= 0) then
  kenv linseg isc, idur - idecline, isc, idecline, 0
else
  kenv linseg 0, iattack, isc, idur - iattack - idecline, isc, idecline, 0
endif

if (ipch_fract != 0) then
  kpitch_ramp1 = kpitch_ramp1 * ipch_fract
  kpitch_ramp2 = kpitch_ramp2 * ipch_fract
endif

k1 line 100,idur,1000
k2 line 1000,idur,100
k3 line 1000,idur,50
k4 line 50,idur,1000

a5  oscil kenv,kpitch_ramp1,ifunc
a6  oscil kenv,kpitch_ramp1*.999,ifunc
a7  oscil kenv,kpitch_ramp1*1.001,ifunc
a8  oscil kenv,kpitch_ramp2,ifunc
a9  oscil kenv,kpitch_ramp2*.999,ifunc
a10 oscil kenv,kpitch_ramp2*1.001,ifunc

a1  = a5 + a6 + a7
a11 = a8 + a9 + a10

a2     butterbp a1,k1,50
a3     butterbr a2,k3,25
aleft  balance  a3,a1
a12    butterbp a11,k2,50
a13    butterbr a12,k4,25
aright balance  a13,a11

outs aleft, aright

endin

</CsInstruments>
<CsScore>

;ins st  dur   db func   at  dec freq_s1   freq_s2   freq_e1  freq_e2   scale   fraction
i3   0   10   .9  28     .2   .4   5.01    5.001     5.05     5.051     10      [0]
i3   0   10   .8  28     .2   .4   5.04    5.041     5.05     5.051     10      [3/2]
i3   0   10   .7  26     .1   .3   7.001   7.00      7.05     7.051     10      [0]
i3   0   10   .7  26     .1   .3   7.001   7.00      7.05     7.051     10      [3/2]

e
</CsScore>
</CsoundSynthesizer>
