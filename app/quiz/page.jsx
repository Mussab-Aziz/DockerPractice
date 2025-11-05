'use client'

import { useEffect, useState } from 'react'
import { useSearchParams, useRouter } from 'next/navigation'
import { motion, useSpring } from 'framer-motion'
import LoadingScreen from '../components/LoadingScreen'
import Question from '../components/Question'
import 'highlight.js/styles/github.css' // Lighter code block style
import hljs from 'highlight.js'

const QuizPage = () => {
    const params = useSearchParams()
    const router = useRouter()

    const language = params.get('language')
    const difficulty = params.get('difficulty')
    const topic = params.get('topic')
    const numQuestions = Number(params.get('numQuestions'))

    const [quiz, setQuiz] = useState([])
    const [isLoading, setIsLoading] = useState(false)
    const [numSubmitted, setNumSubmitted] = useState(0)
    const [numCorrect, setNumCorrect] = useState(0)
    const [progress, setProgress] = useState(0)
    const [responseStream, setResponseStream] = useState('')

    const scaleX = useSpring(progress, {
        stiffness: 100,
        damping: 30,
        restDelta: 0.002,
    })

    useEffect(() => {
        const generateQuestions = async () => {
            setIsLoading(true)
            let responseText = ''
            try {
                const response = await fetch('/api/chat', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ language, difficulty, topic, numQuestions }),
                })

                if (!response.ok) throw new Error('Failed to fetch data')

                const reader = response.body.getReader()
                const decoder = new TextDecoder()
                let done = false

                while (!done) {
                    const { value, done: doneReading } = await reader.read()
                    done = doneReading
                    responseText += decoder.decode(value)
                    setResponseStream(prev => prev + decoder.decode(value))
                }

                const jsonResponse = JSON.parse(responseText.replace(/\n/g, ''))
                setQuiz(jsonResponse.questions)
            } catch (err) {
                console.error('Quiz Page:', err)
            } finally {
                setIsLoading(false)
            }
        }
        generateQuestions()
    }, [])

    useEffect(() => {
        hljs.highlightAll()
    }, [quiz])

    useEffect(() => {
        setProgress(numSubmitted / numQuestions)
        if (numSubmitted === numQuestions && numQuestions !== 0) {
            const score = numCorrect / numSubmitted
            router.push(`/end-screen?score=${score}`)
        }
    }, [numSubmitted])

    useEffect(() => {
        scaleX.set(progress)
    }, [progress])

    return (
        <div className='min-h-screen flex flex-col items-center bg-gray-50 text-gray-800 px-4 py-10'>
            {/* Progress Bar */}
            <motion.div
                className='fixed top-0 left-0 h-1 bg-emerald-500 origin-left'
                style={{ scaleX }}
            />

            {/* Loading Screen */}
            {isLoading ? (
                <LoadingScreen responseStream={responseStream} />
            ) : (
                <div className='w-full max-w-3xl mt-8 space-y-8'>
                    <h1 className='text-center text-4xl font-semibold text-emerald-600 mb-4'>
                        {topic?.charAt(0).toUpperCase() + topic?.slice(1)} Quiz
                    </h1>

                    {quiz?.map((question, index) => (
                        <div
                            key={index}
                            className='bg-white p-6 rounded-xl shadow-md hover:shadow-lg transition'
                        >
                            <Question
                                question={question}
                                id={index}
                                setNumSubmitted={setNumSubmitted}
                                setNumCorrect={setNumCorrect}
                            />
                        </div>
                    ))}
                </div>
            )}
        </div>
    )
}

export default QuizPage
