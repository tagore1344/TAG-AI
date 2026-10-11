# Tag AI Mobile

Siri-style mobile client for Tag AI.

## What is included

- Tag AI voice-first home screen with animated orb.
- Device speech recognition using `speech_to_text`.
- Device text-to-speech using `flutter_tts`.
- `Hey Tag AI`, `OK Tag AI`, and `Hi Tag AI` foreground hands-free mode.
- Secure paired gateway connection using the existing Tag AI REST/WebSocket stack.
- Existing chat, control, review, and pairing screens remain available.
- Conversation replies are spoken locally on the phone.

## Android / iOS project setup

The repository contains the Flutter `lib/` source but not generated native platform folders. From this directory run:

```powershell
flutter create --platforms=android,ios .
flutter pub get
flutter run
```

For microphone speech recognition, configure the native permissions required by `speech_to_text`.

### Android

In `android/app/src/main/AndroidManifest.xml` add under `<manifest>`:

```xml
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<queries>
    <intent>
        <action android:name="android.speech.RecognitionService" />
    </intent>
</queries>
```

### iOS

In `ios/Runner/Info.plist` add:

```xml
<key>NSSpeechRecognitionUsageDescription</key>
<string>Tag AI uses speech recognition to understand your voice commands.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Tag AI uses the microphone for voice conversations.</string>
```

## Connect Tag AI

1. Start the Tag AI desktop/gateway.
2. Get the temporary pairing PIN from the Tag AI gateway.
3. Open Tag AI Mobile.
4. Enter the gateway LAN address and pairing PIN.
5. Pair the phone.
6. The Tag AI voice HUD becomes the default screen.

## Voice modes

**Tap mode:** tap the central Tag AI orb, speak, and release/finish naturally. Tag AI sends the recognized phrase to the paired gateway, receives the AI response, displays it, and speaks it.

**Hands-free mode:** enable `HANDS-FREE`. Tag AI stays in a foreground listening loop and only submits a phrase after hearing a Tag AI wake phrase such as `Hey Tag AI`. After Tag AI answers, the loop returns to wake-word listening.

The current implementation intentionally keeps hands-free recognition in the foreground. A true OS-level background assistant requires native Android foreground-service integration and platform-specific restrictions; that is a separate native layer from the Flutter voice UI.
