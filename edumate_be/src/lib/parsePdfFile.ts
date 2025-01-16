import pdf from "pdf-parse";
import fs from "fs";
import { PDFDocument } from "pdf-lib";

export interface Question {
  question: string;
  answers: string[];
  correctAnswer?: string;
}

export async function parsePdfFile(filePath: string): Promise<Question[]> {
  try {
    const dataBuffer = require("fs").readFileSync(filePath);
    const result = await pdf(dataBuffer);
    const content = result.text; // Nội dung từ file PDF
    return extractQuestions(content);
  } catch (error) {
    console.error("Error processing PDF file:", error);
    throw error;
  }
}

function extractQuestions(content: string): Question[] {
    const lines = content.split("\n");
    const questions: Question[] = [];
    let currentQuestion: Question | null = null;
    const answerPattern = /[A-Da-d](?:\.|\))\s.*?(?=;|$|\n)/g;
  
    // Hàm tách đáp án
    function extractAnswers(answerText: string): string[] {
      const matches = answerText.match(answerPattern);
      return matches ? matches.map((answer) => answer.trim()) : [];
    }
  
    // Lần chạy chính (lần 1)
    lines.forEach((line) => {
      line = line.trim();
  
      if (line.startsWith("Câu")) {
        // Nếu phát hiện câu hỏi mới, lưu câu hỏi hiện tại
        if (currentQuestion) {
          questions.push(currentQuestion);
        }
  
        // Tách câu hỏi và đáp án trên cùng một dòng
        const match = line.match(/^(Câu \d+\. .*?)(?=\s[A-D]\.\s)/);
        if (match) {
          const questionText = match[1];
          const answerPart = line.substring(questionText.length).trim();
          currentQuestion = {
            question: questionText,
            answers: extractAnswers(answerPart),
          };
        } else {
          // Nếu không phát hiện đáp án trên dòng này, chỉ lưu câu hỏi
          currentQuestion = { question: line, answers: [] };
        }
      } else if (/^[A-Da-d](?:\.|\))\s/.test(line)) {
        // Nếu phát hiện đáp án trên dòng riêng biệt
        const answers = extractAnswers(line);
        currentQuestion?.answers.push(...answers);
      } else {
        // Ghép các dòng không rõ ràng vào câu hỏi hoặc đáp án hiện tại
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
  
    // Thêm câu hỏi cuối cùng
    if (currentQuestion) {
      questions.push(currentQuestion);
    }
  
    // Hàm xử lý các câu hỏi không có đáp án
    function handleUnansweredQuestions() {
      const unanswered = questions.filter((q) => q.answers.length === 0);
  
      unanswered.forEach((q) => {
        // Tách đáp án trực tiếp từ nội dung câu hỏi nếu có
        const match = q.question.match(/([A-Da-d](?:\.|\))\s.*?)(?=;|$)/g);
        if (match) {
          q.answers = match.map((answer) => answer.trim());
        }
      });
    }
  
    // Chạy thêm 2 lần để xử lý các câu hỏi chưa có đáp án
    for (let i = 0; i < 2; i++) {
      handleUnansweredQuestions();
    }
  
    return questions;
  }
