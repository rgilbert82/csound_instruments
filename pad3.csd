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

garvbsig1 init 0
garvbsig2 init 0


; =============================================================================
; =============================================================================
; F tables
; =============================================================================
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


; =============================================================================
; =============================================================================
; PAD 3
; =============================================================================
; =============================================================================


instr pad_3

ienv_fnc ftgenonce 0, 0, 4096, 8,  0.020000, 208, 0.780000, 3302, 0.660000, 481, 0.220000, 105, 0.01
iosc_fnc ftgenonce 0, 0, 4096, 10, 1, .5, .333, .25, .2, .167, .1428, .125, .111, .1, .0909, .0833, .0769, .0714, .0667, .0625

idur          = p3
iamp          = p4
iattack       = p5
irelease      = p6
ipan_start    = p7
ipan_end      = p8
ipan_dur      = p9 * idur
ipan_freq     = p10
ipan_mode     = p11
irvbgain      = p12

inote1        = p13
inote2        = p14
ipch_dur      = p15 * idur
ipch_fract    = p16
iscale        = p17

ifeedback     = p18       ;range 1-10
ifb_freq_1    = p19
ifb_freq_2    = p20
ifb_1         = p21       ;range 0-2
ifb_2         = p22
ifb_3         = p23
ifb_time_1    = p24
ifb_time_2    = p25
ifb_fold      = p26

; =============================================================================
; Pitch
; =============================================================================

icps_1   cps2pch  inote1, iscale
icps_2   cps2pch  inote2, iscale

kpitch_ramp linseg  icps_1, ipch_dur, icps_2, idur - ipch_dur, icps_2

if (ipch_fract != 0) then
  kpitch_ramp = kpitch_ramp * ipch_fract
endif

; =============================================================================
; ADSR
; =============================================================================

if (iattack <= 0) then
  kadsr linseg   iamp, idur - irelease, iamp, irelease, 0
else
  kadsr linseg   0, iattack, iamp, idur - iattack - irelease, iamp, irelease, 0
endif

; =============================================================================
; Oscillators
; =============================================================================

kenv oscil 1,1/idur,ienv_fnc
a1 oscil .2*kenv,kpitch_ramp,iosc_fnc
amod oscil 2,.25,-1
adel vdelay a1,amod,20
adel2 vdelay adel,amod,20
adel3 vdelay adel2,amod,20
adel4 vdelay adel3,amod,20
adel5 vdelay adel4,amod,20
aout=(adel3+adel2+adel+adel4+adel5+a1)/6
abal balance aout,a1
afinal = abal * kadsr

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

apan_l, apan_r  pan2  afinal, kpan


; =============================================================================
; Feedback / Outputs
; =============================================================================

if (ifeedback == 0) then
  outs      apan_l, apan_r
  garvbsig1 = garvbsig1 + (apan_l * irvbgain)
  garvbsig2 = garvbsig2 + (apan_r * irvbgain)
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

  garvbsig1 = garvbsig1 + acomb_l * irvbgain
  garvbsig2 = garvbsig2 + acomb_r * irvbgain
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
;p5  env attack percentage
;p6  env release percentage
;p7  pan start    range 0 - 1
;p8  pan end      range 0 - 1
;p9  pan duration
;p10 pan freq for lfo in hz, lfo off = 0
;p11 pad mode for lfo,       sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5
;p12 reverb gain    range 0-1+

; PITCH
;p13 pitch start
;p14 pitch end
;p15 pitch duration percentage  range 0-1
;p16 pitch fraction
;p17 pitch scale

; FEEDBACK
;p18 feedback on = 1, off = 0
;p19 fb freq 1 in Hz
;p20 fb freq 2 in Hz
;p21 fb level 1,     range 0-2
;p22 fb level 2,     range 0-2
;p23 fb level 3,     range 0-2
;p24 fb time 1,      percentage of idur
;p25 fb time 2,      percentage of idur
;p26 fold level      range 1+, 0 = off

; =============================================================================
; =============================================================================
; Score
; =============================================================================
; =============================================================================

i"reverb_1" 0     12    4

i"pad_3"    0     6     .8    .5    .5    .25   .75   .75     0     0     .25   ; Instrument
8.02        5.00        .5    [1]   10                                          ; Pitch
0           150   150   1     .5    .8    .5    .5    0                         ; Feedback

i"pad_3"    5     4     .8    .5    .5    .8    .25   .5      0     0     .5    ; Instrument
4.00        7.00        .5    [1]   10                                          ; Pitch
5           150   150   1     .5    .8    .5    .5    1                         ; Feedback

</CsScore>

; =============================================================================
; =============================================================================

</CsoundSynthesizer>
