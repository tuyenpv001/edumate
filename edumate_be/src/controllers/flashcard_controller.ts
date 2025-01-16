import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { connect } from '../database/connection';


export const create = async (req: Request, res: Response): Promise<Response> => {

    try {

        const { name, color,font, back,cate_uuid } = req.body
        const user_uid = req.idPerson;        
        const conn = await connect();
        const uuid = uuidv4();
        await conn.query(
          'INSERT INTO flash_card (uuid,name,color,font,back, cate_uuid, user_uid) value (?,?,?,?,?,?,?)',
          [uuid, name, color,font, back,cate_uuid, user_uid]
        )

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
        const { uuid, cate_uuid } = req.body;
        const user_uid = req.idPerson;
        const conn = await connect();
        const result = await conn.query(
            'UPDATE flash_card SET name = ?, cate_uuid = ? WHERE uuid = ? AND user_uid = ?',
            [name, cate_uuid,uuid,user_uid]
        );

        return res.json({
            resp: true,
            message: 'flash_card updated successfully'
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
            'SELECT * FROM flash_card WHERE user_uid = ?',
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


export const getAllByCate = async (req: Request, res: Response): Promise<Response> => {
    try {
        const {cateUuid} = req.params
        const {isPublic} = req.query;
        const user_uid = req.idPerson;
        const conn = await connect();
        console.log(user_uid, isPublic);

        let   result = null;
        if(isPublic == '1'){
            result = await conn.query(
                'SELECT * FROM flash_card WHERE user_uid = ? AND cate_uuid = ? AND public = ?',
                [user_uid, cateUuid, isPublic]
            );
        } else {
            result = await conn.query(
                'SELECT * FROM flash_card WHERE user_uid = ? AND cate_uuid = ?',
                [user_uid, cateUuid]
            );  
        }

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


export const deleteflash_card = async (req: Request, res: Response): Promise<Response> => {
    try {
        const { uuid } = req.params;
        const user_uid = req.idPerson;  // Lấy user_uid từ req.idPerson
        const conn = await connect();
        console.log(uuid, user_uid);
        
        const result = await conn.query(
            'DELETE FROM flash_card WHERE uuid = ? AND user_uid = ?',
            [uuid, user_uid]
        );

     
        return res.json({
            resp: true,
            message: 'flash_card deleted successfully'
        });

    } catch (err) {
        return res.status(500).json({
            resp: false,
            message: err
        });
    }
};

export const isPublic = async (req: Request, res: Response): Promise<Response> => {
    try {
        const { isPublic } = req.body;
        const {uuid} = req.params;
        const user_uid = req.idPerson; 
        const conn = await connect();
        console.log(isPublic);
        
        
        const result = await conn.query(
            'UPDATE flash_card SET public = ? WHERE uuid = ? AND user_uid = ?',
            [parseInt(isPublic), uuid, user_uid]
        );
console.log(result);

     
        return res.json({
            resp: true,
            message: 'flash_card public successfully'
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
            'SELECT * FROM flash_card WHERE uuid = ? AND user_uid = ?',
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
