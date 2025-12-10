# 🧠 AI Quiz Generator

An intelligent quiz app powered by **Groq’s LLaMA 3.3-70B** model that dynamically generates multiple-choice quizzes based on your selected **language**, **topic**, **difficulty**, and **number of questions**.

Built with **Next.js (App Router)** and **Tailwind CSS**, it offers a clean, responsive interface and instant feedback when the quiz is complete.

---

## 🚀 Features

- AI-generated quizzes using **Groq’s LLaMA 3.3-70B** model  
- Customizable parameters (language, topic, difficulty, number of questions)  
- Multiple-choice questions with explanations and score tracking  
- Smooth transitions and minimal, responsive design  
- No unnecessary animations or music for a distraction-free experience  

---

## 🧩 Tech Stack

| Category | Technology |
|-----------|-------------|
| Framework | Next.js 13 (App Router) |
| Styling | Tailwind CSS |
| AI Model | **LLaMA 3.3-70B (Via Groq API)** |
| Animation | Framer Motion |
| Syntax Highlighting | Highlight.js |
| Icons | React Icons |

---

## 📦 Dependencies

| Package | Purpose |
|----------|----------|
| `framer-motion` | UI animations |
| `highlight.js` | Code syntax highlighting |
| `react-icons` | Vector icons |
| `react-confetti` | Celebration effect on high scores |
| `react-loader-spinner` | Loading animations |
| `react-simple-typewriter` | Typing effect for headings |

---

## ⚙️ Setup & Run Locally

### 1. Get the code on your local machine

### 2. Install dependencies
```bash
npm install
```

### 3. Add your Groq API key
Create a file named `.env.local` in the root directory:
```bash
GROQ_API_KEY=your_groq_api_key_here
```

### 4. Run the development server
```bash
npm run dev
```
Open **[http://localhost:3000](http://localhost:3000)** in your browser.

---

## 🧠 How It Works

1. The app collects quiz preferences from the user (language, topic, difficulty, number of questions).  
2. It constructs a **dynamic prompt** like this:  
   > “Give me 5 multiple-choice questions about JavaScript arrays at a beginner level. Return only valid JSON with question text, options, correct answer, and explanation.”  
3. The prompt is sent to **Groq’s OpenAI-compatible endpoint**:  
   ```
   https://api.groq.com/openai/v1/chat/completions
   ```  
4. Groq’s **LLaMA 3.3-70B** model returns structured JSON with all questions and answers.  
5. The app renders them interactively with real-time scoring and an end screen summary.

---

## 🧾 API Route Explanation

The backend logic for quiz generation lives in `app/api/route.js` and runs as a **Next.js Edge Function**.

### Key points:

```javascript
// app/api/route.js
export const runtime = "edge";

export async function POST(request) {
  const { language, difficulty, topic, numQuestions } = await request.json();

  const prompt = `Give me ${numQuestions} multiple choice questions about ${topic} in ${language} at a ${difficulty} level. Return valid JSON.`;

  const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: \`Bearer ${process.env.GROQ_API_KEY}\`,
    },
    body: JSON.stringify({
      model: "llama-3.3-70b-versatile",
      messages: [{ role: "user", content: prompt }],
      temperature: 1,
      max_tokens: 2048,
    }),
  });

  const data = await response.json();
  return new Response(data.choices[0].message.content, { status: 200 });
}
```

This function dynamically builds a prompt, sends it to **Groq’s LLaMA 3.3-70B**, and returns clean JSON containing the generated quiz.

---


## 📁 Folder Structure

```
AI-Quiz-Generator/
├── app/
│   ├── api/                 # Edge route for Groq quiz generation
│   ├── components/          # UI components
│   ├── constants/           # Static data (topics, messages)
│   ├── end-screen/          # End screen UI
│   ├── quiz/                # Quiz interface logic
│   └── utils/               # Helper functions
├── public/                  # Favicon and static assets
├── .env.local               # Environment variables
├── package.json
├── next.config.js
├── Dockerfile
├── docker-compose.yml
├── Makefile
├── DOCKER_CICD_GUIDE.md
└── README.md
```

---

## 🐳 Docker & CI/CD Setup

This project includes complete Docker containerization and GitHub Actions CI/CD pipelines.

### Quick Start with Docker

**Development (with hot reload):**
```bash
docker-compose up
```

**Production:**
```bash
docker build -t ai-quiz-generator:latest --target production .
docker run -p 3000:3000 --env-file .env.local ai-quiz-generator:latest
```

### GitHub Actions Pipelines

Two automated workflows are included:

1. **CI Pipeline** (`cicd.yml`) - Runs on every push/PR
   - Linting and testing
   - Docker image build and push
   - Security vulnerability scanning

2. **Deployment Pipeline** (`deploy.yml`) - Triggered by version tags
   - Builds and pushes Docker image to GitHub Container Registry
   - Creates GitHub releases automatically

### Setup Instructions

See [DOCKER_CICD_GUIDE.md](./DOCKER_CICD_GUIDE.md) for:
- Detailed Docker commands
- GitHub Actions configuration
- Environment variable setup
- Troubleshooting guide
- Security best practices

### Quick Commands

```bash
# Local development
make docker-up

# Build production image
make build-docker

# Run production container
make run-docker

# View all available commands
make help
```

---