export default ({ $axios }) => {
  // リクエストログ
  $axios.onRequest((config) => {
    console.log('axiosリクエストログ', config)
  })
  // レスポンスログ
  $axios.onResponse((config) => {
    console.log('axiosレスポンスログ', config)
  })
  // エラーログ
  $axios.onError((e) => {
    console.log('axiosエラー', e.response)
  })
}
