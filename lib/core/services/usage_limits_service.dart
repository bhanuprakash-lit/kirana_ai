/// Feature key constants — used in UI and API calls.
const kFeatureVoice     = 'voice';
const kFeatureHandwrite = 'handwrite';
const kFeatureInvoice   = 'invoice';

/// Free daily allowances per feature (mirrored from backend for UI display).
const kDailyLimits = {
  kFeatureVoice:     3,
  kFeatureHandwrite: 5,
  kFeatureInvoice:   2,
};

/// Max recording seconds for voice before auto-cut.
const kVoiceMaxSeconds = 15;

/// Credits added per pack purchase.
const kCreditsPerPack = 10;
