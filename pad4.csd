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
; =============================================================================
; F Tables
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
gi33       ftgen 33, 0,    1024,  7,  -1,  512, -1, 0, 1, 512, 1    ; Pulse

gi600      ftgen 600, 0, 8193, 8, 0, 512, 1, 1024, 1, 512, .5, 2048, .2, 4096, 0
gi601      ftgen 601, 0, 16, -2,    6, 5, 1, 12,         3, 9, -1, 6,   0, 5, 10, 0,    -1, 25, 3, 20
gi701      ftgen 701, 0, 16, -2,    1, 1, 1, .5, .5,     4,             1.5, .5, 1, 3,          1, 1
gi751      ftgen 751, 0, 16, -2,    1, 0, 0,  1,  0,     0,             0,   0,  1, 0,          1, 0


giadditive_freqs ftgen 999, 0, 32, 7, 0, 32, 0
giadditive_amps  ftgen 998, 0, 32, 7, 0, 32, 0

; =============================================================================
; =============================================================================
; PAD 4     ; GM Strings modified
; =============================================================================
; =============================================================================

instr pad4

; sine
itable1 ftgenonce 0,     0,       512,    10,       1
; linear rise
itable2 ftgenonce 0,     0,       513,     7,       0,       513,         1
; linear fall
itable3 ftgenonce 0,     0,       513,     7,       1,       513,         0
; attack function for vibamp
itable4 ftgenonce 0,     0,       513,     7,       0,       400,         1,       113,    .8
; attack function for vibamp
itable5 ftgenonce 0,     0,       513,     7,       0,       200,        .56,      250,     1,       63,     .85
; index rise function
itable6 ftgenonce 0,     0,       513,     5,      .001,     62,         .95,      61,     .55,      200,     1,       190,     .86
; attack function
itable7 ftgenonce 0,     0,       513,     5,      .001,     200,        .95,      156,    .7,       157,     1
; another oscil function
itable8 ftgenonce 0,     0,       513,     7,      0,     513,         .94,      765,     .82,      123,     .73,       765,	    .67,	467,	.53,	47,	.32,	111,	.20,	1246,	.1

iamp       = p4
icps1      = p5
icps2      = p6
ipch_dur   = p7
ipch_ramp  = p8
iscale     = p9
irel_idx   = p10
ienv_rise  = p11
irise_time = p12
iosc_func  = p13
ipan_start = p14
ipan_end   = p15
ipan_dur   = p16
ipan_freq  = p17
ipan_mode  = p18

ipitch    cps2pch  icps1, iscale
ipitch2   cps2pch  icps2, iscale

if (ipch_dur == 0) then
    ipch_dur = p3
endif

if (ipch_ramp == 0) then
  kpchline 	linseg ipitch, ipch_dur, ipitch2
else
  kpchline 	expseg ipitch, ipch_dur, ipitch2
endif

if (ipan_dur <= 0) then
    ipan_dur = p3
endif

kvamp     randi     .003,5,-1                ; VIBRATO DESIGN
kvstdy    oscil1i   0,.013,p3,itable4
kvibamp   =         kvstdy+kvamp+.003
kvfrq     randi     1,7,-1
ksfrq     oscil1i   .15,4.9,p3,itable5
kvibfrq   =         kvfrq+ksfrq+1
kvib      oscil     kvibamp,kvibfrq,itable1
ibasoct   =		octpch(icps1)
ksinc   	=		cpsoct(ibasoct+kvib)
iampfac   =         (iamp*.25)*.16             ; TREMOLO DESIGN
irfac     =         iampfac*.1
ktrnd     randi     irfac,4,-1
ktsamp    oscil1i   .41,iampfac,p3,itable4
ktamp     =         ktsamp+ktrnd+irfac
kvtfrq    randi     1,5,-1
kstfrq    oscil1i   .38,4,p3,itable5
ktfrq     =         kvtfrq+kstfrq+1
ktrem     oscil     ktamp,ktfrq,itable1
kamp      =         (iamp*.25)+ktrem
katamp    =         iamp*.1                    ; ATTACK NOISE
katramp   oscil1i   0,katamp,.12,itable3
katrand   randi     katramp,kpchline*.2,-1
knoise    oscil     katrand,2000,itable1,-1
kmod1hz   =         ksinc                    ; MAIN INSTRUMENT DESIGN
kmod2hz   =         ksinc*3
kmod3hz   =         ksinc*4
i1        =         7.5/log(ipitch)
i2        =         15/sqrt(ipitch)
i3        =         1.25/sqrt(ipitch)
indx1     =         i1*irel_idx
indx2     =         i2*irel_idx
indx3     =         i3*irel_idx
          if        (irise_time == 1) goto step1
