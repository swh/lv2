PREFIX = /usr/local
INSTALL_DIR = $(PREFIX)/lib/lv2

VERSION = 1.0.16

PLUGINS = alias-swh.lv2 allpass-swh.lv2 am_pitchshift-swh.lv2 amp-swh.lv2 \
analogue_osc-swh.lv2 bandpass_a_iir-swh.lv2 bandpass_iir-swh.lv2 \
bode_shifter-swh.lv2 bode_shifter_cv-swh.lv2 butterworth-swh.lv2 \
chebstortion-swh.lv2 comb-swh.lv2 comb_splitter-swh.lv2 const-swh.lv2 \
crossover_dist-swh.lv2 dc_remove-swh.lv2 decay-swh.lv2 decimator-swh.lv2 \
declip-swh.lv2 delay-swh.lv2 delayorama-swh.lv2 diode-swh.lv2 divider-swh.lv2 \
dj_eq-swh.lv2 dj_flanger-swh.lv2 dyson_compress-swh.lv2 fad_delay-swh.lv2 \
fast_lookahead_limiter-swh.lv2 flanger-swh.lv2 fm_osc-swh.lv2 \
foldover-swh.lv2 foverdrive-swh.lv2 freq_tracker-swh.lv2 gate-swh.lv2 \
giant_flange-swh.lv2 gong-swh.lv2 gong_beater-swh.lv2 gverb-swh.lv2 \
hard_limiter-swh.lv2 harmonic_gen-swh.lv2 hermes_filter-swh.lv2 \
highpass_iir-swh.lv2 hilbert-swh.lv2 impulse-swh.lv2 inv-swh.lv2 \
karaoke-swh.lv2 latency-swh.lv2 lcr_delay-swh.lv2 lookahead_limiter-swh.lv2 \
lookahead_limiter_const-swh.lv2 lowpass_iir-swh.lv2 ls_filter-swh.lv2 \
matrix_ms_st-swh.lv2 matrix_spatialiser-swh.lv2 matrix_st_ms-swh.lv2 \
mod_delay-swh.lv2 multivoice_chorus-swh.lv2 \
phasers-swh.lv2 plate-swh.lv2 pointer_cast-swh.lv2 \
rate_shifter-swh.lv2 retro_flange-swh.lv2 revdelay-swh.lv2 ringmod-swh.lv2 \
satan_maximiser-swh.lv2 sc1-swh.lv2 sc2-swh.lv2 sc3-swh.lv2 sc4-swh.lv2 \
se4-swh.lv2 shaper-swh.lv2 sifter-swh.lv2 simple_comb-swh.lv2 sin_cos-swh.lv2 \
single_para-swh.lv2 sinus_wavewrapper-swh.lv2 smooth_decimate-swh.lv2 \
split-swh.lv2 surround_encoder-swh.lv2 svf-swh.lv2 \
tape_delay-swh.lv2 transient-swh.lv2 triple_para-swh.lv2 valve-swh.lv2 \
valve_rect-swh.lv2 vynil-swh.lv2 wave_terrain-swh.lv2 xfade-swh.lv2 \
zm1-swh.lv2 offset-swh.lv2 \
a_law-swh.lv2 u_law-swh.lv2

FFT_PLUGINS = mbeq-swh.lv2 pitch_scale-swh.lv2


DARWIN := $(shell uname | grep Darwin)
OS := $(shell uname -s)

ifdef DARWIN
EXT = dylib
CC = clang
PLUGIN_CFLAGS = -Wall -Wno-unused-variable -Wno-self-assign -I. -Iinclude -O3 -fomit-frame-pointer -funroll-loops -DFFTW3 -arch x86_64 -ffast-math -msse -fno-common $(CFLAGS)
PLUGIN_LDFLAGS = -arch x86_64 -dynamiclib $(LDFLAGS)
BUILD_PLUGINS = $(PLUGINS) $(FFT_PLUGINS)
RT =
else
EXT = so
PLUGIN_CFLAGS = -Wall -I. -Iinclude -O3 -fomit-frame-pointer -fstrength-reduce -funroll-loops -fPIC -DPIC -DFFTW3 $(CFLAGS)
PLUGIN_LDFLAGS = -shared -lm $(LDFLAGS)
BUILD_PLUGINS = $(PLUGINS) $(FFT_PLUGINS)
RT = -lrt
endif

