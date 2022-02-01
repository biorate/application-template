import { UseGuards } from '@nestjs/common';
import { ApiBasicAuth } from '@nestjs/swagger';
import { AuthGuard } from '../providers';

export const AuthBasic = () => (target, propertyKey?, descriptor?) => {
  ApiBasicAuth()(target, propertyKey, descriptor);
  UseGuards(AuthGuard)(target, propertyKey, descriptor);
};
