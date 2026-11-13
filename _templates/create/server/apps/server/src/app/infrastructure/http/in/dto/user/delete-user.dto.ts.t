---
to: <%= !h.CUT_EXAMPLES && `${h.ROOT}/apps/${h.SERVER_NAME}/src/app/infrastructure/http/in/dto/user/delete-user.dto.ts` %>
unless_exists: true
---
import { PARAMGetUserDTO } from './get-user.dto';

export class PARAMDeleteUserDTO extends PARAMGetUserDTO {}
