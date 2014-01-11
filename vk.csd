<CsoundSynthesizer>
<CsOptions>
-odac -+rtaudio=alsa -+rtmidi=virtual -s -B4096 -Mkeyboard.map
</CsOptions>

/**********************************************************************/

<CsInstruments>

sr=44100
ksmps=32
nchnls=2
0dbfs=1

galeft init 0
garight init 0 

; basic waveforms
gisintbl ftgen 1,0,16384,10,1
gicostbl ftgen 2,0,16384,11,1
gisawtbl ftgen 3,0,16384,7,-1,16384,1
gisquaretbl ftgen 4,0,256,7,-1,128,-1,0,1,128,1

; clipping/compression function for output
gicliptbl ftgen 10,0,4097,"tanh",-1,1,0

giscalebase=100

/**********************************************************************/

/***** MIDI DISPATCHER *****/

; general MIDI map - not used b/c of virtual keyboard mapping silliness
; giinstrmap ftgen 200,0,128,-2, \
;     2 -1 -1 -1 -1 -1 -1 -1 /* 0-7 piano */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 8-15 chromatic percussion */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 16-23 organ */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 24-31 guitar */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 32-39 bass */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 40-47 strings */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 48-55 ensemble */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 56-63 brass */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 64-71 reed */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 72-79 pipe */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 80-87 synth lead */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 88-95 synth pad */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 96-103 synth effects */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 104-111 ethnic */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 112-119 percussive */ \
;    -1 -1 -1 -1 -1 -1 -1 -1 /* 120-127 sound effects */

giinstrmap ftgen 200,0,32,-2, \
  2,3,4

massign 0,0
pgmassign 0,0
massign 0,1

instr 1

ichn midichn
inote notnum
iveloc veloc 0,1

; FIXME map note
imapnote=cpsmidinn(inote)

; velocity kludge for virtual keyboard
ivo ctrl7 ichn,7,0,1
iveloc=(ivo>0?ivo:iveloc)

midiprogramchange p4
instnum table p4,giinstrmap
instnum=instnum+ichn/32+inote/8192

print imapnote,iveloc
event_i "i",instnum,0,-1,imapnote,iveloc

krel release
if krel==1 then
  event "i",-instnum,0,1
endif

endin

/**********************************************************************/

; 2 = basic synth piano

instr 2

inote=p4
iveloc=p5

kenv expsegr 0.01,0.005,iveloc,1.5,0.1*iveloc,0.05,0.001
kbenv linsegr 0.9,0.6,0.33,0.05,0

inotex=inote*(1-rnd(1)*0.005)
inotey=inote*(1+rnd(1)*0.005)

aout1 gbuzz kenv*0.25,inotex,12,(inote>55?1:2),kbenv*iveloc*1.05,gicostbl,0
aout2 gbuzz kenv*0.55,inote,12,(inote>95?1:2),kbenv*iveloc*1.05,gicostbl,0
aout3 gbuzz kenv*0.25,inotey,12,(inote>75?1:2),kbenv*iveloc*1.05,gicostbl,0

aout tone aout2+aout1+aout3,6000,5

galeft=galeft+aout
garight=garight+aout

endin

/**********************************************************************/

; 3 = sawtooth wave
instr 3

inote=p4
iveloc=p5

kenv linsegr 0,0.05,iveloc,0.05,0

aout poscil3 kenv*0.35,inote,gisawtbl,rnd(1)

galeft=galeft+aout
garight=garight+aout

endin

; 4 = sine wave
instr 4

inote=p4
iveloc=p5

kenv linsegr 0,0.05,iveloc,0.05,0

aout poscil3 kenv*0.85,inote,gisintbl,rnd(1)

galeft=galeft+aout
garight=garight+aout

endin

/**********************************************************************/

instr 1000

aleft table3 galeft*0.1,gicliptbl,1,0.5,0
aright table3 garight*0.1,gicliptbl,1,0.5,0

aboth=galeft+garight
galeft=0
garight=0

krms rms aboth
if krms>0.01 then
  dispfft aboth/krms,0.1,4096,0,1
endif
outs aleft,aright
fout "vk.wav",2,aleft,aright

endin

/**********************************************************************/

</CsInstruments>

<CsScore>

i 1000 0 3600

/**********************************************************************/

e 
</CsScore>
</CsoundSynthesizer>
