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


; =============================================================================
; F tables
; =============================================================================

gisine     ftgen 1,  0, 16384, 10, 1	;sine wave
gisquare   ftgen 2,  0, 16384, 10, 1, 0 , .33, 0, .2 , 0, .14, 0 , .11, 0, .09 ;odd harmonics
gisaw      ftgen 3,  0, 16384, 10, 0, .2, 0, .4, 0, .6, 0, .8, 0, 1, 0, .8, 0, .6, 0, .4, 0,.2 ;even harmonics
gihanning  ftgen 4,  0, 8192,  20, 2, 1  ;Hanning function
gisigmoid  ftgen 5,  0, 1024,  19, .5, .5, 270, .5    ; Sigmoid
gisquare2  ftgen 6,  0, 16384, 10, 1, 0, 0.3, 0, 0.2, 0, 0.14, 0, .111 ; Square wave
gisaw2     ftgen 7,  0, 16384, 10, 1, 0.5, 0.3, 0.25, 0.2, 0.167, 0.14, 0.125, .111 ; Saw
gipulse    ftgen 8,  0, 16384, 10, 1, 1, 1, 1, 0.7, 0.5, 0.3, 0.1
ginoise    ftgen 9,  0, 2^10,9, 1,2,0, 3,2,0, 9,0.333,180
giadd1     ftgen 10, 0, 16384, 11, 1, 1
giadd2     ftgen 11, 0, 16384, 11, 10, 1, .7
giadd3     ftgen 12, 0, 16384, 11, 10, 5, 2
gicubic1   ftgen 13, 0, 513, 6, 1, 128, -1, 128, 1, 64, -.5, 64, .5, 16, -.5, 8, 1, 16, -.5, 8, 1, 16, -.5, 84, 1, 16, -.5, 8, .1, 16, -.1, 17, 0
gicubic2   ftgen 14, 0, 513, 6, 0, 128, 0.5, 128, 1, 128, 0, 129, -1
giexpon1   ftgen 15, 0, 129, 5, 1, 100, 0.0001, 29
giexpon2   ftgen 16, 0, 129, 5, 0.00001, 87, 1, 22, .5, 20, 0.0001
gidist     ftgen 17, 0, 257, 9, .5,1,270
gioctblend ftgen 18, 0, 1024, -19, 1, 0.5, 270, 0.5
gifof1     ftgen 19, 0, 1024, 19, 0.5, 0.5, 270, 0.5    ; Sigmoid for FOF
gifof2     ftgen 20, 0, 1024, 7, 0, 512, 1, 0, -1, 512, 0  ; for FOF


giadditive_freqs ftgen 999, 0, 32, 7, 0, 32, 0
giadditive_amps ftgen 998, 0, 32, 7, 0, 32, 0


; =============================================================================
; UDOs
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
  ao balance as, an

  amix = ao + abnd
  xout amix
endop

; =============================================================================
; SYNTH_1
; =============================================================================

instr synth_1

kindex = 0

idur          = p3
iamp          = p4
ipan_start    = p5
ipan_end      = p6
ipan_dur      = p7 * idur
ipan_freq     = p8
ipan_mode     = p9
isynth_type   = p10

ipch_1        = p11
ipch_2        = p12
ipch_3        = p13
ipch_4        = p14
ipch_dur_1    = p15 * idur
ipch_dur_2    = p16 * idur
ipch_dur_3    = p17 * idur
ipch_ramp     = p18
ipch_rand     = p19
iscale        = p20
ipch_fract    = p21

ivib_avg_amp  = p22
ivib_avg_freq = p23
ivib_rand_amp = p24
ivib_rand_freq= p25
ivib_att      = p26 * idur
ivib_dec      = p27 * idur
ivib_sust     = p28
ivib_rel      = p29 * idur
ivib_fnc      = p30

isynth_fnc_1  = p31
isynth_fnc_2  = p32
isynth_fnc_3  = p33
isynth_fnc_4  = p34

iosc_phase_1  = p35
iosc_phase_2  = p36
iosc_phase_3  = p37
iosc_phase_4  = p38

iharmon_start = p39
iharmon_end   = p40
iharmon_dur   = p41 * idur

