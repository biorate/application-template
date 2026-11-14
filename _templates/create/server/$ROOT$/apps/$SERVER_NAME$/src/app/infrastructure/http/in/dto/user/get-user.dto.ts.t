---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
---
import { Transform } from 'class-transformer';
import { IsInt, Min } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { toInt } from '@/app/infrastructure/shared';

export class PARAMGetUserDTO {
  @Transform(toInt)
  @IsInt()
  @Min(1)
  @ApiProperty({
    type: String,
    required: true,
    example: '1',
    default: 1,
    description: 'User ID value',
  })
  public readonly id: number;
}
