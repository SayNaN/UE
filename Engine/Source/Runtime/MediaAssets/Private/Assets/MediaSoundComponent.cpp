// Copyright 1998-2018 Epic Games, Inc. All Rights Reserved.

#include "MediaSoundComponent.h"

#include "IMediaAudioSample.h"
#include "IMediaPlayer.h"
#include "MediaAudioResampler.h"
#include "Misc/ScopeLock.h"

#include "MediaPlayer.h"
#include "MediaPlayerFacade.h"


/* UMediaSoundComponent structors
 *****************************************************************************/

UMediaSoundComponent::UMediaSoundComponent(const FObjectInitializer& ObjectInitializer)
	: Super(ObjectInitializer)
	, Channels(EMediaSoundChannels::Stereo)
	, CachedRate(0.0f)
	, CachedTime(FTimespan::Zero())
	, Resampler(new FMediaAudioResampler)
{
	PrimaryComponentTick.bCanEverTick = true;
	bAutoActivate = true;

#if PLATFORM_MAC
	PreferredBufferLength = 2048; // increase buffer callback size on macOS to prevent underruns
#endif
}


UMediaSoundComponent::~UMediaSoundComponent()
{
	delete Resampler;
}


/* UMediaSoundComponent interface
 *****************************************************************************/

void UMediaSoundComponent::SetMediaPlayer(UMediaPlayer* NewMediaPlayer)
{
	CurrentPlayer = NewMediaPlayer;
}


void UMediaSoundComponent::UpdatePlayer()
{
	if (!CurrentPlayer.IsValid())
	{
		CachedRate = 0.0f;
		CachedTime = FTimespan::Zero();
		SampleQueue.Reset();

		return;
	}

	// create a new sample queue if the player changed
	TSharedRef<FMediaPlayerFacade, ESPMode::ThreadSafe> PlayerFacade = CurrentPlayer->GetPlayerFacade();

	if (PlayerFacade != CurrentPlayerFacade)
	{
		{
			const auto NewSampleQueue = MakeShared<FMediaAudioSampleQueue, ESPMode::ThreadSafe>();

			FScopeLock Lock(&CriticalSection);
			SampleQueue = NewSampleQueue;
		}

		PlayerFacade->AddAudioSampleSink(SampleQueue.ToSharedRef());
		CurrentPlayerFacade = PlayerFacade;
	}

	// caching play rate and time for audio thread (eventual consistency is sufficient)
	CachedRate = PlayerFacade->GetRate();
	CachedTime = PlayerFacade->GetTime();

	check(SampleQueue.IsValid());
}


/* UActorComponent interface
 *****************************************************************************/

void UMediaSoundComponent::TickComponent(float DeltaTime, enum ELevelTick TickType, FActorComponentTickFunction *ThisTickFunction)
{
	Super::TickComponent(DeltaTime, TickType, ThisTickFunction);

	UpdatePlayer();
}


/* USceneComponent interface
 *****************************************************************************/

void UMediaSoundComponent::Activate(bool bReset)
{
	if (bReset || ShouldActivate())
	{
		SetComponentTickEnabled(true);
	}

	Super::Activate(bReset);
}


void UMediaSoundComponent::Deactivate()
{
	if (!ShouldActivate())
	{
		SetComponentTickEnabled(false);
	}

	Super::Deactivate();
}


/* UObject interface
 *****************************************************************************/

void UMediaSoundComponent::PostLoad()
{
	Super::PostLoad();

	CurrentPlayer = MediaPlayer;
}


#if WITH_EDITOR

void UMediaSoundComponent::PostEditChangeProperty(FPropertyChangedEvent& PropertyChangedEvent)
{
	static const FName MediaPlayerName = GET_MEMBER_NAME_CHECKED(UMediaSoundComponent, MediaPlayer);

	UProperty* PropertyThatChanged = PropertyChangedEvent.Property;

	if (PropertyThatChanged != nullptr)
	{
		const FName PropertyName = PropertyThatChanged->GetFName();

		if (PropertyName == MediaPlayerName)
		{
			CurrentPlayer = MediaPlayer;
		}
	}

	Super::PostEditChangeProperty(PropertyChangedEvent);
}

#endif //WITH_EDITOR


/* USynthComponent interface
 *****************************************************************************/

bool UMediaSoundComponent::Init(int32& SampleRate)
{
	Super::Init(SampleRate);

	if (Channels == EMediaSoundChannels::Mono)
	{
		NumChannels = 1;
	}
	else //if (Channels == EMediaSoundChannels::Stereo)
	{
		NumChannels = 2;
	}/*
	else
	{
		NumChannels = 8;
	}*/

	Resampler->Initialize(NumChannels, SampleRate);
	return true;
}


void UMediaSoundComponent::OnGenerateAudio(float* OutAudio, int32 NumSamples)
{
	TSharedPtr<FMediaAudioSampleQueue, ESPMode::ThreadSafe> PinnedSampleQueue;
	{
		FScopeLock Lock(&CriticalSection);
		PinnedSampleQueue = SampleQueue;
	}

	if (PinnedSampleQueue.IsValid() && (CachedRate != 0.0f))
	{
		const uint32 FramesRequested = NumSamples / NumChannels;
		const uint32 FramesWritten = Resampler->Generate(OutAudio, FramesRequested, CachedRate, CachedTime, *PinnedSampleQueue);
	}
	else
	{
		Resampler->Flush();
	}
}