ivco_mode_1   = p42
ivco_mode_2   = p43
ivco_mode_3   = p44
ivco_mode_4   = p45
ivco_pw       = p46
ivco_nyx      = p47

ipvs_type1    = p48
ipvs_type2    = p49
ipvs_type3    = p50
ipvs_type4    = p51

ihsb_oct_count = p52
ihsb_tone_start= p53
ihsb_tone_end  = p54
ibrite_1       = p55
ibrite_2       = p56
ibrite_3       = p57
ibrite_4       = p58

ifm_idx_start  = p59
ifm_idx_end    = p60
ifm_car_start  = p61
ifm_car_end    = p62
iadditive_cnt  = p63
iadditive_func = p64

ifof_fnc_1      = p65
ifof_fnc_2      = p66
ifof_form_start = p67
ifof_form_end   = p68

ivcdr_on         = p69
isample          = p70
isample_pitch    = p71
isample_stretch  = p72
isample_skiptime = p73 / isample_stretch
ivcdr_max        = p74
ivcdr_min        = p75
ivcdr_q          = p76
ivcdr_band       = p77
ivcdr_cnt        = p78

ilowpass_on   = p79
ilp_dist      = p80
ilp_fb        = p81
klp_q         = p82
ilp_stack     = p83

ilp_cut       = p84
ilp_cut_att   = p85 * idur
ilp_cut_dec   = p86 * idur
ilp_cut_sust  = p87
ilp_cut_rel   = p88 * idur
ilp_res       = p89
ilp_res_att   = p90 * idur
ilp_res_dec   = p91 * idur
ilp_res_sust  = p92
ilp_res_rel   = p93 * idur

ihighpass_on  = p94
ihp_cut       = p95
ihp_cut_att   = p96 * idur
ihp_cut_dec   = p97 * idur
ihp_cut_sust  = p98
ihp_cut_rel   = p99 * idur
ihp_q         = p100

idist_on      = p101
idist         = p102
idist_att     = p103 * idur
idist_dec     = p104 * idur
idist_sust    = p105
idist_rel     = p106 * idur
idist_fnc     = p107

idec_on       = p108
idec_bitrate  = p109
idec_samps    = p110
ifold_start   = p111
ifold_end     = p112

iflange_on    = p113
iflange       = p114
iflange_att   = p115 * idur
iflange_dec   = p116 * idur
iflange_sust  = p117
iflange_rel   = p118 * idur
iflange_fb    = p119

iphase_on     = p120
iphase        = p121
iphase_att    = p122 * idur
iphase_dec    = p123 * idur
iphase_sust   = p124
iphase_rel    = p125 * idur
iphase_fb     = p126

ilfo_start    = p127
ilfo_end      = p128
ilfo_shape    = p129
ilfo_att      = p130 * idur
ilfo_dec      = p131 * idur
ilfo_sust     = p132
ilfo_rel      = p133 * idur

iattack       = p134 * idur
idecay        = p135 * idur
isustain_vol  = p136
irelease      = p137 * idur

icomp_ratio   = p138
icomp_thresh  = p139
icomp_loknee  = p140
icomp_hiknee  = p141
icomp_att     = p142
icomp_rel     = p143
icomp_look    = p144

ieq_on        = p145
ieq_freq      = p146
ieq_gain      = ampdb(p147)
ieq_q         = p148
ieq_mode      = p149

icps_1   cps2pch  ipch_1, iscale
icps_2   cps2pch  ipch_2, iscale
icps_3   cps2pch  ipch_3, iscale
icps_4   cps2pch  ipch_4, iscale


; =============================================================================
; Vocoder Samples
; =============================================================================

if (ivcdr_on != 0) then
  i101 ftgenonce 0, 0, 524288, 1, "samples/hellorcb.aif", isample_skiptime, 0, 1
  i102 ftgenonce 0, 0, 524288, 1, "samples/amen.wav",     isample_skiptime, 0, 1
  ; Add other samples here

  if (isample == 101) then
    isample = i101
  elseif (isample == 102) then
    isample = i102
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
  kvib_env   linseg    1, ivib_dec, ivib_sust, idur - ivib_att - ivib_dec - ivib_rel, ivib_sust, ivib_rel, 0
  kvib       vibrato   ivib_avg_amp * kpitch_ramp, ivib_avg_freq, ivib_rand_amp, ivib_rand_freq, 3, 5, 3, 5, ivib_fnc
  kpitch = kpitch_ramp + (kvib * kvib_env)
