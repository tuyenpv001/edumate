import xlsx from "xlsx";

export interface Question {
  question: string;
  answers: string[];
  correctAnswer: string; // Thêm trường đáp án đúng
}

export function parseExcelFile(filePath: string): Question[] {
  try {
    // Đọc file Excel
    const workbook = xlsx.readFile(filePath);

    // Lấy sheet đầu tiên
    const sheetName = workbook.SheetNames[0];
    const sheet = workbook.Sheets[sheetName];

    // Chuyển đổi sheet thành JSON
    const jsonData: any[] = xlsx.utils.sheet_to_json(sheet);

    // Trích xuất câu hỏi, câu trả lời và đáp án đúng
    const questions: Question[] = jsonData.map((row) => ({
      question: row["Question"] || "No question provided",
      answers: [
        row["A"],
        row["B"],
        row["C"],
        row["D"],
      ].filter(Boolean),
      correctAnswer: row["Correct"] || "No correct answer provided", 
    }));

    return questions;
  } catch (error) {
    console.error("Error parsing Excel file:", error);
    throw error;
  }
}
