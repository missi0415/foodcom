export default ({ app }) => {
  app.router.afterEach((to, from) => {
    // ページ遷移ごとに行いたい処理
    console.log('routerOpsionを通ったよ')
    this.fetchPosts()
  })
}
