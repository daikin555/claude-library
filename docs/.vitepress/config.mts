import { defineConfig } from 'vitepress'
import fs from 'fs'
import path from 'path'

function compareVersionFilenames(a: string, b: string): number {
  const versionA = a.match(/^(\d+\.\d+\.\d+)/)
  const versionB = b.match(/^(\d+\.\d+\.\d+)/)

  // バージョン番号がない場合は辞書順
  if (!versionA || !versionB) return b.localeCompare(a)

  // バージョン番号を比較
  const partsA = versionA[1].split('.').map(Number)
  const partsB = versionB[1].split('.').map(Number)

  for (let i = 0; i < 3; i++) {
    if (partsB[i] !== partsA[i]) return partsB[i] - partsA[i]
  }

  // 同一バージョン内はファイル名のアルファベット順
  return a.localeCompare(b)
}

function getUpdatesSidebar() {
  const updatesDir = path.resolve(__dirname, '../updates')
  if (!fs.existsSync(updatesDir)) return []

  const files = fs.readdirSync(updatesDir)
    .filter(f => f.endsWith('.md') && f !== '.gitkeep')
    .sort(compareVersionFilenames)

  return files.map(file => {
    const name = file.replace(/\.md$/, '')
    const content = fs.readFileSync(path.join(updatesDir, file), 'utf-8')
    const titleMatch = content.match(/^#\s+(.+)$/m) || content.match(/^title:\s*(.+)$/m)
    const title = titleMatch ? titleMatch[1] : name

    return {
      text: title,
      link: `/updates/${name}`
    }
  })
}

export default defineConfig({
  base: '/',
  title: 'Claude Code ガイド',
  description: 'Claude Codeの新機能・アップデートガイド',
  lang: 'ja',
  themeConfig: {
    nav: [
      { text: 'ホーム', link: '/' }
    ],
    sidebar: [
      {
        text: 'アップデート',
        items: getUpdatesSidebar()
      }
    ],
    socialLinks: [
      { icon: 'github', link: 'https://github.com/anthropics/claude-code' }
    ],
    outline: {
      label: '目次'
    }
  }
})
