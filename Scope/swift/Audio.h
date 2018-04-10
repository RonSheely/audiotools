//
//  Audio.h
//  Oscilloscope
//
//  Created by Bill Farmer on 08/04/2018.
//  Copyright © 2018 Bill Farmer. All rights reserved.
//

#ifndef Audio_h
#define Audio_h

#import <Foundation/Foundation.h>
#import <AudioUnit/AudioUnit.h>
#import <CoreAudio/CoreAudio.h>

// Audio in values
enum
    {kSampleRate       = 44100,
     kBytesPerPacket   = 4,
     kBytesPerFrame    = 4,
     kChannelsPerFrame = 1};

// Audio processing values
enum
    {kSamples = 262144,
     kFrames = 4096};

// State machine values
enum
    {INIT,
     FIRST,
     NEXT,
     LAST};

typedef struct
{
    float *data;
    float scale;
    float yscale;
    int index;
    int start;
    int length;
    Boolean bright;
    Boolean single;
    Boolean trigger;
    // Boolean polarity;
    Boolean storage;
    Boolean clear;
} Scope;
Scope scope;

typedef struct
{
    float scale;
    float start;
    float step;
} XScale;
XScale xscale;

typedef struct
{
    float index;
} YScale;
YScale yscale;

typedef struct
{
    AudioUnit output;
    AudioBufferList *ablp;
    int frames;
    float sample;
} Audio;
Audio audio;

typedef struct
{
    int index;
    float values[12];
    char *strings[12];
    int counts[12];
} Timebase;

Timebase timebase =
    {3,
     {0.1, 0.2, 0.5, 1.0,
      2.0, 5.0, 10.0, 20.0,
      50.0, 100.0, 200.0, 500.0},
     {"0.1 ms", "0.2 ms", "0.5 ms",
      "1.0 ms", "2.0 ms", "5.0 ms",
      "10 ms", "20 ms", "50 ms",
      "0.1 sec", "0.2 sec", "0.5 sec"},
     {128, 256, 512, 1024,
      2048, 4096, 8192, 16384,
      32768, 65536, 131072, 262144}};

OSStatus InputProc(void *inRefCon, AudioUnitRenderActionFlags *ioActionFlags,
                   const AudioTimeStamp *inTimeStamp, UInt32 inBusNumber,
                   UInt32 inNumberFrames, AudioBufferList *ioData);

#endif /* Audio_h */
