---
to: <%= h.server(ADD_WEB_SOCKET && `${ROOT}/apps/${SERVER_NAME}/src/app/common/infrastructure/gateways/dto/debug/debug.dto.ts`) %>
unless_exists: true
---
import { IsEnum, IsString, IsObject } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';
import { DebugEvents } from '../../events';

export class PUBDebugDataDTO {
  @IsString()
  @ApiProperty({
    type: String,
    required: true,
    description: 'Some string value',
  })
  public readonly value: string;
}

export class SUBDebugDataDTO {
  @IsString()
  @ApiProperty({
    type: String,
    required: true,
    description: 'Hello string value',
  })
  public readonly hello: string;
}

export class PUBDebugDTO {
  @IsEnum([DebugEvents.DebugPub])
  @ApiProperty({
    type: String,
    required: true,
    default: DebugEvents.DebugPub,
    description: 'Event name',
  })
  public readonly event = DebugEvents.DebugPub;

  @IsObject()
  @ApiProperty({
    type: PUBDebugDataDTO,
    required: true,
    description: 'Debug PUB payload',
  })
  @Type(() => PUBDebugDataDTO)
  public readonly data: PUBDebugDataDTO;
}

export class SUBDebugDTO {
  @IsEnum([DebugEvents.DebugSub])
  @ApiProperty({
    type: String,
    required: true,
    default: DebugEvents.DebugSub,
    description: 'Event name',
  })
  public readonly event = DebugEvents.DebugSub;

  @IsObject()
  @ApiProperty({
    type: SUBDebugDataDTO,
    required: true,
    description: 'Debug SUB payload',
  })
  @Type(() => SUBDebugDataDTO)
  public readonly data: SUBDebugDataDTO;
}
