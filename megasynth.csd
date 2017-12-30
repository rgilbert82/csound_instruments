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

gasamp = 0    ;Sample input for vocoder


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
gi21       ftgen 21, 0,   4096,  10, .86, .9, .32, .2, 0, 0, 0, 0, 0, 0, 0, 0, 0, .3, .5
gi22       ftgen 22, 0,   2048,  10,  1
gi23       ftgen 23, 0,    512,   7,  0,   128, 1, 128, .7, 128, .7, 128,  0
gi24       ftgen 24, 0,    512,   7,  1,   128, .8, 128,  .6, 128,  .4,  64,  .2, 64, 0
gi25       ftgen 25, 0,    512,   7,  0,   128, .5, 128, 1, 128, .7, 128, 0
gi26       ftgen 26, 0,   4096,  10, .28, 1, .74, .66, .78, .48, .05, .33, .12, .08, .01, .54, .19, .08, .05, .16, .01, .11, .3, .02, .2
gi27       ftgen 27, 0,      4,   7,  1,     4,  1
gi28       ftgen 28, 0,   4096,  10,  1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0
gi29       ftgen 29, 0,    512,   7,  0,   128, .3, 128, .5, 128, 1, 128, 0
gi30       ftgen 30, 0,   4096,  10,  .6, .4, 1, .22, .09, .24, .02, .06, .05
gi31       ftgen 31, 0,    512,   5,  1,   128, .4, 128, .3, 128, .2, 128, .01
gi32       ftgen 32, 0,    512,   7,  0,   128, .1, 128, .2, 128, .3, 128, 1

gi600      ftgen 600, 0, 8193, 8, 0, 512, 1, 1024, 1, 512, .5, 2048, .2, 4096, 0
gi601      ftgen 601, 0, 16, -2,    6, 5, 1, 12,         3, 9, -1, 6,   0, 5, 10, 0,    -1, 25, 3, 20
gi701      ftgen 701, 0, 16, -2,    1, 1, 1, .5, .5,     4,             1.5, .5, 1, 3,          1, 1
gi751      ftgen 751, 0, 16, -2,    1, 0, 0,  1,  0,     0,             0,   0,  1, 0,          1, 0


giadditive_freqs ftgen 999, 0, 32, 7, 0, 32, 0
giadditive_amps  ftgen 998, 0, 32, 7, 0, 32, 0



; =============================================================================
; =============================================================================
; UDOs
; =============================================================================
; =============================================================================

opcode Vocoder, a, aakkkpp
  avocoder_synth,avocoder_sig,kvocoder_min,kvocoder_max,kvocoder_q,ivocoder_band,ivocoder_cnt  xin

  if kvocoder_max < kvocoder_min then
    ktmp = kvocoder_min
    kvocoder_min = kvocoder_max
    kvocoder_max = ktmp
  endif

  if kvocoder_min == 0 then
    kvocoder_min = 1
  endif

  if (ivocoder_cnt >= ivocoder_band) goto bank
  abnd   Vocoder avocoder_synth,avocoder_sig,kvocoder_min,kvocoder_max,kvocoder_q,ivocoder_band,ivocoder_cnt+1

  bank:
  kfreq = kvocoder_min*(kvocoder_max/kvocoder_min)^((ivocoder_cnt-1)/(ivocoder_band-1))
  kbw = kfreq/kvocoder_q
  an  butterbp  avocoder_sig, kfreq, kbw
  an  butterbp  an, kfreq, kbw
  as  butterbp  avocoder_synth, kfreq, kbw
  as  butterbp  as, kfreq, kbw
  ao  balance as, an

  amix = ao + abnd
  xout amix
endop



; =============================================================================
; =============================================================================
; PLACEHOLDER SAMPLER for vocoder (Any audio source will do)
; =============================================================================
; =============================================================================

instr samp

isample = 101
isample_skiptime = 0

i101 ftgenonce 0, 0, 524288, 1, "samples/hellorcb.aif", isample_skiptime, 0, 1
i102 ftgenonce 0, 0, 524288, 1, "samples/amen.wav",     isample_skiptime, 0, 1
; Add other samples here

if (isample == 101) then
  isample = i101
elseif (isample == 102) then
  isample = i102
endif

;asig  paulstretch 1, 0.02, isample
asig flooper2 1, 1, 0, 1, 0.001, isample


gasamp = asig

endin



; =============================================================================
; =============================================================================
; MEGASYNTH
; =============================================================================
; =============================================================================

instr msynth

kindex        = 0
ipitch        = 0

idur          = p3
ieventdur     = idur
iamp          = p4
ipan_start    = p5
ipan_end      = p6
ipan_dur      = p7 * idur
ipan_freq     = p8
ipan_mode     = p9
isynth_type   = p10

iaccent_curve = 600
iempty_note   = 1
isequencer_on = p11
isequence     = p12
idurations    = p13
iacc_sequence = p14
icutoff_start = p15
icutoff_end   = p16
ires_start    = p17
ires_end      = p18
ienv_attack   = p19
ienv_release  = p20
ibpm          = p21
iseq_speed    = p22

ipch_1        = p23
ipch_2        = p24
ipch_3        = p25
ipch_4        = p26
ipch_dur_1    = p27 * idur
ipch_dur_2    = p28 * idur
ipch_dur_3    = p29 * idur
ipch_ramp     = p30
ipch_rand     = p31
iscale        = p32
ipch_fract    = p33

