OPCODEDIR=/usr/local/lib/csound/plugins
export OPCODEDIR

all: ch-improv.wav ch-improv.png

%.wav: %.csd
	csound -H3 -R -g --wave -o $@ $<

%.png: %.wav
	( mkdir temp-$$ ; cd temp-$$ ; \
	  sox ../$< -n channels 1 rate 8000 spectrogram ; \
	  mv -f spectrogram.png ../$@ ; \
	  cd .. ; rm -rf temp-$$ )

%.flac: %.wav
	flac -f -8 $<
