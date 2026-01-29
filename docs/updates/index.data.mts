import { createContentLoader } from 'vitepress'

export default createContentLoader('updates/*.md', {
  transform(rawData) {
    return rawData
      .filter(page => !page.url.endsWith('/updates/'))
      .sort((a, b) => {
        return +new Date(b.frontmatter.date) - +new Date(a.frontmatter.date)
      })
      .map(page => ({
        ...page,
        frontmatter: {
          ...page.frontmatter,
          date: formatDate(page.frontmatter.date)
        }
      }))
  }
})

function formatDate(date: string | Date): string {
  if (typeof date === 'string') {
    return date.slice(0, 10)
  }
  // Date オブジェクトの場合、UTC年月日を取得（タイムゾーンずれ防止）
  const y = date.getUTCFullYear()
  const m = String(date.getUTCMonth() + 1).padStart(2, '0')
  const d = String(date.getUTCDate()).padStart(2, '0')
  return `${y}-${m}-${d}`
}
