import { createContentLoader } from 'vitepress'

export default createContentLoader('updates/*.md', {
  transform(rawData) {
    return rawData
      .filter(page => !page.url.endsWith('/updates/'))
      .sort((a, b) => {
        return +new Date(b.frontmatter.date) - +new Date(a.frontmatter.date)
      })
  }
})