else
  kvib_env   linseg    0, ivib_att, 1, ivib_dec, ivib_sust, idur - ivib_att - ivib_dec - ivib_rel, ivib_sust, ivib_rel, 0
  kvib       vibrato   ivib_avg_amp * kpitch_ramp, ivib_avg_freq, ivib_rand_amp, ivib_rand_freq, 3, 5, 3, 5, ivib_fnc
  kpitch = kpitch_ramp + (kvib * kvib_env)
endif

; =============================================================================
; Sample Pitch
; =============================================================================

if (ivcdr_on != 0 && isample_pitch != 0) then
  ifftsize = 16
  iwtype = 0
  avcdr_sig     paulstretch isample_stretch, 0.02, isample
  avcdr_sig     butterhp  avcdr_sig, 50
  fsig          pvsanal   avcdr_sig, ifftsize, ifftsize/4, ifftsize, iwtype
  kfr           pvscent   fsig
  kpitch = kfr
  icps = i(kfr)
endif

; =============================================================================
; Synth Modes
; =============================================================================

if (isynth_type == 0) then
  aosc1    oscil iamp, kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_1, iosc_phase_1
  aosc2    oscil iamp, kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_2, iosc_phase_2
  aosc3    oscil iamp, kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_3, iosc_phase_3
  aosc4    oscil iamp, kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_4, iosc_phase_4
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 1) then
  kharmon  linseg  iharmon_start, iharmon_dur, iharmon_end
  aosc1    buzz  iamp, kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aosc2    buzz  iamp, kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aosc3    buzz  iamp, kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aosc4    buzz  iamp, kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 2) then
  aosc1    vco2  iamp, kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_1, ivco_pw, iosc_phase_1, ivco_nyx
  aosc2    vco2  iamp, kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_2, ivco_pw, iosc_phase_2, ivco_nyx
  aosc3    vco2  iamp, kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_3, ivco_pw, iosc_phase_3, ivco_nyx
  aosc4    vco2  iamp, kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_4, ivco_pw, iosc_phase_4, ivco_nyx
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 3) then
  fsig1    pvsosc  iamp, kpitch + (birnd(ipch_rand) * kpitch), ipvs_type1, 1024
  fsig2    pvsosc  iamp, kpitch + (birnd(ipch_rand) * kpitch), ipvs_type2, 1024
  fsig3    pvsosc  iamp, kpitch + (birnd(ipch_rand) * kpitch), ipvs_type3, 1024
  fsig4    pvsosc  iamp, kpitch + (birnd(ipch_rand) * kpitch), ipvs_type4, 1024
  aosc1    pvsynth fsig1
  aosc2    pvsynth fsig2
  aosc3    pvsynth fsig3
  aosc4    pvsynth fsig4
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * .5
elseif (isynth_type == 4) then
  ktone    linseg ihsb_tone_start, idur, ihsb_tone_end
  aosc1    hsboscil iamp, ktone, ibrite_1, icps_1, isynth_fnc_1, 18, ihsb_oct_count
  aosc2    hsboscil iamp, ktone, ibrite_2, icps_1, isynth_fnc_2, 18, ihsb_oct_count
  aosc3    hsboscil iamp, ktone, ibrite_3, icps_1, isynth_fnc_3, 18, ihsb_oct_count
  aosc4    hsboscil iamp, ktone, ibrite_4, icps_1, isynth_fnc_4, 18, ihsb_oct_count
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 5) then    ; FM
  kfm_idx  linseg ifm_idx_start, idur, ifm_idx_end
  kfm_car  linseg ifm_car_start, idur, ifm_car_end
  aosc1    foscil  iamp, kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_1
  aosc2    foscil  iamp, kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_2
  aosc3    foscil  iamp, kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_3
  aosc4    foscil  iamp, kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_4
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

    aoscs adsynt iamp, kpitch, iadditive_func, giadditive_freqs, giadditive_amps, iadditive_cnt
