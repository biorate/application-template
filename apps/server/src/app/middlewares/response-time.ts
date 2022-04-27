import { Injectable, NestMiddleware } from '@nestjs/common';
import { inject, Types } from '@biorate/inversion';
import { IConfig } from '@biorate/config';
import { histogram, Histogram } from '@biorate/prometheus';
import { Request, Response, NextFunction } from 'express';
import * as onHeaders from 'on-headers';

@Injectable()
export class ResponseTime implements NestMiddleware {
  @inject(Types.Config) private config: IConfig;
  private suffix: boolean;
  private header: string;
  private digits: number;
  @histogram({
    name: 'response_time',
    help: 'response time',
    labelNames: ['method', 'baseUrl', 'statusCode'],
    buckets: [5, 10, 20, 50, 100, 300, 500, 1000, 2000, 3000, 5000, 10000],
  })
  private histogram: Histogram;

  public constructor() {
    this.suffix = this.config.get<boolean>('app.middleware.ResponseTime.suffix', true);
    this.header = this.config.get<string>(
      'app.middleware.ResponseTime.header',
      'x-response-time',
    );
    this.digits = this.config.get<number>('app.middleware.ResponseTime.digits', 3);
  }

  public use(req: Request, res: Response, next: NextFunction) {
    const startAt = process.hrtime();
    const baseUrl = req.baseUrl;
    onHeaders(res, () => {
      const diff = process.hrtime(startAt);
      const time = diff[0] * 1e3 + diff[1] * 1e-6;
      this.histogram
        .labels({
          method: req.method,
          baseUrl,
          statusCode: res.statusCode,
        })
        .observe(time);
      res.setHeader(this.header, time.toFixed(this.digits) + (this.suffix ? 'ms' : ''));
    });
    next();
  }
}