ivib_avg_amp  = p34
ivib_avg_freq = p35
ivib_rand_amp = p36
ivib_rand_freq= p37
ivib_att      = p38 * ieventdur
ivib_dec      = p39 * ieventdur
ivib_sust     = p40
ivib_rel      = p41 * ieventdur
ivib_fnc      = p42

isynth_fnc_1  = p43
isynth_fnc_2  = p44
isynth_fnc_3  = p45
isynth_fnc_4  = p46

iosc_phase_1  = p47
iosc_phase_2  = p48
iosc_phase_3  = p49
iosc_phase_4  = p50

iharmon_start = p51
iharmon_end   = p52
iharmon_dur   = p53 * ieventdur

ivco_mode_1   = p54
ivco_mode_2   = p55
ivco_mode_3   = p56
ivco_mode_4   = p57
ivco_pw       = p58
ivco_nyx      = p59

ipvs_type1    = p60
ipvs_type2    = p61
ipvs_type3    = p62
ipvs_type4    = p63

ihsb_oct_count = p64
ihsb_tone_start= p65
ihsb_tone_end  = p66
ibrite_1       = p67
ibrite_2       = p68
ibrite_3       = p69
ibrite_4       = p70

ifm_idx_start  = p71
ifm_idx_end    = p72
ifm_car_start  = p73
ifm_car_end    = p74
iadditive_cnt  = p75
iadditive_func = p76

ifof_fnc_1      = p77
ifof_fnc_2      = p78
ifof_form_start = p79
ifof_form_end   = p80

ivcdr_on        = p81
isample_pitch   = p82
ivcdr_max       = p83
ivcdr_min       = p84
ivcdr_q         = p85
ivcdr_band      = p86
ivcdr_cnt       = p87

ilowpass_on   = p88
ilp_dist      = p89
ilp_fb        = p90
klp_q         = p91
ilp_stack     = p92

ilp_cut       = p93
ilp_cut_att   = p94  * ieventdur
ilp_cut_dec   = p95  * ieventdur
ilp_cut_sust  = p96
ilp_cut_rel   = p97  * ieventdur
ilp_res       = p98
ilp_res_att   = p99  * ieventdur
ilp_res_dec   = p100 * ieventdur
ilp_res_sust  = p101
ilp_res_rel   = p102 * ieventdur

ihighpass_on  = p103
ihp_cut       = p104
ihp_cut_att   = p105 * ieventdur
ihp_cut_dec   = p106 * ieventdur
ihp_cut_sust  = p107
ihp_cut_rel   = p108 * ieventdur
ihp_q         = p109

idist_on      = p110
idist         = p111
idist_att     = p112 * ieventdur
idist_dec     = p113 * ieventdur
idist_sust    = p114
idist_rel     = p115 * ieventdur
idist_fnc     = p116

idec_on       = p117
idec_bitrate  = p118
idec_samps    = p119
ifold_start   = p120
ifold_end     = p121

iflange_on    = p122
iflange       = p123
iflange_att   = p124 * idur
iflange_dec   = p125 * idur
iflange_sust  = p126
iflange_rel   = p127 * idur
iflange_fb    = p128

iphase_on     = p129
iphase        = p130
iphase_att    = p131 * idur
iphase_dec    = p132 * idur
iphase_sust   = p133
iphase_rel    = p134 * idur
iphase_fb     = p135

ilfo_start    = p136
ilfo_end      = p137
ilfo_shape    = p138
ilfo_att      = p139 * ieventdur
ilfo_dec      = p140 * ieventdur
ilfo_sust     = p141
ilfo_rel      = p142 * ieventdur

iattack_val   = p143
idecay_val    = p144
isustain_vol  = p145
irelease_val  = p146
iattack       = ieventdur * iattack_val
idecay        = ieventdur * idecay_val
irelease      = ieventdur * irelease_val

ifeedback     = p147       ;range 1-10
ifb_freq_1    = p148
ifb_freq_2    = p149
ifb_1         = p150       ;range 0-2
ifb_2         = p151
ifb_3         = p152
ifb_time_1    = p153
ifb_time_2    = p154
ifb_fold      = p155

icps_1   cps2pch  ipch_1, iscale
icps_2   cps2pch  ipch_2, iscale
icps_3   cps2pch  ipch_3, iscale
icps_4   cps2pch  ipch_4, iscale


if (isequencer_on != 0) then
  kaccurve       init      0
  ioctave        =         ipch_1
  imaxfreq       =         1000           ; max.filter cutoff freq. when ienvmod = 0
  imaxsweep      =         10000          ; sr/2... max.filter freq. at kenvmod & kaccent= 1
  ireson         =         1.3            ; scale the resonance as you like (you can make the filter to oscillate...)
  inotedur       =         15/ibpm/iseq_speed
  icount         init      0                                  ; sequence counter (for notes)
  icount2        init      0                                  ; id. for durations
  ipcount2       init      0
  idecaydur      =         inotedur
  imindecay      =         (idecaydur<.2 ? .2 : idecaydur)    ; set minimum decay to .2 or inotedur
  idecay_start   = 1
  idecay_end     = 1
  iaccent_start  = .4
  iaccent_end    = .7
  ipitch         table     0, isequence; first note in the sequence

  if (ipitch < 0) then
    ipitch       = 1
    iempty_note  = 0
  else
    ipitch         cps2pch   (ioctave + ipitch/100), iscale
  endif
