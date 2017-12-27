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
ipan_start    = p8
ipan_end      = p9
ipan_dur      = p10 * idur
ipan_freq     = p11
ipan_mode     = p12

ipch_s1       = p13
ipch_s2       = p14
ipch_e1       = p15
ipch_e2       = p16
ipch_dur      = p17
iscale        = p18
ipch_fract    = p19

ifeedback     = p20       ;range 1-10
ifb_freq_1    = p21
ifb_freq_2    = p22
ifb_1         = p23       ;range 0-2
ifb_2         = p24
ifb_3         = p25
ifb_time_1    = p26
ifb_time_2    = p27
ifb_fold      = p28

isc           = iamp * .333

icps_s1   cps2pch  ipch_s1, iscale
icps_s2   cps2pch  ipch_s2, iscale
icps_e1   cps2pch  ipch_e1, iscale
icps_e2   cps2pch  ipch_e2, iscale

kpitch_ramp1 linseg  icps_s1, ipch_dur, icps_e1, idur - ipch_dur, icps_e1
kpitch_ramp2 linseg  icps_s2, ipch_dur, icps_e2, idur - ipch_dur, icps_e2

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

a2        butterbp a1,k1,50
a3        butterbr a2,k3,25
afinal_l  balance  a3,a1
a12       butterbp a11,k2,50
a13       butterbr a12,k4,25
afinal_r  balance  a13,a11


; =============================================================================
; Panning
; =============================================================================

if (ipan_freq != 0) then
  kpan     lfo   1, ipan_freq, ipan_mode
elseif (ipan_start != ipan_end) then
  kpan     linseg  ipan_start, ipan_dur, ipan_end
else
  kpan = ipan_start
endif

apan_l  = (1 - kpan) * (2 * ((afinal_l * (1 - (kpan * .5))) + (afinal_r * (kpan * .5))))
apan_r  = (kpan) * (2 * ((afinal_l * (1 - (kpan * .5))) + (afinal_r * (kpan * .5))))


; =============================================================================
; Feedback / Outputs
; =============================================================================

if (ifeedback == 0) then
  outs      apan_l, apan_r
else
  kfb_freq  linseg    ifb_freq_1, idur, ifb_freq_2
  kfdbk     linseg    ifb_1, idur * ifb_time_1, ifb_2, idur * ifb_time_2, ifb_3
  atemp_l   delayr    1/20
  acomb_l   deltapi   1/kfb_freq
  atemp_r   delayr    1/20
  acomb_r   deltapi   1/kfb_freq

  if (ifb_fold >= 1) then
    asig_l    fold  kfdbk * acomb_l, ifb_fold
    asig_r    fold  kfdbk * acomb_r, ifb_fold

    aiir_l    dcblock   apan_l + asig_l
    aiir_l    =         aiir_l - aiir_l * aiir_l * aiir_l/6
    aiir_r    dcblock   apan_r + asig_r
    aiir_r    =         aiir_r - aiir_r * aiir_r * aiir_r/6
  else
    aiir_l    dcblock   apan_l + (acomb_l * kfdbk)
    aiir_l    =         aiir_l - aiir_l * aiir_l * aiir_l/6
    aiir_r    dcblock   apan_r + (acomb_r * kfdbk)
    aiir_r    =         aiir_r - aiir_r * aiir_r * aiir_r/6
  endif

  delayw    aiir_l
  delayw    aiir_r

  outs      acomb_l, acomb_r
endif

endin

</CsInstruments>
<CsScore>

; =============================================================================
; P fields
; =============================================================================

; INSTRUMENT
;p1  instr number
;p2  start time
;p3  duration
;p4  amplitude    range 0 - 1+
;p5  f-table osc function
;p6  env attack percentage
;p7  env release percentage
;p8  pan start    range 0 - 1
;p9  pan end      range 0 - 1
;p10 pan duration
;p11 pan freq for lfo in hz, lfo off = 0
;p12 pad mode for lfo,       sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5

; PITCH
;p13  pitch 1 start
;p14  pitch 2 start
;p15 pitch 1 end
;p16 pitch 2 end
;p17 pitch duration percentage
;p18 pitch scale
;p19 pitch fraction

; FEEDBACK
;p120 feedback on = 1, off = 0
;p121 fb freq 1 in Hz
;p122 fb freq 2 in Hz
;p123 fb level 1,     range 0-2
;p124 fb level 2,     range 0-2
;p125 fb level 3,     range 0-2
;p126 fb time 1,      percentage of idur
;p127 fb time 2,      percentage of idur
;p128 fold level      range 1+, 0 = off


; =============================================================================
; Score
; =============================================================================

i3      0         10       .9       28      .2     .4   .25   .75   .5    0   0 ;instrument
5.01    5.001     6.05     6.051    .25     10     [0]                          ;pitch
0       350       150      1        .5      .8     .5   .5    0                 ;feedback

i3      0         10       .8       28      .2     .4   .25   .75   .5    0   0 ;instrument
5.04    5.041     6.05     6.051    .25     10     [3/2]                        ;pitch
0       150       150      1        .5      .8     .5   .5    0                 ;feedback

i3      0         10       .7       26      .1     .3   .75   .25   .5    0   0 ;instrument
7.001   7.00      8.05     8.051    .25     10     [0]                          ;pitch
0       350       150      1        .5      .8     .5   .5    0                 ;feedback

i3      0         10       .7       26      .1     .3   .75   .25   .5    0   0 ;instrument
7.001   7.00      8.05     8.051    .25     10     [3/2]                        ;pitch
0       150       150      1        .5      .8     .5   .5    0                 ;feedback

e
</CsScore>
</CsoundSynthesizer>
