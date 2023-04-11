import { IsString } from 'class-validator';

/** example */
export class DebugHelloDTO {
  @IsString()
  value: string;
}
