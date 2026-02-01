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

このページは新しいトップページに統合されました。自動的にリダイレクトします。

[トップページへ](/)