kindx1c   envlpx    indx1,.02,p3,p3-.02,itable2,.999,.01
kindx2c   envlpx    indx2,.03,p3,p3-.03,itable2,.997,.01
kindx3c   envlpx    indx3,.04,p3,p3-.04,itable2,.998,.01
          goto      step2
step1:
kindx1c   envlpx    indx1,p3*.698,p3,p3*.302,itable6,.999,.01
kindx2c   envlpx    indx2,p3*.703,p3,p3*.297,itable6,.996,.01
kindx3c   envlpx    indx3,p3*.695,p3,p3*.305,itable6,.996,.01
step2:
kindex1   =         kindx1c*kmod1hz
kindex2   =         kindx2c*kmod2hz
kindex3   =         kindx3c*kmod3hz
amod1     oscil     kindex1,kmod1hz,itable1,-1
amod2     oscil     kindex2,kmod2hz,itable1,-1
amod3     oscil     kindex3,kmod3hz,itable1,-1
acarfrq   =         amod1+amod2+amod3+ksinc
astr      oscili    kamp,acarfrq,itable1,-1
asig      =         astr+knoise
ienvr     =         .17
ienvf     =         .21
ienvfn    =         itable2
          if        (ienv_rise == 2) igoto set2
          if        (ienv_rise == 3) igoto set3
          if        (ienv_rise == 4) igoto set4
          igoto     set1
set2:
ienvf     =         (p3-.17)*.95
          igoto     set1
set3:
ienvr     =         (p3-.21)*.9
ienvfn    =         itable7
          igoto     set1
set4:
ienvr     =         p3*.5
ienvf     =         p3*.5
ienvfn    =         itable7
set1:
asnd      envlpx    asig,ienvr,p3,ienvf,ienvfn,.998,.01
asnd2	  envlpx    asig,ienvr,p3,ienvf,ienvfn,.957,.0432
asine     oscili    iamp*.5,kpchline,iosc_func
asine2    oscili    iamp*.5,kpchline,iosc_func
asinenv   linen     asine,p3*.5,p3,p3*.4
asinenv2  linen     asine2,p3*.5,p3,p3*.4

asignal   =         asnd+asinenv
asignal2  =		   asnd2+asinenv2

if (ipan_start == ipan_end) then
  kpan = ipan_start
else
  kpan     linseg  ipan_start, ipan_dur, ipan_end
endif

if (ipan_freq != 0) then
  kpan     lfo   1, ipan_freq, ipan_mode
  apan_l, apan_rx    pan2  asignal, kpan
  apan_lx, apan_r    pan2  asignal2, kpan
elseif (ipan_start != ipan_end) then
  apan_l  = (1 - kpan) * (2 * ((asignal * (1 - (kpan * .5))) + (asignal2 * (kpan * .5))))
  apan_r  = (kpan) * (2 * ((asignal * (1 - (kpan * .5))) + (asignal2 * (kpan * .5))))
else
  apan_l = asignal
  apan_r = asignal2
endif


outs       apan_l, apan_r

endin

</CsInstruments>

<CsScore>

; =============================================================================
; P fields
; =============================================================================

;p1 Instrument
;p2 Start time
;p3 Duration
;p4 Amplitude     range 0 - 1+
;p5 Pitch Start
;p6 Pitch End
;p7 Pitch Duration
;p8 pitch envelope ramp type, 0 = linear, 1 = exponential
;p9 number of octave divisions for scale

;p10 relative index level, range 0 - 1+
;p11 code for envelope rise and fall times
;                    1 = fast rise/fast fall, 2 = fast rise/slow fall
;                    3 = slow rise/fast fall, 4 = slow rise/slow fall
;p12 code for index envelope rise time
;                    0 = fast, 1 = slow
;p13 Osc Ftable function
;p14 pan start    range 0 - 1
;p15 pan end      range 0 - 1
;p16 pan duration
;p17 pan freq for lfo in hz, lfo off = 0
;p18 pan mode for lfo,       sine = 0, tri = 1, square bi = 2, square uni = 3, saw up = 4, saw down = 5


; =============================================================================
; =============================================================================
; Score
; =============================================================================
; =============================================================================

i"pad4"     0    10    .25    7.00   7.05    3   0     10
1           2    2     7      .25    .75     3   0     0

i"pad4"     0    10    .25    7.035  7.08    3   0     10
1           2    2     7      .25    .75     3   0     0

i"pad4"     0    10    .25    9.07   9.12    3   0     10
1           3    2     7     .75     .25     3   0     0

i"pad4"     0    10    .25    8.072  8.12    3   0     10
1           3    2     7      .75    .25     3   0     0

</CsScore>

; =============================================================================
; =============================================================================

</CsoundSynthesizer>
