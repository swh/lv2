analogue_osc_LDFLAGS = util/blo.o -lrt
fm_osc_LDFLAGS = util/blo.o -lrt
hermes_filter_LDFLAGS = util/blo.o -lrt

bandpass_iir_LDFLAGS = util/iir.o
bandpass_a_iir_LDFLAGS = util/iir.o
butterworth_LDFLAGS = util/iir.o
highpass_iir_LDFLAGS = util/iir.o
lowpass_iir_LDFLAGS = util/iir.o
notch_iir_LDFLAGS = util/iir.o

gverb_LDFLAGS = gverb/gverbdsp.o gverb/gverb.o

lookahead_limiter_LDFLAGS = util/db.o
lookahead_limiter_const_LDFLAGS = util/db.o
sc1_LDFLAGS = util/db.o util/rms.o
sc2_LDFLAGS = util/db.o util/rms.o
sc3_LDFLAGS = util/db.o util/rms.o
sc4_LDFLAGS = util/db.o util/rms.o
se4_LDFLAGS = util/db.o util/rms.o

mbeq_CFLAGS = `pkg-config fftw3f --cflags`
mbeq_LDFLAGS = `pkg-config fftw3f --libs`

pitch_scale_CFLAGS = `pkg-config fftw3f --cflags`
pitch_scale_LDFLAGS = util/pitchscale.o `pkg-config fftw3f --libs`