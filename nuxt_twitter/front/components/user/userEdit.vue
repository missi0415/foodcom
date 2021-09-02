<template>
  <div>
    <div
      class="my-2"
    >
      <v-btn
        color="white"
        x-large
        rounded
        @click="userDataSet()"
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
            src="https://cdn.pixabay.com/photo/2020/07/12/07/47/bee-5396362_1280.jpg"
          />
          <v-card-title>
            <v-avatar size="56">
              <img
                alt="user"
                src="https://cdn.pixabay.com/photo/2020/06/24/19/12/cabbage-5337431_1280.jpg"
              >
            </v-avatar>
            <p class="ml-3 mt-3">
            </p>
            <v-spacer />
          </v-card-title>
            <v-container>
              <v-form
                ref="form"
                v-model="isValid"
              >
                <user-form-introduction
                  :introduction.sync="user.introduction"
                />
                <user-form-name
                  :name.sync="user.name"
                />
                <user-form-email
                  :email.sync="user.email"
                />
                <user-form-password
                  :password.sync="user.password"
                />
                <v-file-input
                  @change="setImage"
                  label="アバター画像"
                  accept="image/png, image/jpeg, image/bmp"
                />
              <v-btn
                :disabled="!isValid || loading"
                :loading="loading"
                block
                color="info"
                @click="updateUser()"
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
import UserFormIntroduction from './userFormIntroduction.vue'
import userFormName from './userFormName.vue'
import userFormPassword from './userFormPassword.vue'
export default {
  components: {
    userFormEmail,
    userFormPassword,
    userFormName,
    UserFormIntroduction
  },
  data () {
    return {
      dialog: false,
      isValid: false,
      loading: false,
      editLading: false,
      user: { id: '', name: '', email: '', password: '', avatar: '', introduction: '' },
      image: ''
    }
  },
  methods: {
    ...mapActions({
      flashMessage: 'flash/flashMessage',
      currentUserId: 'auth/currentUserId',
      currentUser: 'auth/currentUser'
    }),
    async userDataSet () {
      console.log('userDataSet発火')
      const url = `/api/v1/users/${this.$route.params.id}`
      console.log('url', url)
      await this.$axios.get(url)
        .then((res) => {
          console.log('userDataSetres', res)
          this.user.id = res.data.id
          this.user.name = res.data.name
          this.user.email = res.data.email
          this.user.introduction = res.data.introduction
          this.user.avatar = res.data.avatar.url
          this.user.admin = res.data.admin
          console.log('userDataSet完了')
          this.dialog = true
        })
    },
    // fetchContents () {
    //   this.$axios.get('/api/v1/posts')
    //     .then((res) => {
    //       this.setPosts(res.data)
    //     })
    // },
    setImage (e) {
      this.image = e
    },
    async updateUser () {
      this.loading = true
      const formData = new FormData()
      formData.append('user[name]', this.user.name)
      formData.append('user[email]', this.user.email)
      formData.append('user[introduction]', this.user.introduction)
      formData.append('user[avatar]', this.user.avatar)
      formData.append('user[admin]', this.user.admin)
      console.log('送信データformData', formData)
      await this.$axios.$put(`/api/v1/users/${this.user.id}`, formData)
        .then((res) => {
          console.log('userapdateのレスポンス', res)
          this.$emit('getShowUserData')
          this.$router.push(`/users/${this.user.id}`)
          this.flashMessage({ message: '更新しました', type: 'primary', status: true })
          this.loading = false
          this.dialog = false
          this.$refs.form.reset()
        })
        .catch((err) => {
          this.flashMessage({ message: err.response.data.message.join('\n'), type: 'error', status: true })
          this.loading = false
        })
    }
  }
}
</script>
