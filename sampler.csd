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
; F Tables
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


;
; =============================================================================
; SAMPLER_1
; =============================================================================
;

instr sampler_1

idur          = p3
iamp          = p4
ipan_start    = p5
ipan_end      = p6
ipan_dur      = p7 * idur
isample       = p8
iskiptime     = p9
isampler_mode = p10

ipitch_start  = p11
ipitch_end    = p12
ipitch_dur    = p13 * idur

ivib_avg_amp  = p14
ivib_avg_freq = p15
ivib_rand_amp = p16
ivib_rand_freq= p17
ivib_att      = p18 * idur
ivib_dec      = p19 * idur
ivib_sust     = p20
ivib_rel      = p21 * idur
ivib_fnc      = p22

iloop_start   = p23
iloop_size_1  = p24 * idur
iloop_size_2  = p25 * idur
iloop_fract   = p26
iloop_size_dur= iloop_fract * idur
iloop_cross   = p27
iloop_mode    = p28

iloop_skip_percent = p29
iloop_stretch      = p30
iloop_filename     = p31

igrain_dens   = p32
igrain_speed  = p33
igrain_oct    = p34
igrain_rise   = p35
igrain_dur    = p36
igrain_dec    = p37
igrain_legato = p38
igrain_shape  = p39

ilowpass_on   = p40
ilp_dist      = p41
ilp_fb        = p42
klp_q         = p43
ilp_stack     = p44

ilp_cut       = p45
ilp_cut_att   = p46 * idur
ilp_cut_dec   = p47 * idur
ilp_cut_sust  = p48
ilp_cut_rel   = p49 * idur
ilp_res       = p50
ilp_res_att   = p51 * idur
ilp_res_dec   = p52 * idur
ilp_res_sust  = p53
ilp_res_rel   = p54 * idur

ihighpass_on  = p55
ihp_cut       = p56
ihp_cut_att   = p57 * idur
ihp_cut_dec   = p58 * idur
ihp_cut_sust  = p59
ihp_cut_rel   = p60 * idur
ihp_q         = p61

idist_on      = p62
idist         = p63
idist_att     = p64 * idur
idist_dec     = p65 * idur
idist_sust    = p66
idist_rel     = p67 * idur
idist_fnc     = p68

idec_on       = p69
idec_bitrate  = p70
idec_samps    = p71
ifold_start   = p72
ifold_end     = p73

iflange_on    = p74
iflange       = p75
iflange_att   = p76 * idur
iflange_dec   = p77 * idur
iflange_sust  = p78
iflange_rel   = p79 * idur
iflange_fb    = p80

iphase_on     = p81
iphase        = p82
iphase_att    = p83 * idur
iphase_dec    = p84 * idur
iphase_sust   = p85
iphase_rel    = p86 * idur
iphase_fb     = p87

ilfo_start    = p88
ilfo_end      = p89
ilfo_shape    = p90
ilfo_att      = p91 * idur
ilfo_dec      = p92 * idur
ilfo_sust     = p93
ilfo_rel      = p94 * idur

iattack       = p95 * idur
idecay        = p96 * idur
isustain_vol  = p97
irelease      = p98 * idur

icomp_ratio   = p99
icomp_thresh  = p100
icomp_loknee  = p101
icomp_hiknee  = p102
icomp_att     = p103
icomp_rel     = p104
icomp_look    = p105

ieq_on        = p106
ieq_freq      = p107
ieq_gain      = ampdb(p108)
ieq_q         = p109
ieq_mode      = p110

if (isampler_mode == 1) then
  ilen filelen iloop_filename
  iskiptime = iloop_skip_percent * ilen
  istretch_percent = iloop_stretch / (1 - iloop_skip_percent)
  iloop_length = idur / ((ilen - iskiptime) * istretch_percent)
endif

; =============================================================================
; Samples
; =============================================================================

i101 ftgenonce 0, 0, 524288, 1, "samples/amen.wav",     iskiptime, 0, 2
; add other samples here

if (isample == 101) then
  isample = i101
endif

ichannels = ftchnls(p8)


; =============================================================================
; Pitch ramp
; =============================================================================

kpitch_ramp   linseg      ipitch_start, ipitch_dur, ipitch_end


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
; Sample length ramp
; =============================================================================

