analogue_osc_LDFLAGS = util/blo.o $(RT)
fm_osc_LDFLAGS = util/blo.o $(RT)
hermes_filter_LDFLAGS = util/blo.o $(RT)

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

fftw3_CFLAGS = `pkg-config fftw3f --cflags`
fftw3_LDFLAGS = `pkg-config fftw3f --libs`

mbeq_CFLAGS = $(fftw3_CFLAGS)
mbeq_LDFLAGS = $(fftw3_LDFLAGS)

pitch_scale_CFLAGS = $(fftw3_CFLAGS)
pitch_scale_LDFLAGS = util/pitchscale.o $(fftw3_LDFLAGS)
