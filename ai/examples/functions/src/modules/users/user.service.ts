// src/modules/users/user.service.ts
import * as userRepo from './user.repository';
import { User, UserCreateDto, UserUpdateDto } from './user.types';

export class EmailTakenError extends Error {
  statusCode = 409;
  constructor() {
    super('EMAIL_TAKEN');
  }
}

export async function createUser(dto: UserCreateDto): Promise<User> {
  const existing = await userRepo.findByEmail(dto.email);
  if (existing) {
    throw new EmailTakenError();
  }
  return userRepo.create(dto);
}

export async function getUser(id: string): Promise<User | null> {
  return userRepo.findById(id);
}

export async function updateUser(id: string, dto: UserUpdateDto): Promise<User> {
  return userRepo.update(id, dto);
}