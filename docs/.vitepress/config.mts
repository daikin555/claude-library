import { defineConfig } from 'vitepress'
import fs from 'fs'
import path from 'path'

function getUpdatesSidebar() {
  const updatesDir = path.resolve(__dirname, '../updates')
  if (!fs.existsSync(updatesDir)) return []

  const files = fs.readdirSync(updatesDir)
    .filter(f => f.endsWith('.md') && f !== '.gitkeep')
    .sort()
    .reverse()

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
  base: '/claude-library/',
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