if (iloop_size_1 == iloop_size_2) then
  kloop = k(iloop_size_1)
elseif (iloop_fract == 1) then
  kloop    expseg    iloop_start + iloop_size_1, iloop_size_dur - iloop_start, iloop_start + iloop_size_2
else
  kloop    expseg    iloop_start + iloop_size_1, iloop_size_dur - iloop_start, iloop_start + iloop_size_2, idur - iloop_size_dur - iloop_start, iloop_start + iloop_size_2
endif

; =============================================================================
; Stereo audio file reader
; =============================================================================

if (isampler_mode == 3) then
  iidx    =	sr/ftlen(1) ;scaling to reflect sample rate and table length
  aspd    phasor iidx * igrain_speed ;index for speed
  a1      fog    iamp, igrain_dens, kpitch, aspd, igrain_oct, 0, igrain_rise, igrain_dur, igrain_dec, 30, isample, igrain_shape, idur,  1, 0, igrain_legato
  a2      fog    iamp, igrain_dens, kpitch, aspd, igrain_oct, 0, igrain_rise, igrain_dur, igrain_dec, 30, isample, igrain_shape, idur, .5, 0, igrain_legato
elseif (ichannels == 1 && isampler_mode == 2) then
  a1      flooper2  iamp, kpitch, iloop_start, kloop, iloop_cross, \
                    isample, 0, iloop_mode
  a2 = a1
elseif (ichannels == 2 && isampler_mode == 2) then
  a1, a2  flooper2  iamp, kpitch, iloop_start, kloop, iloop_cross, \
                    isample, 0, iloop_mode
elseif (isampler_mode == 1) then
  a1      paulstretch iloop_length, 0.02, isample
  a2 = a1
elseif (isampler_mode == 0) then
  a1      paulstretch iloop_stretch, 0.02, isample
  a2 = a1
else
  a1 = 0
  a2 = 0
endif


; =============================================================================
; Lowpass Filters
; =============================================================================

if (ilowpass_on != 0) then
  atemp_l = a1
  atemp_r = a2

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
  a1      lpf18     a1, klp_cut, klp_res, ilp_dist
  a2      lpf18     a2, klp_cut, klp_res, ilp_dist
elseif (ilowpass_on == 2) then
  a1      moogladder     a1, klp_cut, klp_res
  a2      moogladder     a2, klp_cut, klp_res
elseif (ilowpass_on == 3) then
  a1      moogvcf2   a1, klp_cut, klp_res
  a2      moogvcf2   a2, klp_cut, klp_res
elseif (ilowpass_on == 4) then
  a1      mvclpf3    a1, klp_cut, klp_res
  a2      mvclpf3    a2, klp_cut, klp_res
elseif (ilowpass_on == 5) then
  a1      K35_lpf    a1, klp_cut, klp_q
  a2      K35_lpf    a2, klp_cut, klp_q
elseif (ilowpass_on == 6) then
  a1      butterlp   a1, klp_cut
  a2      butterlp   a2, klp_cut
elseif (ilowpass_on == 7) then
  a1      tonex     a1, klp_cut, ilp_stack
  a2      tonex     a2, klp_cut, ilp_stack
elseif (ilowpass_on == 8) then
  a1      diode_ladder a1, klp_cut, ilp_fb
  a2      diode_ladder a2, klp_cut, ilp_fb
endif

if (ilowpass_on != 0) then
  a1      balance   a1, atemp_l
  a2      balance   a2, atemp_r
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
  a2      butterhp  a2, khp_cut
elseif (ihighpass_on == 2) then
  a1      mvchpf    a1, khp_cut
  a2      mvchpf    a2, khp_cut
elseif (ihighpass_on == 3) then
  a1      K35_hpf   a1, khp_cut, ihp_q
  a2      K35_hpf   a2, khp_cut, ihp_q
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

  atemp_l  = a1
  atemp_r  = a1
  a1      distort   a1, kdist, idist_fnc
  a2      distort   a2, kdist, idist_fnc
  a1      balance   a1, atemp_l
  a2      balance   a2, atemp_r
endif


; =============================================================================
; Bitcrusher
; =============================================================================


