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
; Reverb Sends
; =============================================================================

garvbsig1 init 0
garvbsig2 init 0



; =============================================================================
; =============================================================================
; PAD 2
; =============================================================================
; =============================================================================

instr pad_2

idur          = p3
iamp          = p4 * .5
ifunc_l1      = p5
ifunc_r1      = p6
ifunc_env_l   = p7
ifunc_env_r   = p8
iattack       = p9 * idur
irelease      = p10 * idur
irvgain       = p11

ipch_l1       = p12
ipch_r1       = p13
ipch_l2       = p14
ipch_r2       = p15
ipch_dur      = p16 * idur
iscale        = p17
ipch_fract    = p18

ipan_start    = p19
ipan_end      = p20
ipan_dur      = p21 * idur
ipan_freq     = p22
ipan_mode     = p23

ifeedback     = p24       ;range 1-10
ifb_freq_1    = p25
ifb_freq_2    = p26
ifb_1         = p27       ;range 0-2
ifb_2         = p28
ifb_3         = p29
ifb_time_1    = p30
ifb_time_2    = p31
ifb_fold      = p32

icps_l1   cps2pch  ipch_l1, iscale
icps_r1   cps2pch  ipch_r1, iscale
icps_l2   cps2pch  ipch_l2, iscale
icps_r2   cps2pch  ipch_r2, iscale

kpitch_ramp1 linseg  icps_l1, ipch_dur, icps_l2, idur - ipch_dur, icps_l2
kpitch_ramp2 linseg  icps_r1, ipch_dur, icps_r2, idur - ipch_dur, icps_r2

if (ipch_fract != 0) then
  kpitch_ramp1 = kpitch_ramp1 * ipch_fract
  kpitch_ramp2 = kpitch_ramp2 * ipch_fract
endif

if (iattack <= 0) then
  kenv linseg   iamp, idur - irelease, iamp, irelease, 0
else
  kenv linseg   0, iattack, iamp, idur - iattack - irelease, iamp, irelease, 0
endif

k1 oscil kenv, 1/idur, ifunc_env_l
k2 oscil kenv, 1/idur, ifunc_env_r
k3 linen  3,.9,idur,.3
k4 randi k3,10
k5 randi k3,15
k6 linen abs(birnd(1)),idur * .1,idur, abs(birnd(.8)) + .1
k7 linen abs(birnd(1)),idur * .1,idur, abs(birnd(.8)) + .1
k8 oscil k6,abs(birnd(10)) + 5,-1
k9 oscil k7,abs(birnd(10)) + 5,-1
afinal_l oscil k1, kpitch_ramp1 + k4 + k8, ifunc_l1
afinal_r oscil k2, kpitch_ramp2 + k5 + k9, ifunc_r1


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
  garvbsig1 = garvbsig1 + apan_l * irvgain
  garvbsig2 = garvbsig2 + apan_r * irvgain
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
  garvbsig1 = garvbsig1 + acomb_l * irvgain
  garvbsig2 = garvbsig2 + acomb_r * irvgain
endif

endin


; =============================================================================
; =============================================================================
; REVERB
; =============================================================================
; =============================================================================

instr reverb_1
irvtime = p4
a1  reverb2 garvbsig1,irvtime,.5
a2  reverb2 garvbsig2,irvtime,.25
outs a1,a2
garvbsig1=0
garvbsig2=0
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
;p5  left  osc f-table function
;p6  right osc f-table function
;p7  left  env f-table function
;p8  right env f-table function
;p9  env attack percentage
;p10 env release percentage
;p11 reverb gain    range 0-1+

; PITCH
;p12 pitch 1 start
;p13 pitch 2 start
;p14 pitch 1 end
;p15 pitch 2 end
;p16 pitch duration percentage
;p17 pitch scale
;p18 pitch fraction

; PANNING
;p19 pan start    range 0 - 1
;p20 pan end      range 0 - 1
;p21 pan duration
;p22 pan freq for lfo in hz, lfo off = 0
;p23 pad mode for lfo,       sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5

; FEEDBACK
;p24 feedback on = 1, off = 0
;p25 fb freq 1 in Hz
;p26 fb freq 2 in Hz
;p27 fb level 1,     range 0-2
;p28 fb level 2,     range 0-2
;p29 fb level 3,     range 0-2
;p30 fb time 1,      percentage of idur
;p31 fb time 2,      percentage of idur
;p32 fold level      range 1+, 0 = off



; =============================================================================
; Score
; =============================================================================

; Instr       st  dur  rvb_time
i"reverb_1"   0   30   4


i"pad_2"  1     20   .6     9      9        12      12      .25    .4    1      ;instrument
5.00      5.0023     5.03          5.034    .25     12      [0]                 ;pitch
.25       .75        .5     0      0                                            ;panning
0         150        150    1      .5       .8      .5      .5     0            ;feedback

i"pad_2"  4     16   .5     9      9        8       12      .25    .4    1      ;instrument
6.00      6.002      6.03          6.034    .25     12      [0]                 ;pitch
.25       .75        .5     0      0                                            ;panning
0         150        150    1      .5       .8      .5      .5     0            ;feedback

i"pad_2"  8     15   .6     9      9        8       12      .5     .4    1      ;instrument
6.08      6.082      8.02          8.034    .25     12      [0]                 ;pitch
.75       .25        .5     0      0                                            ;panning
0         350        350    1      .5       .8      .5      .5     0            ;feedback

e
</CsScore>
</CsoundSynthesizer>