elseif (isynth_type == 7) then    ; FOF
  ; First formant.
  k1amp = iamp
  k1form line ifof_form_start, idur, ifof_form_end
  k1band line 100, idur, 80
  ; Second formant.
  k2amp line iamp * 0.8, idur, iamp * 0.6
  k2form = k1form * 3.3197
  k2band = k1band * 3.2124
  ; Third formant.
  k3amp line iamp * 0.06, idur, iamp * 0.04
  k3form = k1form * 6
  k3band = k1band * 6
  ; Fourth formant.
  k4amp = iamp * 0.025
  k4form = k1form * 8
  k4band = k1band * 8
  ; Fifth formant.
  k5amp = iamp * 0.015
  k5form init 4950
  k5band line 140, idur, 200
  ; Sixth formant.
  k6amp = iamp * 0.005
  k6form init 7006
  k6band line 160, idur, 220

  afof1 fof k1amp, icps_1, k1form, 0, k1band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, idur
  afof2 fof k2amp, icps_1, k2form, 0, k2band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, idur
  afof3 fof k3amp, icps_1, k3form, 0, k3band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, idur
  afof4 fof k4amp, icps_1, k4form, 0, k4band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, idur
  afof5 fof k5amp, icps_1, k5form, 0, k5band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, idur
  afof6 fof k6amp, icps_1, k6form, 0, k6band, 0.003, \
         0.02, 0.007, 100, ifof_fnc_1, ifof_fnc_2, idur

  aoscs = (afof1 + afof2 + afof3 + afof4 + afof5 + afof6)
else
  aoscs    fractalnoise  iamp, 0
endif

; =============================================================================
; Vocoder
; =============================================================================

if (ivcdr_on != 0) then
  if (isample_pitch == 0) then
    avcdr_sig   paulstretch isample_stretch, 0.02, isample
  endif

  kratio = 3
  avcdr_sig   compress  avcdr_sig, avcdr_sig, 0, 48, 60, kratio, .1, .5, .02
  avcdr_sig   balance avcdr_sig, aoscs
  aoscs       Vocoder aoscs, avcdr_sig, ivcdr_min, ivcdr_max, ivcdr_q, ivcdr_band, ivcdr_cnt
endif

; =============================================================================
; Lowpass Filters
; =============================================================================

if (ilowpass_on == 0) then
  a1 = aoscs
else
  if (ilowpass_on != 0 && ilp_cut_att == 0) then
    klp_cut linseg   ilp_cut, ilp_cut_dec, ilp_cut_sust, idur - ilp_cut_dec - ilp_cut_rel, ilp_cut_sust, ilp_cut_rel, 10
  elseif (ilowpass_on != 0 && ilp_cut_att != 0) then
    klp_cut linseg   10, ilp_cut_att, ilp_cut, ilp_cut_dec, ilp_cut_sust, idur - ilp_cut_att - ilp_cut_dec - ilp_cut_rel, ilp_cut_sust, ilp_cut_rel, 10
  endif

  if (ilowpass_on != 0 && ilp_res_att == 0) then
    klp_res linseg   ilp_res, ilp_res_dec, ilp_res_sust, idur - ilp_res_dec - ilp_res_rel, ilp_res_sust, ilp_res_rel, 0.001
  elseif (ilowpass_on != 0 && ilp_res_att != 0) then
    klp_res linseg   0.001, ilp_res_att, ilp_res, ilp_res_dec, ilp_res_sust, idur - ilp_res_att - ilp_res_dec - ilp_res_rel, ilp_res_sust, ilp_res_rel, 0.001
  endif
endif


if (ilowpass_on == 1) then
  a1      lpf18     aoscs, klp_cut, klp_res, ilp_dist
  a1      balance a1, aoscs
elseif (ilowpass_on == 2) then
  a1      moogladder     aoscs, klp_cut, klp_res
  a1      balance a1, aoscs
elseif (ilowpass_on == 3) then
  a1      moogvcf2   aoscs, klp_cut, klp_res
  a1      balance a1, aoscs
elseif (ilowpass_on == 4) then
  a1      mvclpf3    aoscs, klp_cut, klp_res
  a1      balance a1, aoscs