endif


; =============================================================================
; Pitch Envelope
; =============================================================================

if (ipch_2 == 0) then
  kpitch_ramp = icps_1
elseif (ipch_ramp == 0) then
  kpitch_ramp    linseg  icps_1, ipch_dur_1, icps_2, ipch_dur_2, icps_3, ipch_dur_3, icps_4
else
  kpitch_ramp    expseg  icps_1, ipch_dur_1, icps_2, ipch_dur_2, icps_3, ipch_dur_3, icps_4
endif


; =============================================================================
; Pitch Fractioning
; =============================================================================

; For Different intonations. For example, Just Intonation in C would be:
;
;    C       C#      D-      D       Eb-      Eb       E       F      F#-
;    1/1     25/24   10/9    9/8     32/27    6/5      5/4     4/3    25/18
;
;    F#      G       G#      A       Bb-      Bb       B       C
;    45/32   3/2     25/16   5/3     16/9     9/5      15/8    2/1


if (ipch_fract != 0) then
  kpitch_ramp = kpitch_ramp * ipch_fract
endif


; =============================================================================
; Vibrato
; =============================================================================

if (ivib_avg_amp == 0) then
  kpitch = kpitch_ramp
elseif (ivib_att == 0 && ivib_rel == 0) then
  kvib       vibrato   ivib_avg_amp * kpitch_ramp, ivib_avg_freq, ivib_rand_amp, ivib_rand_freq, 3, 5, 3, 5, ivib_fnc
  kpitch = kpitch_ramp + kvib
elseif (ivib_att == 0) then
  kvib_env   linseg    1, ivib_dec, ivib_sust, ieventdur - ivib_att - ivib_dec - ivib_rel, ivib_sust, ivib_rel, 0
  kvib       vibrato   ivib_avg_amp * kpitch_ramp, ivib_avg_freq, ivib_rand_amp, ivib_rand_freq, 3, 5, 3, 5, ivib_fnc
  kpitch = kpitch_ramp + (kvib * kvib_env)
else
  kvib_env   linseg    0, ivib_att, 1, ivib_dec, ivib_sust, ieventdur - ivib_att - ivib_dec - ivib_rel, ivib_sust, ivib_rel, 0
  kvib       vibrato   ivib_avg_amp * kpitch_ramp, ivib_avg_freq, ivib_rand_amp, ivib_rand_freq, 3, 5, 3, 5, ivib_fnc
  kpitch = kpitch_ramp + (kvib * kvib_env)
endif


; =============================================================================
; Set Synth Pitch To Sample Pitch
; =============================================================================

if (ivcdr_on != 0 && isample_pitch != 0) then
  ifftsize = 16
  iwtype = 0
  avcdr_sig     butterhp  gasamp, 50
  fsig          pvsanal   avcdr_sig, ifftsize, ifftsize/4, ifftsize, iwtype
  kfr           pvscent   fsig
  kpitch = kfr
  icps = i(kfr)
endif


; =============================================================================
; Step Sequencer
; =============================================================================

if (isequencer_on != 0) then
  ; TWISTING THE KNOBS FROM THE SCORE
  kfco           line      icutoff_start, idur, icutoff_end
  kres           line      ires_start, idur, ires_end
  kenvmod        line      ienv_attack, idur, ienv_release
  kdecay         line      idecay_start, idur, idecay_end
  kaccent        line      iaccent_start, idur, iaccent_end

  start:
    ippitch        =         ipitch
    ipitch         table     ftlen(isequence)*frac(icount/ftlen(isequence)),isequence

    if (ipitch < 0) then
      ipitch       = 1
      iempty_note  = 0
      goto noslide
    else
      ipitch         cps2pch   (ioctave + ipitch/100), iscale
      iempty_note  = 1
    endif

    if ipcount2    !=        icount2 goto noslide
    kpitch         linseg    ippitch, .06, ipitch, inotedur-.06, ipitch
    goto next

  noslide:
    kpitch         =         ipitch

  next:
    ipcount2       =         icount2
                  timout    0, inotedur, contin
    icount         =         icount + 1
                  reinit    start
                  rireturn

  contin:
    iacc           table     ftlen(iacc_sequence)*frac((icount-1)/ftlen(iacc_sequence)), iacc_sequence
    if iacc == 0   goto noaccent
    ienvdecay      =         0                                            ; accented notes are the shortest ones
    iremacc        =         i(kaccurve)
    kaccurve       oscil1i   0, 1, .4, iaccent_curve
    kaccurve       =         kaccurve+iremacc                             ; successive accents cause hysterical raising cutoff
    goto sequencer

  noaccent:
    kaccurve       =         0                                            ; no accent & "discharges" accent curve
    ienvdecay      =         i(kdecay)
    sequencer:
    aremovedc      init      0                                            ; set feedback to 0 at every event
    imult          table     ftlen(idurations)*frac(icount2/ftlen(idurations)),idurations
    if imult       !=        0 goto noproblemo                            ; compensate for zero padding in the sequencer
    icount2        =         icount2 + 1
    goto sequencer

  noproblemo:
    ieventdur      =         inotedur*imult

    ; TWO ENVELOPES
    kmeg           expseg    1, imindecay+((ieventdur-imindecay)*ienvdecay),ienvdecay+.000001
    kveg           linen     1, .01, ieventdur, .016                      ; attack should be 4 ms. but there would be clicks...

    ; AMPLITUDE ENVELOPE
    iattack  = ieventdur * iattack_val
    irelease = ieventdur * irelease_val


    if (idecay < 0) then
      if (iattack_val <= 0) then
        kadsr expseg  1, ieventdur - irelease, 1, irelease, 0.0001
      else
        kadsr expseg  0.0001, iattack, 1, ieventdur - iattack - irelease, 1, irelease, 0.0001
      endif
    else
      if (iattack_val <= 0) then
        kadsr linseg  1, ieventdur - irelease, 1, irelease, 0
      else
        kadsr linseg  0, iattack, 1, ieventdur - iattack - irelease, 1, irelease, 0
      endif
    endif

    kamp           =         kveg*((1-i(kenvmod)) + kmeg*i(kenvmod)*(.5+.5*iacc*kaccent))
    kamp           =         kamp * iamp * kadsr

    ; FILTER ENVELOPE
    ksweep         =         kveg * (imaxfreq + (.75*kmeg+.25*kaccurve*kaccent)*kenvmod*(imaxsweep-imaxfreq))
    kfco           =         20 + kfco * ksweep                           ; cutoff always greater than 20 Hz ...
    kfco           =         (kfco > sr/2 ? sr/2 : kfco)                  ; could be necessary
                  timout    0, ieventdur, out
    icount2        =         icount2 + 1
                  reinit    contin

  out:
