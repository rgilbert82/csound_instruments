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

gasamp = 0    ;Sample input for vocoder

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

; For Scanner
gi501      ftgen 501, 0, 128, 7, 0, 64, 1, 64, 0			; Initial condition
gi502      ftgen 502, 0, 128, -7, 1, 128, .3			    ; Masses
gi503      ftgen 503, 0, 128, -7, 2, 4, 0, 124, 2		  ; Centering force, also 501, 502, 504
gi504      ftgen 504, 0, 128, -7, 1, 128, 0			      ; Damping
gi505      ftgen 505, 0, 128, -7, 0, 128, 0			    ; Initial velocity

gi550      ftgen 550, 0, 16384, -23, "matrices/cylinder-128,8"	     ; Spring matrices
gi551      ftgen 551, 0, 16384, -23, "matrices/circularstring-128"	 ; Spring matrices
gi552      ftgen 552, 0, 16384, -23, "matrices/full-128"             ; Spring matrices
gi553      ftgen 553, 0, 16384, -23, "matrices/grid-128,8"	         ; Spring matrices
gi554      ftgen 554, 0, 16384, -23, "matrices/string-128"	         ; Spring matrices
gi555      ftgen 555, 0, 16384, -23, "matrices/torus-128,8"	         ; Spring matrices
gi559      ftgen 559, 0, 128, -7, 0, 128, 128
gi560      ftgen 560, 0, 128, -5, .001, 128, 128		                     ; Trajectories
gi561      ftgen 561, 0, 128, -23, "matrices/spiral-8,16,128,2,1over2"   ; Trajectories
gi562      ftgen 562, 0, 128, -23, "matrices/cylinder-128,8"
gi563      ftgen 563, 0, 128, -23, "matrices/circularstring-128"
gi564      ftgen 564, 0, 128, -23, "matrices/full-128"
gi565      ftgen 565, 0, 128, -23, "matrices/grid-128,8"
gi566      ftgen 566, 0, 128, -23, "matrices/string-128"
gi567      ftgen 567, 0, 128, -23, "matrices/torus-128,8"

; For Additive Synths
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
; SAMPLER for vocoder
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
asig flooper2 1, 1, 0, p3, 0.001, isample


gasamp = asig

endin


; =============================================================================
; SCANNER
; =============================================================================

instr scan

idur        = p3
iamp        = p4
icps1       = p5
icps2       = p6
ipch_dur    = p7 * idur
ipch_scale  = p8
ipch_fract  = p9

ipan_start  = p10
ipan_end    = p11
ipan_dur    = p12 * idur
ipan_freq   = p13
ipan_mode   = p14   ; sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5

ivib_avg_amp  = p15
ivib_avg_freq = p16
ivib_rand_amp = p17
ivib_rand_freq= p18
ivib_att      = p19 * idur
ivib_dec      = p20 * idur
ivib_sust     = p21
ivib_rel      = p22 * idur
ivib_fnc      = p23

irate       = p24    ; range 0.0001 - 1
imass       = p25    ; range 0.5 - 120+ Don't go lower!
icenter     = p26    ; range 0+ - 0.1   Don't go higher!
idamp       = p27    ; range -1 - 0     Don't go positive!

iscan_init  = p28
iscan_cntr  = p29
iscan_damp  = p30
iscan_vel   = p31
iscan_mass  = p32
iscan_stiff = p33
iscan_traj  = p34

ivcdr_on         = p35
isample_pitch    = p36
ivcdr_max        = p37
ivcdr_min        = p38
ivcdr_q          = p39
ivcdr_band       = p40
ivcdr_cnt        = p41

ilowpass_on   = p42
ilp_dist      = p43
ilp_fb        = p44
klp_q         = p45
ilp_stack     = p46

