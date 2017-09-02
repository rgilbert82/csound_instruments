<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac      ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o name_of_output_file.wav -W ;;; for file output any platform
</CsOptions>

<CsInstruments>

sr        =         48000
kr        =         480
ksmps     =         100
nchnls    =         2
0dbfs     =         1


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

opcode	decimator, a, aki
  ; A modified version of David Akbari's Decimator opcode
  ain, kbitrate, isamps		xin
  setksmps isamps
  kbit	ctrl7	1, 1, 1, 16
  ksrate	ctrl7	1, 7, 11025, 44100

  kbits    = kbitrate^kbit			; Bit depth (1 to 16)
  kfold    = (sr/ksrate)			; Sample rate
  kin      downsamp  ain			; Convert to kr
  kin      = (kin + 32768)		; Add DC to avoid (-)
  kin      = kin*(kbits / 65536)		; Divide signal level
  kin      = int(kin)			; Quantise
  aout     upsamp  kin			; Convert to sr
  aout     = aout * (65536/kbits) - 32768	; Scale and remove DC

  a0ut     fold  aout, kfold		; Resample

	xout      a0ut * 0.0001
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
ipan_dur      = p7
ipan_freq     = p8
ipan_mode     = p9
isynth_type   = p10

ipch_1        = p11
ipch_2        = p12
ipch_3        = p13
ipch_4        = p14
ipch_dur_1    = p15
ipch_dur_2    = p16
ipch_dur_3    = p17
ipch_ramp     = p18
ipch_rand     = p19
iscale        = p20

ivib_avg_amp  = p21
ivib_avg_freq = p22
ivib_rand_amp = p23
ivib_rand_freq= p24
ivib_att      = p25
ivib_dec      = p26
ivib_sust     = p27
ivib_rel      = p28
ivib_fnc      = p29

isynth_fnc_1  = p30
isynth_fnc_2  = p31
isynth_fnc_3  = p32
isynth_fnc_4  = p33

iosc_phase_1  = p34
iosc_phase_2  = p35
iosc_phase_3  = p36
iosc_phase_4  = p37

iharmon_start = p38
iharmon_end   = p39
iharmon_dur   = p40

ivco_mode_1   = p41
ivco_mode_2   = p42
ivco_mode_3   = p43
ivco_mode_4   = p44
ivco_pw       = p45
ivco_nyx      = p46

ipvs_type1    = p47
ipvs_type2    = p48
ipvs_type3    = p49
ipvs_type4    = p50

ihsb_oct_count = p51
ihsb_tone_start= p52
ihsb_tone_end  = p53
ibrite_1       = p54
ibrite_2       = p55
ibrite_3       = p56
ibrite_4       = p57

ifm_idx_start  = p58
ifm_idx_end    = p59
ifm_car_start  = p60
ifm_car_end    = p61
iadditive_cnt  = p62
iadditive_func = p63

ifof_fnc_1      = p64
ifof_fnc_2      = p65
ifof_form_start = p66
ifof_form_end   = p67

ilowpass_on   = p68
ilp_dist      = p69
ilp_fb        = p70
klp_q         = p71
ilp_stack     = p72

ilp_cut       = p73
ilp_cut_att   = p74
ilp_cut_dec   = p75
ilp_cut_sust  = p76
ilp_cut_rel   = p77
ilp_res       = p78
ilp_res_att   = p79
ilp_res_dec   = p80
ilp_res_sust  = p81
ilp_res_rel   = p82

ihighpass_on  = p83
ihp_cut       = p84
ihp_cut_att   = p85
ihp_cut_dec   = p86
ihp_cut_sust  = p87
ihp_cut_rel   = p88
ihp_q         = p89

idist_on      = p90
idist         = p91
idist_att     = p92
idist_dec     = p93
idist_sust    = p94
idist_rel     = p95
idist_fnc     = p96

idec_on       = p97
idec_bitrate  = p98
idec_samps    = p99
ifold_start   = p100
ifold_end     = p101

iflange_on    = p102
iflange       = p103
iflange_att   = p104
iflange_dec   = p105
iflange_sust  = p106
iflange_rel   = p107
iflange_fb    = p108