else
  kamp = k(iamp)
endif


; =============================================================================
; Synth Modes
; =============================================================================


if (isynth_type == 0) then
  aosc1    oscil kamp, kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_1, iosc_phase_1
  aosc2    oscil kamp, kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_2, iosc_phase_2
  aosc3    oscil kamp, kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_3, iosc_phase_3
  aosc4    oscil kamp, kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_4, iosc_phase_4
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 1) then
  kharmon  linseg  iharmon_start, iharmon_dur, iharmon_end
  aosc1    buzz  kamp, kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aosc2    buzz  kamp, kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aosc3    buzz  kamp, kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aosc4    buzz  kamp, kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.5
elseif (isynth_type == 2) then
  aosc1    vco2  kamp, kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_1, ivco_pw, iosc_phase_1, ivco_nyx
  aosc2    vco2  kamp, kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_2, ivco_pw, iosc_phase_2, ivco_nyx
  aosc3    vco2  kamp, kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_3, ivco_pw, iosc_phase_3, ivco_nyx
  aosc4    vco2  kamp, kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_4, ivco_pw, iosc_phase_4, ivco_nyx
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 3) then
  fsig1    pvsosc  kamp, kpitch + (birnd(ipch_rand) * kpitch), ipvs_type1, 1024
  fsig2    pvsosc  kamp, kpitch + (birnd(ipch_rand) * kpitch), ipvs_type2, 1024
  fsig3    pvsosc  kamp, kpitch + (birnd(ipch_rand) * kpitch), ipvs_type3, 1024
  fsig4    pvsosc  kamp, kpitch + (birnd(ipch_rand) * kpitch), ipvs_type4, 1024
  aosc1    pvsynth fsig1
  aosc2    pvsynth fsig2
  aosc3    pvsynth fsig3
  aosc4    pvsynth fsig4
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * .5
elseif (isynth_type == 4) then
  ktone    linseg ihsb_tone_start, ieventdur, ihsb_tone_end
  aosc1    hsboscil kamp, ktone, ibrite_1, icps_1, isynth_fnc_1, 18, ihsb_oct_count
  aosc2    hsboscil kamp, ktone, ibrite_2, icps_1, isynth_fnc_2, 18, ihsb_oct_count
  aosc3    hsboscil kamp, ktone, ibrite_3, icps_1, isynth_fnc_3, 18, ihsb_oct_count
  aosc4    hsboscil kamp, ktone, ibrite_4, icps_1, isynth_fnc_4, 18, ihsb_oct_count
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
  if (iempty_note == 0) then
    aoscs = aoscs * 0
  endif
elseif (isynth_type == 5) then    ; FM
  kfm_idx  linseg ifm_idx_start, ieventdur, ifm_idx_end
  kfm_car  linseg ifm_car_start, ieventdur, ifm_car_end
  aosc1    foscil  kamp, kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_1
  aosc2    foscil  kamp, kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_2
  aosc3    foscil  kamp, kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_3
  aosc4    foscil  kamp, kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_4
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 6) then    ; Additive
  loop:
    kspeed  pow kindex + 1, 1.6
    kphas phasorbnk kspeed * 0.7, kindex, iadditive_cnt
    klfo table kphas, iadditive_func, 1
    kdepth pow 1.4, kindex
    kfreq pow kindex + 1, 1.5
    kfreq = kfreq + klfo*0.006*kdepth

    tablew kfreq, kindex, giadditive_freqs

    kspeed  pow kindex + 1, 0.8
    kphas phasorbnk kspeed*0.13, kindex, iadditive_cnt, 2
    klfo table kphas, iadditive_func, 1
    kamp_fnc pow 1 / (kindex + 1), 0.4
    kamp_fnc = kamp_fnc * (0.3+0.35*(klfo+1))

    tablew kamp_fnc, kindex, giadditive_amps

    kindex = kindex + 1
    if (kindex < iadditive_cnt) kgoto loop

    aoscs adsynt kamp, kpitch, iadditive_func, giadditive_freqs, giadditive_amps, iadditive_cnt
    aoscs = aoscs * .6
