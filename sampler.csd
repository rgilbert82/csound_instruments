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

	xout      a0ut * 0.0002
endop

; =============================================================================
; F Tables
; =============================================================================

gisine     ftgen 1, 0, 16384, 10, 1	;sine wave
gisquare   ftgen 2, 0, 16384, 10, 1, 0 , .33, 0, .2 , 0, .14, 0 , .11, 0, .09 ;odd harmonics
gisaw      ftgen 3, 0, 16384, 10, 0, .2, 0, .4, 0, .6, 0, .8, 0, 1, 0, .8, 0, .6, 0, .4, 0,.2 ;even harmonics
gihanning  ftgen 4, 0, 8192,  20, 2, 1  ;Hanning function
gisigmoid  ftgen 5, 0, 1024,  19, .5, .5, 270, .5    ; Sigmoid
gisquare2  ftgen 6, 0, 16384, 10, 1, 0, 0.3, 0, 0.2, 0, 0.14, 0, .111 ; Square wave
gisaw2     ftgen 7, 0, 16384, 10, 1, 0.5, 0.3, 0.25, 0.2, 0.167, 0.14, 0.125, .111 ; Saw
gipulse    ftgen 8, 0, 16384, 10, 1, 1, 1, 1, 0.7, 0.5, 0.3, 0.1
ginoise    ftgen 9,0,2^10,9, 1,2,0, 3,2,0, 9,0.333,180
giadd1     ftgen 10, 0, 16384, 11, 1, 1
giadd2     ftgen 11, 0, 16384, 11, 10, 1, .7
giadd3     ftgen 12, 0, 16384, 11, 10, 5, 2
gicubic1   ftgen 13, 0, 513, 6, 1, 128, -1, 128, 1, 64, -.5, 64, .5, 16, -.5, 8, 1, 16, -.5, 8, 1, 16, -.5, 84, 1, 16, -.5, 8, .1, 16, -.1, 17, 0
gicubic2   ftgen 14, 0, 513, 6, 0, 128, 0.5, 128, 1, 128, 0, 129, -1
giexpon1   ftgen 15, 0, 129, 5, 1, 100, 0.0001, 29
giexpon2   ftgen 16, 0, 129, 5, 0.00001, 87, 1, 22, .5, 20, 0.0001
gidist     ftgen 17, 0, 257, 9, .5,1,270
gioctblend ftgen 18, 0, 1024, -19, 1, 0.5, 270, 0.5
gifof1     ftgen 19,  0, 1024, 19, 0.5, 0.5, 270, 0.5    ; Sigmoid for FOF
gifof2     ftgen 20,  0, 1024, 7, 0, 512, 1, 0, -1, 512, 0  ; for FOF


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
ipan_dur      = p7
isample       = p8
iskiptime     = p9
isampler_mode = p10

ipitch_start  = p11
ipitch_end    = p12
ipitch_dur    = p13

ivib_avg_amp  = p14
ivib_avg_freq = p15
ivib_rand_amp = p16
ivib_rand_freq= p17
ivib_att      = p18
ivib_dec      = p19
ivib_sust     = p20
ivib_rel      = p21
ivib_fnc      = p22

iloop_start   = p23
iloop_size_1  = p24
iloop_size_2  = p25
iloop_size_dur= p26
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
ilp_cut_att   = p46
ilp_cut_dec   = p47
ilp_cut_sust  = p48
ilp_cut_rel   = p49
ilp_res       = p50
ilp_res_att   = p51
ilp_res_dec   = p52
ilp_res_sust  = p53
ilp_res_rel   = p54

ihighpass_on  = p55
ihp_cut       = p56
ihp_cut_att   = p57
ihp_cut_dec   = p58
ihp_cut_sust  = p59
ihp_cut_rel   = p60
ihp_q         = p61

idist_on      = p62
idist         = p63
idist_att     = p64
idist_dec     = p65
idist_sust    = p66
idist_rel     = p67
idist_fnc     = p68

idec_on       = p69
idec_bitrate  = p70
idec_samps    = p71
ifold_start   = p72
ifold_end     = p73

iflange_on    = p74
iflange       = p75
iflange_att   = p76
iflange_dec   = p77
iflange_sust  = p78
iflange_rel   = p79
iflange_fb    = p80

iphase_on     = p81
iphase        = p82
iphase_att    = p83
iphase_dec    = p84
iphase_sust   = p85
iphase_rel    = p86
iphase_fb     = p87

ilfo_start    = p88
ilfo_end      = p89
ilfo_shape    = p90
ilfo_att      = p91
ilfo_dec      = p92
ilfo_sust     = p93
ilfo_rel      = p94

iattack       = p95
idecay        = p96
isustain_vol  = p97
irelease      = p98

icomp_thresh  = p99
icomp_loknee  = p100
icomp_hiknee  = p101
icomp_ratio   = p102
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

i101 ftgenonce 0, 0, 524288, 1, "amen.wav",     iskiptime, 0, 2
; add other samples here


