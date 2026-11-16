(async () => {
  const fs = require('fs');
  const pt = require('path');
  const https = require('https');

  const registry = 'https://registry.npmjs.org/';
  const path = (...args) => pt.normalize(pt.join(...args));
  const templatesPath = './_templates';
  const dir = path(process.cwd(), templatesPath);
  // Рекурсивный обход: package.json.t лежит в root/$ROOT$, client/$ROOT$/apps/$CLIENT_NAME$ и server/$ROOT$/apps/$SERVER_NAME$
  const files = fs
    .readdirSync(dir, { recursive: true, withFileTypes: true })
    .filter((item) => item.isFile() && /package\.json(\.t)?$/.test(item.name))
    .map((item) => path(item.parentPath ?? item.path, item.name));
  const regexp = /"(@biorate\/[^"]+)":\s*"([^"]+)"/g;

  for (const file of files) {
    const p = file;
    let data = fs.readFileSync(p, 'utf-8');
    const matches = [...data.matchAll(regexp)];
    for (const match of matches) {
      const line = match[0];
      const name = match[1];
      const oldVersion = match[2];
      const latestVersion = await version(name);
      // Сохраняем префикс range (^/~) из текущей версии
      const prefix = /^[~^]/.test(oldVersion) ? oldVersion[0] : '';
      const newVersion = `"${name}": "${prefix}${latestVersion}"`;
      if (newVersion === `"${name}": "${oldVersion}"`) continue;
      data = data.replace(line, newVersion);
      console.info(
        pt.relative(process.cwd(), p),
        name,
        oldVersion,
        '->',
        prefix + latestVersion,
      );
    }
    fs.writeFileSync(p, data, 'utf8');
  }

  async function version(packageName) {
    return new Promise((resolve, reject) => {
      https
        .get(`${registry}${packageName}`, (res) => {
          if (res.statusCode !== 200) {
            res.resume();
            return reject(
              new Error(`${packageName}: registry responded ${res.statusCode}`),
            );
          }
          let data = '';
          res.on('data', (d) => (data += d));
          res.on('end', () => {
            try {
              resolve(JSON.parse(data)['dist-tags'].latest);
            } catch (e) {
              reject(new Error(`${packageName}: malformed registry response`));
            }
          });
        })
        .on('error', reject);
    });
  }
})();
