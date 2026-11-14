---
unless_exists: true
mirror: true
skip: <%= h.CUT_EXAMPLES && 'examples cut' %>
---
import { PARAMGetUserDTO } from './get-user.dto';

export class PARAMDeleteUserDTO extends PARAMGetUserDTO {}