elseif (ilowpass_on == 5) then
  a1      K35_lpf    aoscs, klp_cut, klp_q
  a1      balance a1, aoscs
elseif (ilowpass_on == 6) then
  a1      butterlp   aoscs, klp_cut
  a1      balance a1, aoscs
elseif (ilowpass_on == 7) then
  a1      tonex     aoscs, klp_cut, ilp_stack
  a1      balance a1, aoscs
elseif (ilowpass_on >= 8) then
  a1      diode_ladder aoscs, klp_cut, ilp_fb
  a1      balance a1, aoscs
endif


; =============================================================================
; Highpass Filters
; =============================================================================

if (ihighpass_on != 0 && ihp_cut_att == 0) then
  khp_cut linseg   ihp_cut, ihp_cut_dec, ihp_cut_sust, idur - ihp_cut_dec - ihp_cut_rel, ihp_cut_sust, ihp_cut_rel, 10
elseif (ihighpass_on != 0 && ihp_cut_att != 0) then
  khp_cut linseg   10, ihp_cut_att, ihp_cut, ihp_cut_dec, ihp_cut_sust, idur - ihp_cut_att - ihp_cut_dec - ihp_cut_rel, ihp_cut_sust, ihp_cut_rel, 10
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
    kdist   linseg   idist, idist_dec, idist_sust, idur - idist_dec - idist_rel, idist_sust, idist_rel, 0
  else
    kdist   linseg   0, idist_att, idist, idist_dec, idist_sust, idur - idist_att - idist_dec - idist_rel, idist_sust, idist_rel, 0
  endif

  atemp   = a1
  a1      distort   a1, kdist, idist_fnc
  a1      balance   a1, atemp
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
  kfold   linseg  ifold_start, idur, ifold_end
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
  klfo_ramp  linseg      ilfo_start, idur, ilfo_end
  if (ilfo_att == 0) then
    klfo_env   linseg      1, ilfo_dec, ilfo_sust, idur - ilfo_dec - ilfo_rel, ilfo_sust, ilfo_rel, 0
  else
    klfo_env   linseg      0, ilfo_att, 1, ilfo_dec, ilfo_sust, idur - ilfo_att - ilfo_dec - ilfo_rel, ilfo_sust, ilfo_rel, 0
  endif
  alfo       lfo       klfo_env, klfo_ramp, ilfo_shape
endif


; =============================================================================
; Envelope
; =============================================================================

iremaining_time = idur - iattack - idecay

if ((iattack + idecay) >= idur ) then
  idecay = idur - iattack
  irelease = 0
elseif (iremaining_time < irelease) then
  irelease = iremaining_time
endif

if ((iattack <= 0 && idecay <= 0) && irelease <= 0) then
  aadsr = 1
elseif (iattack <= 0 && irelease <= 0) then
  aadsr   linseg  1, idecay, isustain_vol
elseif (iattack <= 0 && idecay <= 0) then
  aadsr   linseg  1, idur - irelease, 1, irelease, 0
elseif (iattack <= 0) then
  aadsr   linseg  1, idecay, isustain_vol, idur - idecay - irelease, isustain_vol, irelease, 0
else
  aadsr   adsr    iattack, idecay, isustain_vol, irelease
endif

afadeout  linseg    1, idur - 0.001, 1, 0.001, 0
aenv_sig = aadsr * afadeout * (1 - alfo) * a1


; =============================================================================
; Compressor
; =============================================================================

if (icomp_ratio <= 1) then
  afinal = aenv_sig
else
  afinal    compress  aenv_sig, aenv_sig, icomp_thresh, icomp_loknee, icomp_hiknee, icomp_ratio, icomp_att, icomp_rel, icomp_look
endif

; =============================================================================
; EQ
; =============================================================================

if (ieq_on != 0) then
  afinal    pareq     afinal, ieq_freq, ieq_gain, ieq_q, ieq_mode
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
; Outputs
; =============================================================================

outs  apan_l, apan_r

endin

; =============================================================================

</CsInstruments>
<CsScore>

; =============================================================================
; P fields
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

