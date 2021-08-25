<template>
  <!-- eslint-disable-next-line -->
  <bef-login-form-card #form-card-content>
    <v-form
      ref="form"
      v-model="isValid"
    >
      <user-form-email
        :email.sync="user.email"
        no-validation
      />
      <user-form-password
        :password.sync="user.password"
        no-validation
      />
    </v-form>
    <v-card-actions>
      <nuxt-link
        to="#"
        class="body-2 text-decoration-none"
      >
        パスワードを忘れた?
      </nuxt-link>
    </v-card-actions>
    <v-card-text class="px-0">
      <v-btn
        :disabled="!isValid || loading"
        :loading="loading"
        block
        color="myblue"
        class="white--text"
        @click="loginUser"
      >
        ログインする
      </v-btn>
      <v-card-text>
        {{ user }}
      </v-card-text>
    </v-card-text>
  </bef-login-form-card>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import UserFormEmail from '../../components/user/userFormEmail.vue'
import UserFormPassword from '../../components/user/userFormPassword.vue'
import befLoginFormCard from '~/components/layout/befLogin/befLoginFormCard.vue'
import firebase from '~/plugins/firebase'
export default {
  components: { befLoginFormCard, UserFormEmail, UserFormPassword },
  layout: 'beforeLogin',
  data () {
    return {
      isValid: false,
      loading: false,
      user: { email: '', password: '' }
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/user'
    })
  },
  methods: {
    ...mapActions({
      login: 'auth/login',
      flashMessage: 'flash/flashMessage'
    }),
    loginUser () {
      this.loading = true
      firebase.auth().signInWithEmailAndPassword(this.user.email, this.user.password)
        .then((res) => {
          this.login(res.user)
          this.flashMessage({ message: 'ログインしました', type: 'success', status: true })
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
