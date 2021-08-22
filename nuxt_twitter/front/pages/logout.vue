<template>
  <div />
</template>
<script>
export default {
  async middleware ({ store, redirect, from }) {
    await store.dispatch('logout')
    // 変更
    if (from.name !== 'index') { return redirect('/') }
    // return redirect('/') 削除
  },
  // 以下、追加
  layout: 'logout',
  beforeCreate () {
    this.$router.replace('/')
  }
}
</script>