; PITCH
;p11 pitch value 1, in octave point decimal
;p12 pitch value 2
;p13 pitch value 3
;p14 pitch value 4
;p15 pitch duration 1 (between pitch value 1 and 2)
;p16 pitch duration 2
;p17 pitch duration 3
;p18 pitch envelope ramp type, 0 = linear, 1 = exponential
;p19 pitch randomness, range 0 - 1
;p20 number of octave divisions for scale
;p21 pitch fraction, off = 0
;    Ex with C root:
;    C       C#      D-      D       Eb-      Eb       E       F      F#-
;    1/1     25/24   10/9    9/8     32/27    6/5      5/4     4/3    25/18
;
;    F#      G       G#      A       Bb-      Bb       B       C
;    45/32   3/2     25/16   5/3     16/9     9/5      15/8    2/1


; VIBRATO
;p22 average amplitude value of vibrato
;p23 average frequency value of vibrato (in cps)
;p24 amount of random amplitude deviation
;p25 amount of random frequency deviation
;p26 vibrato attack
;p27 vibrato decay
;p28 vibrato sustain
;p29 vibrato release
;p30 f-table function for vibrato shape

; SYNTH OSC FUNCTIONS - for synth types 0, 4, 5
;p31 synth function 1
;p32 synth function 2
;p33 synth function 3
;p34 synth function 4

; SYNTH OSC PHASE - for synth types 0, 2
;p35 osc phase 1, range 0 - 1
;p36 osc phase 2
;p37 osc phase 3
;p38 osc phase 4

; HARMONICS - for synth type 1
;p39 number of harmonics start
;p40 number of harmonics end
;p41 number of harmonics duration

; VCO - for synth type 2
;p42 vco mode 1: 12 = tri, 10 = square, 8 = integrated saw, 6 = pulse, 4 = saw/tri/ramp, 2 = square/PWM, 0 = saw
;p43 vco mode 2
;p44 vco mode 3
;p45 vco mode 4
;p46 pulse width of square wave, range 0 - 1
;p47 bandwidth of waveform, range 0 - 1, default 0.5

; PVS SYNTH - for synth type 3
;p48 pvs type 1: 1 = saw, 2 = square, 3 = pulse, 4 = cosine
;p49 pvs type 2
;p50 pvs type 3
;p51 pvs type 4

; HSB SYNTH - for synth type 4
;p52 octave count, range 2 - 10
;p53 tone start, range 0 - 1
;p54 tone end
;p55 brightness 1: 1 is octiave above 0, -1 is octave below, etc
;p56 brightness 2
;p57 brightness 3
;p58 brightness 4

; FM SYNTH - for synth type 5
;p59 fm index start value, range 0+
;p60 fm index end
;p61 fm mod start. gives modulating freq when multiplied by the carrier freq
;p62 fm mod end
; ADDITIVE SYNTH - for synth type 6
;p63 additive osc count, range 1 - 30
;p64 additive osc wave function

; FOF SYNTH - for synth type 7
;p65 fof osc function 1
;p66 fof osc function 2, preferably linear or sinusoid
;p67 fof formant freq start, in hz
;p68 fof formant freq end

; VOCODER
;p69 Vocoder on = 1, off = 0
;p70 sample function
;p71 sample pitch
;p72 sample stretch value:  1 = normal, 2 = half, .5 = double, etc
;p73 sample skiptime
;p74 vocoder max freq
;p75 vocoder min freq
;p76 vocoder Q:  range 5+
;p77 vocoder band:  range 5+
;p78 vocoder count:  range 1+

; LOWPASS FILTERS
;p79 lowpass type, off = 0
;p80 lp distortion, for lp type 1    range 0 - 1+
;p81 lp feedback, for lp type 8      range 0 - 17
;p82 lp q, for lp type 5             range 1 - 10
;p83 lp stack, for lp type 7         range 1+

;p84 lp cutoff freq in hz
;p85 lp cutoff attack time
;p86 lp cutoff decline time
;p87 lp cutoff sustain freq in hz
;p88 lp cutoff release time
;p89 lp resonance value,   range 0 - 1
;p90 lp resonance attack time
;p91 lp resonance decline time
;p92 lp resonance sustain value, range 0 - 1
;p93 lp resonance release time

