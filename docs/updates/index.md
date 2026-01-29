---
layout: page
title: アップデート一覧
---

<script setup>
import { data } from './index.data.ts'
</script>

# アップデート一覧

Claude Codeの新機能・アップデートに関するガイド記事の一覧です。

<div v-for="article of data" :key="article.url" class="article-item">
  <h3><a :href="article.url">{{ article.frontmatter.title }}</a></h3>
  <p class="date">{{ article.frontmatter.date }}</p>
  <p v-if="article.frontmatter.tags" class="tags">
    <span v-for="tag in article.frontmatter.tags" :key="tag" class="tag">{{ tag }}</span>
  </p>
</div>

<style>
.article-item { margin-bottom: 1.5rem; }
.date { color: var(--vp-c-text-2); font-size: 0.9em; margin: 0.25rem 0; }
.tags { display: flex; gap: 0.5rem; flex-wrap: wrap; }
.tag { background: var(--vp-c-bg-soft); padding: 0.1rem 0.5rem; border-radius: 4px; font-size: 0.85em; }
</style>