# Load plugin specific flags:
include extra.mk

OBJECTS = $(shell echo $(BUILD_PLUGINS) | sed 's/\([^ ]*\.lv2\)/plugins\/\1\/plugin.$(EXT)/g')

all: util gverb $(OBJECTS)

gverb: gverb/gverb.c gverb/gverbdsp.c gverb/gverb.o gverb/gverbdsp.o
	(cd gverb && make -w CFLAGS="$(PLUGIN_CFLAGS)" LDFLAGS="$(PLUGIN_LDFLAGS)")

util/pitchscale.o:
	$(CC) $(PLUGIN_CFLAGS) $(fftw3_CFLAGS) $*.c -c -o $@

util: util/blo.o util/iir.o util/db.o util/rms.o util/pitchscale.o

%.c: OBJ = $(shell echo $@ | sed 's/\.c$$/-@OS@.$(EXT)/')
%.c: %.xml xslt/source.xsl xslt/manifest.xsl
	xsltproc -novalid xslt/source.xsl $*.xml | sed 's/LADSPA_Data/float/g' > $@
	xsltproc -novalid -stringparam obj `basename $(OBJ)` xslt/manifest.xsl $*.xml > `dirname $@`/manifest.ttl.in

%.ttl: %.xml xslt/turtle.xsl
	xsltproc -novalid xslt/turtle.xsl $*.xml | sed 's/\\/\\\\/g' > $@

%.o: NAME = $(shell echo $@ | sed 's/plugins\/\(.*\)-swh.*/\1/')
%.o: %.c
	$(CC) $(PLUGIN_CFLAGS) $($(NAME)_CFLAGS) $*.c -c -o $@

%.$(EXT): NAME = $(shell echo $@ | sed 's/plugins\/\(.*\)-swh.*/\1/')
%.$(EXT): %.xml %.o %.ttl
	$(CC) $*.o $(PLUGIN_LDFLAGS) $($(NAME)_LDFLAGS) -o $@
	cp $@ $*-$(OS).$(EXT)
	sed 's/@OS@/$(OS)/g' < `dirname $@`/manifest.ttl.in > `dirname $@`/manifest.ttl

clean: dist-clean

dist-clean:
	rm -f plugins/*/*.{$(EXT),o} plugins/*/*.o plugins/*/manifest.ttl util/*.o gverb/*.o

real-clean:
	rm -f plugins/*/*.{c,ttl,$(EXT),o,in} util/*.o gverb/*.o

install:
	@echo 'use install-user to install in home or install-system to install system wide'

install-system: INSTALL_DIR_REALLY=$(INSTALL_DIR)
install-system: all install-really

install-user: INSTALL_DIR_REALLY=~/.lv2
install-user: all install-really

install-really:
	for plugin in $(BUILD_PLUGINS); do \
		echo Installing $$plugin; \
		install -pd $(INSTALL_DIR_REALLY)/$$plugin; \
		install -pm 755 plugins/$$plugin/*-$(OS).$(EXT) $(INSTALL_DIR_REALLY)/$$plugin/ ; \
		install -pm 644 plugins/$$plugin/*.ttl $(INSTALL_DIR_REALLY)/$$plugin/ ; \
	done

dist: real-clean all dist-clean
	cd .. && \
	cp -pr lv2 swh-lv2-$(VERSION) && \
	tar cfz swh-lv2-$(VERSION).tar.gz swh-lv2-$(VERSION)/{Makefile,README,*.mk,plugins/*/*,util/*,gverb/*,xslt/*,include/*} && \
	rm -rf swh-lv2-$(VERSION)
	mv ../swh-lv2-$(VERSION).tar.gz .

.PRECIOUS: %.c %.ttl
