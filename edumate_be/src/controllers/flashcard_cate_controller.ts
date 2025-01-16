import { Request, Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { connect } from '../database/connection';


export const create = async (req: Request, res: Response): Promise<Response> => {

    try {

        const { name, color } = req.body
        const user_uid = req.idPerson;
        const conn = await connect();
        const uuid = uuidv4();
        await conn.query(
            'INSERT INTO category_flash_card (uuid,name,color, user_uid) value (?,?,?,?)',
            [uuid, name, color, user_uid]
        )

        return res.json({
            resp: true,
            message: 'Success.'
        });

    } catch (err) {
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
            'UPDATE category_flash_card SET name = ?, cate_uuid = ? WHERE uuid = ? AND user_uid = ?',
            [name, cate_uuid, uuid, user_uid]
        );

        return res.json({
            resp: true,
            message: 'category_flash_card updated successfully'
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
            `SELECT 
                cf.*,
                COUNT(f.uuid) AS count 
            FROM 
                category_flash_card cf
            LEFT JOIN 
                flash_card f ON cf.uuid = f.cate_uuid
            WHERE 
                cf.user_uid = ?
            GROUP BY 
                cf.uuid`,
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

export const getPublic = async (req: Request, res: Response): Promise<Response> => {
    try {
        const conn = await connect();
        const result = await conn.query(
            `SELECT 
                fc_cate.*, 
                p.fullname AS creator_name,
                COUNT(fc.uuid) AS count
            FROM 
                flash_card AS fc
            JOIN 
                category_flash_card AS fc_cate ON fc.cate_uuid = fc_cate.uuid
            JOIN 
                person AS p ON fc.user_uid = p.uid
            WHERE 
                fc.public = 1
            GROUP BY 
                fc_cate.uuid, p.fullname
            `
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


export const deletecategory_flash_card = async (req: Request, res: Response): Promise<Response> => {
    try {
        const { uuid } = req.params;
        const user_uid = req.idPerson;  // Lấy user_uid từ req.idPerson
        const conn = await connect();
        console.log(uuid, user_uid);

        const result = await conn.query(
            'DELETE FROM category_flash_card WHERE uuid = ? AND user_uid = ?',
            [uuid, user_uid]
        );


        return res.json({
            resp: true,
            message: 'category_flash_card deleted successfully'
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
            'SELECT * FROM category_flash_card WHERE uuid = ? AND user_uid = ?',
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
