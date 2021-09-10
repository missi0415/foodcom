<template>
  <div>
    <v-card
      class="ma-1"
      hover
      outlined
    >
      <v-app-bar
          flat
          color="rgba(0, 0, 0, 0)"
        >
          <v-btn
            icon
            large
            class="mr-5"
            @click="pageBack"
          >
          <v-icon>mdi-arrow-left</v-icon>
          </v-btn>
          <v-toolbar-title>
            アカウントの設定
          </v-toolbar-title>
        </v-app-bar>
        <v-divider/>
        <v-container>
          <!-- パスワード変更 -->
          {{ currentUser }}
          {{ email }}
          {{ password }}
          {{ newPassword }}
          <v-form
            ref="form"
            v-model="isValid"
          >
            <user-form-email
              :email.sync="email"
              :noValidation="noValidation"
            />
            <user-form-password
              :password.sync="password"
              :noValidation="noValidation"
            />
            <v-text-field
              v-model="newPassword"
              :rules="passwordRules.rules"
              :counter="!noValidation"
              :hint="passwordRules.hint"
              label="新しいパスワード"
              :placeholder="passwordRules.placeholder"
              :hide-details="noValidation"
              outlined
              :append-icon="toggle.icon"
              :type="toggle.type"
              autocomplete="on"
              @click:append="show = !show"
            />
            <v-btn
              :disabled="!isValid || loading"
              :loading="loading"
              block
              color="info"
              @click="changePassword"
            >
              保存する
            </v-btn>
          </v-form>
        </v-container>
    </v-card>
  </div>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import userFormPassword from '../../components/user/userFormPassword.vue'
import UserFormEmail from '../../components/user/userFormEmail.vue'
import firebase from '~/plugins/firebase'

export default {
  components: {
    userFormPassword,
    UserFormEmail
  },
  data () {
    return {
      show: false,
      isValid: false,
      loading: false,
      email: '',
      password: '',
      newPassword: '',
      noValidation: false
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/data',
      currentUserId: 'auth/currentUserId',
      btnColor: 'btn/color'
    }),
    passwordRules () {
      const min = '8文字以上'
      const msg = `${min}。半角英数字•ﾊｲﾌﾝ•ｱﾝﾀﾞｰﾊﾞｰが使えます`
      const required = v => !!v || ''
      const format = v => /^[\w-]{8,72}$/.test(v) || msg
      const rules = this.noValidation ? [required] : [format]
      const hint = this.noValidation ? undefined : msg
      const placeholder = this.noValidation ? undefined : min
      return { rules, hint, placeholder }
    },
    toggle () {
      const icon = this.show ? 'mdi-eye' : 'mdi-eye-off'
      const type = this.show ? 'text' : 'password'
      return { icon, type }
    }
  },
  methods: {
    ...mapActions({
      logout: 'auth/logout',
      loadData: 'auth/loadData',
      showMessage: 'flash/flashMessage'
    }),
    // メールアドレスを変更 //
    async changeEmail () {
      const user = await firebase.auth().currentUser
      user.updateEmail(this.email)
        .then(() => {
          this.$axios.put(`/api/v1/users/${this.loginUser.id}`, { user: { email: this.email, uid: this.loginUser.uid } })
            .then((res) => {
              this.loadData(res.data.uid)
              this.showMessage({ message: 'メールアドレスを変更しました', type: 'success', status: true })
            })
            .catch((err) => {
              console.log('メールアドレス変更失敗', err)
            })
        })
    },
    // パスワードを変更 //
    changePassword () {
      const user = firebase.auth().currentUser
      const credential = firebase.auth.EmailAuthProvider.credential(
        user.email,
        this.password
      )
      user.reauthenticateWithCredential(credential)
        .then(() => {
          console.log('再認証成功')
          user.updatePassword(this.newPassword)
            .then(() => {
              console.log('パスワード変更成功')
              this.showMessage({ message: 'パスワードを変更しました', type: 'success', status: true })
            })
            .catch((err) => {
              console.log('パスワード変更エラー', err)
            })
        })
        .catch((err) => {
          console.log('再認証エラー', err)
        })
    },
    // ユーザーを削除 //
    async deleteUser () {
      const user = await firebase.auth().currentUser
      user.delete()
        .then(() => {
          this.$axios.$delete(`/api/v1/users/${this.loginUser.id}`, {
            params: {
              uid: this.$store.state.auth.user.uid
            }
          })
        })
        .then(() => {
          this.logout()
          this.showMessage({ message: 'ユーザーを削除しました', type: 'error', status: true })
          this.$router.push('/')
        })
    },
    pageBack () {
      this.$router.go(-1)
    }
  }
}
</script>
