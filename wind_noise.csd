<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac   ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
;-o test.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>
sr        =         44100
kr        =         4410
ksmps     =         10
nchnls    =         2
0dbfs     =         1


instr         wind_noise
idur          = p3
iamp          = p4
ipch_1        = p5
ipch_2        = p6
ipch_dur      = p7 * idur
ibf           = p8
iscale        = p9

ipan_start    = p10
ipan_end      = p11
ipan_dur      = p12 * idur
ipan_freq     = p13
ipan_mode     = p14

ifeedback     = p15       ;range 1-10
ifb_freq_1    = p16
ifb_freq_2    = p17
ifb_1         = p18       ;range 0-2
ifb_2         = p19
ifb_3         = p20
ifb_time_1    = p21
ifb_time_2    = p22
ifb_fold      = p23

icps_1   cps2pch  ipch_1, iscale
icps_2   cps2pch  ipch_2, iscale

kpitch_ramp linseg  icps_1, ipch_dur, icps_2, idur - ipch_dur, icps_2

; =============================================================================
; Osc
; =============================================================================

kbw        =         kpitch_ramp * ibf
iseed      =         rnd(1)
kenv       linseg    0, idur/2, iamp, idur/2, 0
anoise     randi     1.0, 13000, iseed
ares       reson     anoise, kpitch_ramp, kbw, 1
ares1      reson     ares, kpitch_ramp, kbw, 1
afinal     =         ares1 * kenv

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

; =============================================================================
; =============================================================================

<CsScore>

; =============================================================================
; P-fields
; =============================================================================

; INSTRUMENT
;p1  instr number
;p2  start time
;p3  duration
;p4  amplitude    range 0 - 1+
;p5  pitch start
;p6  pitch end
;p7  pitch duration (percentage of duration)
;p8  bandwidth    range 0 - 1
;p9  pitch scale

; PANNING
;p10 pan start    range 0 - 1
;p11 pan end      range 0 - 1
;p12 pan duration
;p13 pan freq for lfo in hz, lfo off = 0
;p14 pad mode for lfo,       sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5

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
; Score
; =============================================================================

i"wind_noise"   0     2     1     12.02     4.05      .7      .3        12      ; Instrument
.25     .75     .7    0     0                                                   ; Panning
3       150     150   1     .5    .8        .5        .5      0                 ; Feedback


</CsScore>
</CsoundSynthesizer>
