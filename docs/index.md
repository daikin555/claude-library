---
layout: home
hero:
  name: Claude Code ガイド
  text: 新機能・アップデート活用ガイド
  tagline: Claude Codeのchangelogを自動監視し、新機能の活用方法を日本語で解説します
  actions:
    - theme: brand
      text: Claude Code公式
      link: https://github.com/anthropics/claude-code
features:
  - title: 自動検出
    details: Claude Codeのchangelogを毎日監視し、新しい変更を自動検出します
  - title: 活用ガイド
    details: 新機能ごとに実践的な活用方法をまとめたガイドを自動生成します
  - title: 日本語対応
    details: すべてのガイドは日本語で記述され、具体的なコード例を含みます
---

<script setup>
import { data as updates } from './.vitepress/loaders/updates.data.mts'
import ArticleCard from './.vitepress/components/ArticleCard.vue'
</script>

<div class="updates-section">
  <h2 class="section-title">最新アップデート</h2>
  <div class="updates-grid">
    <ArticleCard
      v-for="update in updates"
      :key="update.url"
      :url="update.url"
      :title="update.frontmatter.title"
      :date="update.frontmatter.date"
      :excerpt="update.excerpt"
      :tags="update.frontmatter.tags"
    />
  </div>
</div>

<style scoped>
.updates-section {
  max-width: 1400px;
  margin: 64px auto;
  padding: 0 24px;
}

.section-title {
  font-size: 32px;
  font-weight: 700;
  margin: 0 0 32px 0;
  color: var(--vp-c-text-1);
  text-align: center;
}

.updates-grid {
  display: grid;
  gap: 24px;
  grid-template-columns: 1fr;
}

@media (min-width: 640px) {
  .updates-section {
    padding: 0 48px;
  }

  .updates-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (min-width: 960px) {
  .updates-section {
    padding: 0 64px;
  }

  .updates-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}
</style>
