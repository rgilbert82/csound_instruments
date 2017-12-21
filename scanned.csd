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

; For Scanner
gi501      ftgen 501, 0, 128, 7, 0, 64, 1, 64, 0			; Initial condition
gi502      ftgen 502, 0, 128, -7, 1, 128, 0.3			    ; Masses
gi503      ftgen 503, 0, 128, -7, 2, 4, 0, 124, 2		  ; Centering force, also 501, 502, 504
gi504      ftgen 504, 0, 128, -7, 1, 128, 0			      ; Damping
gi505      ftgen 505, 0, 128, -7, -.0, 128, 0			    ; Initial velocity

gi550      ftgen 550, 0, 16384, -23, "matrices/cylinder-128,8"	     ; Spring matrices
gi551      ftgen 551, 0, 16384, -23, "matrices/circularstring-128"	 ; Spring matrices
gi552      ftgen 552, 0, 16384, -23, "matrices/full-128"             ; Spring matrices
gi553      ftgen 553, 0, 16384, -23, "matrices/grid-128,8"	         ; Spring matrices
gi554      ftgen 554, 0, 16384, -23, "matrices/string-128"	         ; Spring matrices
gi555      ftgen 555, 0, 16384, -23, "matrices/torus-128,8"	         ; Spring matrices
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
; SCANNER
; =============================================================================

instr 2

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
isample          = p36
isample_pitch    = p37
isample_stretch  = p38
isample_skiptime = p39 / isample_stretch
ivcdr_max        = p40
ivcdr_min        = p41
ivcdr_q          = p42
ivcdr_band       = p43
ivcdr_cnt        = p44

ilowpass_on   = p45
ilp_dist      = p46
ilp_fb        = p47
klp_q         = p48
ilp_stack     = p49

ilp_cut       = p50
ilp_cut_att   = p51 * idur
ilp_cut_dec   = p52 * idur
ilp_cut_sust  = p53
ilp_cut_rel   = p54 * idur
ilp_res       = p55
ilp_res_att   = p56 * idur
ilp_res_dec   = p57 * idur
ilp_res_sust  = p58
ilp_res_rel   = p59 * idur

ihighpass_on  = p60
ihp_cut       = p61
ihp_cut_att   = p62 * idur
ihp_cut_dec   = p63 * idur
ihp_cut_sust  = p64
ihp_cut_rel   = p65 * idur
ihp_q         = p66

idist_on      = p67
idist         = p68
idist_att     = p69 * idur
idist_dec     = p70 * idur
idist_sust    = p71
idist_rel     = p72 * idur
idist_fnc     = p73

idec_on       = p74
idec_bitrate  = p75
idec_samps    = p76
ifold_start   = p77
ifold_end     = p78

iflange_on    = p79
iflange       = p80
iflange_att   = p81 * idur
iflange_dec   = p82 * idur
iflange_sust  = p83
iflange_rel   = p84 * idur
iflange_fb    = p85

iphase_on     = p86
iphase        = p87
iphase_att    = p88 * idur
iphase_dec    = p89 * idur
iphase_sust   = p90
iphase_rel    = p91 * idur
iphase_fb     = p92

ilfo_start    = p93
ilfo_end      = p94
ilfo_shape    = p95
ilfo_att      = p96 * idur
ilfo_dec      = p97 * idur
ilfo_sust     = p98
ilfo_rel      = p99 * idur

iattack       = p100 * idur
idecay        = p101 * idur
isustain_vol  = p102
irelease      = p103 * idur

kpos        = abs(birnd(1))
aout        = 0

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
; Scan
; =============================================================================

      scanu iscan_init, irate, iscan_vel, iscan_mass, iscan_stiff, iscan_cntr, iscan_damp, imass, .01, icenter, idamp, .1, .9, kpos, 0, aout, 1, 0
asig  scans iamp, kpitch, iscan_traj , 0
aoscs limit asig, 0, 1


; =============================================================================
; Vocoder
; =============================================================================

if (ivcdr_on != 0) then
  if (isample_pitch == 0) then
    avcdr_sig   paulstretch isample_stretch, 0.02, isample
  endif

  kratio = 3
  avcdr_sig   compress avcdr_sig, avcdr_sig, 0, 48, 60, kratio, .1, .5, .02
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
; Outs
; =============================================================================

outs apan_l, apan_r

endin

</CsInstruments>
<CsScore>

s
i2      0       6       .9      7.00    0.00    [1/1]   10    [1/1]             ; Instrument
.5      .5      [2/1]   0       0                                               ; Pan
0       8       0       0       [1/2]   [1/4]   3       [0]    1                ; vibrato
.02     5       0.01    -0.07                                                   ; Scanner Params
501     503     504     505     502     550     561                             ; Scanner Functions
0       101     0       1       0       9000    100     10     50      2        ; Vocoder
0       0.25    15      9.0     20                                              ; lowpass settings
5000    [1/4]   [1/2]   500     [1/4]   0.5     [0]     [0]  0.8       [1/2]    ; lowpass cutoff / res
0       5000    [1/4]   [1/2]   100     [1/4]   9.5                             ; highpass
0       1       [1/4]   [1/2]   .2      [1/4]   1                               ; distortion
0       16      20      30      2                                               ; bitcrusher
0       0.8     [1/4]   [1/2]   .3      [1/4]   .5                              ; flanger
0       5000    [1/4]   [1/2]   100     [1/4]   0.8                             ; phaser
0       8       0       [1/4]   [1/2]   1       [1/4]                           ; tremolo / amp lfo
[0]     [0]     1       [0]                                                     ; adsr


i2      6       10      .9      2.00    6.00    [1/1]   10    [1/1]             ; Instrument
.5      .5      [0]     0       0                                               ; Pan
0       8       0       0       [1/2]   [1/4]   3       [0]    1                ; vibrato
.05     .5      0.001   -0.07      	                                            ; Scanner Params
501     503     504     505     502     550     561                             ; Scanner Functions
0       101     0       1       0       9000    100     10     50      2        ; Vocoder
0       0.25    15      9.0     20                                              ; lowpass settings
5000    [1/4]   [1/2]   500     [0]     0.5     [0]     [1/4]  0.8     [1/2]    ; lowpass cutoff / res
0       5000    [1/4]   [1/2]   100     [1/4]   9.5                             ; highpass
0       1       [1/4]   [1/2]   .2      [1/4]   1                               ; distortion
0       16      20      30      2                                               ; bitcrusher
0       0.8     [1/4]   [1/2]   .3      [1/4]   .5                              ; flanger
0       5000    [1/4]   [1/2]   100     [1/4]   0.8                             ; phaser
0       8       0       [1/4]   [1/2]   1       [1/4]                           ; tremolo / amp lfo
[0]     [0]     1       [0]                                                     ; adsr


e
</CsScore>
</CsoundSynthesizer>