ilp_cut       = p47
ilp_cut_att   = p48 * idur
ilp_cut_dec   = p49 * idur
ilp_cut_sust  = p50
ilp_cut_rel   = p51 * idur
ilp_res       = p52
ilp_res_att   = p53 * idur
ilp_res_dec   = p54 * idur
ilp_res_sust  = p55
ilp_res_rel   = p56 * idur

ihighpass_on  = p57
ihp_cut       = p58
ihp_cut_att   = p59 * idur
ihp_cut_dec   = p60 * idur
ihp_cut_sust  = p61
ihp_cut_rel   = p62 * idur
ihp_q         = p63

idist_on      = p64
idist         = p65
idist_att     = p66 * idur
idist_dec     = p67 * idur
idist_sust    = p68
idist_rel     = p69 * idur
idist_fnc     = p70

idec_on       = p71
idec_bitrate  = p72
idec_samps    = p73
ifold_start   = p74
ifold_end     = p75

iflange_on    = p76
iflange       = p77
iflange_att   = p78 * idur
iflange_dec   = p79 * idur
iflange_sust  = p80
iflange_rel   = p81 * idur
iflange_fb    = p82

iphase_on     = p83
iphase        = p84
iphase_att    = p85 * idur
iphase_dec    = p86 * idur
iphase_sust   = p87
iphase_rel    = p88 * idur
iphase_fb     = p89

ilfo_start    = p90
ilfo_end      = p91
ilfo_shape    = p92
ilfo_att      = p93 * idur
ilfo_dec      = p94 * idur
ilfo_sust     = p95
ilfo_rel      = p96 * idur

iattack       = p97 * idur
idecay        = p98 * idur
isustain_vol  = p99
irelease      = p100 * idur

ifeedback     = p101       ;range 1-10
ifb_freq_1    = p102
ifb_freq_2    = p103
ifb_1         = p104       ;range 0-2
ifb_2         = p105
ifb_3         = p106
ifb_time_1    = p107
ifb_time_2    = p108
ifb_fold      = p109

kpos        = abs(birnd(1))
aout        = 0


; =============================================================================
; Pitch Duration
; =============================================================================

ipch1       cps2pch icps1, ipch_scale
ipch2       cps2pch icps2, ipch_scale

if (ipch_dur > idur || ipch_dur <= 0) then
  ipch_dur = idur
endif

if (ipch1 == ipch2 || icps2 == 0) then
  kpitch_ramp = k(ipch1)
else
  kpitch_ramp   linseg  ipch1, ipch_dur, ipch2
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
  avcdr_sig     butterhp  gasamp, 50
  fsig          pvsanal   avcdr_sig, ifftsize, ifftsize/4, ifftsize, iwtype
  kfr           pvscent   fsig
  kpitch = kfr
  icps = i(kfr)
endif

; =============================================================================
; Scan
; =============================================================================

      scanu iscan_init, irate, iscan_vel, iscan_mass, iscan_stiff, iscan_cntr, iscan_damp, imass, .01, icenter, idamp, .1, .9, kpos, 0, aout, 1, 1000
asig  scans iamp, kpitch, iscan_traj , 1000
aoscs limit asig, 0, 1


; =============================================================================
; Vocoder
; =============================================================================

if (ivcdr_on != 0) then
  kratio = 3
  avcdr_sig   compress gasamp, gasamp, 0, 48, 60, kratio, .1, .5, .02
  avcdr_sig   balance  avcdr_sig, aoscs
  aoscs       Vocoder  aoscs, avcdr_sig, ivcdr_min, ivcdr_max, ivcdr_q, ivcdr_band, ivcdr_cnt
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
    klp_cut linseg   100, ilp_cut_att, ilp_cut, ilp_cut_dec, ilp_cut_sust, idur - ilp_cut_att - ilp_cut_dec - ilp_cut_rel, ilp_cut_sust, ilp_cut_rel, 10

    if (iattack == 0) then
      iattack = 0.05
    endif
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
; Panning
; =============================================================================

if (ipan_dur > idur || ipan_dur <= 0) then
  ipan_dur = idur
endif