iphase_on     = p109
iphase        = p110
iphase_att    = p111
iphase_dec    = p112
iphase_sust   = p113
iphase_rel    = p114
iphase_fb     = p115

ilfo_start    = p116
ilfo_end      = p117
ilfo_shape    = p118
ilfo_att      = p119
ilfo_dec      = p120
ilfo_sust     = p121
ilfo_rel      = p122

iattack       = p123
idecay        = p124
isustain_vol  = p125
irelease      = p126

icomp_thresh  = p127
icomp_loknee  = p128
icomp_hiknee  = p129
icomp_ratio   = p130
icomp_att     = p131
icomp_rel     = p132
icomp_look    = p133

ieq_on        = p134
ieq_freq      = p135
ieq_gain      = ampdb(p136)
ieq_q         = p137
ieq_mode      = p138

icps_1   cps2pch  ipch_1, iscale
icps_2   cps2pch  ipch_2, iscale
icps_3   cps2pch  ipch_3, iscale
icps_4   cps2pch  ipch_4, iscale


; =============================================================================
; Pitch Envelope
; =============================================================================

if (ipch_ramp == 0) then
  kpitch_ramp    linseg  icps_1, ipch_dur_1, icps_2, ipch_dur_2, icps_3, ipch_dur_3, icps_4
else
  kpitch_ramp    expseg  icps_1, ipch_dur_1, icps_2, ipch_dur_2, icps_3, ipch_dur_3, icps_4
endif


; =============================================================================
; Vibrato
; =============================================================================

if (ivib_avg_amp == 0) then
  kpitch = kpitch_ramp
else
  kvib_env   adsr      ivib_att, ivib_dec, ivib_sust, ivib_rel
  kvib       vibrato   ivib_avg_amp * kpitch_ramp, ivib_avg_freq, ivib_rand_amp, ivib_rand_freq, 3, 5, 3, 5, ivib_fnc
  kpitch = kpitch_ramp + (kvib * kvib_env)
endif


; =============================================================================
; Synth Modes
; =============================================================================

if (isynth_type == 0) then
  aosc1    oscil iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_1, iosc_phase_1
  aosc2    oscil iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_2, iosc_phase_2
  aosc3    oscil iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_3, iosc_phase_3
  aosc4    oscil iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), isynth_fnc_4, iosc_phase_4
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 1) then
  kharmon  line  iharmon_start, iharmon_dur, iharmon_end
  aosc1    buzz  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aosc2    buzz  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aosc3    buzz  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aosc4    buzz  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), kharmon, 1
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 2) then
  aosc1    vco2  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_1, ivco_pw, iosc_phase_1, ivco_nyx
  aosc2    vco2  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_2, ivco_pw, iosc_phase_2, ivco_nyx
  aosc3    vco2  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_3, ivco_pw, iosc_phase_3, ivco_nyx
  aosc4    vco2  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), ivco_mode_4, ivco_pw, iosc_phase_4, ivco_nyx
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 3) then
  fsig1    pvsosc  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), ipvs_type1, 1024
  fsig2    pvsosc  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), ipvs_type2, 1024
  fsig3    pvsosc  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), ipvs_type3, 1024
  fsig4    pvsosc  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), ipvs_type4, 1024
  aosc1    pvsynth fsig1
  aosc2    pvsynth fsig2
  aosc3    pvsynth fsig3
  aosc4    pvsynth fsig4
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * .5
elseif (isynth_type == 4) then
  ktone    line ihsb_tone_start, idur, ihsb_tone_end
  aosc1    hsboscil iamp + birnd(0.05), ktone, ibrite_1, icps_1, isynth_fnc_1, 18, ihsb_oct_count
  aosc2    hsboscil iamp + birnd(0.05), ktone, ibrite_2, icps_1, isynth_fnc_2, 18, ihsb_oct_count
  aosc3    hsboscil iamp + birnd(0.05), ktone, ibrite_3, icps_1, isynth_fnc_3, 18, ihsb_oct_count
  aosc4    hsboscil iamp + birnd(0.05), ktone, ibrite_4, icps_1, isynth_fnc_4, 18, ihsb_oct_count
  aoscs = (aosc1 + aosc2 + aosc3 + aosc4) * 0.25
