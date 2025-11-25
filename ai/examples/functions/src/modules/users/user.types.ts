// src/modules/users/user.types.ts
export interface User {
    id: string;
    email: string;
    name: string;
    createdAt: Date;
  }
  
  export interface UserCreateDto {
    email: string;
    name: string;
  }
  
  export interface UserUpdateDto {
    name?: string;
  }