elseif (isynth_type == 7) then    ; FOF
  iadded_hz = (ipitch > 0 ? ipitch : 0)

  ; First formant.
  k1amp = kamp
  k1form line ifof_form_start + iadded_hz, ieventdur, ifof_form_end + iadded_hz
  k1band line 100, ieventdur, 80
  ; Second formant.
  k2amp line iamp * 0.8, ieventdur, iamp * 0.6
  k2form = k1form * 3.3197
  k2band = k1band * 3.2124
  ; Third formant.
  k3amp line iamp * 0.06, ieventdur, iamp * 0.04
  k3form = k1form * 6
  k3band = k1band * 6
  ; Fourth formant.
  k4amp = kamp * 0.025
  k4form = k1form * 8
  k4band = k1band * 8
  ; Fifth formant.
  k5amp = kamp * 0.015
  k5form init 4950
  k5band line 140, ieventdur, 200
  ; Sixth formant.
  k6amp = kamp * 0.005
  k6form init 7006
  k6band line 160, ieventdur, 220

  afof1 fof k1amp, icps_1, k1form, 0, k1band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, ieventdur
  afof2 fof k2amp, icps_1, k2form, 0, k2band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, ieventdur
  afof3 fof k3amp, icps_1, k3form, 0, k3band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, ieventdur
  afof4 fof k4amp, icps_1, k4form, 0, k4band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, ieventdur
  afof5 fof k5amp, icps_1, k5form, 0, k5band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, ieventdur
  afof6 fof k6amp, icps_1, k6form, 0, k6band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, ieventdur

  aoscs = (afof1 + afof2 + afof3 + afof4 + afof5 + afof6)
  if (iempty_note == 0) then
    aoscs = aoscs * 0
  endif
else
  aoscs    fractalnoise  iamp, 0
  if (iempty_note == 0) then
    aoscs = aoscs * 0
  endif
endif


; =============================================================================
; Vocoder
; =============================================================================

if (ivcdr_on != 0) then
  kratio = 3
  avcdr_sig   compress  gasamp, gasamp, 0, 48, 60, kratio, .1, .5, .02
  avcdr_sig   balance   avcdr_sig, aoscs
  aoscs       Vocoder   aoscs, avcdr_sig, ivcdr_min, ivcdr_max, ivcdr_q, ivcdr_band, ivcdr_cnt

  if (iempty_note == 0) then
    aoscs = aoscs * 0
  endif
endif


; =============================================================================
; Lowpass Filters
; =============================================================================

if (ilowpass_on == 0) then
  a1 = aoscs
else
  imin_cutoff = 50
  imin_res    = 0.001

  if (ilowpass_on != 0 && ilp_cut_att == 0) then
    klp_cut linseg   ilp_cut, ilp_cut_dec, ilp_cut_sust, ieventdur - ilp_cut_dec - ilp_cut_rel, ilp_cut_sust, ilp_cut_rel, imin_cutoff
  elseif (ilowpass_on != 0 && ilp_cut_att != 0) then
    klp_cut linseg   imin_cutoff, ilp_cut_att, ilp_cut, ilp_cut_dec, ilp_cut_sust, ieventdur - ilp_cut_att - ilp_cut_dec - ilp_cut_rel, ilp_cut_sust, ilp_cut_rel, imin_cutoff
  endif

  if (ilowpass_on != 0 && ilp_res_att == 0) then
    klp_res linseg   ilp_res, ilp_res_dec, ilp_res_sust, ieventdur - ilp_res_dec - ilp_res_rel, ilp_res_sust, ilp_res_rel, imin_res
  elseif (ilowpass_on != 0 && ilp_res_att != 0) then
    klp_res linseg   imin_res, ilp_res_att, ilp_res, ilp_res_dec, ilp_res_sust, ieventdur - ilp_res_att - ilp_res_dec - ilp_res_rel, ilp_res_sust, ilp_res_rel, imin_res
  endif
endif


if (ilowpass_on == 1) then
  a1      lpf18     aoscs, klp_cut, klp_res, ilp_dist
  a1 = a1 * 1.3
elseif (ilowpass_on == 2) then
  a1      moogladder     aoscs, klp_cut, klp_res
  a1 = a1 * 1.9
elseif (ilowpass_on == 3) then
  a1      moogvcf2   aoscs, klp_cut, klp_res
  a1 = a1 * 1.9
elseif (ilowpass_on == 4) then
  a1      mvclpf3    aoscs, klp_cut, klp_res
  a1 = a1 * 1.9
elseif (ilowpass_on == 5) then
  a1      K35_lpf    aoscs, klp_cut, klp_q
elseif (ilowpass_on == 6) then
  a1      butterlp   aoscs, klp_cut
