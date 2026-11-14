---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
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
