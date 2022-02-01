import { BaseError } from '@biorate/errors';
import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  BadRequestException,
} from '@nestjs/common';

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  public catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();
    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : (exception as BaseError)?.meta?.status ?? HttpStatus.INTERNAL_SERVER_ERROR;
    this.log(exception);
    response.status(status).json({
      status,
      code: this.code(exception),
      hint: this.hint(exception),
      path: request.url,
    });
  }

  private code(exception: unknown) {
    return (exception as BaseError).code ?? exception.constructor.name;
  }

  private hint(exception: unknown) {
    return (
      (
        (exception as BadRequestException)?.getResponse?.() as unknown as {
          message?: [string];
        }
      )?.message ?? (exception as BaseError).message
    );
  }

  private log(exception: Record<string, any>) {
    console.error(exception);
  }
}
