import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { connect } from '../database/connection';


export const create = async (req: Request, res: Response): Promise<Response> => {

    try {

        const { group_uuid } = req.body
        const user_uid = req.idPerson;        
        const conn = await connect();
        const uuid = uuidv4();
        await conn.query(
          'INSERT INTO group_member (uuid,group_uuid, user_uid) value (?,?,?)',
          [uuid, group_uuid, user_uid]
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
        const { uuid, cate_uuid } = req.body;
        const user_uid = req.idPerson;
        const conn = await connect();
        const result = await conn.query(
            'UPDATE group_member SET name = ?, cate_uuid = ? WHERE uuid = ? AND user_uid = ?',
            [name, cate_uuid,uuid,user_uid]
        );

        return res.json({
            resp: true,
            message: 'group_member updated successfully'
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
            'SELECT * FROM group_member WHERE user_uid = ?',
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



export const deletegroup_member = async (req: Request, res: Response): Promise<Response> => {
    try {
        const { uuid } = req.params;
        const user_uid = req.idPerson;  // Lấy user_uid từ req.idPerson
        const conn = await connect();
        console.log(uuid, user_uid);
        
        const result = await conn.query(
            'DELETE FROM group_member WHERE uuid = ? AND user_uid = ?',
            [uuid, user_uid]
        );

     
        return res.json({
            resp: true,
            message: 'group_member deleted successfully'
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
            'SELECT * FROM group_member WHERE uuid = ? AND user_uid = ?',
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
