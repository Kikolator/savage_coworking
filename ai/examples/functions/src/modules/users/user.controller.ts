// src/modules/users/user.controller.ts
import { Request, Response } from 'express';
import * as userService from './user.service';
import { UserCreateDto, UserUpdateDto } from './user.types';

export async function createUserController(req: Request, res: Response) {
  try {
    const dto = req.body as UserCreateDto;
    const user = await userService.createUser(dto);
    return res.status(201).json(user);
  } catch (err: any) {
    if (err.statusCode) {
      return res.status(err.statusCode).json({ message: err.message });
    }
    return res.status(500).json({ message: 'INTERNAL_ERROR' });
  }
}

export async function getUserController(req: Request, res: Response) {
  try {
    const { id } = req.params;
    const user = await userService.getUser(id);
    if (!user) return res.status(404).json({ message: 'NOT_FOUND' });
    return res.json(user);
  } catch (err: any) {
    return res.status(500).json({ message: 'INTERNAL_ERROR' });
  }
}

export async function updateUserController(req: Request, res: Response) {
  try {
    const { id } = req.params;
    const dto = req.body as UserUpdateDto;
    const user = await userService.updateUser(id, dto);
    return res.json(user);
  } catch (err: any) {
    if (err.statusCode) {
      return res.status(err.statusCode).json({ message: err.message });
    }
    return res.status(500).json({ message: 'INTERNAL_ERROR' });
  }
}