if (idec_on == 1) then
  kbit	   ctrl7	1, 1, 1, 16
  ksrate   ctrl7	1, 7, 11025, 44100

  kbits    = idec_bitrate^kbit
  kfold    = (idec_samps/ksrate)

  kin_l    downsamp  a1
  kin_l    = (kin_l + 1)
  kin_l    = kin_l*(kbits / 2)
  kin_l    = int(kin_l)
  a1       upsamp  kin_l
  a1       = a1 * (2/kbits) - 1

  kin_r    downsamp  a2
  kin_r    = (kin_r + 1)
  kin_r    = kin_r*(kbits / 2)
  kin_r    = int(kin_r)
  a2       upsamp  kin_r
  a2       = a2 * (2/kbits) - 1

  a1      fold  a1, kfold
  a2      fold  a2, kfold
elseif (idec_on == 2) then
  kfold   linseg  ifold_start, idur, ifold_end
  a1      fold  a1, kfold
  a2      fold  a2, kfold
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
  a2       flanger   a2, aflange, iflange_fb
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
  a2      phaser1   a2, kphase, 100, iphase_fb
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

aenv_sig_l = aadsr * afadeout * (1 - alfo) * a1
aenv_sig_r = aadsr * afadeout * (1 - alfo) * a2


; =============================================================================
; Compressor
; =============================================================================

if (icomp_ratio <= 1) then
  afinal_l = aenv_sig_l
  afinal_r = aenv_sig_r
else
  afinal_l    compress  aenv_sig_l, aenv_sig_l, icomp_thresh, icomp_loknee, icomp_hiknee, icomp_ratio, icomp_att, icomp_rel, icomp_look
  afinal_r    compress  aenv_sig_r, aenv_sig_r, icomp_thresh, icomp_loknee, icomp_hiknee, icomp_ratio, icomp_att, icomp_rel, icomp_look
endif

; =============================================================================
; EQ
; =============================================================================

if (ieq_on != 0) then
  afinal_l    pareq     afinal_l, ieq_freq, ieq_gain, ieq_q, ieq_mode
  afinal_r    pareq     afinal_r, ieq_freq, ieq_gain, ieq_q, ieq_mode
endif


; =============================================================================
; Panned Outputs
; =============================================================================

if (ipan_start == ipan_end) then
  kpan = ipan_start
else
  kpan     linseg  ipan_start, ipan_dur, ipan_end
endif

apan_l  = (1 - kpan) * (2 * ((afinal_l * (1 - (kpan * .5))) + (afinal_r * (kpan * .5))))
apan_r  = (kpan) * (2 * ((afinal_l * (1 - (kpan * .5))) + (afinal_r * (kpan * .5))))

outs      apan_l, apan_r

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
;p8  f-table function number
;p9  sample skiptime
;p10 sampler mode   0 = paulstretch, 1 = paulstretch loop, 2 = flooper, 3 = fog

; PITCH
;p11  pitch start    relative to sample pitch, which is 1
;p12  pitch end
;p13  pitch duration

; VIBRATO
;p14 average amplitude value of vibrato
;p15 average frequency value of vibrato (in cps)
;p16 amount of random amplitude deviation
;p17 amount of random frequency deviation
;p18 vibrato attack
;p19 vibrato decay
;p20 vibrato sustain
;p21 vibrato release
;p22 f-table function for vibrato shape

; FLOOPER
;p23 loop start time
;p24 loop size start
;p25 loop size end
;p26 loop size duration     0 turns off looping
;p27 loop crossfade length
;p28 loop mode    0 forward, 1 backward, 2 back-and-forth

; PAULSTRETCH
;p29 loop skiptime percentage   range 0 - 1
;p30 loop stretch    default value = 1
;p31 loop filename   for filelen

; FOG
;p32 grain density in grains per second
;p33 grain speed    range 0 - 1
;p34 grain octaviation   range 0+
;p35 grain envelope rise time
;p36 grain envelope duration
;p37 grain envelope decay
;p38 grain legato on = 1, off = 0
;p39 grain shape f-table function

; LOWPASS FILTERS
;p40 lowpass type, off = 0, range = 0 - 8
;p41 lp distortion, for lp type 1    range 0 - 1+
;p42 lp feedback, for lp type 8      range 0 - 17
;p43 lp q, for lp type 5             range 1 - 10
;p44 lp stack, for lp type 7         range 1+

