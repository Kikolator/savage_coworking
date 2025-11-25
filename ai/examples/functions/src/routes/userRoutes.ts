// src/api/routes/userRoutes.ts
import { Router } from 'express';
import {
  createUserController,
  getUserController,
  updateUserController,
} from '../../modules/users/user.controller';
import { validateCreateUser } from '../../modules/users/user.validators';

export const userRouter = Router();

userRouter.post('/', validateCreateUser, createUserController);
userRouter.get('/:id', getUserController);
userRouter.patch('/:id', updateUserController);