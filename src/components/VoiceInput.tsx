import React, { useState, useEffect } from 'react';
import { View, TouchableOpacity, Text, Platform } from 'react-native';
import Voice, {
  SpeechResultsEvent,
  SpeechErrorEvent,
} from '@react-native-voice/voice';

interface VoiceInputProps {
  onTranscript: (text: string) => void;
  style?: object;
}

const VoiceInput: React.FC<VoiceInputProps> = ({ onTranscript, style }) => {
  const [isListening, setIsListening] = useState(false);
  const [error, setError] = useState<string>('');

  useEffect(() => {
    // Initialize voice recognition
    Voice.onSpeechResults = onSpeechResults;
    Voice.onSpeechError = onSpeechError;

    // Cleanup
    return () => {
      Voice.destroy().then(Voice.removeAllListeners);
    };
  }, []);

  const onSpeechResults = (e: SpeechResultsEvent) => {
    if (e.value && e.value[0]) {
      onTranscript(e.value[0]);
      setIsListening(false);
    }
  };

  const onSpeechError = (e: SpeechErrorEvent) => {
    setError(e.error?.message || 'Error occurred during speech recognition');
    setIsListening(false);
  };

  const startListening = async () => {
    try {
      setError('');
      await Voice.start('en-US');
      setIsListening(true);
    } catch (e) {
      setError('Error starting voice recognition');
    }
  };

  const stopListening = async () => {
    try {
      await Voice.stop();
      setIsListening(false);
    } catch (e) {
      setError('Error stopping voice recognition');
    }
  };

  return (
    <View style={style}>
      <TouchableOpacity
        onPress={isListening ? stopListening : startListening}
        style={{
          backgroundColor: isListening ? '#ff6b6b' : '#4CAF50',
          padding: 15,
          borderRadius: 10,
        }}
      >
        <Text style={{ color: 'white', textAlign: 'center' }}>
          {isListening ? 'Stop Recording' : 'Start Recording'}
        </Text>
      </TouchableOpacity>
      {error ? (
        <Text style={{ color: 'red', marginTop: 10 }}>{error}</Text>
      ) : null}
    </View>
  );
};

export default VoiceInput; 