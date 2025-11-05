import { useEffect, useState } from 'react'
import { HiCheck, HiOutlineXMark } from 'react-icons/hi2'

const Question = ({ question, id, setNumSubmitted, setNumCorrect }) => {
    const { query, choices, answer, explanation } = question
    const [isSubmitted, setIsSubmitted] = useState(false)
    const [isExplained, setIsExplained] = useState(false)
    const [isSelected, setIsSelected] = useState(false)
    const [selectedChoiceIndex, setSelectedChoiceIndex] = useState(-1)

    const [choiceObjects, setChoiceObjects] = useState(() =>
        choices.map((choice) => ({
            text: choice,
            isSelected: false,
        }))
    )

    const isCorrect = () => Number(answer) === selectedChoiceIndex

    const handleChoiceSelect = (choiceIndex) => {
        if (isSubmitted) return
        setSelectedChoiceIndex(choiceIndex)
        setIsSelected(true)
        setChoiceObjects((prev) =>
            prev.map((c, i) => ({ ...c, isSelected: i === choiceIndex }))
        )
    }

    const handleAnswerSubmit = () => {
        if (isSubmitted) return
        setIsSubmitted(true)
        setNumSubmitted((p) => p + 1)
        setSelectedChoiceIndex(choiceObjects.findIndex((c) => c.isSelected))
        if (isCorrect()) {
            setNumCorrect((p) => p + 1)
            setIsExplained(true)
        }
    }

    const handleExplain = () => setIsExplained(true)

    const submitButtonStyles = () => {
        if (isSubmitted)
            return 'pointer-events-none opacity-50 bg-gray-300 text-gray-600'
        return isSelected
            ? 'bg-emerald-500 hover:bg-emerald-400 text-white'
            : 'bg-gray-200 text-gray-700 hover:bg-gray-300 cursor-not-allowed opacity-70'
    }

    const explainButtonStyles = () => {
        return isExplained
            ? 'pointer-events-none opacity-50 bg-gray-200 text-gray-600'
            : 'bg-emerald-100 text-emerald-700 hover:bg-emerald-200'
    }

    const renderChoices = () => {
        return choiceObjects?.map((choice, index) => {
            let style = choice.isSelected
                ? 'border-emerald-400 bg-emerald-50'
                : 'border-gray-300 hover:bg-emerald-50'

            let checkOrX = null

            if (isSubmitted) {
                if (index === selectedChoiceIndex) {
                    if (isCorrect()) {
                        style = 'border-emerald-400 bg-emerald-100'
                        checkOrX = <HiCheck size={30} color="#059669" />
                    } else {
                        style = 'border-red-400 bg-red-100'
                        checkOrX = <HiOutlineXMark size={30} color="#dc2626" />
                    }
                }
            }

            if (isExplained && index === Number(answer)) {
                style = 'border-emerald-400 bg-emerald-100'
                checkOrX = <HiCheck size={30} color="#059669" />
            }

            return (
                <div
                    key={index}
                    className={`w-full p-4 text-left border rounded cursor-pointer ${style} flex items-center justify-between`}
                    onClick={() => handleChoiceSelect(index)}
                >
                    <pre className="whitespace-pre-wrap">
                        <code
                            className="rounded"
                            style={{ padding: 5, backgroundColor: 'transparent' }}
                        >
                            {choice.text}
                        </code>
                    </pre>
                    {checkOrX}
                </div>
            )
        })
    }

    useEffect(() => {
        setChoiceObjects(
            choices.map((choice) => ({
                text: choice,
                isSelected: false,
            }))
        )
    }, [])

    return (
        <div className="max-w-3xl mx-auto">
            <h2 className="text-sm font-semibold text-gray-600">
                Question {id + 1}
            </h2>
            <div className="border border-gray-200 rounded bg-white p-4">
                <div className="py-2 mt-2 text-xl">{query}</div>
                <div className="grid gap-2 mt-4">{renderChoices()}</div>
                <div className="flex items-center justify-end gap-2 mt-4">
                    {isSubmitted && (
                        <button
                            onClick={handleExplain}
                            className={`px-6 py-2 rounded transition ${explainButtonStyles()}`}
                        >
                            Explain
                        </button>
                    )}
                    <button
                        onClick={handleAnswerSubmit}
                        className={`px-6 py-2 font-semibold rounded transition ${submitButtonStyles()}`}
                    >
                        {isSubmitted ? 'Submitted' : 'Submit'}
                    </button>
                </div>
                {((isSubmitted && isCorrect()) || isExplained) && (
                    <div className="mt-4 p-4 rounded bg-emerald-50 border border-emerald-200">
                        <h3 className="text-emerald-700 text-sm font-bold">
                            Explanation
                        </h3>
                        <p className="mt-2 text-sm text-gray-700">{explanation}</p>
                    </div>
                )}
            </div>
        </div>
    )
}

export default Question
