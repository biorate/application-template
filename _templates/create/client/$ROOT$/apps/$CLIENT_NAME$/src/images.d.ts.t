---
unless_exists: true
mirror: true
---
declare module '*.svg' {
  const content: any;
  export default content;
}