elseif (ilowpass_on == 7) then
  a1      tonex     aoscs, klp_cut, ilp_stack
elseif (ilowpass_on >= 8) then
  a1      diode_ladder aoscs, klp_cut, ilp_fb
  a1 = a1 * 2.5
endif


; RESONANT 4-POLE LPF for sequencer
if (isequencer_on != 0) then
  if (icutoff_start == 1 && icutoff_end == 1) then
    a1          atone     a1,   10
  else
    kseq_env    linseg    0, 0.01, 1, ieventdur - 0.02, 1, 0.01, 0
    ainpt       =         a1 - aremovedc*kres*ireson
    alpf        tone      ainpt,kfco
    alpf        tone      alpf,kfco
    alpf        tone      alpf,kfco
    alpf        tone      alpf,kfco
    a1          atone     alpf, 10
  endif
endif


; =============================================================================
; Highpass Filters
; =============================================================================

if (ihighpass_on != 0 && ihp_cut_att == 0) then
  khp_cut linseg   ihp_cut, ihp_cut_dec, ihp_cut_sust, ieventdur - ihp_cut_dec - ihp_cut_rel, ihp_cut_sust, ihp_cut_rel, 10
elseif (ihighpass_on != 0 && ihp_cut_att != 0) then
  khp_cut linseg   10, ihp_cut_att, ihp_cut, ihp_cut_dec, ihp_cut_sust, ieventdur - ihp_cut_att - ihp_cut_dec - ihp_cut_rel, ihp_cut_sust, ihp_cut_rel, 10
endif

if (ihighpass_on == 1) then
  a1      butterhp  a1, khp_cut
elseif (ihighpass_on == 2) then
  a1      mvchpf    a1, khp_cut
elseif (ihighpass_on == 3) then
  a1      K35_hpf   a1, khp_cut, ihp_q
endif


; =============================================================================
; Distortion
; =============================================================================

if (idist_on == 1) then
  if (idist_att == 0) then
    kdist   linseg   idist, idist_dec, idist_sust, ieventdur - idist_dec - idist_rel, idist_sust, idist_rel, 0
  else
    kdist   linseg   0, idist_att, idist, idist_dec, idist_sust, ieventdur - idist_att - idist_dec - idist_rel, idist_sust, idist_rel, 0
  endif

  a1      distort   a1, kdist, idist_fnc
endif


; =============================================================================
; Bitcrusher
; =============================================================================

if (idec_on == 1) then
  kbit	   ctrl7	1, 1, 1, 16
  ksrate   ctrl7	1, 7, 11025, 44100

  kbits    = idec_bitrate^kbit
  kfold    = (idec_samps/ksrate)
  kin      downsamp  a1
  kin      = (kin + 1)
  kin      = kin*(kbits / 2)
  kin      = int(kin)
  a1       upsamp  kin
  a1       = a1 * (2/kbits) - 1

  a1      fold  a1, kfold
elseif (idec_on == 2) then
  kfold   linseg  ifold_start, ieventdur, ifold_end
  a1      fold  a1, kfold
endif


; =============================================================================
; Flanger
; =============================================================================

if (iflange_on == 1) then
  if (iflange_att == 0) then
    aflange   linseg   iflange, iflange_dec, iflange_sust, idur - iflange_dec - iflange_rel, iflange_sust, iflange_rel, 0
  else
    aflange   linseg   0, iflange_att, iflange, iflange_dec, iflange_sust, idur - iflange_att - iflange_dec - iflange_rel, iflange_sust, iflange_rel, 0
  endif

  a1       flanger   a1, aflange, iflange_fb
endif


; =============================================================================
; Phaser
; =============================================================================

if (iphase_on == 1) then
  if (iphase_att == 0) then
    kphase   linseg   iphase, iphase_dec, iphase_sust, idur - iphase_dec - iphase_rel, iphase_sust, iphase_rel, 0
  else
    kphase   linseg   0, iphase_att, iphase, iphase_dec, iphase_sust, idur - iphase_att - iphase_dec - iphase_rel, iphase_sust, iphase_rel, 0
  endif

  a1      phaser1   a1, kphase, 100, iphase_fb
endif


; =============================================================================
; Tremolo
; =============================================================================

if (ilfo_start == 0) then
  alfo = 0
else
  klfo_ramp  linseg      ilfo_start, ieventdur, ilfo_end
  if (ilfo_att == 0) then
    klfo_env   linseg      1, ilfo_dec, ilfo_sust, ieventdur - ilfo_dec - ilfo_rel, ilfo_sust, ilfo_rel, 0
  else
    klfo_env   linseg      0, ilfo_att, 1, ilfo_dec, ilfo_sust, ieventdur - ilfo_att - ilfo_dec - ilfo_rel, ilfo_sust, ilfo_rel, 0
  endif
  alfo       lfo       klfo_env, klfo_ramp, ilfo_shape
endif


; =============================================================================
; Envelope
; =============================================================================

afadeout  linseg    1, ieventdur - 0.001, 1, 0.001, 0

if (isequencer_on == 0 && idecay < 0) then
  if (iattack_val <= 0) then
    aadsr expseg  1, ieventdur - irelease, 1, irelease, 0.0001
  else
    aadsr expseg  0.0001, iattack, 1, ieventdur - iattack - irelease, 1, irelease, 0.0001
  endif

  afinal = aadsr * afadeout * (1 - alfo) * a1
