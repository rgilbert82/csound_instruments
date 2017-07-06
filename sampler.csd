<CsoundSynthesizer>
<CsOptions>
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

gisine     ftgen 1, 0, 16384, 10, 1	;sine wave
gisquare   ftgen 2, 0, 16384, 10, 1, 0 , .33, 0, .2 , 0, .14, 0 , .11, 0, .09 ;odd harmonics
gisaw      ftgen 3, 0, 16384, 10, 0, .2, 0, .4, 0, .6, 0, .8, 0, 1, 0, .8, 0, .6, 0, .4, 0,.2 ;even harmonics
gihanning  ftgen 4, 0, 8192,  20, 2, 1  ;Hanning function
gisigmoid  ftgen 5, 0, 1024,  19, .5, .5, 270, .5    ; Sigmoid

;
; ULTIMATE SAMPLER!
;

instr 1

; Samples
gi101 ftgen 101, 0, 131072, 1, "audio_file_name.wav",    p21, 0, 0

idur          = p3
iamp          = p4
ipan_start    = p5
ipan_end      = p6
ipan_dur      = p7
ichannels     = ftchnls(p8)
isample       = p8

ipitch_start  = p9
ipitch_end    = p10
ipitch_dur    = p11

ivib_avg_amp  = p12
ivib_avg_freq = p13
ivib_rand_amp = p14
ivib_rand_freq= p15
ivib_att      = p16
ivib_dec      = p17
ivib_sust     = p18
ivib_rel      = p19
ivib_fnc      = p20

iskiptime     = p21
iloop_start   = p22
iloop_size_1  = p23
iloop_size_2  = p24
iloop_size_dur= p25
iloop_cross   = p26
iloop_mode    = p27

igrain_on     = p28
igrain_dens   = p29
igrain_speed  = p30
igrain_oct    = p31
igrain_rise   = p32
igrain_dur    = p33
igrain_dec    = p34
igrain_legato = p35
igrain_shape  = p36

ilowpass_on   = p37
ilp_cut_start = p38
ilp_cut_end   = p39
ilp_cut_dur   = p40
ilp_res_start = p41
ilp_res_end   = p42
ilp_res_dur   = p43
ilp_dist      = p44

ihighpass_on  = p45
ihp_cut_start = p46
ihp_cut_end   = p47
ihp_cut_dur   = p48

idist_start   = p49
idist_end     = p50
idist_dur     = p51
idist_fnc     = p52

idec_on       = p53
idec_bitrate  = p54
idec_samps    = p55

iflange_on    = p56
iflange_start = p57
iflange_end   = p58
iflange_dur   = p59
iflange_fb    = p60

iphase_on     = p61
iphase_start  = p62
iphase_end    = p63
iphase_dur    = p64
iphase_fb     = p65

iattack       = p66
irelease      = p67
ivol1         = p68
ivol2         = p69
ivol3         = p70
islope1       = p71
islope2       = p72
islope3       = p73

ilfo_start    = p74
ilfo_end      = p75
ilfo_shape    = p76
ilfo_att      = p77
ilfo_dec      = p78
ilfo_sust     = p79
ilfo_rel      = p80

icomp_thresh  = p81
icomp_loknee  = p82
icomp_hiknee  = p83
icomp_ratio   = p84
icomp_att     = p85
icomp_rel     = p86
icomp_look    = p87

ieq_on        = p88
ieq_freq      = p89
ieq_gain      = ampdb(p90)
ieq_q         = p91
ieq_mode      = p92

isend_1       = p93
isend_2       = p94
isend_3       = p95
isend_4       = p96
isend_5       = p97


; Pitch ramp
kpitch_ramp   line      ipitch_start, ipitch_dur, ipitch_end

; Vibrato
if (ivib_avg_amp == 0) then
  kpitch = kpitch_ramp
else
  kvib_env   adsr      ivib_att, ivib_dec, ivib_sust, ivib_rel
  kvib       vibrato   ivib_avg_amp, ivib_avg_freq, ivib_rand_amp, ivib_rand_freq, 3, 5, 3, 5, ivib_fnc
  kpitch = kpitch_ramp + (kvib * kvib_env)
endif

; Sample length ramp
kloop    expseg    iloop_start + iloop_size_1, iloop_size_dur, iloop_start + iloop_size_2

; Stereo audio file reader
if (igrain_on == 1) then
  iidx    =	sr/ftlen(1) ;scaling to reflect sample rate and table length
  aspd    phasor iidx * igrain_speed ;index for speed
  a1      fog    iamp, igrain_dens, kpitch, aspd, igrain_oct, 0, igrain_rise, igrain_dur, igrain_dec, 30, isample, igrain_shape, idur,  1, 0, igrain_legato
  a2      fog    iamp, igrain_dens, kpitch, aspd, igrain_oct, 0, igrain_rise, igrain_dur, igrain_dec, 30, isample, igrain_shape, idur, .5, 0, igrain_legato
