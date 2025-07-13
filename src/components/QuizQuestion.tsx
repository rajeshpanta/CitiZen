import React, { useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import VoiceInput from './VoiceInput';

interface QuizQuestionProps {
  question: string;
  correctAnswer: string;
  onAnswer: (isCorrect: boolean) => void;
}

const QuizQuestion: React.FC<QuizQuestionProps> = ({
  question,
  correctAnswer,
  onAnswer,
}) => {
  const [userAnswer, setUserAnswer] = useState('');

  const handleVoiceInput = (transcript: string) => {
    setUserAnswer(transcript);
    // Optional: Automatically check answer when voice input is received
    checkAnswer(transcript);
  };

  const checkAnswer = (answer: string) => {
    // You might want to implement more sophisticated answer checking
    // For example, checking for similar meanings or partial matches
    const isCorrect = answer.toLowerCase().includes(correctAnswer.toLowerCase());
    onAnswer(isCorrect);
  };

  return (
    <View style={styles.container}>
      <Text style={styles.question}>{question}</Text>
      <Text style={styles.instruction}>
        Tap the microphone and speak your answer
      </Text>
      {userAnswer ? (
        <Text style={styles.userAnswer}>Your answer: {userAnswer}</Text>
      ) : null}
      <VoiceInput onTranscript={handleVoiceInput} style={styles.voiceInput} />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    padding: 20,
  },
  question: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 20,
  },
  instruction: {
    fontSize: 16,
    color: '#666',
    marginBottom: 15,
  },
  userAnswer: {
    marginVertical: 15,
    fontSize: 16,
  },
  voiceInput: {
    marginTop: 20,
  },
});

export default QuizQuestion; 