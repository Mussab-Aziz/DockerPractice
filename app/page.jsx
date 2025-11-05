'use client'

import { useState } from 'react'
import { topics } from './constants/topics'
import Link from 'next/link'

const HomePage = () => {
  const [language, setLanguage] = useState('javascript')
  const [difficulty, setDifficulty] = useState('beginner')
  const [topic, setTopic] = useState('Random')
  const [numQuestions, setNumQuestions] = useState('5')

  return (
    <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-br from-blue-50 via-white to-emerald-50 text-gray-800 px-6">
      <div className="w-full max-w-lg bg-white border border-gray-200 rounded-3xl shadow-xl p-10 transition-all hover:shadow-2xl">
        <h1 className="text-center text-5xl font-extrabold mb-8 text-emerald-600 tracking-tight">
            AI Quiz Generator
        </h1>


        <form className="flex flex-col gap-6">
          {/* LANGUAGE */}
          <div className="flex flex-col">
            <label htmlFor="language" className="uppercase text-xs font-semibold text-gray-500 mb-1">
              Language
            </label>
            <select
              value={language}
              onChange={(e) => setLanguage(e.target.value)}
              className="border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-emerald-400 bg-white"
            >
              <option value="javascript">JavaScript</option>
              <option value="python">Python</option>
              <option value="react">React</option>
              <option value="css">CSS</option>
            </select>
          </div>

          {/* TOPIC */}
          <div className="flex flex-col">
            <label htmlFor="topic" className="uppercase text-xs font-semibold text-gray-500 mb-1">
              Topic
            </label>
            <select
              value={topic}
              onChange={(e) => setTopic(e.target.value)}
              className="border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-emerald-400 bg-white"
            >
              {topics[language].map((option, index) => (
                <option value={option} key={index}>
                  {option}
                </option>
              ))}
            </select>
          </div>

          {/* DIFFICULTY */}
          <div className="flex flex-col">
            <label htmlFor="difficulty" className="uppercase text-xs font-semibold text-gray-500 mb-1">
              Difficulty
            </label>
            <select
              value={difficulty}
              onChange={(e) => setDifficulty(e.target.value)}
              className="border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-emerald-400 bg-white"
            >
              <option value="beginner">Beginner</option>
              <option value="intermediate">Intermediate</option>
              <option value="advanced">Advanced</option>
            </select>
          </div>

          {/* NUMBER OF QUESTIONS */}
          <div className="flex flex-col">
            <label htmlFor="numQuestions" className="uppercase text-xs font-semibold text-gray-500 mb-1">
              # of Questions
            </label>
            <select
              value={numQuestions}
              onChange={(e) => setNumQuestions(e.target.value)}
              className="border border-gray-300 rounded-lg p-2 focus:outline-none focus:ring-2 focus:ring-emerald-400 bg-white"
            >
              <option value="5">5</option>
              <option value="10">10</option>
              <option value="15">15</option>
              <option value="20">20</option>
            </select>
          </div>

          {/* BUTTON */}
          <div className="text-center mt-6">
            <Link
              href={{
                pathname: '/quiz',
                query: {
                  language,
                  difficulty,
                  topic: topic.toLowerCase(),
                  numQuestions,
                },
              }}
              className="inline-block w-full py-3 text-lg font-semibold rounded-xl bg-gradient-to-r from-emerald-500 to-blue-500 text-white shadow-md hover:opacity-90 active:scale-95 transition"
            >
              Generate Quiz
            </Link>
          </div>
        </form>
      </div>
    </div>
  )
}

export default HomePage
