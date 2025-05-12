---
to: <%= h.server(CUT_EXAMPLES || `${ROOT}/apps/${SERVER_NAME}/src/app/http/dto/crud.ts`) %>
unless_exists: true
---
import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsEnum } from 'class-validator';

/** example */
export class GetCrudItemDTO {
  @IsString()
  @ApiProperty({ type: String, required: true })
  id: string;
}
