<template>
  <a :href="withBase(url)" class="article-card">
    <h3 class="title">{{ title }}</h3>
    <div class="date">{{ date }}</div>
    <p class="excerpt">{{ excerpt }}</p>
    <div class="tags">
      <span v-for="tag in tags" :key="tag" class="tag" :style="getTagStyle(tag)">
        {{ tag }}
      </span>
    </div>
    <div class="read-more">続きを読む →</div>
  </a>
</template>

<script setup lang="ts">
import { withBase } from 'vitepress'

interface Props {
  url: string
  title: string
  date: string
  excerpt: string
  tags?: string[]
}

defineProps<Props>()

// タグの色分け（ハッシュベースで5色をローテーション）
const tagColors = [
  { color: '#3b82f6', bg: 'rgba(59, 130, 246, 0.1)' },   // blue
  { color: '#22c55e', bg: 'rgba(34, 197, 94, 0.1)' },    // green
  { color: '#a855f7', bg: 'rgba(168, 85, 247, 0.1)' },   // purple
  { color: '#f97316', bg: 'rgba(249, 115, 22, 0.1)' },   // orange
  { color: '#ec4899', bg: 'rgba(236, 72, 153, 0.1)' }    // pink
]

function getTagStyle(tag: string) {
  const hash = tag.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0)
  const colorIndex = hash % tagColors.length
  const { color, bg } = tagColors[colorIndex]
  return {
    color,
    backgroundColor: bg,
    borderColor: color
  }
}
</script>

<style scoped>
.article-card {
  display: flex;
  flex-direction: column;
  padding: 24px;
  border: 1px solid var(--vp-c-divider);
  border-radius: 12px;
  background-color: var(--vp-c-bg-soft);
  text-decoration: none;
  color: inherit;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  height: 100%;
}

.article-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
  border-color: var(--vp-c-brand-1);
}

.title {
  margin: 0 0 8px 0;
  font-size: 18px;
  font-weight: 600;
  color: var(--vp-c-text-1);
  line-height: 1.4;
}

.date {
  margin: 0 0 12px 0;
  font-size: 14px;
  color: var(--vp-c-text-2);
}

.excerpt {
  margin: 0 0 16px 0;
  font-size: 14px;
  line-height: 1.6;
  color: var(--vp-c-text-2);
  flex-grow: 1;
}

.tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 16px;
}

.tag {
  display: inline-block;
  padding: 4px 10px;
  font-size: 12px;
  border-radius: 6px;
  border: 1px solid;
  font-weight: 500;
}

.read-more {
  margin-top: auto;
  font-size: 14px;
  color: var(--vp-c-brand-1);
  font-weight: 500;
  transition: text-decoration 0.2s;
}

.article-card:hover .read-more {
  text-decoration: underline;
}
</style>