elseif (isynth_type == 5) then    ; FM
  kfm_idx  line ifm_idx_start, idur, ifm_idx_end
  kfm_car  line ifm_car_start, idur, ifm_car_end
  aosc1    foscil  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_1
  aosc2    foscil  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_2
  aosc3    foscil  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_3
  aosc4    foscil  iamp + birnd(0.05), kpitch + (birnd(ipch_rand) * kpitch), 1, kfm_car, kfm_idx, isynth_fnc_4
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
; Lowpass Filters
; =============================================================================

if (ilowpass_on != 0 && ilp_cut_att == 0) then
  klp_cut linsegr   ilp_cut, ilp_cut_dec, ilp_cut_sust, ilp_cut_rel, 10
elseif (ilowpass_on != 0 && ilp_cut_att != 0) then
  klp_cut linsegr   10, ilp_cut_att, ilp_cut, ilp_cut_dec, ilp_cut_sust, ilp_cut_rel, 10
endif

if (ilowpass_on != 0 && ilp_res_att == 0) then
  klp_res linsegr   ilp_res, ilp_res_dec, ilp_res_sust, ilp_res_rel, 0.001
elseif (ilowpass_on != 0 && ilp_res_att != 0) then
  klp_res linsegr   0.001, ilp_res_att, ilp_res, ilp_res_dec, ilp_res_sust, ilp_res_rel, 0.001
endif

if (ilowpass_on == 1) then
  a1      lpf18     aoscs, klp_cut, klp_res, ilp_dist
elseif (ilowpass_on == 2) then
  a1      moogladder     aoscs, klp_cut, klp_res
elseif (ilowpass_on == 3) then
  a1      moogvcf2   aoscs, klp_cut, klp_res
elseif (ilowpass_on == 4) then
  a1      mvclpf3    aoscs, klp_cut, klp_res
elseif (ilowpass_on == 5) then
  a1      K35_lpf    aoscs, klp_cut, klp_q
elseif (ilowpass_on == 6) then
  a1      butterlp   aoscs, klp_cut
elseif (ilowpass_on == 7) then
  a1      tonex     aoscs, klp_cut, ilp_stack
elseif (ilowpass_on == 8) then
  a1      diode_ladder aoscs, klp_cut, ilp_fb
  a1 = a1 * 3
else
  a1 = aoscs
endif


; =============================================================================
;Highpass Filters
; =============================================================================

if (ihighpass_on != 0 && ihp_cut_att == 0) then
  khp_cut linsegr   ihp_cut, ihp_cut_dec, ihp_cut_sust, ihp_cut_rel, 10
elseif (ihighpass_on != 0 && ihp_cut_att != 0) then
  khp_cut linsegr   10, ihp_cut_att, ihp_cut, ihp_cut_dec, ihp_cut_sust, ihp_cut_rel, 10
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

if (idist_att == 0) then
  kdist   linsegr   idist, idist_dec, idist_sust, idist_rel, 0
else
  kdist   linsegr   0, idist_att, idist, idist_dec, idist_sust, idist_rel, 0
endif

if (idist_on == 1) then
  a1      distort   a1, kdist, idist_fnc
endif


; =============================================================================
; Bitcrusher
; =============================================================================

if (idec_on == 1) then
  a1      decimator a1, idec_bitrate, idec_samps
elseif (idec_on == 2) then
  kfold   line  ifold_start, idur, ifold_end
  a1      fold  a1, kfold
endif

/*If UDOs don't work in Blue*/
/*if (idec_on == 1) then
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
  kfold   line  ifold_start, idur, ifold_end
  a1      fold  a1, kfold
endif*/

; =============================================================================
; Flanger
; =============================================================================

if (iflange_att == 0) then
  aflange   linsegr   iflange, iflange_dec, iflange_sust, iflange_rel, 0
else
  aflange   linsegr   0, iflange_att, iflange, iflange_dec, iflange_sust, iflange_rel, 0
endif

if (iflange_on == 1) then
  a1       flanger   a1, aflange, iflange_fb
endif


; =============================================================================
; Phaser
; =============================================================================