;p45 lp cutoff freq in hz
;p46 lp cutoff attack time
;p47 lp cutoff decline time
;p48 lp cutoff sustain freq in hz
;p49 lp cutoff release time
;p50 lp resonance value,   range 0 - 1
;p51 lp resonance attack time
;p52 lp resonance decline time
;p53 lp resonance sustain value, range 0 - 1
;p54 lp resonance release time

; HIGHPASS FILTERS
;p55 hp type, off = 0, range = 0 - 3
;p56 hp cutoff freq in hz
;p57 hp cutoff attack time
;p58 hp cutoff decline time
;p59 hp cutoff sustain freq in hz
;p60 hp cutoff release time
;p61 hp cutoff q, for hp type 3     range 1 - 10

; DISTORTION
;p62 distortion on = 1, off = 0
;p63 distortion value,    range 0 - 1
;p64 distortion attack time
;p65 distortiom decline time
;p66 distortion sustain value,   range 0 - 1
;p67 distortion release time
;p68 distortion shape function

; BITCRUSHER
;p69 bitcrusher type, off = 0
;p70 decimator bitrate, range 1 - 32
;p71 decimator samples
;p72 fold start value, amount of foldover expressed in multiple of sampling rate. range 1+
;p73 fold end value

; FLANGER
;p74 flanger on = 1, off = 0
;p75 flanger delay time value
;p76 flanger delay attack time
;p77 flanger delay decline time
;p78 flanger delay time sustain value
;p79 flanger release time
;p80 flanger feedback, range 0 - 1

; PHASER
;p81 phaser on = 1, off = 0
;p82 phaser freq in hz
;p83 phaser attack time
;p84 phaser decline time
;p85 phaser sustain freq in hz
;p86 phaser release time
;p87 phaser feedback, range -1 - 1

; LFO / TREMOLO
;p88 lfo start freq in hz, off = 0
;p89 lfo end freq in hz
;p90 lfo shape,  sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5
;p91 lfo attack time
;p92 lfo decline time
;p93 lfo sustain amplitude
;p94 lfo release time

; AMPLITUDE ENVELOPE
;p95 adsr attack time
;p96 adsr decay value
;p97 adsr sustain volume, range 0 - 1
;p98 adsr release time

; COMPRESSOR
;p99  compression ratio, a value of <= 1 will cause no compression
;p100 compressor threshold, normally <= 0
;p101 compressor low knee in db
;p102 compressor high knee in db
;p103 compressor attack time
;p104 compressor release time
;p105 compressor lookahead time, typical value is 0.5

; EQ
;p106 eq on = 1, off = 0
;p107 eq freq in hz
;p108 eq gain in db
;p109 eq q, range 0 - 1
;p110 eq mode, 0 = peaking, 1 = low shelf, 2 = high shelf


; =============================================================================
; SCORE
; =============================================================================

i"sampler_1"       0      5       1       .5     .5     [1/1]  101  0     2     ; instrument
.8          .8     [1/2]                                                        ; pitch
0           10     0      0       [1/2]   [1/4]   3     [0]    1                ; vibrato
0           [1/1]  [1/132]        [1/1]   0.001   0                             ; timing / loop
0           [1/4]         "samples/amen.wav"                                    ; tempo stretch loop
20          .001   1      .05     .2      .001    0     1                       ; grain
0           0.25   15     9.0     20                                            ; lowpass settings
            5000   [1/4]  [1/2]   500     [1/4]   0.5   [1/4] [1/2] 0.8 [1/4]   ; lowpass cutoff / res
0           5000   [1/4]  [1/2]   100     [1/4]   9.5                           ; highpass
0           1      [1/4]  [1/2]   .2      [1/4]   1                             ; distortion
0           32     20     30      2                                             ; bitcrusher
0           0.8    [1/4]  [1/2]   .3      [1/4]   .5                            ; flanger
0           5000   [1/4]  [1/2]   100     [1/4]   0.8                           ; phaser
0           8      0      [1/4]   [1/2]   1       [1/4]                         ; tremolo / amp lfo
[0]        [0]     1      [0]                                                   ; adsr
0           0      45     60      0.1     0.5     .05                           ; Compressor
0           1000   -100   1       0                                             ; EQ

e

</CsScore>
</CsoundSynthesizer>
