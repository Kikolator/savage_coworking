// src/modules/users/__tests__/user.service.test.ts
import * as service from '../user.service';
import * as repo from '../user.repository';
import { UserCreateDto } from '../user.types';

jest.mock('../user.repository');

describe('user.service', () => {
  const dto: UserCreateDto = { email: 'test@example.com', name: 'Test' };

  beforeEach(() => {
    jest.resetAllMocks();
  });

  it('throws EmailTakenError when email already exists', async () => {
    (repo.findByEmail as jest.Mock).mockResolvedValue({
      id: '1',
      email: dto.email,
      name: dto.name,
      createdAt: new Date(),
    });

    await expect(service.createUser(dto)).rejects.toThrow('EMAIL_TAKEN');
  });

  it('creates user when email is free', async () => {
    (repo.findByEmail as jest.Mock).mockResolvedValue(null);
    (repo.create as jest.Mock).mockResolvedValue({
      id: '1',
      email: dto.email,
      name: dto.name,
      createdAt: new Date(),
    });

    const user = await service.createUser(dto);

    expect(user.email).toBe(dto.email);
    expect(repo.create).toHaveBeenCalledWith(dto);
  });
});