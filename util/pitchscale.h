#ifndef PITCHSCALE_H
#define PITCHSCALE_H

#include <fftw3.h>

typedef fftwf_plan fft_plan;
typedef float fftw_real;

typedef struct {
	float *gInFIFO;
	float *gOutFIFO;
	float *gLastPhase;
	float *gSumPhase;
	float *gOutputAccum;
	float *gAnaFreq;
	float *gAnaMagn;
	float *gSynFreq;
	float *gSynMagn;
	float *gWindow;
	long   gRover;
} sbuffers;

#define MAX_FRAME_LENGTH 4096

#define true  1
#define false 0

void pitch_scale(sbuffers *buffers, const double pitchScale, const long
		fftFrameLength, const long osamp, const long numSampsToProcess,
		const double sampleRate, const float *indata, float *outdata,
		const int adding, const float gain);

#endif