if (isample == 101) then
  isample = i101
endif

ichannels = ftchnls(p8)


; =============================================================================
; Pitch ramp
; =============================================================================

kpitch_ramp   line      ipitch_start, ipitch_dur, ipitch_end


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
; Sample length ramp
; =============================================================================

kloop    expseg    iloop_start + iloop_size_1, iloop_size_dur, iloop_start + iloop_size_2


; =============================================================================
; Stereo audio file reader
; =============================================================================

if (isampler_mode == 2) then
  iidx    =	sr/ftlen(1) ;scaling to reflect sample rate and table length
  aspd    phasor iidx * igrain_speed ;index for speed
  a1      fog    iamp, igrain_dens, kpitch, aspd, igrain_oct, 0, igrain_rise, igrain_dur, igrain_dec, 30, isample, igrain_shape, idur,  1, 0, igrain_legato
  a2      fog    iamp, igrain_dens, kpitch, aspd, igrain_oct, 0, igrain_rise, igrain_dur, igrain_dec, 30, isample, igrain_shape, idur, .5, 0, igrain_legato
elseif (isampler_mode == 1) then
  a1      paulstretch iloop_length, 0.02, isample
  a2 = a1
elseif (ichannels == 1 && isampler_mode == 0) then
  a1      flooper2  iamp, kpitch, iloop_start, kloop, iloop_cross, \
                    isample, 0, iloop_mode
  a2 = a1
elseif (ichannels == 2 && isampler_mode == 0) then
  a1, a2  flooper2  iamp, kpitch, iloop_start, kloop, iloop_cross, \
                    isample, 0, iloop_mode
else
  a1 = 0
  a2 = 0
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
  a1 = a1 * 3
  a2 = a2 * 3
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

if (idist_att == 0) then
  kdist   linsegr   idist, idist_dec, idist_sust, idist_rel, 0
else
  kdist   linsegr   0, idist_att, idist, idist_dec, idist_sust, idist_rel, 0
endif

if (idist_on == 1) then
  a1      distort   a1, kdist, idist_fnc
  a2      distort   a2, kdist, idist_fnc
endif


; =============================================================================
; Bitcrusher
; =============================================================================

if (idec_on == 1) then
  a1      decimator a1, idec_bitrate, idec_samps
  a2      decimator a2, idec_bitrate, idec_samps
elseif (idec_on == 2) then
  kfold   line  ifold_start, idur, ifold_end
  a1      fold  a1, kfold
  a2      fold  a2, kfold
endif


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
  a2       flanger   a2, aflange, iflange_fb
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
  a2      phaser1   a2, kphase, 100, iphase_fb
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
aenv_sig_l = aadsr * afadeout * (1 - alfo) * a1
aenv_sig_r = aadsr * afadeout * (1 - alfo) * a2


; =============================================================================
; Compressor
; =============================================================================

afinal_l    compress  aenv_sig_l, aenv_sig_l, icomp_thresh, icomp_loknee, icomp_hiknee, icomp_ratio, icomp_att, icomp_rel, icomp_look
afinal_r    compress  aenv_sig_r, aenv_sig_r, icomp_thresh, icomp_loknee, icomp_hiknee, icomp_ratio, icomp_att, icomp_rel, icomp_look


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
  kpan     line  ipan_start, ipan_dur, ipan_end
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
;p10 sampler mode   0 = flooper, 1 = paulstretch, 2 = fog

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
;p40 lowpass type, off = 0
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
;p55 hp type, off = 0
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
;p99  compressor threshold, normally <= 0
;p100 compressor low knee in db
;p101 compressor high knee in db
;p102 compression ratio, a value of 1 will cause no compression
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

i"sampler_1"       0      5       .9      0.5     0.5   1    101  0     1   \   ; instrument
.8          .7     5      \                                                     ; pitch
0           10     .5     .1      .1      1       0     0    1    \             ; vibrato
0           5      5      5       0.001   0       \                             ; timing / loop
0           [1/2]         "amen.wav"      \                                     ; tempo stretch loop
20          .001   1      .05     .2      .001    0     1    \                  ; grain
0           0.25   15     9.0     20      \                                     ; lowpass settings
            5000   0      .5      500     4       0.5   0    0.1  0.8   4   \   ; lowpass cutoff / res
0           5000   0      1       100     3       9.5    \                      ; highpass
0           1      0      1       .2      2       1      \                      ; distortion
0           8      20     30      2       \                                     ; bitcrusher
0           0.8    0      2       .3      1       .5     \                      ; flanger
0           5000   0      2       100     2       0.8    \                      ; phaser
0           0      0     .1       1       2       0      \                      ; tremolo / amp lfo
0.01        0.03   .4     4       \                                             ; adsr
0           45     60     1       0.1     0.5     .05    \                      ; Compressor
0           1000   -100   1       0       \                                     ; EQ
\

e

</CsScore>
</CsoundSynthesizer>
