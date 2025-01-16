import { Router } from 'express';
import path from "path";
import { uploadsMaterial } from '../lib/multer';
import { parseWordFile, Question } from '../lib/parseWordFile';
import { parsePdfFile } from '../lib/parsePdfFile';
import { parseExcelFile } from '../lib/parseExcelFile';
import { saveQuestionsToDb } from '../lib/saveQuestion';
import { verifyToken } from '../middleware/verify_token';
import { v4 as uuidv4 } from 'uuid';
import fs from 'fs';
import { Request, Response } from 'express';
import { log } from 'console';
import { extractQuestions, extractTextFromImage } from '../lib/parseImage';
import { connect } from '../database/connection';

const router = Router();

router.post('/upload', [verifyToken, uploadsMaterial.single('file')], async (req: Request, res: Response) => {
    const filePath = req.file?.path;
    const ext = path.extname(req.file?.originalname || "").toLowerCase();
    if (!filePath || !ext) {
        return res.status(400).json({ error: "Invalid file" });
    }
    let questions: Question[] = [];
    let user_uid = req.idPerson
    let {group_uid } = req.query
    console.log("lkkkk",group_uid,req.query);
    
    try {

        if (ext === ".docx") {
            questions = await parseWordFile(filePath);
        } else if (ext === ".pdf") {
            questions = await parsePdfFile(filePath);
        } else if (ext === ".xlsx") {
            questions = parseExcelFile(filePath);
        } else if (ext === '.png' || ext === '.jpg') {
            const extractedText = await extractTextFromImage(filePath);
             console.log("Extracted text:", extractedText);

    // Tách câu hỏi và đáp án
             questions = extractQuestions(extractedText);
        }
        else {
            return res.status(400).json({ error: "Unsupported file format" });
        }
        console.log(questions);

        await saveQuestionsToDb(questions, group_uid as string, user_uid);
        res.json({ questions });
    } catch (error: any) {
        console.error("Error processing file:", error);
        res.status(500).json({ error: "Error processing file", details: error.message });
    }
});


router.post('/material/upload', [verifyToken, uploadsMaterial.single('file')], async (req: Request, res: Response) => {
    try {
     
        
         const uuid = uuidv4();
        const filePath = path.basename(req.file?.path || "");
        const fileName = req.file?.originalname;
        const fileExtension = path.extname(req.file?.originalname || "").toLowerCase();
        const conn = await connect();
        // Kiểm tra dữ liệu đầu vào
        if (!filePath || !fileName || !fileExtension) {
            return res.status(400).json({ message: 'File upload failed' });
        }
        console.log(filePath);
        
        // Lưu thông tin tệp vào cơ sở dữ liệu
        const query = `
            INSERT INTO material (uuid,file_path, file_name, file_extension,user_uid)
            VALUES (?, ?, ?, ?,?);
        `;
        const values = [uuid,filePath, fileName, fileExtension, req.idPerson];

        const result = await conn.query(query, values);

        return res.json({
            resp: true,
            message: 'Success.'
        });
    } catch (error) {
        console.log(error);
        
        return res.status(500).json({
            resp: false,
            message: error
        });
    }
});



router.get('/material/getall', verifyToken, async (req: Request, res: Response) => {
    try {

        const user_uid = req.idPerson;
        let { pageSize, page, keyword = ''} = req.query;
        if(!pageSize) {
            pageSize = '10';
        }
        if(!page) {
            page = '1';
        }

        const limit = parseInt(pageSize as string, 10); 
        const offset = (parseInt(page as string, 10) - 1) * limit; 
        const conn = await connect();


        const result = await conn.query(
            `
            SELECT * 
            FROM material 
            WHERE user_uid = ? AND file_name LIKE ?
            LIMIT ? OFFSET ?
            `,
            [user_uid, `%${keyword}%`, limit, offset]
          );

          const [totalRows] = await conn.query(
            `
            SELECT COUNT(*) as total 
            FROM material 
            WHERE user_uid = ? AND file_name LIKE ?
            `,
            [user_uid, `%${keyword}%`]
          );

          
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


});

router.delete('/material/delete/:uuid', verifyToken, async (req: Request, res: Response) => {
    try {
        const { uuid } = req.params;

        const conn = await connect();
        const [rows]: any = await conn.query('SELECT file_path FROM material WHERE uuid = ?', [uuid]);
        
        if (rows.length === 0) {
            return res.status(404).json({
                resp: false,
                message: 'File not found',
            });
        }

        const filePath = path.resolve(__dirname,'..' ,'uploads','material', rows[0].file_path);    
        // Kiểm tra file có tồn tại trong hệ thống không
        if (fs.existsSync(filePath)) {
            fs.unlinkSync(filePath); // Xóa file khỏi hệ thống
        }

        // Xóa thông tin file khỏi cơ sở dữ liệu
        await conn.query('DELETE FROM material WHERE uuid = ?', [uuid]);

        return res.json({
            resp: true,
            message: 'File deleted successfully',
        });
    } catch (error) {
        console.error(error);
        return res.status(500).json({
            resp: false,
            message: 'An error occurred',
        });
    }
});



export default router;