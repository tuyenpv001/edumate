import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { connect } from '../database/connection';


export const create = async (req: Request, res: Response): Promise<Response> => {

    try {

        const { group_uid, question, ans_a, ans_b, ans_c, ans_d, result } = req.body;
        const user_uid = req.idPerson; // User ID được lấy từ middleware xác thực
        const uuid = uuidv4(); // Tạo UUID duy nhất
        const conn = await connect();

        if (!group_uid || !question || !ans_a || !ans_b || !ans_c || !ans_d || !result) {
            return res.status(400).json({ error: "Missing required fields" });
        }

        await conn.query(
            `INSERT INTO quizz_question (uuid, group_uid, question, ans_b, ans_a, ans_c, ans_d, result, user_uid)
           VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
            [uuid, group_uid, question, ans_b, ans_a, ans_c, ans_d, result, user_uid]
        );

        return res.json({
            resp: true,
            message: 'Success.'
        });

    } catch (err) {
        console.log(err);

        return res.status(500).json({
            resp: false,
            message: err
        });
    }

}


export const update = async (req: Request, res: Response): Promise<Response> => {
    try {
        const {uuid} = req.params;
        const {question, ans_a, ans_b, ans_c, ans_d, result } = req.body;

        if (!uuid) {
            return res.status(400).json({ error: "UUID is required for updating a question." });
        }

        const conn = await connect();

        // Xây dựng câu lệnh UPDATE động, chỉ cập nhật các trường được cung cấp
        const fieldsToUpdate = [];
        const values = [];
        if (question) {
            fieldsToUpdate.push("question = ?");
            values.push(question);
        }

        if (ans_a) {
            fieldsToUpdate.push("ans_a = ?");
            values.push(ans_a);
        }

        if (ans_b) {
            fieldsToUpdate.push("ans_b = ?");
            values.push(ans_b);
        }

        if (ans_c) {
            fieldsToUpdate.push("ans_c = ?");
            values.push(ans_c);
        }

        if (ans_d) {
            fieldsToUpdate.push("ans_d = ?");
            values.push(ans_d);
        }

        if (result) {
            fieldsToUpdate.push("result = ?");
            values.push(result);
        }

        // Nếu không có trường nào để cập nhật
        if (fieldsToUpdate.length === 0) {
            return res.status(400).json({ error: "No fields to update." });
        }

        // Thêm UUID vào cuối mảng giá trị
        values.push(uuid);
        values.push(req.idPerson);
        const sql = `UPDATE quizz_question SET ${fieldsToUpdate.join(", ")} WHERE uuid = ? AND  user_uid = ?`;
        const response = await conn.query(sql, values);
        console.log(response);
        
        return res.json({
            resp: true,
            message: 'quizz_question updated successfully'
        });

    } catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};


export const updateResult = async (req: Request, res: Response): Promise<Response> => {
    try {
        const {uuid} = req.params
        const {  result } = req.body;
        console.log(result, uuid);
        if (!uuid) {
            return res.status(400).json({ error: "UUID is required for updating a question." });
        }
        const conn = await connect();
        const response = await conn.query(
            'UPDATE quizz_question SET result = ?  WHERE uuid = ? AND  user_uid = ?',
            [result, uuid,req.idPerson]
        );
        console.log(response);
        
        return res.json({
            resp: true,
            message: 'quizz_question updated successfully'
        });

    } catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};

export const updateGroup = async (req: Request, res: Response): Promise<Response> => {
    try {
        const {uuid} = req.params
        const {  group_uid } = req.body;

        console.log(group_uid, uuid,req.body );
        if (!uuid) {
            return res.status(400).json({ error: "UUID is required for updating a question." });
        }
        const conn = await connect();
        const response = await conn.query(
            'UPDATE quizz_question SET 	group_uid = ?  WHERE uuid = ? AND  user_uid = ?',
            [group_uid, uuid,req.idPerson]
        );
        console.log(response);
        
        return res.json({
            resp: true,
            message: 'quizz_question updated successfully'
        });

    } catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};


export const getAll = async (req: Request, res: Response): Promise<Response> => {
    try {

        const user_uid = req.idPerson;
        console.log(req.query);
        
        let { pageSize, page, keyword = '', groudId = ""} = req.query;
        if(!pageSize) {
            pageSize = '10';
        }
        if(!page) {
            page = '1';
        }
        const limit = parseInt(pageSize as string, 10); 
        const offset = (parseInt(page as string, 10) - 1) * limit; 
        console.log(page, pageSize, keyword);
        
        const conn = await connect();
        console.log(user_uid);

        const result = await conn.query(
            `
            SELECT * 
            FROM quizz_question 
            WHERE user_uid = ? AND question LIKE ?
            LIMIT ? OFFSET ?
            `,
            [user_uid, `%${keyword}%`, limit, offset]
          );

          const [totalRows] = await conn.query(
            `
            SELECT COUNT(*) as total 
            FROM quizz_question 
            WHERE user_uid = ? AND question LIKE ?
            `,
            [user_uid, `%${keyword}%`]
          );
          console.log(totalRows);
          
          const total = (totalRows as any)[0].total; 
          const totalPages = Math.ceil(total / limit); 

        return res.json({
            resp: true,
            message: 'successfully',
            data: result[0],
            total,
            totalPages
        });

    } catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};


export const getAllByCate = async (req: Request, res: Response): Promise<Response> => {
    try {
        const { groudId } = req.params
        console.log(groudId);
        
        const user_uid = req.idPerson;
        const conn = await connect();

        let result = await conn.query(
            'SELECT * FROM quizz_question WHERE user_uid = ? AND group_uid = ?',
            [user_uid, groudId]
        );
       
        return res.json({
            resp: true,
            message: 'successfully',
            data: result[0]
        });

    } catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};


export const deletequizz_question = async (req: Request, res: Response): Promise<Response> => {
    try {
        const { uuid } = req.params;
        const user_uid = req.idPerson;  // Lấy user_uid từ req.idPerson
        const conn = await connect();
        console.log(uuid, user_uid);

        const result = await conn.query(
            'DELETE FROM quizz_question WHERE uuid = ? AND user_uid = ?',
            [uuid, user_uid]
        );


        return res.json({
            resp: true,
            message: 'quizz_question deleted successfully'
        });

    } catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};


export const getById = async (req: Request, res: Response): Promise<Response> => {
    try {

        const { uuid } = req.params;
        const user_uid = req.idPerson;
        const conn = await connect();
        console.log(uuid, user_uid);

        const result = await conn.query(
            'SELECT * FROM quizz_question WHERE uuid = ? AND user_uid = ?',
            [uuid, user_uid]
        );

        return res.json({
            resp: true,
            data: (result[0] as any[]).length > 0 ? (result[0] as any[])[0] : {}
        });

    } catch (err) {
        console.log(err);

        return res.status(500).json({
            resp: false,
            message: 'Internal server error'
        });
    }
};


export const generateRandomTest = async (req: Request, res: Response) => {
    const { numQuestions, groupId } = req.query;
  
    if (!numQuestions || isNaN(parseInt(numQuestions as string)) || parseInt(numQuestions as string) <= 0) {
      return res.status(400).json({
        resp: false,
        message: 'Invalid number'
    });;
    }
  
    const conn = await connect();
  
    try {
        
      if(!groupId){
        let [rows] = await conn.query(
            `
            SELECT * 
            FROM quizz_question 
            ORDER BY RAND() 
            LIMIT ?;
            `,
            [parseInt(numQuestions as string)]
          );
          return res.json({
            resp: true,
            message: "Test generated successfully",
            data: rows,
          });
      }

      let [rows] = await conn.query(
        `
        SELECT * 
        FROM quizz_question  WHERE group_uid = ?
        ORDER BY RAND() 
        LIMIT ?;
        `,
        [ groupId, parseInt(numQuestions as string)]
      );
      return res.json({
        resp: true,
        message: "Test generated successfully",
        data: rows,
      });
      
     
    } catch (error) {
      console.error("Error generating test:", error);
      return res.status(500).json({ resp: false, message: "Internal server error" });
    }
  };
