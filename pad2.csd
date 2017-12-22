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
; Instrument
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
ipch_l1       = p11
ipch_r1       = p12
ipch_l2       = p13
ipch_r2       = p14
ipch_dur      = p15 * idur
iscale        = p16
ipch_fract    = p17
irvgain       = p18


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
a1 oscil k1, kpitch_ramp1 + k4 + k8, ifunc_l1
a2 oscil k2, kpitch_ramp2 + k5 + k9, ifunc_r1

outs a1,a2

garvbsig1 = garvbsig1 + a1 * irvgain
garvbsig2 = garvbsig2 + a2 * irvgain

endin

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

; Instr       st  dur  rvb_time
i"reverb_1"   0   30   4


;Instr    st   dur  amp    fnc_l  fnc_r    env_fnc_l  env_fnc_r   attack    release
;pch_l1   pch_r1    pch_l2        pch_r2   pch_dur    scale      fraction    rb_gain
i"pad_2"  1    20   .6     9      9        12         12          .25       .4
5.00      5.0023    5.03          5.034    .25        12         [0]         1

i"pad_2"  4    16   .5     9      9        8          12          .25       .4
6.00      6.002     6.03          6.034    .25        12         [0]         1

i"pad_2"  8    15   .6     9      9        8          12          .5        .4
6.08      6.082     8.02          8.034    .25        12         [0]         1

e
</CsScore>
</CsoundSynthesizer>
