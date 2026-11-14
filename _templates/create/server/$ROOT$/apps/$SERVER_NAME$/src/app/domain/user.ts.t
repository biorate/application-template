---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
---
import { AutoObject, Getter } from '@biorate/auto-object';
import { IsInt, IsNumber, IsString, IsObject, IsOptional } from 'class-validator';
import { Type } from 'class-transformer';

class UserAddress extends AutoObject<UserAddress> {
  @IsString()
  @IsOptional()
  public city: string;

  @IsString()
  @IsOptional()
  public street: string;

  @IsNumber()
  @IsOptional()
  public apartment: number;

  @IsNumber()
  @IsOptional()
  public postal: number;

  public get inline() {
    return <Getter<string>>(
      `${this.postal}, ${this.city}, ${this.street} №${this.apartment}`
    );
  }
}

export class User extends AutoObject<User> {
  @IsInt()
  public id: number;

  @IsString()
  @IsOptional()
  public name?: string;

  @IsString()
  @IsOptional()
  public email?: string;

  @IsObject()
  @IsOptional()
  @Type(() => UserAddress)
  public address?: UserAddress;
}
