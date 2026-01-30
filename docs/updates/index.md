---
layout: page
---

<script setup>
import { onMounted } from 'vue'
import { useRouter } from 'vitepress'

const router = useRouter()
onMounted(() => {
  router.go('/')
})
</script>

# リダイレクト中...

このページは新しいトップページに統合されました。自動的にリダイレクトします。

[トップページへ](/)
