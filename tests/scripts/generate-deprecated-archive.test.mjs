import assert from "node:assert/strict";
import fs from "node:fs";
import vm from "node:vm";

const indexHtml = fs.readFileSync(new URL("../../index.html", import.meta.url), "utf8");
const fixtures = JSON.parse(
  fs.readFileSync(new URL("../fixtures/deprecated-archive-replacements.json", import.meta.url), "utf8"),
);

const functionBlock = indexHtml.match(
  /const DEPRECATED_ARCHIVE_HOSTS[\s\S]*?function readQueryParameter/,
);

assert.ok(functionBlock, "Could not find replacement generation functions in index.html");

const script = functionBlock[0].replace(/\n\s*function readQueryParameter$/, "");
const context = { URL };
vm.createContext(context);
vm.runInContext(`${script}\nthis.generateDeprecatedArchiveTemplate = generateDeprecatedArchiveTemplate;`, context);

for (const fixture of fixtures) {
  const actual = context.generateDeprecatedArchiveTemplate(fixture.find);

  assert.equal(actual, fixture.replace, fixture.name);
  assert.equal(actual.includes("sourceurl="), false, fixture.name);
  assert.equal(actual.includes("title="), false, fixture.name);
  assert.equal(actual.includes("archivehostpath="), false, fixture.name);
  assert.equal(actual.includes("protocol="), false, fixture.name);

  if (fixture.sourceText && fixture.updatedText) {
    assert.equal(
      fixture.sourceText.split(fixture.find).join(actual),
      fixture.updatedText,
      `${fixture.name} preserves surrounding text`,
    );
  }
}

const unsupportedCases = [
  "plain text",
  "[https://example.com/page Not a deprecated archive host]",
  "[ftp://archive.today/example Unsupported protocol]",
  "[https://archive.today/a Bad | label]",
  "[https://archive.today/a Bad = label]",
  "[https://archive.today/a First] [https://archive.today/b Second]",
];

for (const find of unsupportedCases) {
  assert.equal(context.generateDeprecatedArchiveTemplate(find), "", find);
}

console.log(`Validated ${fixtures.length} Deprecated archive replacement fixtures.`);
