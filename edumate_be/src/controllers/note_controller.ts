import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { connect } from '../database/connection';


export const create = async (req: Request, res: Response): Promise<Response> => {

    try {

        let { name, cate_uuid,content } = req.body
        
        const user_uid = req.idPerson;        
        const conn = await connect();
        const uuid = uuidv4();
        console.log(name, cate_uuid,content );
        
       
        if(!cate_uuid) {
          await conn.query(
          'INSERT INTO note (uuid,name,content, user_uid) value (?,?,?,?)',
          [uuid, name,content, user_uid]
        )
        } else {
            await conn.query(
                'INSERT INTO note (uuid,name, cate_uuid,content, user_uid) value (?,?,?,?,?)',
                [uuid, name, cate_uuid,content, user_uid]
              )
        }
        

        console.log("sdsdsds");
        

        return res.json({
            resp: true,
            message: 'Success.'
        });

    } catch(err) {
        console.log(err);
        
        return res.status(500).json({
            resp: false,
            message: err
        });
    }

}


export const update = async (req: Request, res: Response): Promise<Response> => {
    try {
        const { uuid, name, content } = req.body;
        const user_uid = req.idPerson;
        const conn = await connect();
        const result = await conn.query(
            'UPDATE note SET name = ?, content = ? WHERE uuid = ? AND user_uid = ?',
            [name,content,uuid,user_uid]
        );

        return res.json({
            resp: true,
            message: 'note updated successfully'
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
            'SELECT * FROM note WHERE user_uid = ?',
            [user_uid]
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



export const deletenote = async (req: Request, res: Response): Promise<Response> => {
    try {
        const { uuid } = req.params;
        const user_uid = req.idPerson;  // Lấy user_uid từ req.idPerson
        const conn = await connect();
        console.log(uuid, user_uid);
        
        const result = await conn.query(
            'DELETE FROM note WHERE uuid = ? AND user_uid = ?',
            [uuid, user_uid]
        );

     
        return res.json({
            resp: true,
            message: 'note deleted successfully'
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
            'SELECT * FROM note WHERE uuid = ? AND user_uid = ?',
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
