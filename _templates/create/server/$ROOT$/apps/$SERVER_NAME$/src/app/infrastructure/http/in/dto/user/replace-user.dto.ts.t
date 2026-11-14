---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
---
import { IsString } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { PARAMGetUserDTO } from './get-user.dto';

export class PARAMReplaceUserDTO extends PARAMGetUserDTO {}

export class BODYReplaceUserDTO {
  @IsString()
  @ApiProperty({
    type: String,
    required: true,
    example: 'Alice',
    default: 'Alice',
    description: 'User name',
  })
  public readonly name: string;

  @IsString()
  @ApiProperty({
    type: String,
    required: true,
    example: 'alice@example.com',
    default: 'alice@example.com',
    description: 'User email',
  })
  public readonly email: string;
}
