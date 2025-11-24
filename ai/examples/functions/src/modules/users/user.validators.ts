// src/modules/users/user.validators.ts
import { Request, Response, NextFunction } from 'express';

export function validateCreateUser(req: Request, res: Response, next: NextFunction) {
  const { email, name } = req.body ?? {};
  if (typeof email !== 'string' || !email.includes('@')) {
    return res.status(400).json({ message: 'Invalid email' });
  }
  if (typeof name !== 'string' || !name.trim()) {
    return res.status(400).json({ message: 'Invalid name' });
  }
  next();
}