import { motion } from 'framer-motion'

const LoadingScreen = () => {
    return (
        <div className="min-h-screen flex flex-col items-center justify-center bg-gradient-to-b from-white to-emerald-50 text-gray-700">
            <motion.div
                animate={{ rotate: 360 }}
                transition={{ repeat: Infinity, duration: 1.5, ease: 'linear' }}
                className="w-16 h-16 border-4 border-emerald-400 border-t-transparent rounded-full mb-8"
            ></motion.div>

            <h1 className="text-3xl font-semibold text-emerald-600 mb-3">
                Generating Your Quiz
            </h1>
            <p className="text-gray-500 text-center max-w-sm">
                Crafting smart, fun questions just for you...  
                This usually takes about <span className="font-medium text-gray-700">20–30 seconds</span>.
            </p>

            <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: [0, 1, 0] }}
                transition={{ repeat: Infinity, duration: 2 }}
                className="mt-10 text-emerald-500 font-medium"
            >
                Please wait ⏳
            </motion.div>
        </div>
    )
}

export default LoadingScreen
