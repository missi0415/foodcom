<template>
  <v-btn
    outlined
    dark
    :loading="loading"
    color="success"
    class="ml-2 font-weight-bold"
    @click="loginGest"
  >
    {{ $t('pages.gest-login') }}
    <!-- コメント -->
  </v-btn>
</template>

<script>
import { mapActions } from 'vuex'
import firebase from '~/plugins/firebase'
export default {
  data () {
    return {
      loading: false,
      user: { email: 'guest@example.com', password: 'guestpassword' }
    }
  },
  methods: {
    ...mapActions({
      login: 'auth/login',
      flashMessage: 'flash/flashMessage'
    }),
    loginGest () {
      this.loading = true
      firebase.auth().signInWithEmailAndPassword(this.user.email, this.user.password)
        .then((res) => {
          this.login(res.user)
          this.flashMessage({ message: 'ゲストログインしました', type: 'success', status: true })
          this.$router.push('/posts')
          this.loading = false
        })
        .catch((err) => {
          this.loading = false
          // eslint-disable-next-line no-console
          console.log(err)
          this.flashMessage({ message: 'メールアドレスまたはパスワードが正しくありません', type: 'error', status: true })
        })
    }
  }
}
</script>