; HIGHPASS FILTERS
;p94  hp type, off = 0
;p95  hp cutoff freq in hz
;p96  hp cutoff attack time
;p97  hp cutoff decline time
;p98  hp cutoff sustain freq in hz
;p99  hp cutoff release time
;p100 hp cutoff q, for hp type 3     range 1 - 10

; DISTORTION
;p101 distortion on = 1, off = 0
;p102 distortion value,    range 0 - 1
;p103 distortion attack time
;p104 distortiom decline time
;p105 distortion sustain value,   range 0 - 1
;p106 distortion release time
;p107 distortion shape function

; BITCRUSHER
;p108  bitcrusher type, off = 0
;p109  decimator bitrate, range 1 - 32
;p110  decimator samples
;p111 fold start value, amount of foldover expressed in multiple of sampling rate. range 1+
;p112 fold end value

; FLANGER
;p113 flanger on = 1, off = 0
;p114 flanger delay time value
;p115 flanger delay attack time
;p116 flanger delay decline time
;p117 flanger delay time sustain value
;p118 flanger release time
;p119 flanger feedback, range 0 - 1

; PHASER
;p120 phaser on = 1, off = 0
;p121 phaser freq in hz
;p122 phaser attack time
;p123 phaser decline time
;p124 phaser sustain freq in hz
;p125 phaser release time
;p126 phaser feedback, range -1 - 1

; LFO / TREMOLO
;p127 lfo start freq in hz, off = 0
;p128 lfo end freq in hz
;p129 lfo shape,  sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5
;p130 lfo attack time
;p131 lfo decline time
;p132 lfo sustain amplitude
;p133 lfo release time

; AMPLITUDE ENVELOPE
;p134 adsr attack time
;p135 adsr decay value
;p136 adsr sustain volume, range 0 - 1
;p137 adsr release time

; COMPRESSOR
;p138 compression ratio, a value of 1 will cause no compression
;p139 compressor threshold, normally <= 0
;p140 compressor low knee in db
;p141 compressor high knee in db
;p142 compressor attack time
;p143 compressor release time
;p144 compressor lookahead time, typical value is 0.5

; EQ
;p145 eq on = 1, off = 0
;p146 eq freq in hz
;p147 eq gain in db
;p148 eq q, range 0 - 1
;p149 eq mode, 0 = peaking, 1 = low shelf, 2 = high shelf


; =============================================================================
; Score
; =============================================================================

i"synth_1"  0      3      .5      .5      .5      [1/2]  0     0    0           ; Instrument
7.00        0      6.02   5.08    [1/10]  [3/10]  [6/10] 0     0    12    [0]   ; Pitch
0           8      0      0       [1/2]   [1/4]   3      [0]   1                ; vibrato
2           2      14     15                                                    ; Osc functions
0           0      0      0                                                     ; Osc phase
4           28     [1/2]                                                        ; Harmonics
12          12     10     10      0.8     0.5                                   ; VCO
2           2      2      2                                                     ; PVS osc types
5           0      1      0       0       1       2                             ; HBSoscil
0           20     2.03   2.03    25      10                                    ; FM / Additive
6           19     400    100                                                   ; FOF
0           101    0      1      0       9000    100     10     50   2          ; Vocoder
0           0.25   15     9.0     20                                            ; lowpass settings
            5000   [1/4]  [1/2]   500     [0]     0.5    [0]   [1/4] 0.8  [1/2] ; lowpass cutoff / res
0           5000   [1/4]  [1/2]   100     [1/4]   9.5                           ; highpass
0           1      [1/4]  [1/2]   .2      [1/4]   1                             ; distortion
0           16     20     30      2                                             ; bitcrusher
0           0.8    [1/4]  [1/2]   .3      [1/4]   .5                            ; flanger
0           5000   [1/4]  [1/2]   100     [1/4]   0.8                           ; phaser
0           8      0      [1/4]   [1/2]   1       [1/4]                         ; tremolo / amp lfo
[0]        [0]     1      [0]                                                   ; adsr
0           0      45     60      0.1     0.5     .05                           ; Compressor
0           1000   -100   1       0                                             ; EQ

e

</CsScore>
</CsoundSynthesizer>
