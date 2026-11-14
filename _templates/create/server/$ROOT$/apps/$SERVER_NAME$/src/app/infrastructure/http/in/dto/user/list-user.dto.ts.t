---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
---
import { Transform } from 'class-transformer';
import { IsInt, IsOptional, Min } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { toInt } from '@/app/infrastructure/shared';

export class QUERYListUserDTO {
  @Transform(toInt)
  @IsInt()
  @Min(0)
  @IsOptional()
  @ApiProperty({
    type: String,
    required: false,
    example: '0',
    default: 0,
    description: 'Pagination offset',
  })
  public readonly offset: number = 0;

  @Transform(toInt)
  @IsInt()
  @Min(1)
  @IsOptional()
  @ApiProperty({
    type: String,
    required: false,
    example: '100',
    default: 100,
    description: 'Pagination limit',
  })
  public readonly limit: number = 100;
}
