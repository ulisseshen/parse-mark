const fs = require('fs');
const readline = require('readline');

async function processFile(file) {
  const fileStream = fs.createReadStream(file);

  const rl = readline.createInterface({
    input: fileStream,
    crlfDelay: Infinity,
  });

  let result = '';
  let insideCodeBlock = false;
  let currentBlock = '';

  for await (const line of rl) {
    if (line.startsWith('```')) {
      insideCodeBlock = !insideCodeBlock;
    }

    if (!insideCodeBlock) {
      if (line.trim() === '') {
        if (currentBlock.trim() !== '') {
          result += currentBlock.trim() + '\n\n---\n\n';
          currentBlock = '';
        }
      } else {
        currentBlock += line + '\n';
      }
    }
  }

  if (currentBlock.trim() !== '') {
    result += currentBlock.trim() + '\n\n---\n\n';
  }

  const withoutHtmlTags = result.replace(/<[^>]+>/g, '');

  const lines = withoutHtmlTags.split('\n');
  const filteredLines = lines.filter(line => line.trim() !== '');

  const plainText = filteredLines.join('\n');

  const noConsecutiveSeparators = plainText.replace(/(---\n){2,}/g, '---\n')
  .replace(/---\n```\n---(\n)?/gm,'---\n');

  fs.writeFileSync('output.md', noConsecutiveSeparators);
}

processFile('exemplo.md');
