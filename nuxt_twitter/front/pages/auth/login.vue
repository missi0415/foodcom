<template>
  <!-- eslint-disable-next-line -->
  <bef-login-form-card #form-card-content>
    <v-form
      ref="form"
      v-model="isValid"
    >
      <user-form-email
        :email.sync="params.auth.email"
        no-validation
      />
      <user-form-password
        :password.sync="params.auth.password"
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
        @click="login"
      >
        ログインする
      </v-btn>
      <v-card-text>
        {{ params }}
      </v-card-text>
    </v-card-text>
  </bef-login-form-card>
</template>

<script>
import befLoginFormCard from '../../components/beforeLogin/befLoginFormCard.vue'
import firebase from '~/plugins/firebase'
export default {
  components: { befLoginFormCard },
  layout: 'beforeLogin',
  data () {
    return {
      isValid: false,
      loading: false,
      params: { auth: { email: '', password: '' } }
    }
  },
  methods: {
    login () {
      firebase.auth().signInWithEmailAndPassword(this.params.auth.email, this.params.auth.password)
        .then(() => {
          this.$store.dispatch('login')
          this.$router.push('/')
        })
        .catch(() => {
          this.params.auth.email = 'メールアドレスまたはパスワードが正しくありません'
          this.alert = true
        })
      this.loading = true
      setTimeout(() => {
        this.$store.dispatch('login')
        this.$router.push('/')
        this.loading = false
      }, 1500)
    }
  }
}
</script>