elseif (isequencer_on == 0) then
  iremaining_time = ieventdur - iattack - idecay

  if ((iattack + idecay) >= ieventdur ) then
    idecay = ieventdur - iattack
    irelease = 0
  elseif (iremaining_time < irelease) then
    irelease = iremaining_time
  endif

  if ((iattack <= 0 && idecay <= 0) && irelease <= 0) then
    aadsr = 1
  elseif (iattack <= 0 && irelease <= 0) then
    aadsr   linseg  1, idecay, isustain_vol
  elseif (iattack <= 0 && idecay <= 0) then
    aadsr   linseg  1, ieventdur - irelease, 1, irelease, 0
  elseif (iattack <= 0) then
    aadsr   linseg  1, idecay, isustain_vol, ieventdur - idecay - irelease, isustain_vol, irelease, 0
  else
    aadsr   adsr    iattack, idecay, isustain_vol, irelease
  endif

  afinal = aadsr * afadeout * (1 - alfo) * a1
else
  afinal = afadeout * (1 - alfo) * a1
endif


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

; =============================================================================

</CsInstruments>
<CsScore>


; =============================================================================
; =============================================================================
; P fields
; =============================================================================
; =============================================================================

; INSTRUMENT
;p1  instr
;p2  start time
;p3  duration
;p4  amplitude    range 0 - 1+
;p5  pan start    range 0 - 1
;p6  pan end      range 0 - 1
;p7  pan duration
;p8  pan freq for lfo in hz, lfo off = 0
;p9  pad mode for lfo,       sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5
;p10 synth type   range 0 - 8

; SEQUENCER
;p11 sequencer on = 1, off = 0
;p12 sequence f-table function
;p13 durations f-table function
;p14 accents f-table function
;p15 lpf cutoff start     range 0-1
;p16 lpf cutoff end       range 0-1
;p17 resonance start      range 0-1
;p18 resonance end        range 0-1
;p19 env attack           range 0-1
;p20 env release          range 0-1
;p21 BPM
;p22 sequence speed       1 = normal, 2 = double time, etc.

; PITCH
;p23 pitch value 1, in octave point decimal
;p24 pitch value 2
;p25 pitch value 3
;p26 pitch value 4
;p27 pitch duration 1 (between pitch value 1 and 2)
;p28 pitch duration 2
;p29 pitch duration 3
;p30 pitch envelope ramp type, 0 = linear, 1 = exponential
;p31 pitch randomness, range 0 - 1
;p32 number of octave divisions for scale
;p33 pitch fraction, off = 0
;    Ex with C root:
;    C       C#      D-      D       Eb-      Eb       E       F      F#-
;    1/1     25/24   10/9    9/8     32/27    6/5      5/4     4/3    25/18
;
;    F#      G       G#      A       Bb-      Bb       B       C
;    45/32   3/2     25/16   5/3     16/9     9/5      15/8    2/1


; VIBRATO
;p34 average amplitude value of vibrato
;p35 average frequency value of vibrato (in cps)
;p36 amount of random amplitude deviation
;p37 amount of random frequency deviation
;p38 vibrato attack
;p39 vibrato decay
;p40 vibrato sustain
;p41 vibrato release
;p42 f-table function for vibrato shape

; SYNTH OSC FUNCTIONS - for synth types 0, 4, 5
;p43 synth function 1
;p44 synth function 2
;p45 synth function 3
;p46 synth function 4

; SYNTH OSC PHASE - for synth types 0, 2
;p47 osc phase 1, range 0 - 1
;p48 osc phase 2
;p49 osc phase 3
;p50 osc phase 4

; HARMONICS - for synth type 1
;p51 number of harmonics start
;p52 number of harmonics end
;p53 number of harmonics duration

; VCO - for synth type 2
;p54 vco mode 1: 12 = tri, 10 = square, 8 = integrated saw, 6 = pulse, 4 = saw/tri/ramp, 2 = square/PWM, 0 = saw
;p55 vco mode 2
;p56 vco mode 3
;p57 vco mode 4
;p58 pulse width of square wave, range 0 - 1
;p59 bandwidth of waveform, range 0 - 1, default 0.5

; PVS SYNTH - for synth type 3
;p60 pvs type 1: 1 = saw, 2 = square, 3 = pulse, 4 = cosine
;p61 pvs type 2
;p62 pvs type 3
;p63 pvs type 4

; HSB SYNTH - for synth type 4
;p64 octave count, range 2 - 10
;p65 tone start, range 0 - 1
;p66 tone end
;p67 brightness 1: 1 is octiave above 0, -1 is octave below, etc
;p68 brightness 2
;p69 brightness 3
;p70 brightness 4

; FM SYNTH - for synth type 5
;p71 fm index start value, range 0+
;p72 fm index end
;p73 fm mod start. gives modulating freq when multiplied by the carrier freq
;p74 fm mod end
; ADDITIVE SYNTH - for synth type 6
;p75 additive osc count, range 1 - 30
;p76 additive osc wave function

