'use client'

import './globals.css'
import { Inter, Poppins, Lato } from 'next/font/google'
import Script from 'next/script'

// Load Google fonts
const poppins = Poppins({ subsets: ['latin'], weight: '400' })
const inter = Inter({ subsets: ['latin'] })
const lato = Lato({ subsets: ['latin'], weight: '400' })

export default function RootLayout({ children }) {
    return (
        <html lang='en'>
            <head>
                <title>AI Quiz Generator</title>
                <link rel="icon" href="my-favicon-32x32.png" type="image/x-icon" />
            </head>

            <body className={`${poppins.className} relative`}>
                <div className='bg-grid'>
                    <div className='gradient' />
                </div>

                {/* Removed AudioPlayer component */}

                <main className='relative z-10 max-w-7xl mx-auto sm:px-16 px-6'>
                    {children}
                </main>
            </body>

            {/* Google tag (gtag.js) */}
            <Script
                async
                strategy='afterInteractive'
                src='https://www.googletagmanager.com/gtag/js?id=G-BKK7659J87'
            />
            <Script strategy='afterInteractive' src='/analytics.js' />
        </html>
    )
}
