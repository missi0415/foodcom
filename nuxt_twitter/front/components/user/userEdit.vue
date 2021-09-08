<template>
  <div>
    <div
      class="my-2"
    >
      <v-btn
        color="white"
        x-large
        rounded
        @click="userDataSet"
      >
      <v-icon>mdi-pencil</v-icon>
        プロフィールを編集
      </v-btn>
    </div>
    <v-dialog
      v-model="dialog"
      width="800"
    >
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
              @click="dialog = false"
            >
              ✖︎
            </v-btn>
            <v-toolbar-title>
              プロフィールを編集
            </v-toolbar-title>
            <v-spacer />
            <v-btn
              icon
              rounded
              large
              color="dark"
              dark
            >
              <v-icon>保存</v-icon>
            </v-btn>
          </v-app-bar>
          <v-img
            height="200px"
            width="800px"
            :src="user.header"
          >
          </v-img>
            <v-file-input
              @change="setHeaderImage"
              prepend-icon="mdi-camera"
              label="ヘッダー画像"
              accept="image/png, image/jpeg, image/bmp"
            />
            <v-list-item
              class="grow"
              link
            >
              <v-list-item-avatar
                size=60
              >
                <v-img
                  :src="avatarImage"
                  contain
                  lazy-src
                />
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title>
                  <v-file-input
                    @change="setAvatarImage"
                    prepend-icon="mdi-camera"
                    label="アバター画像"
                    accept="image/png, image/jpeg, image/bmp"
                  />
                </v-list-item-title>
              </v-list-item-content>
            </v-list-item>
            <v-container>
              <v-form
                ref="form"
                v-model="isValid"
              >
                <user-form-name
                  :name.sync="user.name"
                />
                <user-form-introduction
                  :introduction.sync="user.introduction"
                />
                <user-form-email
                  :email.sync="user.email"
                />
                <user-form-password
                  :password.sync="user.password"
                />
              <v-btn
                :disabled="!isValid || loading"
                :loading="loading"
                block
                color="info"
                @click="updateUser"
              >
                保存する
              </v-btn>
              </v-form>
            </v-container>
          </v-card>
        </v-row>
      </v-container>
    </v-dialog>
  </div>
</template>

<script>
import { mapActions } from 'vuex'
import userFormEmail from './userFormEmail.vue'
import userFormIntroduction from './userFormIntroduction.vue'
import userFormName from './userFormName.vue'
import userFormPassword from './userFormPassword.vue'
export default {
  components: {
    userFormEmail,
    userFormPassword,
    userFormName,
    userFormIntroduction
  },
  data () {
    return {
      dialog: false,
      isValid: false,
      loading: false,
      editLading: false,
      user: { id: '', name: '', email: '', password: '', avatar: '', header: '', introduction: '' },
      avatarImage: '',
      headerImage: ''
    }
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage',
      currentUserId: 'auth/currentUserId',
      currentUser: 'auth/currentUser'
    }),
    async userDataSet () {
      const url = `/api/v1/users/${this.$route.params.id}`
      await this.$axios.get(url)
        .then((res) => {
          this.avatarImage = res.data.user.avatar.url
          this.user.id = res.data.user.id
          this.user.name = res.data.user.name
          this.user.email = res.data.user.email
          this.user.introduction = res.data.user.introduction
          this.user.avatar = res.data.user.avatar.url
          this.user.header = res.data.user.header.url
          this.dialog = true
        })
    },
    setAvatarImage (e) {
      this.avatarImage = e
    },
    setHeaderImage (e) {
      this.headerImage = e
    },
    async updateUser () {
      this.loading = true
      const formData = new FormData()
      formData.append('user[name]', this.user.name)
      formData.append('user[email]', this.user.email)
      formData.append('user[introduction]', this.user.introduction)
      formData.append('user[avatar]', this.avatarImage)
      formData.append('user[header]', this.headerImage)
      formData.append('user[admin]', this.user.admin)
      console.log('送信データformData', formData)
      await this.$axios.$put(`/api/v1/users/${this.user.id}`, formData)
        .then((res) => {
          console.log('userapdateのレスポンス', res)
          this.fetchUser()
          this.flashMessage({ message: '更新しました', type: 'primary', status: true })
          this.loading = false
          this.dialog = false
          this.$refs.form.reset()
        })
        .catch((err) => {
          this.flashMessage({ message: err.response.data.message.join('\n'), type: 'error', status: true })
          this.loading = false
        })
    },
    fetchUser () {
      this.$emit('fetchUser')
    }
  }
}
</script>
