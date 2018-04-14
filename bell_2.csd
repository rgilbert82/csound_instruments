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


          instr bell_2

idur          = p3
iamp          = p4
icps1         = p5
icps2         = p6
ipch_dur      = p7 * idur
ibias         = p8
iosc_fnc      = p9
iscale        = p10

ipan_start    = p11
ipan_end      = p12
ipan_dur      = p13 * idur
ipan_freq     = p14
ipan_mode     = p15

ifeedback     = p16       ;range 1-10
ifb_freq_1    = p17
ifb_freq_2    = p18
ifb_1         = p19       ;range 0-2
ifb_2         = p20
ifb_3         = p21
ifb_time_1    = p22
ifb_time_2    = p23
ifb_fold      = p24

ipch1     cps2pch   icps1, iscale
ipch2     cps2pch   icps2, iscale

kpch_env  linseg  ipch1, ipch_dur, ipch2, idur - ipch_dur, ipch2

; =============================================================================
; Osc
; =============================================================================

i2        =         log(ipch1)/10.0 - ibias
k1        expseg     .0001,.03,iamp,idur-.03,.001      ; ENV
k25       linseg     1,.03,1,idur-.03,3
k1        =          k25*k1
k10       linseg     2.25,.03,3,idur-.03,2           ; POWER TO PARTIALS
a1        gbuzz      k1,kpch_env,k10,0,35,iosc_fnc
a2        reson      a1,500,50,1     ;filt
a3        reson      a2,1500,100,1   ;filt
a4        reson      a3,2500,150,1   ;filt
a5        reson      a4,3500,150,1   ;filt
a6        balance    a5,a1
i6        =          ibias
afinal_l  =         a6*i2
afinal_r  =         a6*(1-i2)

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

; =============================================================================
; =============================================================================

<CsScore>

f1  0 513 10 1                                    ; sine
f4  0 513 9  1 1 90                               ; cosine
f8  0 256 7  0 0 1 128 1 0 -1 128 -1              ; square

; =============================================================================
; P fields
; =============================================================================

; INSTRUMENT
;p1  instr number
;p2  start time
;p3  duration
;p4  amplitude    range 0 - 1+
;p5  pitch start
;p6  pitch end
;p7  pitch duration percentage
;p8  bias    range 0 - 1
;p9  oscillator function
;p10 pitch scale

; PANNING
;p11 pan start    range 0 - 1
;p12 pan end      range 0 - 1
;p13 pan duration
;p14 pan freq for lfo in hz, lfo off = 0
;p15 pad mode for lfo,       sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5

; FEEDBACK
;p16 feedback on = 1, off = 0
;p17 fb freq 1 in Hz
;p18 fb freq 2 in Hz
;p19 fb level 1,     range 0-2
;p20 fb level 2,     range 0-2
;p21 fb level 3,     range 0-2
;p22 fb time 1,      percentage of idur
;p23 fb time 2,      percentage of idur
;p24 fold level      range 1+, 0 = off


; =============================================================================
; Score
; =============================================================================

i"bell_2"     0     3    .5    10.00   10.00    .5      0.15    4       12      ; Instrument
.5      .5    .5    0     0                                                     ; Panning
0       150   150   1     .5    .8      .5      .5      0                       ; Feedback

i"bell_2"     3     5    .5    4.00   12.00     .5      0.15    8       12      ; Instrument
.5      .5    .5    0     0                                                     ; Panning
2       150   150   1     .5    .8      .5      .5      0                       ; Feedback

e

; =============================================================================
; =============================================================================

</CsScore>
</CsoundSynthesizer>
