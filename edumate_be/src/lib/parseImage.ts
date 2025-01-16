

  import Tesseract from "tesseract.js";

  interface Question {
    question: string;
    answers: string[];
  }

  export async function extractTextFromImage(imagePath: string): Promise<string> {
    try {
      const result = await Tesseract.recognize(imagePath, "vie", {
        logger: (info) => console.log(info), // Log OCR
      });
      return result.data.text;
    } catch (error) {
      console.error("Error extracting text from image:", error);
      throw error;
    }
  }
  


  
  export function extractQuestions(content: string): Question[] {
    const lines = content.split("\n");
    const questions: Question[] = [];
    let currentQuestion: Question | null = null;
    const answerPattern = /[A-Da-d](?:\.|\))\s.*?(?=;|$|\n)/g;
  
    // Tách danh sách đáp án từ một đoạn văn bản
    function extractAnswers(answerText: string): string[] {
      const matches = answerText.match(answerPattern);
      return matches ? matches.map((answer) => answer.trim()) : [];
    }
  
    lines.forEach((line) => {
      line = line.trim();
  
      if (line.startsWith("Câu")) {
        // Nếu phát hiện câu hỏi mới
        if (currentQuestion) {
          questions.push(currentQuestion);
        }
  
        // Tách câu hỏi và đáp án trên cùng dòng
        const match = line.match(/^(Câu \d+\. .*?)(?=\s[A-D]\.\s)/);
        if (match) {
          const questionText = match[1];
          const answerPart = line.substring(questionText.length).trim();
          currentQuestion = {
            question: questionText,
            answers: extractAnswers(answerPart),
          };
        } else {
          currentQuestion = { question: line, answers: [] };
        }
      } else if (/^[A-Da-d](?:\.|\))\s/.test(line)) {
        // Nếu phát hiện đáp án trên dòng riêng biệt
        const answers = extractAnswers(line);
        currentQuestion?.answers.push(...answers);
      } else {
        // Ghép các dòng không rõ ràng
        if (currentQuestion) {
          if (currentQuestion.answers.length === 0) {
            currentQuestion.question += " " + line;
          } else {
            const lastAnswerIndex = currentQuestion.answers.length - 1;
            currentQuestion.answers[lastAnswerIndex] += " " + line;
          }
        }
      }
    });
  
    if (currentQuestion) {
      questions.push(currentQuestion);
    }
  
    return questions;
  }
  