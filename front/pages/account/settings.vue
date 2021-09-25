<template>
  <layout-main #layout-main><!--eslint-disable-line-->
    <v-container>
      <v-row justify="space-around">
        <v-card>
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
          <v-img
            height="200px"
            width="1000px"
            :src="user.header"
          />
          <v-list-item class="grow">
            <v-list-item-avatar
              size=60
            >
              <v-img
                alt="user"
                contain
                :src="user.avatar"
              />
            </v-list-item-avatar>
            <v-list-item-content>
              <v-list-item-title>
                {{ user.name }}
              </v-list-item-title>
            </v-list-item-content>
            <v-row
              align="center"
              justify="end"
              class="mr-1"
            >
            </v-row>
          </v-list-item>
          <v-tabs
            v-model="tab"
            color="primary accent-10"
            grow
          >
            <v-tab>メールアドレス変更</v-tab>
            <v-tab>パスワード変更</v-tab>
          </v-tabs>
          <v-tabs-items v-model="tab">
            <v-tab-item>
              <v-card
                class="pa-5"
              >
                <!-- email変更 -->
                  <v-card-title>
                    現在のメールアドレス
                  </v-card-title>
                  <v-card-subtitle>
                    {{ user.email }}
                  </v-card-subtitle>
                  <v-form
                    ref="form"
                    v-model="isEmailValid"
                  >
                    <v-text-field
                      v-model="newEmail"
                      :rules="emailRules"
                      label="新しいメールアドレス"
                      :placeholder="emailForm.placeholder"
                    />
                    <user-form-password
                      :password.sync="password"
                      :noValidation="noValidation"
                    />
                  <template v-if="user.id === guestId">
                    <v-btn
                      disabled
                      block
                    >
                      ゲストユーザーのため変更できません
                    </v-btn>
                  </template>
                  <template v-else>
                    <v-btn
                      block
                      color="primary"
                      :disabled="!isEmailValid || loading"
                      :loading="loading"
                      @click="changeEmail"
                    >
                        変更する
                    </v-btn>
                  </template>
                </v-form>
              </v-card>
            </v-tab-item>
            <v-tab-item>
              <v-card
                class="pa-5"
              >
                <!-- パスワード変更 -->
                <v-form ref="form" v-model="isValid" class="mt-4 mb-2">
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
                    :append-icon="toggle.icon"
                    :type="toggle.type"
                    autocomplete="on"
                    @click:append="show = !show"
                  />
                  <template v-if="user.id === guestId">
                    <v-btn
                      disabled
                      block
                    >
                      ゲストユーザーのため変更できません
                    </v-btn>
                  </template>
                  <template v-else>
                    <v-btn
                      :disabled="!isValid || loading"
                      :loading="loading"
                      block
                      color="primary"
                      @click="changePassword"
                    >
                      保存する
                    </v-btn>
                  </template>
                </v-form>
              </v-card>
            </v-tab-item>
          </v-tabs-items>
        </v-card>
      </v-row>
    </v-container>
  </layout-main>
</template>

<script>
import { mapActions, mapGetters } from 'vuex'
import userFormPassword from '../../components/user/userFormPassword.vue'
import firebase from '~/plugins/firebase'

export default {
  components: {
    userFormPassword
  },
  data () {
    return {
      tab: null,
      show: false,
      isValid: false,
      isEmailValid: false,
      loading: false,
      guestId: 1,
      user: { id: '', name: '', email: '', avatar: '', introduction: '', admin: '', header: '', password: '' },
      email: '',
      newEmail: '',
      password: '',
      newPassword: '',
      noValidation: false,
      emailRules: [
        v => !!v || '',
        v => /.+@.+\..+/.test(v) || ''
      ]
    }
  },
  computed: {
    ...mapGetters({
      currentUser: 'auth/user',
      currentUserId: 'auth/currentUserId',
      btnColor: 'btn/color'
    }),
    emailForm () {
      const placeholder = this.noValidation ? undefined : 'your@email.com'
      return { placeholder }
    },
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
  mounted () {
    setTimeout(() => {
      this.fetchUser()
      this.user.password = this.currentUser.password
    }, 10)
  },
  methods: {
    ...mapActions({
      logout: 'auth/logout',
      loadData: 'auth/loadData',
      showMessage: 'flash/flashMessage'
    }),
    async fetchUser () {
      const url = `/api/v1/users/${this.currentUserId}`
      await this.$axios.get(url)
        .then((res) => {
          this.user.id = res.data.user.id
          this.user.name = res.data.user.name
          this.user.email = res.data.user.email
          this.user.introduction = res.data.user.introduction
          this.user.avatar = res.data.user.avatar.url
          this.user.admin = res.data.user.admin
          this.user.header = res.data.user.header.url
        })
        .catch((err) => {
          // eslint-disable-next-line no-console
          console.error(err)
        })
    },
    // メールアドレスを変更 //
    changeEmail () {
      const credential = firebase.auth.EmailAuthProvider.credential(
        this.user.email,
        this.password
      )
      console.log(credential)
      firebase.auth().currentUser.reauthenticateWithCredential(credential)
        .then(() => {
          firebase.auth().currentUser.updateEmail(this.newEmail)
            .then(() => {
              this.$axios.patch(`/api/v1/users/${this.currentUserId}`, { user: { email: this.newEmail } })
                .then(() => {
                  this.fetchUser()
                  this.$refs.form.reset()
                  this.showMessage({ message: 'メールアドレスを変更しました', type: 'success', status: true })
                })
                .catch((err) => {
                  console.log('メールアドレス変更失敗', err)
                })
            })
        })
        .catch((err) => {
          console.log('再認証エラー', err)
          this.showMessage({ message: 'パスワードが違います', type: 'error', status: true })
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
              this.fetchUser()
              this.$refs.form.reset()
              this.showMessage({ message: 'パスワードを変更しました', type: 'success', status: true })
            })
            .catch((err) => {
              console.log('パスワード変更エラー', err)
            })
        })
        .catch((err) => {
          console.log('再認証エラー', err)
          this.showMessage({ message: 'パスワードが違います', type: 'error', status: true })
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