if (ipan_freq != 0) then
  kpan     lfo   1, ipan_freq, ipan_mode
elseif (ipan_start != ipan_end) then
  kpan     linseg  ipan_start, ipan_dur, ipan_end
else
  kpan = ipan_start
endif

apan_l, apan_r  pan2  aenv_sig, kpan


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
;p1  instr
;p2  start time
;p3  duration
;p4  amplitude    range 0 - 1+
;p5 pitch value 1, in octave point decimal
;p6 pitch value 2
;p7 pitch duration
;p8 number of octave divisions for scale
;p9 pitch fraction, off = 0
;    Ex with C root:
;    C       C#      D-      D       Eb-      Eb       E       F      F#-
;    1/1     25/24   10/9    9/8     32/27    6/5      5/4     4/3    25/18
;
;    F#      G       G#      A       Bb-      Bb       B       C
;    45/32   3/2     25/16   5/3     16/9     9/5      15/8    2/1

; PANNING
;p10 pan start, range: 0 - 1
;p11 pan end, range: 0 - 1
;p12 pan duration
;p13 pan freq, for LFO pan
;p14 pan LFO mode  ; sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5

; VIBRATO
;p15 average amplitude value of vibrato
;p16 average frequency value of vibrato (in cps)
;p17 amount of random amplitude deviation
;p18 amount of random frequency deviation
;p19 vibrato attack
;p20 vibrato decay
;p21 vibrato sustain
;p22 vibrato release
;p23 f-table function for vibrato shape

; SCANNER
;p24 scan rate,     range 0.0001 - 1
;p25 scan mass,     range 0.5 - 120+  Don't go lower!
;p26 scan center,   range 0+ - 0.1    Don't go higher!
;p27 scan damp,     range -1 - 0      Don't go positive!

; SCANNER F-Table Functions
;p28 init
;p29 center
;p30 damp
;p31 velocity
;p32 mass
;p33 stiffness
;p34 trajectory

; VOCODER
;p35 Vocoder on = 1, off = 0
;p36 sample pitch
;p37 vocoder max freq
;p38 vocoder min freq
;p39 vocoder Q:  range 5+
;p40 vocoder band:  range 5+
;p41 vocoder count:  range 1+

; LOWPASS FILTERS
;p42 lowpass type, off = 0
;p43 lp distortion, for lp type 1    range 0 - 1+
;p44 lp feedback, for lp type 8      range 0 - 17
;p45 lp q, for lp type 5             range 1 - 10
;p46 lp stack, for lp type 7         range 1+

;p47 lp cutoff freq in hz
;p48 lp cutoff attack time
;p49 lp cutoff decline time
;p50 lp cutoff sustain freq in hz
;p51 lp cutoff release time
;p52 lp resonance value,   range 0 - 1
;p53 lp resonance attack time
;p54 lp resonance decline time
;p55 lp resonance sustain value, range 0 - 1
;p56 lp resonance release time

; HIGHPASS FILTERS
;p57 hp type, off = 0
;p58 hp cutoff freq in hz
;p59 hp cutoff attack time
;p60 hp cutoff decline time
;p61 hp cutoff sustain freq in hz
;p62 hp cutoff release time
;p63 hp cutoff q, for hp type 3     range 1 - 10

; DISTORTION
;p64 distortion on = 1, off = 0
;p65 distortion value,    range 0 - 1
;p66 distortion attack time
;p67 distortiom decline time
;p68 distortion sustain value,   range 0 - 1
;p69 distortion release time
;p70 distortion shape function

; BITCRUSHER
;p71 bitcrusher type, off = 0
;p72 decimator bitrate, range 1 - 32
;p73 decimator samples
;p74 fold start value, amount of foldover expressed in multiple of sampling rate. range 1+
;p75 fold end value

; FLANGER
;p76 flanger on = 1, off = 0
;p77 flanger delay time value
;p78 flanger delay attack time
;p79 flanger delay decline time
;p80 flanger delay time sustain value
;p81 flanger release time
;p82 flanger feedback, range 0 - 1