; FOF SYNTH - for synth type 7
;p77 fof osc function 1
;p78 fof osc function 2, preferably linear or sinusoid
;p79 fof formant freq start, in hz
;p80 fof formant freq end

; VOCODER
;p81 Vocoder on = 1, off = 0
;p82 sample pitch
;p83 vocoder max freq
;p84 vocoder min freq
;p85 vocoder Q:  range 5+
;p86 vocoder band:  range 5+
;p87 vocoder count:  range 1+

; LOWPASS FILTERS
;p88 lowpass type, off = 0
;p89 lp distortion, for lp type 1    range 0 - 1+
;p90 lp feedback, for lp type 8      range 0 - 17
;p91 lp q, for lp type 5             range 1 - 10
;p92 lp stack, for lp type 7         range 1+

;p93  lp cutoff freq in hz
;p94  lp cutoff attack time
;p95  lp cutoff decline time
;p96  lp cutoff sustain freq in hz
;p97  lp cutoff release time
;p98  lp resonance value,   range 0 - 1
;p99  lp resonance attack time
;p100 lp resonance decline time
;p101 lp resonance sustain value, range 0 - 1
;p102 lp resonance release time

; HIGHPASS FILTERS
;p103 hp type, off = 0
;p104 hp cutoff freq in hz
;p105 hp cutoff attack time
;p106 hp cutoff decline time
;p107 hp cutoff sustain freq in hz
;p108 hp cutoff release time
;p109 hp cutoff q, for hp type 3     range 1 - 10

; DISTORTION
;p110 distortion on = 1, off = 0
;p111 distortion value,    range 0 - 1
;p112 distortion attack time
;p113 distortiom decline time
;p114 distortion sustain value,   range 0 - 1
;p115 distortion release time
;p116 distortion shape function

; BITCRUSHER
;p117 bitcrusher type, off = 0
;p118 decimator bitrate, range 1 - 32
;p119 decimator samples
;p120 fold start value, amount of foldover expressed in multiple of sampling rate. range 1+
;p121 fold end value

; FLANGER
;p122 flanger on = 1, off = 0
;p123 flanger delay time value
;p124 flanger delay attack time
;p125 flanger delay decline time
;p126 flanger delay time sustain value
;p127 flanger release time
;p128 flanger feedback, range 0 - 1

; PHASER
;p129 phaser on = 1, off = 0
;p130 phaser freq in hz
;p131 phaser attack time
;p132 phaser decline time
;p133 phaser sustain freq in hz
;p134 phaser release time
;p135 phaser feedback, range -1 - 1

; LFO / TREMOLO
;p136 lfo start freq in hz, off = 0
;p137 lfo end freq in hz
;p138 lfo shape,  sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5
;p139 lfo attack time
;p140 lfo decline time
;p141 lfo sustain amplitude
;p142 lfo release time

; AMPLITUDE ENVELOPE
;p143 adsr attack time
;p144 adsr decay value          expon env if value < 0
;p145 adsr sustain volume, range 0 - 1
;p146 adsr release time

; FEEDBACK
;p147 feedback on = 1, off = 0
;p148 fb freq 1 in Hz
;p149 fb freq 2 in Hz
;p150 fb level 1,     range 0-2
;p151 fb level 2,     range 0-2
;p152 fb level 3,     range 0-2
;p153 fb time 1,      percentage of idur
;p154 fb time 2,      percentage of idur
;p155 fold level      range 1+, 0 = off


; =============================================================================
; =============================================================================
; Score
; =============================================================================
; =============================================================================

t 0 85

i"samp"     0      16

i"msynth"   0      16     .8      .5      .5      [1/2]  0     0    2           ; Instrument
1     601   701    751    1       1       .6      .1     .3    .1   85    1     ; Sequencer
6.00        0      6.02   5.08    [1/10]  [3/10]  [6/10] 0     0    12    [0]   ; Pitch
0           8      0      0       [1/2]   [1/4]   3      [0]   1                ; vibrato
3           3      26     26                                                    ; Osc functions
0           0      0      0                                                     ; Osc phase
4           28     [1/2]                                                        ; Harmonics
12          12     10     10      0.8     0.5                                   ; VCO
2           2      2      2                                                     ; PVS osc types
5           0      1      0       0       1       2                             ; HBSoscil
0           20     2.03   2.03    25      10                                    ; FM / Additive
6           19     400    100                                                   ; FOF
0           0      9000   100     10      50      2                             ; Vocoder
1           0.25   15     9.0     20                                            ; lowpass settings
            6000   [1/32] [3/4]   600     [0]     0.5    [0]   [1/4] 0.8  [1/2] ; lowpass cutoff / res
0           5000   [1/4]  [1/2]   500     [1/4]   9.5                           ; highpass
0           1      [1/32] [1/2]   .2      [1/4]   1                             ; distortion
0           16     20     30      5                                             ; bitcrusher
0           0.8    [1/4]  [1/2]   .3      [1/4]   .5                            ; flanger
0           5000   [1/4]  [1/2]   100     [1/4]   0.8                           ; phaser
0           8      0      [1/4]   [1/2]   1       [1/4]                         ; tremolo / amp lfo
[0]        [0]     1      [7/8]                                                 ; adsr
0           150    150    1       1      .5      .5     .5    0                 ; Feedback

e

</CsScore>
</CsoundSynthesizer>