elseif (ichannels == 1 && iloop_size_dur == 0) then
  a1      loscil    iamp, kpitch, isample, 1, 0
  a2 = a1
elseif (ichannels == 1) then
  a1      flooper2  iamp, kpitch, iloop_start, kloop, iloop_cross, \
                    isample, 0, iloop_mode
  a2 = a1
elseif (ichannels == 2 && iloop_size_dur == 0) then
  a1, a2  loscil    iamp, kpitch, isample, 1, 0
elseif (ichannels == 2) then
  a1, a2  flooper2  iamp, kpitch, iloop_start, kloop, iloop_cross, \
                    isample, 0, iloop_mode
else
  a1 = 0
  a2 = 0
endif

; Lowpass Filter
if (ilowpass_on == 0) then
  a3 = a1
  a4 = a1
else
  klp_cut line      ilp_cut_start, ilp_cut_dur, ilp_cut_end
  klp_res line      ilp_res_start, ilp_res_dur, ilp_res_end
  a3      lpf18     a1, klp_cut, klp_res, ilp_dist
  a4      lpf18     a2, klp_cut, klp_res, ilp_dist
endif

;Highpass Filter
if (ihighpass_on == 0) then
  a5 = a3
  a6 = a4
else
  khp_cut line      ihp_cut_start, ihp_cut_dur, ihp_cut_end
  a5      butterhp  a3, khp_cut
  a6      butterhp  a4, khp_cut
endif

; Distortion
if (idist_start == 0 && idist_end == 0) then
  a7 = a5
  a8 = a6
elseif (idist_start == 0 || idist_end == 0) then
  kdist   line      idist_start, idist_dur, idist_end
  a7      distort   a5, kdist, idist_fnc
  a8      distort   a6, kdist, idist_fnc
else
  kdist   expon     idist_start, idist_dur, idist_end
  a7      distort   a5, kdist, idist_fnc
  a8      distort   a6, kdist, idist_fnc
endif

; Bitcrusher
if (idec_on == 0) then
  a9 = a7
  a10 = a8
else
  a9      decimator a7, idec_bitrate, idec_samps
  a10     decimator a8, idec_bitrate, idec_samps
endif

; Flanger
if (iflange_on == 0) then
  a11 = a9
  a12 = a10
else
  aflange  line      iflange_start, iflange_dur, iflange_end
  a11      flanger   a9, aflange, iflange_fb
  a12      flanger   a10, aflange, iflange_fb
endif

; Phaser
if (iphase_on == 0) then
  a13 = a11
  a14 = a12
else
  kphase  line      iphase_start, iphase_dur, iphase_end
  a13      phaser1   a11, kphase, 100, iphase_fb
  a14      phaser1   a12, kphase, 100, iphase_fb
endif

; Enveloped Signals
klfo_ramp line      ilfo_start, idur, ilfo_end

if (ilfo_start == 0) then
  alfo = 0
else
  klfo_env   adsr      ilfo_att, ilfo_dec, ilfo_sust, ilfo_rel
  alfo       lfo       klfo_env, klfo_ramp, ilfo_shape
endif

aenv      transeg   0.0001, iattack, islope1, ivol1, (idur - iattack - irelease), islope2, ivol2, irelease, islope3, ivol3
afadeout  linseg    1, idur - 0.05, 1, 0.05, 0

aenvsig_l  = aenv * afadeout * (1 - alfo) * a13
aenvsig_r  = aenv * afadeout * (1 - alfo) * a14

; Compressor
acomp_l  compress  aenvsig_l, aenvsig_l, icomp_thresh, icomp_loknee, icomp_hiknee, icomp_ratio, icomp_att, icomp_rel, icomp_look
acomp_r  compress  aenvsig_r, aenvsig_r, icomp_thresh, icomp_loknee, icomp_hiknee, icomp_ratio, icomp_att, icomp_rel, icomp_look

; EQ
if (ieq_on == 0) then
  afinal_l = acomp_l
  afinal_r = acomp_r
else
  afinal_l    pareq     acomp_l, ieq_freq, ieq_gain, ieq_q, ieq_mode
  afinal_r    pareq     acomp_r, ieq_freq, ieq_gain, ieq_q, ieq_mode
endif

; Panned Outputs
if (ipan_start == ipan_end) then
  kpan = ipan_start
else
  kpan     line  ipan_start, ipan_dur, ipan_end
endif

apan_l  = (1 - kpan) * (2 * ((afinal_l * (1 - (kpan * .5))) + (afinal_r * (kpan * .5))))
apan_r  = (kpan) * (2 * ((afinal_l * (1 - (kpan * .5))) + (afinal_r * (kpan * .5))))

outs      apan_l, apan_r

endin

</CsInstruments>
<CsScore>

; INSTRUMENT
;p1  instr
;p2  start time
;p3  duration
;p4  amplitude    range 0 - 1
;p5  pan start    range 0 - 1
;p6  pan end      range 0 - 1
;p7  pan duration
;p8  f-table function number