; PHASER
;p83 phaser on = 1, off = 0
;p84 phaser freq in hz
;p85 phaser attack time
;p86 phaser decline time
;p87 phaser sustain freq in hz
;p88 phaser release time
;p89 phaser feedback, range -1 - 1

; LFO / TREMOLO
;p90 lfo start freq in hz, off = 0
;p91 lfo end freq in hz
;p92 lfo shape,  sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5
;p93 lfo attack time
;p94 lfo decline time
;p95 lfo sustain amplitude
;p96 lfo release time

; AMPLITUDE ENVELOPE
;p97  adsr attack time
;p98  adsr decay value
;p99  adsr sustain volume, range 0 - 1
;p100 adsr release time

; FEEDBACK
;p101 feedback on = 1, off = 0
;p102 fb freq 1 in Hz
;p103 fb freq 2 in Hz
;p104 fb level 1,     range 0-2
;p105 fb level 2,     range 0-2
;p106 fb level 3,     range 0-2
;p107 fb time 1,      percentage of idur
;p108 fb time 2,      percentage of idur
;p109 fold level      range 1+, 0 = off


; =============================================================================
; Score
; =============================================================================

i"samp" 0       10

i"scan" 0       6       .9      4.00    0.00    [1/1]   10    [1/1]             ; Instrument
.5      .5      [2/1]   0       0                                               ; Pan
0       8       0       0       [1/2]   [1/4]   3       [0]    1                ; vibrato
.03     1       0.005   -0.1                                                    ; Scanner Params
501     503     504     505     502     550     561                             ; Scanner Functions
0       0       9000    100     10      50      2                               ; Vocoder
0       0.25    15      9.0     20                                              ; lowpass settings
5000    [1/4]   [1/2]   500     [1/4]   0.5     [0]     [0]  0.8       [1/2]    ; lowpass cutoff / res
0       5000    [1/4]   [1/2]   100     [1/4]   9.5                             ; highpass
0       1       [1/4]   [1/2]   .2      [1/4]   1                               ; distortion
0       16      20      30      2                                               ; bitcrusher
0       0.8     [1/4]   [1/2]   .3      [1/4]   .5                              ; flanger
0       5000    [1/4]   [1/2]   100     [1/4]   0.8                             ; phaser
0       8       0       [1/4]   [1/2]   1       [1/4]                           ; tremolo / amp lfo
[0]     [0]     1       [0]                                                     ; adsr
0       150     150     1       .5      .8      .5      .5     10               ; Feedback


i"scan" 6       10      .9      2.00    6.00    [1/1]   10    [1/1]             ; Instrument
.5      .5      [0]     0       0                                               ; Pan
0       8       0       0       [1/2]   [1/4]   3       [0]    1                ; vibrato
.05     .5      0.001   -0.07      	                                            ; Scanner Params
501     503     504     505     502     550     561                             ; Scanner Functions
0       0       9000    100     10      50      2                               ; Vocoder
0       0.25    15      9.0     20                                              ; lowpass settings
5000    [1/4]   [1/2]   500     [0]     0.5     [0]     [1/4]  0.8     [1/2]    ; lowpass cutoff / res
0       5000    [1/4]   [1/2]   100     [1/4]   9.5                             ; highpass
0       1       [1/4]   [1/2]   .2      [1/4]   1                               ; distortion
0       16      20      30      2                                               ; bitcrusher
0       0.8     [1/4]   [1/2]   .3      [1/4]   .5                              ; flanger
0       5000    [1/4]   [1/2]   100     [1/4]   0.8                             ; phaser
0       8       0       [1/4]   [1/2]   1       [1/4]                           ; tremolo / amp lfo
[0]     [0]     1       [0]                                                     ; adsr
0       150     150     1       .5      .8      .5      .5     0                ; Feedback


e
</CsScore>
</CsoundSynthesizer>