if (iphase_att == 0) then
  kphase   linsegr   iphase, iphase_dec, iphase_sust, iphase_rel, 0
else
  kphase   linsegr   0, iphase_att, iphase, iphase_dec, iphase_sust, iphase_rel, 0
endif

if (iphase_on == 1) then
  a1      phaser1   a1, kphase, 100, iphase_fb
endif


; =============================================================================
; Tremolo
; =============================================================================

klfo_ramp line      ilfo_start, idur, ilfo_end

if (ilfo_start == 0) then
  alfo = 0
else
  klfo_env   adsr      ilfo_att, ilfo_dec, ilfo_sust, ilfo_rel
  alfo       lfo       klfo_env, klfo_ramp, ilfo_shape
endif


; =============================================================================
; Envelope
; =============================================================================

aadsr     adsr    iattack, idecay, isustain_vol, irelease
afadeout  linsegr    1, idur - 0.01, 1, 0.01, 0
aenv_sig = aadsr * afadeout * (1 - alfo) * a1


; =============================================================================
; Compressor
; =============================================================================

afinal    compress  aenv_sig, aenv_sig, icomp_thresh, icomp_loknee, icomp_hiknee, icomp_ratio, icomp_att, icomp_rel, icomp_look


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
  kpan     line  ipan_start, ipan_dur, ipan_end
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
;p10 synth type

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

; VIBRATO
;p21 average amplitude value of vibrato
;p22 average frequency value of vibrato (in cps)
;p23 amount of random amplitude deviation
;p24 amount of random frequency deviation
;p25 vibrato attack
;p26 vibrato decay
;p27 vibrato sustain
;p28 vibrato release
;p29 f-table function for vibrato shape

; SYNTH OSC FUNCTIONS - for synth types 0, 4, 5
;p30 synth function 1
;p31 synth function 2
;p32 synth function 3
;p33 synth function 4

; SYNTH OSC PHASE - for synth types 0, 2
;p34 osc phase 1, range 0 - 1
;p35 osc phase 2
;p36 osc phase 3
;p37 osc phase 4

; HARMONICS - for synth type 1
;p38 number of harmonics start
;p39 number of harmonics end
;p40 number of harmonics duration

; VCO - for synth type 2
;p41 vco mode 1: 12 = tri, 10 = square, 8 = integrated saw, 6 = pulse, 4 = saw/tri/ramp, 2 = square/PWM, 0 = saw
;p42 vco mode 2
;p43 vco mode 3
;p44 vco mode 4
;p45 pulse width of square wave, range 0 - 1
;p46 bandwidth of waveform, range 0 - 1, default 0.5

; PVS SYNTH - for synth type 3
;p47 pvs type 1: 1 = saw, 2 = square, 3 = pulse, 4 = cosine
;p48 pvs type 2
;p49 pvs type 3
;p50 pvs type 4

; HSB SYNTH - for synth type 4
;p51 octave count, range 2 - 10
;p52 tone start, range 0 - 1
;p53 tone end
;p54 brightness 1: 1 is octiave above 0, -1 is octave below, etc
;p55 brightness 2
;p56 brightness 3
;p57 brightness 4

; FM SYNTH - for synth type 5
;p58 fm index start value, range 0+
;p59 fm index end
;p60 fm mod start. gives modulating freq when multiplied by the carrier freq
;p61 fm mod end
; ADDITIVE SYNTH - for synth type 6
;p62 additive osc count, range 1 - 30
;p63 additive osc wave function

; FOF SYNTH - for synth type 7
;p64 fof osc function 1
;p65 fof osc function 2, preferably linear or sinusoid
;p66 fof formant freq start, in hz
;p67 fof formant freq end

; LOWPASS FILTERS
;p68 lowpass type, off = 0
;p69 lp distortion, for lp type 1    range 0 - 1+
;p70 lp feedback, for lp type 8      range 0 - 17
;p71 lp q, for lp type 5             range 1 - 10
;p72 lp stack, for lp type 7         range 1+

;p73 lp cutoff freq in hz
;p74 lp cutoff attack time
;p75 lp cutoff decline time
;p76 lp cutoff sustain freq in hz
;p77 lp cutoff release time
;p78 lp resonance value,   range 0 - 1
;p79 lp resonance attack time
;p80 lp resonance decline time
;p81 lp resonance sustain value, range 0 - 1
;p82 lp resonance release time

