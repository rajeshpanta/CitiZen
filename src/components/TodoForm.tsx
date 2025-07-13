import React, { useState } from 'react';
import VoiceInput from './VoiceInput';

const TodoForm: React.FC<{ onSubmit: (text: string) => void }> = ({ onSubmit }) => {
  const [inputText, setInputText] = useState('');

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (inputText.trim()) {
      onSubmit(inputText);
      setInputText('');
    }
  };

  const handleVoiceInput = (transcript: string) => {
    setInputText(transcript);
  };

  return (
    <form onSubmit={handleSubmit} className="flex gap-2 items-center">
      <input
        type="text"
        value={inputText}
        onChange={(e) => setInputText(e.target.value)}
        className="flex-1 px-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
        placeholder="Add a new todo..."
      />
      <VoiceInput onTranscript={handleVoiceInput} />
      <button 
        type="submit"
        className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600"
      >
        Add Todo
      </button>
    </form>
  );
};

export default TodoForm; 