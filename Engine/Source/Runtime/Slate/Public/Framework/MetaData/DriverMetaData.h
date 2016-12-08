// Copyright 1998-2016 Epic Games, Inc. All Rights Reserved.
#pragma once

class ISlateMetaData;

/**
 * A static helper class which is used to easily construct various types of AutomationDriver specific SlateMetaData.
 */
class SLATE_API FDriverMetaData
{
public:

	/**
	 * @return the automation driver specific metadata type for specifying an Id for a widget
	 */
	static TSharedRef<ISlateMetaData> Id(FName Tag);
};