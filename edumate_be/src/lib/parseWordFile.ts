import mammoth from "mammoth";

export interface Question {
  question: string;
  answers: string[];
  correctAnswer?: string;
}

// export async function parseWordFile(filePath: string): Promise<Question[]> {
//   try {
//     const result = await mammoth.extractRawText({ path: filePath });
//     const content = result.value; // Nội dung từ file Word
//     return extractQuestions(content);
//   } catch (error) {
//     console.error("Error processing Word file:", error);
//     throw error;
//   }
// }

// function extractQuestions(content: string): Question[] {
//     const lines = content.split("\n");
//     const questions: Question[] = [];
//     let currentQuestion: Question | null = null;
  
//     lines.forEach((line) => {
//       line = line.trim();
  
//       if (line.startsWith("Câu")) {
//         // Nếu phát hiện câu hỏi mới, lưu câu hỏi hiện tại
//         if (currentQuestion) {
//           questions.push(currentQuestion);
//         }
//         currentQuestion = { question: line, answers: [] };
//       } else if (/^[A-D](?:\.|\)|\s\))\s/.test(line)) {
//         // Tách các đáp án trên dòng hiện tại
//         const matches = line.match(/([A-D](?:\.|\)|\s\))\s.*?)(?=;|$)/g);
//         if (matches) {
//           matches.forEach((answer) => currentQuestion?.answers.push(answer.trim()));
//         }
//       } else {
//         // Nếu không phải câu hỏi hoặc đáp án, nối nội dung vào câu hỏi/đáp án
//         if (currentQuestion) {
//           if (currentQuestion.answers.length === 0) {
//             currentQuestion.question += " " + line;
//           } else {
//             const lastAnswerIndex = currentQuestion.answers.length - 1;
//             currentQuestion.answers[lastAnswerIndex] += " " + line;
//           }
//         }
//       }
//     });
  
//     // Thêm câu hỏi cuối cùng
//     if (currentQuestion) {
//       questions.push(currentQuestion);
//     }
  
//     return questions;
//   }
  

export async function parseWordFile(filePath: string): Promise<Question[]> {
  try {
    // Trích xuất nội dung bao gồm định dạng
    const result = await mammoth.extractRawText({ path: filePath });
    const content = result.value; // Nội dung từ file Word
    return extractQuestions(content);
  } catch (error) {
    console.error("Error processing Word file:", error);
    throw error;
  }
}

function extractQuestions(content: string): Question[] {
  const lines = content.split("\n");
  const questions: Question[] = [];
  let currentQuestion: Question | null = null;

  lines.forEach((line) => {
    line = line.trim();

    if (line.startsWith("Câu")) {
      // Nếu phát hiện câu hỏi mới, lưu câu hỏi hiện tại
      if (currentQuestion) {
        questions.push(currentQuestion);
      }
      currentQuestion = { question: line, answers: [], correctAnswer: "" };
    } else if (/^[A-D](?:\.|\)|\s\))\s/.test(line)) {
      // Tách các đáp án trên dòng hiện tại
      const matches = line.match(/([A-D](?:\.|\)|\s\))\s.*?)(?=;|$)/g);
      if (matches) {
        matches.forEach((answer) => {
          const isBold = /<b>(.*?)<\/b>/i.test(answer); // Kiểm tra in đậm
          const isRed = /<color:red>(.*?)<\/color>/i.test(answer); // Kiểm tra màu đỏ
          const isCorrect = isBold || isRed;

          const cleanAnswer = answer
            .replace(/<b>|<\/b>/g, "") // Loại bỏ thẻ in đậm
            .replace(/<color:red>|<\/color>/g, "") // Loại bỏ thẻ màu đỏ
            .trim();

          currentQuestion?.answers.push(cleanAnswer);

          if (isCorrect) {
            currentQuestion!.correctAnswer = cleanAnswer;
          }
        });
      }
    } else {
      // Nếu không phải câu hỏi hoặc đáp án, nối nội dung vào câu hỏi/đáp án
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

  return questions;
}
