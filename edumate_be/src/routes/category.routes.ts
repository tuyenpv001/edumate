import { Router } from 'express';
import { verifyToken } from '../middleware/verify_token';
import * as category from '../controllers/category_controller';
import * as flashcard from '../controllers/flashcard_controller';
import * as quizz from '../controllers/quizz_controller';
import * as quizz_group from '../controllers/quizz_group_controller';
import * as flashcardCate from '../controllers/flashcard_cate_controller';
import * as  note from '../controllers/note_controller';
import * as group from '../controllers/group_controller';
import * as groupMember from '../controllers/group_member_controller';
import * as material from '../controllers/material_controller';



const router = Router();

    router.post('/category/create',verifyToken, category.create);
    router.get('/category/getall', verifyToken, category.getAll); 
    router.put('/category/update', verifyToken, category.update);
    router.get('/category/getId/:uuid', verifyToken, category.getById);
    router.delete('/category/delete/:uuid', verifyToken, category.deleteCategory); 
  

    router.post('/note/create',verifyToken, note.create);
    router.get('/note/getall', verifyToken, note.getAll); 
    router.put('/note/update', verifyToken, note.update);
    router.get('/note/getId/:uuid', verifyToken, note.getById);
    router.delete('/note/delete/:uuid', verifyToken, note.deletenote); 

    router.post('/flashcard/create',verifyToken, flashcard.create);
    router.get('/flashcard/getall', verifyToken, flashcard.getAll); 
    router.get('/flashcard/getall/:cateUuid', verifyToken, flashcard.getAllByCate); 
    router.put('/flashcard/update', verifyToken, flashcard.update);
    router.put('/flashcard/public/:uuid', verifyToken, flashcard.isPublic);
    router.get('/flashcard/getId/:uuid', verifyToken, flashcard.getById);
    router.delete('/flashcard/delete/:uuid', verifyToken, flashcard.deleteflash_card);
    
    router.post('/flashcard-cate/create',verifyToken, flashcardCate.create);
    router.get('/flashcard-cate/getall', verifyToken, flashcardCate.getAll); 
    router.get('/flashcard-cate/public', verifyToken, flashcardCate.getPublic); 
    router.put('/flashcard-cate/update', verifyToken, flashcardCate.update);
    router.get('/flashcard-cate/getId/:uuid', verifyToken, flashcardCate.getById);
    router.delete('/flashcard-cate/delete/:uuid', verifyToken, flashcardCate.deletecategory_flash_card); 

    // router.post('/material/create',verifyToken, material.create);
    // router.get('/material/getall', verifyToken, material.getAll); 
    // router.put('/material/update', verifyToken, material.update);
    // router.get('/material/getId/:uuid', verifyToken, material.getById);
    // router.delete('/material/delete/:uuid', verifyToken, material.deletematerial); 

    router.post('/group/create',verifyToken, group.create);
    router.get('/group/getall', verifyToken, group.getAll); 
    router.put('/group/update', verifyToken, group.update);
    router.get('/group/getId/:uuid', verifyToken, group.getById);
    router.delete('/group/delete/:uuid', verifyToken, group.deletenew_group); 

    router.post('/group-member/create',verifyToken, groupMember.create);
    router.get('/group-member/getall', verifyToken, groupMember.getAll); 
    router.put('/group-member/update', verifyToken, groupMember.update);
    router.get('/group-member/getId/:uuid', verifyToken, groupMember.getById);
    router.delete('/group-member/delete/:uuid', verifyToken, groupMember.deletegroup_member); 

    router.post('/quizz/create',verifyToken, quizz.create);
    router.get('/quizz/getall', verifyToken, quizz.getAll); 
    router.get('/quizz/generate-random', verifyToken, quizz.generateRandomTest); 
    router.get('/quizz/getall/:groudId', verifyToken, quizz.getAllByCate); 
    router.put('/quizz/update/:uuid', verifyToken, quizz.update);
    router.put('/quizz/update/result/:uuid', verifyToken, quizz.updateResult);
    router.put('/quizz/update/group/:uuid', verifyToken, quizz.updateGroup);
    router.get('/quizz/getId/:uuid', verifyToken, quizz.getById);
    router.delete('/quizz/delete/:uuid', verifyToken, quizz.deletequizz_question);

    router.post('/quizz-group/create',verifyToken, quizz_group.create);
    router.get('/quizz-group/getall', verifyToken, quizz_group.getAll); 
    router.put('/quizz-group/update', verifyToken, quizz_group.update);
    router.get('/quizz-group/getId/:uuid', verifyToken, quizz_group.getById);
    router.delete('/quizz-group/delete/:uuid', verifyToken, quizz_group.deletequiz_group);

    
export default router;