// Final version  (Groq API compatible, updated model)
// Next.js Edge Function for quiz generation

if (!process.env.GROQ_API_KEY) {
  throw new Error("Missing Groq API Key");
}

export const runtime = "edge"; // define this API route as an Edge Function

export async function POST(request) {
  try {
    const { language, difficulty, topic, numQuestions } = await request.json();

    console.log("Quiz request:", { language, difficulty, topic, numQuestions });

    // Build prompt dynamically
    let firstSentence = "";
    if (language === "javascript" || language === "python") {
      firstSentence =
        topic === "random"
          ? `Give me ${numQuestions} multiple choice questions about a random topic in the ${language} programming language.`
          : `Give me ${numQuestions} multiple choice questions about ${topic} in the ${language} programming language.`;
    } else {
      firstSentence =
        topic === "random"
          ? `Give me ${numQuestions} multiple choice questions about a random topic in ${language}.`
          : `Give me ${numQuestions} multiple choice questions about ${topic} in ${language}.`;
    }

    const prompt = `${firstSentence} The questions should be at an ${difficulty} level. Return your answer entirely in JSON format. The JSON object should have a key named "questions" (an array). Each question must include "query", "choices", "answer", and "explanation". The answer must be the 0-indexed number of the correct choice. Do not include anything except valid JSON.`

    // Call Groq API (OpenAI-compatible endpoint)
    const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${process.env.GROQ_API_KEY}`,
      },
      body: JSON.stringify({
        model: "llama-3.3-70b-versatile", 
        messages: [{ role: "user", content: prompt }],
        temperature: 1,
        max_tokens: 2048,
      }),
    });

    if (!response.ok) {
      const err = await response.text();
      console.error("Groq API error:", err);
      return new Response("Error from Groq API", { status: 500 });
    }

    const data = await response.json();
    const content = data?.choices?.[0]?.message?.content || "{}";

    // Return the generated JSON string
    return new Response(content, {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });

  } catch (err) {
    console.error("Request error:", err);
    return new Response("Request could not be processed.", { status: 500 });
  }
}
