import { Injectable, NestMiddleware } from '@nestjs/common';
import { counter, Counter } from '@biorate/prometheus';
import { Request, Response, NextFunction } from 'express';

@Injectable()
export class RequestCount implements NestMiddleware {
  @counter({
    name: 'requests_counter',
    help: 'requests counter',
    labelNames: ['method', 'baseUrl', 'statusCode'],
  })
  private counter: Counter;

  public use(req: Request, res: Response, next: NextFunction) {
    this.counter
      .labels({
        method: req.method,
        baseUrl: req.baseUrl,
        statusCode: res.statusCode,
      })
      .inc();
    next();
  }
}
