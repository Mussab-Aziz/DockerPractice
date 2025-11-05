'use client'

import { useState, useEffect } from 'react'
import { useSearchParams, useRouter } from 'next/navigation'
import { pickRandom } from '../utils'
import { endMessages } from '../constants/endMessages'

const EndScreen = () => {
    const router = useRouter()
    const params = useSearchParams()
    const score = Number(params.get('score'))
    const [message, setMessage] = useState('')

    useEffect(() => {
        let grade = ''
        if (score === 1) grade = 'perfect'
        else if (score >= 0.7) grade = 'good'
        else grade = 'bad'

        const randomMessage = pickRandom(endMessages[grade])
        setMessage(randomMessage)
    }, [])

    const handlePlayAgain = () => router.push('/')

    const percentage = Math.round(score * 100)

    return (
        <div className="min-h-screen flex flex-col items-center justify-center bg-gray-50 text-gray-800 px-6 text-center">
            <div className="max-w-xl bg-white p-10 rounded-2xl shadow-md border border-gray-200">
                <h1 className="text-5xl font-bold mb-6 text-emerald-600">
                    Quiz Complete!
                </h1>

                <p className="text-2xl mb-4">
                    Your Score:{' '}
                    <span className="font-semibold text-emerald-500">
                        {percentage}%
                    </span>
                </p>

                <p className="text-lg text-gray-600 mb-8">{message}</p>

                <button
                    onClick={handlePlayAgain}
                    className="px-8 py-3 bg-emerald-500 text-white font-medium rounded-lg shadow hover:bg-emerald-400 transition active:scale-95"
                >
                    Play Again
                </button>
            </div>
        </div>
    )
}

export default EndScreen