; PITCH
;p9  pitch start    relative to sample pitch, which is 1
;p10  pitch end
;p11  pitch duration

; VIBRATO
;p12 average amplitude value of vibrato
;p13 average frequency value of vibrato (in cps)
;p14 amount of random amplitude deviation
;p15 amount of random frequency deviation
;p16 vibrato attack
;p17 vibrato decay
;p18 vibrato sustain
;p19 vibrato release
;p20 f-table function

; TIMING
;p21 skiptime
;p22 loop start time
;p23 loop size start
;p24 loop size end
;p25 loop size duration     0 turns off looping
;p26 loop crossfade length
;p27 loop mode    0 forward, 1 backward, 2 back-and-forth

; GRAIN
;p28 grain    on = 1, off = 0
;p29 grain density in grains per second
;p30 grain speed    range 0 - 1
;p31 grain octaviation   range 0+
;p32 grain envelope rise time
;p33 grain envelope duration
;p34 grain envelope decay
;p35 grain legato on = 1, off = 0
;p36 grain shape f-table function

; LOWPASS FILTER
;p37 filter on = 1, off = 0
;p38 cutoff start freq in Hz
;p39 cutoff end freq in Hz
;p40 cutoff duration
;p41 resonance start value, between 0 - 1, 1+ for dist
;p42 resonance end value
;p43 resonance duration
;p44 lowpass distortion   range 0+

; HIGHPASS FILTER
;p45 filter on = 1, off = 0
;p46 cutoff start freq in Hz
;p47 cutoff end freq in Hz
;p48 cutoff duration

; DISTORTION
;p49 dist start value   range 0 - 1     Dist off if start and end are both 0
;p50 dist end value     range 0 - 1
;p51 dist env duration
;p52 dist f-table function

; BITCRUSHER
;p53 bitcrusher  on = 1, off = 0
;p54 bitrate     range 1 - 16
;p55 samples

; FLANGER
;p56 flanger on = 1, off = 0
;p57 flanger start delay in seconds  (small values, ie 0.02)
;p58 flanger end delay in seconds
;p59 flanger delay ramp duration
;p60 flanger feedback   range 0 - 1

; PHASER
;p61 phaser on = 1, off = 0
;p62 phaser start freq in Hz
;p63 phaser end freq in Hz
;p64 phaser duration
;p65 phaser feedback    range 0 - 1

; ENVELOPE
;p66 attack
;p67 fadeout
;p68 vol 1
;p69 vol 2
;p70 vol 3
;p71 slope 1      0 is a straight line, - for steeper, + for less steep
;p72 slope 2
;p73 slope 3

; LFO
;p74 lfo start pitch in Hz    0 = off
;p75 lfo end pitch in Hz
;p76 lfo shape       0 = sine, 1 = tri, 2 = square, 3 = square uni, 4 = saw up, 5 = saw down
;p77 lfo attack
;p78 lfo decay
;p79 lfo sustain
;p80 lfo release

; COMPRESSOR
;p81 threshold in dB, usually 0 or below
;p82 low knee, decibel breakpoint denoting where compression or expansion will begin
;p83 high knee, decibel breakpoint denoting where compression or expansion will begin
;p84 ratio of compression when the signal is above the knee
;p85 compressor attack in seconds
;p86 compressor release in seconds
;p87 lookahead time in seconds

; EQ
;p88 EQ on = 1, off = 0
;p89 EQ frequency
;p90 EQ gain in dB
;p91 Q  range 0 - 1
;p92 EQ mode  0 = peaking, 1 = low shelf, 2 = high shelf

; SENDS   range 0 - 1
;p93 send 1
;p94 send 2
;p95 send 3
;p96 send 4
;p97 send 5


;
; SCORE
;

i1    0       10      .9     0.5   0.5   1      101   \         ; instrument
      .8      0.5     3      \                                  ; pitch
      0       10      .5     .1    .1    1      0     0   1  \  ; vibrato
      0       0       0.01   1     4     0.001  2     \         ; timing / loop
      0       20      .001   1     .01   .2     .001  0  1   \  ; grain
      0       200     4000   1     1     .5     1     0  \      ; lowpass
      0       40      5000   3     \                            ; highpass
      0       1       5      1     \                            ; distortion
      0       16      20     \                                  ; bitcrusher
      0       0       0      0     0     \                      ; flanger
      0       1000    10000  3     0     \                      ; phaser
      0.0001  0.1     1      1     0     0      0     0   \     ; amp envelope
      0       0       0      0.1   3     2      0      \        ; tremolo / amp lfo
      0       40      80     3     0.1   0.5    .05    \        ; Compressor
      0       500     -100   0.75  0     \                      ; EQ
      0       0       0      0     0                            ; sends
\
e

</CsScore>

  ;2017 Ryan Gilbert
</CsoundSynthesizer>
