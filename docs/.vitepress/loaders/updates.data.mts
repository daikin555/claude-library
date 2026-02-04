import { createContentLoader } from 'vitepress'

export default createContentLoader('updates/*.md', {
  transform(rawData) {
    return rawData
      .filter(page => !page.url.endsWith('/updates/'))
      .sort((a, b) => {
        // バージョン番号でソート（降順）
        const versionA = extractVersion(a.url)
        const versionB = extractVersion(b.url)

        if (versionA && versionB) {
          return compareVersions(versionB, versionA)
        }

        // バージョン番号がない場合は日付でソート
        return +new Date(b.frontmatter.date) - +new Date(a.frontmatter.date)
      })
      .map(page => ({
        ...page,
        frontmatter: {
          ...page.frontmatter,
          date: extractVersion(page.url) || formatDate(page.frontmatter.date)
        },
        excerpt: extractExcerpt(page.html)
      }))
  }
})

function compareVersions(a: string, b: string): number {
  const partsA = a.split('.').map(Number)
  const partsB = b.split('.').map(Number)

  for (let i = 0; i < 3; i++) {
    if (partsA[i] !== partsB[i]) {
      return partsA[i] - partsB[i]
    }
  }

  return 0
}

function extractVersion(url: string): string | null {
  // URLから最後のセグメントを取得 (/updates/2.1.30-feature.html -> 2.1.30-feature.html)
  const filename = url.split('/').pop()
  if (!filename) return null

  // ファイル名からバージョン番号を抽出 (2.1.30-feature.html -> 2.1.30)
  const match = filename.match(/^(\d+\.\d+\.\d+)/)
  return match ? match[1] : null
}

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

function extractExcerpt(html: string | undefined): string {
  if (!html) return ''

  // HTMLタグを除去
  const text = html.replace(/<[^>]*>/g, ' ')

  // 連続空白を1つに正規化
  const normalized = text.replace(/\s+/g, ' ').trim()

  // 文単位で分割（句点、感嘆符、疑問符で判定）
  const sentences = normalized.split(/[。！？]/)
    .map(s => s.trim())
    .filter(s => s.length > 0)

  // 最初の2文を結合
  let excerpt = sentences.slice(0, 2).join('。') + '。'

  // 150字を超える場合は切り詰めて「...」を追加
  if (excerpt.length > 150) {
    excerpt = excerpt.slice(0, 147) + '...'
  }

  return excerpt
}
