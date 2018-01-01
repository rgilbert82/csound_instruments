<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac      ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o name_of_output_file.wav -W ;;; for file output any platform
</CsOptions>

<CsInstruments>

sr     = 44100
kr     = 4410
ksmps  = 10
nchnls = 2
0dbfs  = 1

garvbsig init 0


; =============================================================================
; =============================================================================
; REVERB
; =============================================================================
; =============================================================================


instr 99
asig reverb2 garvbsig, p4, p5
outs asig * .5, asig * .5
garvbsig = 0
endin


; =============================================================================
; =============================================================================
; BELL
; =============================================================================
; =============================================================================


instr bell
idur        = p3
iamp        = p4
icps1       = p5
icps2       = p6
ipch_dur    = p7 * idur
iscale      = p8
ipch_fract  = p9

ipan1       = p10
ipan2       = p11
irvbgain    = p12
ifunc       = p13
ienv_shape  = p14

ifeedback     = p15       ;range 1-10
ifb_freq_1    = p16
ifb_freq_2    = p17
ifb_1         = p18       ;range 0-2
ifb_2         = p19
ifb_3         = p20
ifb_time_1    = p21
ifb_time_2    = p22
ifb_fold      = p23

ipch1     cps2pch icps1, iscale
ipch2     cps2pch icps2, iscale
kpch_env  linseg  ipch1, ipch_dur, ipch2, idur - ipch_dur, ipch2

if (ipch_fract != 0) then
  kpch_env = kpch_env * ipch_fract
endif

if (ienv_shape == 1) then
  ienv_func   ftgenonce 0, 0, 512, 7, 0, 1, 1, 50, .6, 411, 0
else
  ienv_func   ftgenonce 0, 0, 512, 7, 0, 1, 1, 50, .6, 411, 0
endif

a5 oscil iamp*.25,1729+kpch_env,ifunc
a4 oscil (iamp*.3)+a5,973+kpch_env,ifunc
a1 oscil (iamp*.5)+a4,513+kpch_env,ifunc
a2 oscil a1+iamp,kpch_env,ifunc
a3 oscil iamp,440,ifunc
kenv oscil 1, 1/idur, ienv_func
am balance a2,a3
afinal = am * kenv


; =============================================================================
; Panning
; =============================================================================


if (ipan1 != ipan2) then
  kpan     linseg  ipan1, idur, ipan2
else
  kpan = ipan1
endif

apan_l, apan_r  pan2  afinal, kpan


; =============================================================================
; Feedback / Outputs
; =============================================================================

if (ifeedback == 0) then
  outs      apan_l, apan_r
  garvbsig = garvbsig + (afinal * irvbgain)
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
  garvbsig = garvbsig + (acomb_l * irvbgain)
endif

endin

</CsInstruments>

; =============================================================================
; =============================================================================

<CsScore>

; =============================================================================
; =============================================================================
; P-FIELDS
; =============================================================================
; =============================================================================

; INSTRUMENT
;p1  instr
;p2  start time
;p3  duration
;p4  amplitude    range 0 - 1+
;p5  pitch 1
;p6  pitch 2
;p7  pitch duration, fraction of total duration
;p8  scale, octave divisions
;p9  pitch fraction

; MISC
;p10 pan start    range 0 - 1
;p11 pan end      range 0 - 1
;p12 reverb gain  range 0 - 1
;p13 osc function
;p14 envelope shape selection, default = 1

; FEEDBACK
;p15 feedback on = 1, off = 0
;p16 fb freq 1 in Hz
;p17 fb freq 2 in Hz
;p18 fb level 1,     range 0-2
;p19 fb level 2,     range 0-2
;p20 fb level 3,     range 0-2
;p21 fb time 1,      percentage of idur
;p22 fb time 2,      percentage of idur
;p23 fold level      range 1+, 0 = off


; =============================================================================
; =============================================================================
; SCORE
; =============================================================================
; =============================================================================

f1 0 2048 10 1                                         ;SINE WAVE
f2 0 4096 10 1 .5 .333 .25 .2 .167 .1428 .125 .111 .1 .0909 .0833 .0769 .0714 .0667 .0625 ;SAW



i99 0 10 4 .3

i"bell"   0     1     .7    9.07    8.07    [1/4]   10    [0]                   ;Instr / pitch
.5        .5    .2    1     1                                                   ;Panning / Misc
0         350   150   1     .5      .8      .5      .5    0                     ;feedback


</CsScore>
</CsoundSynthesizer>

; =============================================================================
; =============================================================================
; =============================================================================