; HIGHPASS FILTERS
;p83 hp type, off = 0
;p84 hp cutoff freq in hz
;p85 hp cutoff attack time
;p86 hp cutoff decline time
;p87 hp cutoff sustain freq in hz
;p88 hp cutoff release time
;p89 hp cutoff q, for hp type 3     range 1 - 10

; DISTORTION
;p90 distortion on = 1, off = 0
;p91 distortion value,    range 0 - 1
;p92 distortion attack time
;p93 distortiom decline time
;p94 distortion sustain value,   range 0 - 1
;p95 distortion release time
;p96 distortion shape function

; BITCRUSHER
;p97  bitcrusher type, off = 0
;p98  decimator bitrate, range 1 - 32
;p99  decimator samples
;p100 fold start value, amount of foldover expressed in multiple of sampling rate. range 1+
;p101 fold end value

; FLANGER
;p102 flanger on = 1, off = 0
;p103 flanger delay time value
;p104 flanger delay attack time
;p105 flanger delay decline time
;p106 flanger delay time sustain value
;p107 flanger release time
;p108 flanger feedback, range 0 - 1

; PHASER
;p109 phaser on = 1, off = 0
;p110 phaser freq in hz
;p111 phaser attack time
;p112 phaser decline time
;p113 phaser sustain freq in hz
;p114 phaser release time
;p115 phaser feedback, range -1 - 1

; LFO / TREMOLO
;p116 lfo start freq in hz, off = 0
;p117 lfo end freq in hz
;p118 lfo shape,  sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5
;p119 lfo attack time
;p120 lfo decline time
;p121 lfo sustain amplitude
;p122 lfo release time

; AMPLITUDE ENVELOPE
;p123 adsr attack time
;p124 adsr decay value
;p125 adsr sustain volume, range 0 - 1
;p126 adsr release time

; COMPRESSOR
;p127  compressor threshold, normally <= 0
;p128 compressor low knee in db
;p129 compressor high knee in db
;p130 compression ratio, a value of 1 will cause no compression
;p131 compressor attack time
;p132 compressor release time
;p133 compressor lookahead time, typical value is 0.5

; EQ
;p134 eq on = 1, off = 0
;p135 eq freq in hz
;p136 eq gain in db
;p137 eq q, range 0 - 1
;p138 eq mode, 0 = peaking, 1 = low shelf, 2 = high shelf


; =============================================================================
; Score
; =============================================================================

i"synth_1"  0      5      1       0.5     0.5     5      0     0    0     \     ; Instrument
5.05        6.03   6.03   6.03    0.05    0.15    0.05   0     0    10    \     ; Pitch
0           12     0      0.0001  2       1       2      0.1   1    \           ; vibrato
13          13     14     15      \                                             ; Osc functions
0           0      0      0       \                                             ; Osc phase
4           28      .25   \                                                     ; Harmonics
12          12     10     10      0.8     0.5      \                            ; VCO
2           2      2      2       \                                             ; PVS osc types
5           0      1      0       0       1        2     \                      ; HBSoscil
0           20     2.03   2.03    25      10       \                            ; FM / Additive
6           19     400    100     \                                             ; FOF
1           0.25   15     9.0     20      \                                     ; lowpass settings
            5000   0      .5      500     4        0.5   0    0.1  0.8   4   \  ; lowpass cutoff / res
0           5000   0      1       100     3       9.5    \                      ; highpass
0           1      0      1       .2      2       1      \                      ; distortion
1           8      20     30      2       \                                     ; bitcrusher
0           0.8    0      2       .3      1       .5     \                      ; flanger
0           5000   0      2       100     2       0.8    \                      ; phaser
0           0      0     .1       1       2       0      \                      ; tremolo / amp lfo
0.01        0.03   .4     4       \                                             ; adsr
0           45     60     1       0.1     0.5     .05    \                      ; Compressor
0           1000   -100   1       0       \                                     ; EQ

e

</CsScore>
</CsoundSynthesizer>
