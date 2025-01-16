import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { connect } from '../database/connection';




export const create = async (req: Request, res: Response): Promise<Response> => {

    try {

        const { name} = req.body
        const user_uid = req.idPerson;
        console.log(user_uid,name);
        
        const conn = await connect();
        const uuid = uuidv4();
        await conn.query(
          'INSERT INTO quiz_group (uuid,name, user_uid) value (?,?,?)',
          [uuid, name, user_uid]
        )

        return res.json({
            resp: true,
            message: 'Success.'
        });

    } catch(err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }

}


export const update = async (req: Request, res: Response): Promise<Response> => {
    try {
        const { uuid, name } = req.body;
        const user_uid = req.idPerson;
        const conn = await connect();

        const result = await conn.query(
            'UPDATE quiz_group SET name = ? WHERE uuid = ? AND user_uid = ?',
            [name, uuid,user_uid]
        );

        return res.json({
            resp: true,
            message: 'quiz_group updated successfully'
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
        const conn = await connect();
        console.log(user_uid);
        
        
        const result = await conn.query(
            `SELECT c.*, 
                    COUNT(n.uuid) AS count
             FROM quiz_group c
             LEFT JOIN quizz_question n ON n.group_uid = c.uuid
             WHERE c.user_uid = ?
             GROUP BY c.uuid
            
            `,
            [user_uid]
        );

        console.log((result[0] as any[])[0]);
        return res.json({
            resp: true,
            message: 'successfully',
            data: result[0]
        });

    } catch (err) {
        console.log(err);
        
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};



export const deletequiz_group = async (req: Request, res: Response): Promise<Response> => {
    try {
        const { uuid } = req.params;
        const user_uid = req.idPerson;  // Lấy user_uid từ req.idPerson
        const conn = await connect();
        console.log(uuid, user_uid);
        
        const result = await conn.query(
            'DELETE FROM quiz_group WHERE uuid = ? AND user_uid = ?',
            [uuid, user_uid]
        );

     
        return res.json({
            resp: true,
            message: 'quiz_group deleted successfully'
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
        console.log(req);
        
        const { uuid } = req.params;  
        const user_uid = req.idPerson;  
        const conn = await connect();
        console.log(uuid, user_uid);
        
        const result = await conn.query(
            'SELECT * FROM quiz_group WHERE uuid = ? AND user_uid = ?',
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
            message:  'Internal server error'
        });
    }
};
