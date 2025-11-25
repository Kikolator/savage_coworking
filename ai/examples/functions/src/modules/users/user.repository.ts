// src/modules/users/user.repository.ts
import { db } from '../../config/firebaseAdmin';
import { User, UserCreateDto, UserUpdateDto } from './user.types';

const col = () => db().collection('users');

export async function findById(id: string): Promise<User | null> {
  const doc = await col().doc(id).get();
  if (!doc.exists) return null;
  return { id: doc.id, ...(doc.data() as Omit<User, 'id'>) };
}

export async function findByEmail(email: string): Promise<User | null> {
  const snap = await col().where('email', '==', email).limit(1).get();
  if (snap.empty) return null;
  const doc = snap.docs[0];
  return { id: doc.id, ...(doc.data() as Omit<User, 'id'>) };
}

export async function create(dto: UserCreateDto): Promise<User> {
  const now = new Date();
  const docRef = await col().add({
    ...dto,
    createdAt: now,
  });
  return { id: docRef.id, email: dto.email, name: dto.name, createdAt: now };
}

export async function update(id: string, dto: UserUpdateDto): Promise<User> {
  const ref = col().doc(id);
  await ref.update({ ...dto });
  const updated = await ref.get();
  return { id: updated.id, ...(updated.data() as Omit<User, 'id'>) };
}