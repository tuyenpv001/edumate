import {connect} from '../database/connection';
import { v4 as uuidv4 } from "uuid";

export async function saveQuestionsToDb(
  questions: {
    question: string;
    answers: string[];
    correctAnswer?: string;
  }[],
  groupUid: string,
  userUid: string
) {
  try {
    const conn = await connect();
    const pool = await conn.getConnection();
    try {
      // Thực hiện giao dịch
      await pool.beginTransaction();

      for (const q of questions) {
        const uuid = uuidv4();
        const [result] = await conn.query(
          `INSERT INTO quizz_question (uuid, group_uid, question, ans_a, ans_b, ans_c, ans_d, result, user_uid)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
          [
            uuid,
            groupUid,
            q.question,
            q.answers[0] || "",
            q.answers[1] || "",
            q.answers[2] || "",
            q.answers[3] || "",
            q.correctAnswer,
            userUid,
          ]
        );
      }

      // Commit giao dịch
      await pool.commit();
      console.log(`${questions.length} questions saved successfully!`);
    } catch (error) {
      // Rollback nếu có lỗi
      await pool.rollback();
      console.error("Error saving questions to database, transaction rolled back:", error);
      throw error;
    } finally {
        pool.release();
    }
  } catch (error) {
    console.error("Error connecting to database:", error);
    throw error;
  }
}
