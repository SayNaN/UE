// Copyright 1998-2014 Epic Games, Inc. All Rights Reserved.

#pragma once


/**
 * Implements a widget that provides a notice for files that need to be checked out.
 */
class SHAREDSETTINGSWIDGETS_API SSettingsEditorCheckoutNotice : public SCompoundWidget
{
public:

	SLATE_BEGIN_ARGS(SSettingsEditorCheckoutNotice) { }

		/** Called to determine if the associated file is unlocked */
		SLATE_ATTRIBUTE(bool, Unlocked)

		/** Called to get the filename of the config file for display */
		SLATE_ATTRIBUTE(FString, ConfigFilePath)

		/** Slot for this button's content (optional) */
		SLATE_NAMED_SLOT(FArguments, LockedContent)

		/** Called when the 'Check Out' button is clicked */
		SLATE_EVENT(FOnClicked, OnCheckOutClicked)

		/** Called to determine if we are currently looking for the source control state of the file */
		SLATE_ATTRIBUTE(bool, LookingForSourceControlState)

	SLATE_END_ARGS()

	/**
	 * Constructs the widget.
	 *
	 * @param InArgs The construction arguments.
	 */
	void Construct( const FArguments& InArgs );

	// SWidget interface
	virtual void Tick(const FGeometry& AllottedGeometry, const double InCurrentTime, const float InDeltaTime) override;
	// End of SWidget interface

	// Return true if the watched file can be modified (as of the last update)
	bool IsUnlocked() const;

	// Force an update on the next tick
	void Invalidate()
	{
		DefaultConfigCheckOutTimer = 1.0f;
	}

private:

	// Callback for clicking the 'Check Out' button.
	FReply HandleCheckOutButtonClicked( );

	// Callback for getting the text of the 'Check Out' button.
	FText HandleCheckOutButtonText( ) const;

	// Callback for getting the tool tip text of the 'Check Out' button.
	FText HandleCheckOutButtonToolTip( ) const;

	// Callback for determining the visibility of the check-out button.
	EVisibility HandleCheckOutButtonVisibility( ) const;

	// Callback for getting the widget index for the notice switcher.
	int32 HandleNoticeSwitcherWidgetIndex( ) const
	{
		return IsUnlocked() ? 1 : 0;
	}

	// Callback for getting the status text when the config is locked
	FText HandleLockedStatusText() const;

	// Callback for getting the status text when the config is unlocked
	FText HandleUnlockedStatusText() const;

	// Callback for getting the status color, which indicates if it is writeable or not
	FSlateColor GetLockedOrUnlockedStatusBarColor() const;

	// Callback for getting the visibility of the source control throbber
	EVisibility HandleThrobberVisibility() const;

private:

	// Holds a delegate that is executed when the 'Check Out' button has been clicked.
	FOnClicked CheckOutClickedDelegate;

	// The current file being watched
	TAttribute<FString> ConfigFilePath;

	// Holds a flag indicating whether the section's configuration file needs to be checked out.
	bool DefaultConfigCheckOutNeeded;

	// Holds a flag indicating whether the section's configuration file has a source control status request in progress.
	bool DefaultConfigQueryInProgress;

	// Holds a timer for checking whether the section's configuration file needs to be checked out.
	float DefaultConfigCheckOutTimer;
};
