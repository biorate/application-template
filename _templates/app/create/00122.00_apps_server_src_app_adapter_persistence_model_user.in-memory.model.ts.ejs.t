---
to: <%= h.server(!CUT_EXAMPLES && `${ROOT}/apps/${SERVER_NAME}/src/app/adapter/persistence/model/user.in-memory.model.ts`) %>
unless_exists: true
---
import { IsOptional, IsString, IsNumber } from 'class-validator';
import { AutoObject } from '@biorate/auto-object';

export class UserInMemoryModel extends AutoObject<UserInMemoryModel> {
  @IsNumber()
  public id: number;

  @IsString()
  @IsOptional()
  public name?: string;

  @IsString()
  @IsOptional()
  public email?: string;
}
