---
to: <%= h.server(`${ROOT}/apps/server/src/app/common/infrastructure/controllers/dto/user/delete-user.dto.ts`) %>
unless_exists: true
---
import { PARAMGetUserDTO } from './get-user.dto';

export class PARAMDeleteUserDTO extends PARAMGetUserDTO {}
