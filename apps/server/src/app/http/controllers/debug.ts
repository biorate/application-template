import { Controller, Get, Header } from '@nestjs/common';
import { ApiOperation, ApiTags } from '@nestjs/swagger';
import { GETGoogle } from '../../../api';

@ApiTags('Debug')
@Controller('debug')
export class DebugController {
  @Get('google')
  @Header('Content-Type', 'text/html')
  @ApiOperation({ summary: 'google' })
  private async google() {
    const { data } = await GETGoogle.fetch();
    return data;
  }
}
